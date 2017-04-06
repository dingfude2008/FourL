//
//  NSObject+Combine.h
//  LED_Zheng
//
//  Created by DFD on 2017/4/6.
//  Copyright © 2017年 DFD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Combine)


/**
 把一条信息的点阵数据合成在一起
 
 @param arrayM 一条信息的所有点阵数据，
 @return 一个数组
 */
+ (NSArray <NSNumber *> *)conbineArray:(NSArray<NSArray <NSNumber*>*> *)arrayM;

@end
