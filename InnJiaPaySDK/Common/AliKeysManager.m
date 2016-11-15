//
//  AliKeysManager.m
//  InnJia_2.0
//
//  Created by pg on 16/6/3.
//  Copyright © 2016年 pg. All rights reserved.
//

#import "AliKeysManager.h"

@implementation AliKeysManager
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    __strong static AliKeysManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[AliKeysManager alloc] init];
        instance.partner = @"";
        instance.seller = @"";
        instance.notifyURL = @"";
        instance.privateKey = @"";
    });
    return instance;
}
@end

@implementation TokenUrls

+ (instancetype)sharedUrlInstance
{
    static dispatch_once_t onceToken;
    __strong static TokenUrls *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[TokenUrls alloc] init];
        instance.tokenUlr = @"";
        instance.payInfoUrl = @"";
    });
    return instance;
}

@end

@implementation WXKeys

+ (instancetype)sharedWXKeysInstance
{
    static dispatch_once_t onceToken;
    __strong static WXKeys *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[WXKeys alloc] init];
        instance.wxAppID = @"";
        instance.WXAppSecret = @"";
        instance.WXPartnerId = @"";
        instance.WXAppKey = @"";
        instance.WXPartnerKey = @"";
        instance.WXNotifyUrl = @"";
    });
    return instance;

}

@end
