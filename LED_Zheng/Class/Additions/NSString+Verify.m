//
//  NSString+Verify.m
//  EShoping
//
//  Created by Seven on 14-11-29.
//  Copyright (c) 2014年 FUEGO. All rights reserved.
//

#import "NSString+Verify.h"

// 01 - 59
static NSString *const regex = @"\\[[1-5]{1}[0-9]{1}\\]|\\[[0]{1}[1-9]{1}\\]";

@implementation NSString (Verify)

// 是否是表情
- (BOOL)isLogo{
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [emailTest evaluateWithObject:self];
}

// 是否含有表情
- (BOOL)isContainLogo{
    NSArray<NSTextCheckingResult *> *arrayResult = [self rangeLogoInString];
    if (arrayResult.count > 0) {
        return YES;
    }else{
        return NO;
    }
}

// 表情所占的索引位置集合
- (NSArray<NSTextCheckingResult *> *)rangeLogoInString{
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionUseUnixLineSeparators error:NULL];
    NSArray<NSTextCheckingResult *> * arrayResult = [regularExpression matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    return arrayResult;
}



@end
