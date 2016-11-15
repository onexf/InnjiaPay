//
//  NSString+Encryption.m
//  InnJia_2.0
//
//  Created by pg on 16/5/24.
//  Copyright © 2016年 pg. All rights reserved.
//

#import "NSString+Encryption.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (Encryption)

- (NSString *)stringToMD5:(NSString *)string
{
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}

//- (NSString *)stringToSHA1WithKey:(NSString *)key string:(NSString *)string;
//{
//    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
//    const char *cData = [string cStringUsingEncoding:NSUTF8StringEncoding];
//    char cHMAC[CC_SHA1_DIGEST_LENGTH];
//    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
//    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
//    NSString *hash = [HMAC base64EncodedString];//base64 编码。
//    return hash;
//}


@end
