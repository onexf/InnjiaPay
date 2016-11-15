//
//  NSString+NSString_IsValid.m
//  BCPay
//
//  Created by Ewenlong03 on 15/8/28.
//  Copyright (c) 2015年 BeeCloud. All rights reserved.
//

#import "NSString+IsValid.h"
@implementation NSString (IsValid)

- (BOOL)isValid {
    if (self == nil || (NSNull *)self == [NSNull null] || self.length == 0 ) return NO;
    return YES;
}
- (BOOL)isValidUUID {
    if (!self.isValid || self.length != 36) return NO;
    for (NSUInteger i = 0; i < self.length; i++) {
        unichar ch = [self characterAtIndex:i];
        if (i == 8 || i == 13 || i == 18 || i == 23) {
            if (ch != '-')
                return NO;
        } else {
            if (!([self isDigit:ch] || (ch >= 'a' && ch <= 'f') || (ch >= 'A' && ch <= 'F')))
                return NO;
        }
    }
    return YES;
}
- (BOOL)isValidTraceNo {
    if (!self.isValid) return NO;
    for (NSUInteger i = 0; i < self.length; i++) {
        unichar ch = [self characterAtIndex:i];
        // Invalid character.
        if (![self isLetter:ch] && ![self isDigit:ch]) return NO;
    }
    return YES;
}
- (BOOL)isPureInt {
    NSScanner *scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)isPureFloat {
    NSScanner *scan = [NSScanner scannerWithString:self];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}
- (BOOL)isLetter:(unichar)ch {
    return (BOOL)((ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z'));
}

- (BOOL)isDigit:(unichar)ch {
    return (BOOL)(ch >= '0' && ch <= '9');
}

@end
