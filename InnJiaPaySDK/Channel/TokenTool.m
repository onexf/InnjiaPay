//
//  TokenTool.m
//  InnJia
//
//  Created by pg on 16/7/14.
//  Copyright © 2016年 pg. All rights reserved.
//

#import "TokenTool.h"
#import "PayBody.h"
@implementation TokenTool


+ (instancetype)sharedTokenTool {
    static dispatch_once_t onceToken;
    static TokenTool *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[TokenTool alloc] init];
        instance.aliPayInfo = nil;
        instance.wxPayInfo = nil;
        instance.body = nil;
    });
    return instance;
}

@end
