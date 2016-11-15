//
//  InnjiaAdapter.h
//  InnJia_2.0
//
//  Created by pg on 16/5/25.
//  Copyright © 2016年 pg. All rights reserved.
//

static NSString * const kAdapterAliPay = @"InnjiaAliPayAdapter";
static NSString * const kAdapterWXPay = @"InnjiaWXPayAdapter";
static NSString * const kAdapterBaidu = @"InnjiaBaiduPayAdapter";

#import <Foundation/Foundation.h>
@class PayBody;
@interface InnjiaAdapter : NSObject

/**
 *  是否安装微信
 */
+ (BOOL)innjiaPayIsWXAppInstalled;
/**
 *  注册微信支付
 *  @param appid 微信id
 */
+ (BOOL)innjiaRegisterWeChat:(NSString *)appid;

/**
 *  传递参数发起微信支付
 *
 *  @param dic 参数
 *
 *  @return 结果
 */
+ (BOOL)innjiaWXPay:(NSMutableDictionary *)dic;
+ (BOOL)innjiaWXPay:(NSMutableDictionary *)dic andBody:(PayBody *)body;

/**
 *  传递参数发起支付宝支付
 *
 *  @param dic 参数
 *
 *  @return 结果
 */
+ (BOOL)innjiaAliPay:(NSMutableDictionary *)dic;

+ (BOOL)innjiaAliPay:(NSMutableDictionary *)dic andBody:(PayBody *)body;

/**
 *  支付完成返回应用
 *
 *  @param object 支付宝/微信
 *  @param url    url
 *
 *  @return 结果
 */
+ (BOOL)innjia:(NSString *)object handleOpenUrl:(NSURL *)url;
/**
 *  BY WXF
 *  百度支付 
 */
+ (NSString *)innjiaBaiduPay:(NSMutableDictionary *)dic;
@end
