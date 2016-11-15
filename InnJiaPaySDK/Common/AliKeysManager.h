//
//  AliKeysManager.h
//  InnJia_2.0
//
//  Created by pg on 16/6/3.
//  Copyright © 2016年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AliKeysManager : NSObject

/**
 *  partner
 */
@property (nonatomic, copy) NSString *partner;
/**
 *  seller
 */
@property (nonatomic, copy) NSString *seller;
/**
 *  notifyURL
 */
@property (nonatomic, copy) NSString *notifyURL;
/**
 *  privateKey
 */
@property (nonatomic, copy) NSString *privateKey;

+ (instancetype)sharedInstance;

@end

@interface TokenUrls : NSObject

/**
 *  获取token
 */
@property (nonatomic, copy) NSString *tokenUlr;
/**
 *  订单信息
 */
@property (nonatomic, copy) NSString *payInfoUrl;

+ (instancetype)sharedUrlInstance;

@end

@interface WXKeys : NSObject
/**
 *  微信appid
 */
@property (nonatomic, copy) NSString *wxAppID;
/**
 *  wxPayAppSecret
 */
@property (nonatomic, copy) NSString *WXAppSecret;
/**
 *  wxPayPartnerId
 */
@property (nonatomic, copy) NSString *WXPartnerId;
/**
 *  wxPayAppKey
 */
@property (nonatomic, copy) NSString *WXAppKey;
/**
 *  wxPayPartnerKey
 */
@property (nonatomic, copy) NSString *WXPartnerKey;
/**
 *  wxnotifyurl
 */
@property (nonatomic, copy) NSString *WXNotifyUrl;

+ (instancetype)sharedWXKeysInstance;

@end




