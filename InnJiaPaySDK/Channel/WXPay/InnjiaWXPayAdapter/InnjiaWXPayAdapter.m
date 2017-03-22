//
//  InnjiaWXPayAdapter.m
//  InnJia
//
//  Created by pg on 16/6/24.
//  Copyright © 2016年 pg. All rights reserved.
//

#import "InnjiaWXPayAdapter.h"
#import "WXApi.h"
#import "InnjiaAdapterProtocpl.h"
#import "NSDictionary+Utils.h"
#import "InnjiaPayResp.h"
#import "NSString+IsValid.h"
#import "InnjiaPayCache.h"
#import "CommonUtil.h"
#import "AliKeysManager.h"

#import "InnjiaPayUtil.h"
#import "ApiXml.h"
@interface InnjiaWXPayAdapter ()<InnjiaAdapterDelegate, WXApiDelegate>

@end

@implementation InnjiaWXPayAdapter

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static InnjiaWXPayAdapter *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[InnjiaWXPayAdapter alloc] init];
    });
    return instance;
}

- (BOOL)isWXAppInstalled
{
    return [WXApi isWXAppInstalled];
}

- (BOOL)registerWeChat:(NSString *)appid {
    return [WXApi registerApp:appid];
}

- (BOOL)handleOpenUrl:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:[InnjiaWXPayAdapter sharedInstance]];
}

- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *tempResp = (PayResp *)resp;
        NSString *strMsg = nil;
        int errcode = 0;
        switch (tempResp.errCode) {
            case WXSuccess:
                strMsg = @"支付成功";
                errcode = InnjiaErrCodeSuccess;
                break;
            case WXErrCodeUserCancel:
                strMsg = @"支付取消";
                errcode = InnjiaErrCodeUserCancel;
                break;
            default:
                strMsg = @"支付失败";
                errcode = InnjiaErrCodeSentFail;
                break;
        }
        NSString *result = tempResp.errStr.isValid?[NSString stringWithFormat:@"%@,%@",strMsg,tempResp.errStr]:strMsg;
        //发起回调
        InnjiaPayResp *innjiaResp = [InnjiaPayCache sharedInstance].innjiaResp;
        innjiaResp.resultMsg = result;
        innjiaResp.resultCode = errcode;
        [InnjiaPayCache innjiaPayDoResponse];
    }
}
//后台版
- (BOOL)wxPay:(NSMutableDictionary *)dic
{
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = [dic stringValueForKey:@"partnerid" defaultValue:@""];
    request.prepayId = [dic stringValueForKey:@"prepayid" defaultValue:@""];
    request.package = [dic stringValueForKey:@"package" defaultValue:@"Sign=WXPay"];//固定值
    request.nonceStr = [dic stringValueForKey:@"noncestr" defaultValue:@""];
    NSString *time = [dic stringValueForKey:@"timestamp" defaultValue:@""];
    request.timeStamp = time.intValue;
    request.sign = [dic stringValueForKey:@"sign" defaultValue:@""];
    BOOL result = [WXApi sendReq:request];
    return result;
}

#pragma mark - 以下签名，获取预支付订单代码（无后台）
- (BOOL)wxPay:(NSMutableDictionary *)dic andBody:(PayBody *)body
{
    NSString *prepayid = [self getPrepayIdWithBody:body];
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = [dic stringValueForKey:@"partnerid" defaultValue:@""];
    request.prepayId = prepayid;
    request.package = @"Sign=WXPay";//固定值
    request.nonceStr = [dic stringValueForKey:@"noncestr" defaultValue:@""];
    NSString *time = [dic stringValueForKey:@"timestamp" defaultValue:@""];
    request.timeStamp = time.intValue;
    request.sign = [dic stringValueForKey:@"sign" defaultValue:@""];
    return [WXApi sendReq:request];
}

- (NSString *)getPrepayIdWithBody:(PayBody *)body
{
    NSString *prepayid = nil;
    NSMutableDictionary *postData = [self getProductArgsWithBody:body];
    NSString *send = [self getPackage:postData];
    NSData *res = [CommonUtil httpSend:@"https://api.mch.weixin.qq.com/pay/unifiedorder" method:@"POST" data:send];
    XMLHelper *xml  = [[XMLHelper alloc] init];
    [xml startParse:res];
    NSMutableDictionary *resParams = [xml getDict];
//    NSLog(@"%@---%@", resParams, [resParams valueForKey:@"return_msg"]);
    NSString *return_code   = [resParams objectForKey:@"return_code"];
    if ([return_code isEqualToString:@"SUCCESS"]) {
        NSString *send_sign = [resParams objectForKey:@"sign"] ;
        NSString *sign = [self genSign:resParams];
        //这里可能直接对比之前的sign
        if ([sign isEqualToString:send_sign]) {
            prepayid = [resParams objectForKey:@"prepay_id"];
        } else {
            [InnjiaPayUtil doErrorResponse:resParams[@"return_msg"]];
        }
    } else {
        [InnjiaPayUtil doErrorResponse:resParams[@"return_msg"]];
    }
    return prepayid;
}

- (NSMutableDictionary *)getProductArgsWithBody:(PayBody *)body
{
    WXKeys *wxKeys = [WXKeys sharedWXKeysInstance];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"appid"] = wxKeys.wxAppID;//微信开放平台审核通过的应用APPID
    params[@"mch_id"] = wxKeys.WXPartnerId;//微信支付分配的商户号
    params[@"nonce_str"] = [self genNonceStr];//随机字符串，不长于32位
    params[@"body"] = body.title;//商品或支付单简要描述
    params[@"out_trade_no"] = body.billNo;//商户系统内部的订单号,32个字符内、可包含字母, 其他说明见商户订单号
    params[@"total_fee"] = [NSString stringWithFormat:@"%d", (int)(body.totalFee.floatValue * 100)];//订单总金额，单位为分，详见支付金额
    params[@"spbill_create_ip"] = [CommonUtil getIPAddress:YES];//用户端实际ip
    params[@"notify_url"] = wxKeys.WXNotifyUrl;//接收微信支付异步通知回调地址，通知url必须为直接可访问的url，不能携带参数。
    params[@"trade_type"] = @"APP";
    return params;
}

- (NSString *)genSign:(NSDictionary *)signParams
{
    // 排序
    NSArray *keys = [signParams allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    // 生成
    NSMutableString *sign = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [sign appendString:key];
        [sign appendString:@"="];
        [sign appendString:[signParams objectForKey:key]];
        [sign appendString:@"&"];
    }
    NSString *stringA = [[sign copy] substringWithRange:NSMakeRange(0, sign.length - 1)];
    WXKeys *wxKeys = [WXKeys sharedWXKeysInstance];
    NSString *stringSignTemp = [NSString stringWithFormat:@"%@&key=%@", stringA, wxKeys.WXAppSecret];
    NSString *md5Strig = [CommonUtil md5:stringSignTemp];
    NSString *result = [self toUpper:md5Strig];
    return result;
}

-(NSString *)toUpper:(NSString *)str{
    for (NSInteger i=0; i<str.length; i++) {
        if ([str characterAtIndex:i]>='a'&[str characterAtIndex:i]<='z') {
            char temp=[str characterAtIndex:i]-32;
            NSRange range=NSMakeRange(i, 1);
            str=[str stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"%c",temp]];
        }
    } return str;
}

//获取package带参数的签名包
- (NSString *)getPackage:(NSMutableDictionary*)packageParams
{
    NSString *sign;
    NSMutableString *reqPars=[NSMutableString string];
    //生成签名
    sign = [self genSign:packageParams];
    //生成xml的package
    NSArray *keys = [packageParams allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    [reqPars appendString:@"<xml>\n"];
    
    for (NSString *categoryId in sortedKeys) {
        [reqPars appendFormat:@"<%@>%@</%@>\n", categoryId, [packageParams objectForKey:categoryId],categoryId];
    }
    [reqPars appendFormat:@"<sign>%@</sign>\n</xml>", sign];
    return [NSString stringWithString:reqPars];
}

- (NSString *)genTimeStamp
{
    return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
}
- (NSString *)genNonceStr
{
    return [CommonUtil md5:[NSString stringWithFormat:@"%d", arc4random() % 10000]];
}
- (NSString *)genTraceId
{
    return [NSString stringWithFormat:@"crestxu_%@", [self genTimeStamp]];
}

@end
