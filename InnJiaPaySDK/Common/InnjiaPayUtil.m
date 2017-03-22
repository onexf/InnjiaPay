//
//  InnjiaPayUtil.m
//  InnJia_2.0
//
//  Created by pg on 16/5/25.
//  Copyright © 2016年 pg. All rights reserved.
//

#import "InnjiaPayUtil.h"
#import "InnjiaPayCache.h"
@implementation InnjiaPayUtil

+ (NSString *)getChannelString:(PayChannel)channel
{
    NSString *cType = @"";
    switch (channel) {
        case PayChannelWxApp:
#if DEBUG
            cType = @"wxpayTest";
#else
            cType = @"LBLSWXpay";
#endif
            break;
        case PayChannelAliApp:
#if DEBUG
            cType = @"alipay";
#else
            cType = @"LBLSalipayFormal";
#endif
            break;
        default:
            break;
    }
    return cType;
}

/**
 *  签名验证
 *
 *  @return app_id， timestamp， app_sign
 */
+ (NSMutableDictionary *)prepareParametersForRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //可添加固定参数（预留）
    parameters[@"appId"] = [[NSBundle mainBundle] bundleIdentifier];
    parameters[@"version"] = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    parameters[@"appName"] = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    return parameters;
}

+ (InnjiaPayUrlType)getUrlType:(NSURL *)url
{
    if ([url.host isEqualToString:@"safepay"])
        return InnjiaPayUrlAlipay;
    else if ([url.scheme hasPrefix:@"wx"] && [url.host isEqualToString:@"pay"])
        return InnjiaPayUrlWeChat;
    else
        return InnjiaPayUrlUnknown;
}

+ (InnjiaPayResp *)doErrorResponse:(NSString *)errMsg
{
    InnjiaPayResp *resp = [InnjiaPayCache sharedInstance].innjiaResp;
    resp.resultCode = InnjiaErrCodeCommon;
    resp.resultMsg = errMsg;
    [InnjiaPayCache innjiaPayDoResponse];
    return resp;
}

+ (InnjiaPayResp *)getErrorInResponse:(NSDictionary *)response
{
    return nil;
}
@end
