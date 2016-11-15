//
//  InnjiaPayTool+Utils.m
//  InnJia_2.0
//
//  Created by pg on 16/5/25.
//  Copyright © 2016年 pg. All rights reserved.
//

#import "InnjiaPayTool+Utils.h"
#import "PayBody.h"
@implementation InnjiaPayTool (Utils)

- (void)reqPay:(PayBody *)body
{
    [body payReq];
}

@end
