//
//  InnjiaPayCache.h
//  InnJia_2.0
//
//  Created by pg on 16/5/26.
//  Copyright © 2016年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>
@class InnjiaPayResp;
@interface InnjiaPayCache : NSObject
/**
 *  响应体
 */
@property (nonatomic, strong) InnjiaPayResp *innjiaResp;

+ (instancetype)sharedInstance;
/**
 *  发起回调
 *
 *  @return 返回YES回调成功，NO回调失败
 */
+ (BOOL)innjiaPayDoResponse;
@end
