//
//  NSObject+Combine.m
//  LED_Zheng
//
//  Created by DFD on 2017/4/6.
//  Copyright © 2017年 DFD. All rights reserved.
//

#import "NSObject+Combine.h"

@implementation NSObject (Combine)

/**
 把一条信息的点阵数据合成在一起
 
 @param arrayM 一条信息的所有点阵数据，
 @return 一个数组
 */
+ (NSArray <NSNumber *> *)conbineArray:(NSArray<NSArray <NSNumber*>*> *)arrayM{
    NSMutableArray *arrayResult = [NSMutableArray array];
    int index = 0;
    for (int i = 0; i < arrayM.count; i++) {
        NSArray *arraySimple = arrayM[i];
        for (int j = 0; j < arraySimple.count; j++) {
            arrayResult[index] = arraySimple[j];
            index++;
        }
    }
    return arrayResult;
}

+ (void)changeArray:(NSMutableArray *)dicArray
       orderWithKey:(NSString *)key
          ascending:(BOOL)yesOrNo{
    NSSortDescriptor *distanceDescriptor = [[NSSortDescriptor alloc] initWithKey:key
                                                                       ascending:yesOrNo];
    NSArray *descriptors = [NSArray arrayWithObjects:distanceDescriptor,nil];
    [dicArray sortUsingDescriptors:descriptors];
}

@end
