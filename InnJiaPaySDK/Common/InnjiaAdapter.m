//
//  InnjiaAdapter.m
//  InnJia_2.0
//
//  Created by pg on 16/5/25.
//  Copyright © 2016年 pg. All rights reserved.
//
#import "InnjiaAdapter.h"
#import "InnjiaAdapterProtocpl.h"
#import "PayBody.h"
@implementation InnjiaAdapter

+ (BOOL)innjiaPayIsWXAppInstalled
{
    id adapter = [[NSClassFromString(kAdapterWXPay) alloc] init];
    if (adapter && [adapter respondsToSelector:@selector(isWXAppInstalled)]) {
        return [adapter isWXAppInstalled];
    }
    return NO;
}

+ (BOOL)innjiaRegisterWeChat:(NSString *)appid
{
    id adapter = [[NSClassFromString(kAdapterWXPay) alloc] init];
    if (adapter && [adapter respondsToSelector:@selector(registerWeChat:)]) {
        return [adapter registerWeChat:appid];
    }
    return NO;
}

+ (BOOL)innjiaWXPay:(NSMutableDictionary *)dic
{
    id adapter = [[NSClassFromString(kAdapterWXPay) alloc] init];
    if (adapter && [adapter respondsToSelector:@selector(wxPay:)]) {
        return [adapter wxPay:dic];
    }
    return NO;
}

+ (BOOL)innjiaWXPay:(NSMutableDictionary *)dic andBody:(PayBody *)body
{
    id adapter = [[NSClassFromString(kAdapterWXPay) alloc] init];
    if (adapter && [adapter respondsToSelector:@selector(wxPay:)]) {
        return [adapter wxPay:dic andBody:body];
    }
    return NO;
}

+ (BOOL)innjiaAliPay:(NSMutableDictionary *)dic
{
    id adapter = [[NSClassFromString(kAdapterAliPay) alloc] init];
    if (adapter && [adapter respondsToSelector:@selector(aliPay:)]) {
        return [adapter aliPay:dic];
    }
    return NO;
}

+ (BOOL)innjiaAliPay:(NSMutableDictionary *)dic andBody:(PayBody *)body
{
    id adapter = [[NSClassFromString(kAdapterAliPay) alloc] init];
    if (adapter && [adapter respondsToSelector:@selector(aliPay:)]) {
        return [adapter aliPay:dic andBody:body];
    }
    return NO;
}

+ (BOOL)innjia:(NSString *)object handleOpenUrl:(NSURL *)url;
{
    id adapter = [[NSClassFromString(object) alloc] init];
    if (adapter && [adapter respondsToSelector:@selector(handleOpenUrl:)]) {
        return [adapter handleOpenUrl:url];
    }
    return NO;
}

@end
