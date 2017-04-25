//
//  NSString+Verify.h
//  EShoping
//
//  Created by Seven on 14-11-29.
//  Copyright (c) 2014年 FUEGO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Verify)

// 是否是表情
- (BOOL)isLogo;

// 是否含有表情
- (BOOL)isContainLogo;

// 表情所占的索引位置集合
- (NSArray<NSTextCheckingResult *> *)rangeLogoInString;


@end
