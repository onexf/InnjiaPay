//
//  InnjiaPayResp.m
//  InnJia_2.0
//
//  Created by pg on 16/5/24.
//  Copyright © 2016年 pg. All rights reserved.
//

#import "InnjiaPayResp.h"
@implementation InnjiaPayResp

- (instancetype)initWithReq:(PayBody *)request
{
    self = [super init];
    if (self) {
        self.payBody = request;
        self.resultCode = InnjiaErrCodeCommon;
        self.resultMsg = @"";
    }
    return self;
}

@end
