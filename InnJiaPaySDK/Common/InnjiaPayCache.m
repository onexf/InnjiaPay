//
//  InnjiaPayCache.m
//  InnJia_2.0
//
//  Created by pg on 16/5/26.
//  Copyright © 2016年 pg. All rights reserved.
//

#import "InnjiaPayCache.h"
#import "InnjiaPayResp.h"
#import "InnjiaPayTool.h"
@implementation InnjiaPayCache

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    __strong static InnjiaPayCache *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[InnjiaPayCache alloc] init];
        instance.innjiaResp = [[InnjiaPayResp alloc] init];
    });
    return instance;
}

+ (BOOL)innjiaPayDoResponse
{
    id <InnjiaPayDelegate> delegate = [InnjiaPayTool getInnjiaDelegate];
    if (delegate && [delegate respondsToSelector:@selector(innjiaPayResp:)]) {
        [delegate innjiaPayResp:[InnjiaPayCache sharedInstance].innjiaResp];
        return YES;
    }
    return NO;
}

@end
