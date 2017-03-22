//
//  InnjiaPayTool.h
//  InnJia_2.0
//
//  Created by pg on 16/5/24.
//  Copyright © 2016年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InnjiaPayResp.h"
#import "XMGConst.h"
//@class InnjiaPayResp, PayBody;

@protocol InnjiaPayDelegate <NSObject>
@required
/**
 *  支付结果回调
 *
 *  @param resp 响应体，不同类型的请求，对应不同的响应
 */
- (void)innjiaPayResp:(InnjiaPayResp *)resp;

@end

@interface InnjiaPayTool : NSObject

+ (instancetype)sharedInstance;
/**
 *  需要在每次启动第三方应用程序时调用。第一次调用后，会在微信的可用应用列表中出现。
 *  iOS7及以上系统需要调起一次微信才会出现在微信的可用应用列表中。
 *
 *  @param wxAppID 微信开放平台创建APP的APPID
 *
 *  @return 成功返回YES，失败返回NO。只有YES的情况下，才能正常执行微信支付。
 */
+ (BOOL)initWeChatPay:(NSString *)wxAppID;
/**
 * 处理通过URL启动App时传递的数据。需要在application:openURL:sourceApplication:annotation:中调用。
 *
 * @param url 启动第三方应用时传递过来的URL
 *
 * @return 成功返回YES，失败返回NO。
 */
+ (BOOL)handleOpenUrl:(NSURL *)url;
/**
 *  发起支付请求
 *
 *  @param body 请求参数
 *
 *  @return 请求结果
 */
+ (BOOL)sendInnjiaReq:(PayBody *)body;
/**
 *  设置代理
 */
+ (void)setInnjiaDelegate:(id<InnjiaPayDelegate>)delegate;
/**
 *  @return 代理
 */
+ (id<InnjiaPayDelegate>)getInnjiaDelegate;
/**
 *  设置支付宝参数，都不能为空
 *
 *  @param PartnerID PartnerID
 *  @param sellerID  sellerID
 *  @param notifyURL notifyURL
 *
 *  @return 设置结果
 */
+ (BOOL)setAliPartnerID:(NSString *)PartnerID sellerID:(NSString *)sellerID notifyURL:(NSString *)notifyURL privateKey:(NSString *)privateKey;
/**
 *  设置
 *
 *  @param tokenUrl   获取token
 *  @param payInfoUrl 获取订单
 *
 *  @return 成功
 */
+ (BOOL)setTokenUrl:(NSString *)tokenUrl payInfoUrl:(NSString *)payInfoUrl;

+ (BOOL)setWXAppID:(NSString *)appID appSecret:(NSString *)appSecret partnerId:(NSString *)partnerId appKey:(NSString *)appKey partnerKey:(NSString *)partnerKey notifyUrl:(NSString *)notifyUrl;

@end

