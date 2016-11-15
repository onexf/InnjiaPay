//
//  NSString+NSString_IsValid.h
//  BCPay
//
//  Created by Ewenlong03 on 15/8/28.
//  Copyright (c) 2015年 BeeCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSString (IsValid)
/**
 *  字符串是否有效（长度>0）
 *
 *  @return YES有效，NO无效
 */
- (BOOL)isValid;
- (BOOL)isPureInt;
- (BOOL)isValidTraceNo;
- (BOOL)isPureFloat;
- (BOOL)isValidUUID;

@end
