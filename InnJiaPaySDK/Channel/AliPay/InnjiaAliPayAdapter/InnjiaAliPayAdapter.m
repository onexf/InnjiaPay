//
//  InnjiaAliPayAdapter.m
//  InnJia_2.0
//
//  Created by pg on 16/5/25.
//  Copyright © 2016年 pg. All rights reserved.
//

#import "InnjiaAliPayAdapter.h"
#import "InnjiaAdapterProtocpl.h"
#import <AlipaySDK/AlipaySDK.h>
#import "NSDictionary+Utils.h"
#import "NSString+IsValid.h"
#import "InnjiaPayResp.h"
#import "InnjiaPayCache.h"
#import "GenerateOrderstring.h"
#import "InnjiaPayTool.h"
#import "TokenTool.h"
@interface InnjiaAliPayAdapter ()<InnjiaAdapterDelegate>

@end
@implementation InnjiaAliPayAdapter


+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static InnjiaAliPayAdapter *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[InnjiaAliPayAdapter alloc] init];
    });
    return instance;
}

- (BOOL)aliPay:(NSMutableDictionary *)dic andBody:(PayBody *)body
{
    NSString *orderData = dic[@"orderData"];
    if (orderData.isValid) {
        dic[@"order_string"] = [GenerateOrderstring getOrderStingWithOrderSpec:[dic stringValueForKey:@"orderData" defaultValue:@""] privateKey:[dic stringValueForKey:@"RSA_PRIVATE" defaultValue:@""]];
    } else {
        dic[@"order_string"] = [GenerateOrderstring getOrderSting:body];
    }
    //签名
    NSString *orderString = [dic stringValueForKey:@"order_string" defaultValue:@""];
    NSString *scheme = [dic stringValueForKey:@"scheme" defaultValue:@""];
    if (orderString.isValid) {
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:scheme callback:^(NSDictionary *resultDic) {
            [[InnjiaAliPayAdapter sharedInstance] processOrderForAliPay:resultDic];
        }];
        return YES;
    }
    return NO;
}


- (BOOL)aliPay:(NSMutableDictionary *)dic
{
    //签名
    dic[@"order_string"] = [GenerateOrderstring getOrderStingWithOrderSpec:[dic stringValueForKey:@"orderData" defaultValue:@""] privateKey:[dic stringValueForKey:@"RSA_PRIVATE" defaultValue:@""]];
    NSString *orderString = [dic stringValueForKey:@"order_string" defaultValue:@""];
    NSString *scheme = [dic stringValueForKey:@"scheme" defaultValue:@""];
    id <InnjiaPayDelegate> delegate = [InnjiaPayTool getInnjiaDelegate];
    if (delegate && [delegate respondsToSelector:@selector(raiseUpPayingAPP)]) {
        [delegate raiseUpPayingAPP];
    }
    if (orderString.isValid) {
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:scheme callback:^(NSDictionary *resultDic) {
            [[InnjiaAliPayAdapter sharedInstance] processOrderForAliPay:resultDic];
        }];
        return YES;
    }
    return NO;
}

- (BOOL)handleOpenUrl:(NSURL *)url {
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        [[InnjiaAliPayAdapter sharedInstance] processOrderForAliPay:resultDic];
    }];
    return YES;
}
//结果
- (void)processOrderForAliPay:(NSDictionary *)resultDic {
    int status = [resultDic[@"resultStatus"] intValue];
    NSString *strMsg;
    int errcode = 0;
    switch (status) {
        case 9000:
        {
            TokenTool *tokens = [TokenTool sharedTokenTool];
            tokens.aliPayInfo = nil;
            tokens.wxPayInfo = nil;
            tokens.body = nil;
        }
            strMsg = @"支付成功";
            errcode = InnjiaErrCodeSuccess;
            break;
        case 4000:
        case 6002:
            strMsg = @"支付失败";
            errcode = InnjiaErrCodeSentFail;
            break;
        case 6001:
            strMsg = @"支付取消";
            errcode = InnjiaErrCodeUserCancel;
            break;
        default:
            strMsg = @"未知错误";
            errcode = InnjiaErrCodeUnsupport;
            break;
    }
    //发起回调
    InnjiaPayResp *resp = [InnjiaPayCache sharedInstance].innjiaResp;
    resp.resultMsg = strMsg;
    resp.resultCode = errcode;
    [InnjiaPayCache innjiaPayDoResponse];
}
@end
