//
//  TokenTool.h
//  InnJia
//
//  Created by pg on 16/7/14.
//  Copyright © 2016年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PayBody;
@interface TokenTool : NSObject
/**
 *  支付宝token信息
 */
@property (nonatomic, copy) NSDictionary *aliPayInfo;
/**
 *  微信token信息
 */
@property (nonatomic, copy) NSDictionary *wxPayInfo;
/**
 *  body
 */
@property (nonatomic, strong) PayBody *body;



+ (instancetype)sharedTokenTool;

@end
