//
//  BillModel.m
//  InnJia_2.0
//
//  Created by pg on 16/5/24.
//  Copyright © 2016年 pg. All rights reserved.
//

#import "PayBody.h"
#import "InnjiaPayUtil.h"
#import "InnjiaAdapter.h"
#import "GenerateOrderstring.h"
#import "InnjiaPayCache.h"
#import "InnjiaPayResp.h"
#import "AliKeysManager.h"
#import "NSString+IsValid.h"
#import "InnjiaPayTool.h"
#import "TokenTool.h"
#import "AFNetWorking.h"

@implementation PayBody

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.channel = PayChannelNone;
        self.title = @"";
        self.totalFee = @"";
        self.billNo = @"";
        self.scheme = @"";
    }
    return self;
}
- (void)payReq
{
    //设置回调响应体的请求体
    [InnjiaPayCache sharedInstance].innjiaResp = [[InnjiaPayResp alloc] initWithReq:self];
    //检验订单是否合格，是否安装客户端（微信)
    if (![self checkParametersForReqPay]) return;
    //支付类型
    NSString *cType = [InnjiaPayUtil getChannelString:self.channel];
    NSMutableDictionary *parameters = [InnjiaPayUtil prepareParametersForRequest];
    if (!parameters) {
        return;
    }
    parameters[@"identification"] = cType;
    parameters[@"total_fee"] = [NSString stringWithFormat:@"%.2f", self.totalFee.floatValue];
    parameters[@"bill_no"] = self.billNo;
    parameters[@"title"] = self.title;
    //添加参数
    if (self.optional) {
        parameters[@"optional"] = self.optional;
    }
    TokenUrls *urls = [TokenUrls sharedUrlInstance];
    AliKeysManager *aliKeys = [AliKeysManager sharedInstance];
    BOOL flag = urls.tokenUlr.isValid && urls.payInfoUrl.isValid;
    BOOL keysValid = aliKeys.partner.isValid && aliKeys.seller.isValid && aliKeys.notifyURL.isValid && aliKeys.privateKey.isValid;
    //有SDK后台
    if (flag) {
        id <InnjiaPayDelegate> delegate = [InnjiaPayTool getInnjiaDelegate];
        if (delegate && [delegate respondsToSelector:@selector(startPaying)]) {
            [delegate startPaying];
        }
        TokenTool *tokens = [TokenTool sharedTokenTool];
        if (tokens.body == self) {
            if ([tokens.aliPayInfo[@"identification"] isEqualToString:cType]) {
                [self getPayInfoWithDict:tokens.aliPayInfo];
            } else if ([tokens.wxPayInfo[@"identification"] isEqualToString:cType]) {
                [self getPayInfoWithDict:tokens.wxPayInfo];
            } else {
                [self getTokenWithDict:parameters];
            }
        } else {
            tokens.aliPayInfo = nil;
            tokens.wxPayInfo = nil;
            tokens.body = nil;
            [self getTokenWithDict:parameters];
        }
    }
    //无sdk后台，且配置了alikeys
    if (!flag && keysValid) {
        //在此生成支付宝请求string
        parameters[@"order_string"] = [GenerateOrderstring getOrderSting:self];
        [self doPayAction:parameters];
    }
}
- (void)getTokenWithDict:(NSDictionary *)parameters
{
    TokenUrls *urls = [TokenUrls sharedUrlInstance];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    [manager POST:urls.tokenUlr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject valueForKey:@"code"] isEqualToString:@"0000"]) {
            NSString *cType = [InnjiaPayUtil getChannelString:self.channel];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary *)responseObject];
            dict[@"identification"] = cType;
            TokenTool *tokens = [TokenTool sharedTokenTool];
            tokens.body = self;
            if ([cType isEqualToString:@"alipay"]) {
                tokens.aliPayInfo = dict;
            }
            if ([cType isEqualToString:@"wxpayTest"]) {
                tokens.wxPayInfo = dict;
            }
            [self getPayInfoWithDict:dict];
        } else {
            [InnjiaPayUtil doErrorResponse:@"网络请求失败"];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [InnjiaPayUtil doErrorResponse:@"网络请求失败"];
    }];
}

- (void)getPayInfoWithDict:(NSDictionary *)response
{
    TokenUrls *urls = [TokenUrls sharedUrlInstance];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];

    [manager POST:urls.payInfoUrl parameters:response progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject valueForKey:@"code"] isEqualToString:@"0000"]) {
            [self doPayAction:(NSDictionary *)responseObject];
        } else {
            [InnjiaPayUtil doErrorResponse:@"网络请求失败"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [InnjiaPayUtil doErrorResponse:@"网络请求失败"];
    }];
}

- (BOOL)doPayAction:(NSDictionary *)response
{
    TokenUrls *urls = [TokenUrls sharedUrlInstance];
    BOOL flag = urls.tokenUlr.isValid && urls.payInfoUrl.isValid;
    BOOL bSendPay = NO;
    if (response) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)response];
        if (self.channel == PayChannelAliApp) {
            [dic setObject:self.scheme forKey:@"scheme"];
        }
        //支付方式
        switch (self.channel) {
            case PayChannelWxApp:
            {
                bSendPay = flag?[InnjiaAdapter innjiaWXPay:dic]:[InnjiaAdapter innjiaWXPay:dic andBody:self];
            }
                break;
            case PayChannelBaiduApp:
                bSendPay = [InnjiaAdapter innjiaBaiduPay:dic].isValid;
                break;
                //支付宝支付要放到后面
            case PayChannelAliApp:
            {
                bSendPay = flag?[InnjiaAdapter innjiaAliPay:dic]:[InnjiaAdapter innjiaAliPay:dic andBody:self];
            }
            default:
                break;
        }
    }
    if (!bSendPay) {
        [InnjiaPayUtil doErrorResponse:@"订单信息验证错误"];
    }
    return bSendPay;
}

- (BOOL)checkParametersForReqPay
{
    if (self.channel == PayChannelWxApp && ![InnjiaAdapter innjiaPayIsWXAppInstalled]) {
        [InnjiaPayUtil doErrorResponse:@"未安装微信客户端或微信版本过低"];
        return NO;
    }
    return YES;
}

@end
