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
#import "BCNetworking.h"
#import "AliKeysManager.h"
#import "NSString+IsValid.h"

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
        self.quantity = @"1";
    }
    return self;
}
#if 0

#endif

//- (NSString *)billNo
//{
//    return [_billNo substringWithRange:NSMakeRange(15, 32)];
//}
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
    if (self.title.length > 6) {
        self.title = [self.title substringToIndex:5];
    }
    parameters[@"title"] = self.title;
    
    parameters[@"quantity"] = self.quantity;
    parameters[@"returnType"] = @"url";

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
        [self getTokenWithDict:parameters];
//        [self doPayAction:parameters];
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
    BCHTTPSessionManager *manager = [BCHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    [manager POST:urls.tokenUlr parameters:parameters progress:nil
           success:^(NSURLSessionTask *task, id response) {
               /*
                * 0000 成功
                * 0001 该账号无绑定支付账号
                * 0002 无效的projectId
                * 0003 accessToken 已失效
                * 0004 无效的支付渠道
                * 0005 订单已经支付
                * 0006 唯一订单号格式不正确
                * 0007 TOKEN不能为空
                */
               if ([[response valueForKey:@"code"] isEqualToString:@"0000"]) {
                   [self getPayInfoWithDict:(NSDictionary *)response];
               } else {
                   [InnjiaPayUtil doErrorResponse:@"网络异常"];
               }
           } failure:^(NSURLSessionTask *operation, NSError *error) {
               [InnjiaPayUtil doErrorResponse:@"网络异常"];
           }];
    
    
}

- (void)getPayInfoWithDict:(NSDictionary *)response
{
    TokenUrls *urls = [TokenUrls sharedUrlInstance];
    BCHTTPSessionManager *manager = [BCHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    NSDictionary *dict = @{@"accessToken" : response[@"accessToken"]};
    [manager POST:urls.payInfoUrl parameters:dict progress:nil
          success:^(NSURLSessionTask *task, id response) {
              if ([[response valueForKey:@"code"] isEqualToString:@"0000"]) {
                  [self doPayAction:(NSDictionary *)response];
              } else {
                  [InnjiaPayUtil doErrorResponse:@"网络异常"];
              }
          } failure:^(NSURLSessionTask *operation, NSError *error) {
              [InnjiaPayUtil doErrorResponse:@"网络异常"];
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
            case PayChannelAliApp:
            {
                bSendPay = flag?[InnjiaAdapter innjiaAliPay:dic]:[InnjiaAdapter innjiaAliPay:dic andBody:self];
            }
                break;
            default:
                break;
        }
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
