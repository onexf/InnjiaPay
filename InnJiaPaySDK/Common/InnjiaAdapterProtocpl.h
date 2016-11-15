//
//  InnjiaAdapterProtocpl.h
//  InnJia_2.0
//
//  Created by pg on 16/5/25.
//  Copyright © 2016年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PayBody;
@protocol InnjiaAdapterDelegate <NSObject>

@optional
/**
 *  是否安装微信
 */
- (BOOL)isWXAppInstalled;
/**
 *  注册微信appid
 *
 *  @param appid 微信appid
 *
 *  @return 成功，失败
 */
- (BOOL)registerWeChat:(NSString *)appid;

- (BOOL)handleOpenUrl:(NSURL *)url;
/**
 *  调起微信SDK
 *
 *  @param dic 参数
 *
 *  @return 结果
 */
- (BOOL)wxPay:(NSMutableDictionary *)dic;
- (BOOL)wxPay:(NSMutableDictionary *)dic andBody:(PayBody *)body;

/**
 *  调起支付宝SDK
 *
 *  @param dic 参数
 *
 *  @return 结果
 */
- (BOOL)aliPay:(NSMutableDictionary *)dic;

- (BOOL)aliPay:(NSMutableDictionary *)dic andBody:(PayBody *)body;
/**
 *  BY WXF
 *  2016-9-19
 *  百度支付
 */
- (NSString *)baiduPay:(NSMutableDictionary *)dic;

@end
