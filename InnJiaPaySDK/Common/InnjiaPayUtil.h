//
//  InnjiaPayUtil.h
//  InnJia_2.0
//
//  Created by pg on 16/5/25.
//  Copyright © 2016年 pg. All rights reserved.
//
//支付类型
typedef NS_ENUM(NSInteger, InnjiaPayUrlType) {
    /**
     *  Unknown type.
     */
    InnjiaPayUrlUnknown,
    /**
     *  WeChat pay.
     */
    InnjiaPayUrlWeChat,
    /**
     *  Alipay.
     */
    InnjiaPayUrlAlipay
};
#import <Foundation/Foundation.h>
#import "InnjiaPayResp.h"
@interface InnjiaPayUtil : NSObject
/**
 *  支付类型
 *
 *  @param channel 类型（枚举）
 *
 *  @return 类型（字符串）
 */
+ (NSString *)getChannelString:(PayChannel)channel;

/**
 *  准备请求参数
 *
 *  @return 请求参数
 */
+ (NSMutableDictionary *)prepareParametersForRequest;
/**
 *  获取url的类型，微信或者支付宝
 *
 *  @param url 渠道返回的url
 *
 *  @return 微信或者支付宝
 */
+ (InnjiaPayUrlType)getUrlType:(NSURL *)url;
/**
 *  错误回调
 *  @param errMsg 错误信息
 */
+ (InnjiaPayResp *)doErrorResponse:(NSString *)errMsg;
/**
 *  服务端返回错误，执行错误回调
 *
 *  @param response 服务端返回参数
 */
+ (InnjiaPayResp *)getErrorInResponse:(NSDictionary *)response;

@end
