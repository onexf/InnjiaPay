//
//  GenerateOrderstring.m
//  InnJia_2.0
//
//  Created by pg on 16/5/25.
//  Copyright © 2016年 pg. All rights reserved.
//

#import "GenerateOrderstring.h"
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
#import "PayBody.h"
#import "DataSigner.h"
#import "AliKeysManager.h"
#import "CommonUtil.h"
@implementation GenerateOrderstring

+ (NSString *)getOrderSting:(PayBody *)body
{
    Order *order = [[Order alloc] init];
    //用户必传参数
    order.tradeNO = body.billNo;
    order.productName = body.title;
    order.productDescription = @"盈家订单";
    order.amount = [NSString stringWithFormat:@"%.2f", body.totalFee.floatValue];
    //配置参数
    AliKeysManager *aliKeys = [AliKeysManager sharedInstance];
    
    order.partner = aliKeys.partner;
    order.seller = aliKeys.seller;
    order.notifyURL = aliKeys.notifyURL;
    //固定参数
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    id<DataSigner> signer = CreateRSADataSigner(aliKeys.privateKey);
    NSString *signedString = [signer signString:orderSpec];
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
    }
    return orderString;
}

+ (NSString *)getOrderStingWithOrderSpec:(NSString *)orderSpec privateKey:(NSString *)privateKey
{
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
    }
    return orderString;
}

+ (NSString *)getSignWithDict:(NSMutableDictionary *)dict
{
    // 排序
    NSArray *keys = [dict allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    // 生成
    NSMutableString *sign = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [sign appendString:key];
        [sign appendString:@"="];
        [sign appendString:[dict objectForKey:key]];
        [sign appendString:@"&"];
    }
    NSString *signString = [[sign copy] substringWithRange:NSMakeRange(0, sign.length - 1)];
    
    NSString *result = [CommonUtil sha1:signString];
    NSLog(@"--- Gen sign: %@", result);
    return result;

}

@end
