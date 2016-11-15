//
//  InnjiaPayTool.m
//  InnJia_2.0
//
//  Created by pg on 16/5/24.
//  Copyright © 2016年 pg. All rights reserved.
//

#import "InnjiaPayTool.h"
#import "InnjiaPayTool+Utils.h"
#import "InnjiaPayUtil.h"
#import "InnjiaAdapter.h"
#import "AliKeysManager.h"
#import "NSString+IsValid.h"

@interface InnjiaPayTool ()

/**
 *  代理属性
 */
@property (nonatomic, weak) id<InnjiaPayDelegate> delegate;

@end

@implementation InnjiaPayTool

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static InnjiaPayTool *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[InnjiaPayTool alloc] init];
    });
    return instance;
}

+ (BOOL)sendInnjiaReq:(PayBody *)body
{
    InnjiaPayTool *instance = [InnjiaPayTool sharedInstance];
    BOOL reqResult = YES;
    [instance reqPay:body];
    return reqResult;
}

+ (BOOL)initWeChatPay:(NSString *)wxAppID;
{
    if (!wxAppID.isValid) {
        return NO;
    } return [InnjiaAdapter innjiaRegisterWeChat:wxAppID];
}
+ (BOOL)handleOpenUrl:(NSURL *)url;
{
    if (InnjiaPayUrlAlipay == [InnjiaPayUtil getUrlType:url]) {
        return [InnjiaAdapter innjia:kAdapterAliPay handleOpenUrl:url];
    } else if (InnjiaPayUrlWeChat == [InnjiaPayUtil getUrlType:url]){
        return [InnjiaAdapter innjia:kAdapterWXPay handleOpenUrl:url];
    }
    return NO;
}

+ (void)setInnjiaDelegate:(id<InnjiaPayDelegate>)delegate
{
    [InnjiaPayTool sharedInstance].delegate = delegate;
}
+ (id<InnjiaPayDelegate>)getInnjiaDelegate
{
    return [InnjiaPayTool sharedInstance].delegate;
}

+ (BOOL)setAliPartnerID:(NSString *)PartnerID sellerID:(NSString *)sellerID notifyURL:(NSString *)notifyURL privateKey:(NSString *)privateKey
{
    if (PartnerID.isValid && sellerID.isValid && sellerID.isValid && notifyURL.isValid && privateKey.isValid) {
        AliKeysManager *aliKeys = [AliKeysManager sharedInstance];
        aliKeys.partner = PartnerID;
        aliKeys.seller = sellerID;
        aliKeys.notifyURL = notifyURL;
        aliKeys.privateKey = privateKey;
        return YES;
    } return NO;
}

+ (BOOL)setTokenUrl:(NSString *)tokenUrl payInfoUrl:(NSString *)payInfoUrl
{
    if (tokenUrl.isValid && payInfoUrl.isValid) {
        TokenUrls *urls = [TokenUrls sharedUrlInstance];
        urls.tokenUlr = tokenUrl;
        urls.payInfoUrl = payInfoUrl;
        return YES;
    } return NO;
}

+ (BOOL)setWXAppID:(NSString *)appID appSecret:(NSString *)appSecret partnerId:(NSString *)partnerId appKey:(NSString *)appKey partnerKey:(NSString *)partnerKey notifyUrl:(NSString *)notifyUrl
{
    if (appID.isValid && appSecret.isValid && partnerId.isValid && notifyUrl.isValid) {
        WXKeys *wxKeys = [WXKeys sharedWXKeysInstance];
        wxKeys.wxAppID = appID;
        wxKeys.WXAppSecret = appSecret;
        wxKeys.WXPartnerId = partnerId;
        wxKeys.WXAppKey = appKey;
        wxKeys.WXPartnerKey = partnerKey;
        wxKeys.WXNotifyUrl = notifyUrl;
        return YES;
    } return NO;
}
@end
