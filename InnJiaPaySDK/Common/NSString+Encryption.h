//
//  NSString+Encryption.h
//  InnJia_2.0
//
//  Created by pg on 16/5/24.
//  Copyright © 2016年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encryption)
/**
 *  MD5加密
 *
 *  @param string 需要加密的数据
 *
 *  @return 加密结果
 */
- (NSString *)stringToMD5:(NSString *)string;
/**
 *  sha1加密
 *
 *  @param key    秘钥
 *  @param string 需要加密的字符串
 *
 *  @return 加密结果
 */
//- (NSString *)stringToSHA1WithKey:(NSString *)key string:(NSString *)string;


@end
