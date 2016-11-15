//
//  GenerateOrderstring.h
//  InnJia_2.0
//
//  Created by pg on 16/5/25.
//  Copyright © 2016年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PayBody;
@interface GenerateOrderstring : NSObject
/**
 *  生成支付宝OrderString
 *
 *  @param body 支付请求体
 *
 *  @return OrderString
 */
+ (NSString *)getOrderSting:(PayBody *)body;
/**
 *  本应该后台做的操作，后台无法正确签名，由前端来签
 */
+ (NSString *)getOrderStingWithOrderSpec:(NSString *)orderSpec privateKey:(NSString *)privateKey;

+ (NSString *)getSignWithDict:(NSMutableDictionary *)dict;

@end
