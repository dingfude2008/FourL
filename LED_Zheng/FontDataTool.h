//
//  FontDataTool.h
//  BMPTool
//
//  Created by DFD on 2017/4/1.
//  Copyright © 2017年 DFD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FontDataTool : NSObject

/**
 初始化数据
 */
+ (void)setupData;


/**
 通过文字，获取到行列数据信息

 @param string 文字
 @return 行列信息
 */
+ (NSArray<NSArray <NSDictionary*>*> *)getRowColumnDataFromText:(NSString *)string;

/**
 获取文本的点阵数据

 @param string 文本
 @return NSArray<NSArray <NSNumber*>*> * 类型
 */
+ (NSArray<NSArray <NSNumber*>*> *)getLatticeDataArray:(NSString *)string;

/**
 通过字模数组信息，获取到行列数据信息
 
 @param arrayM 字模信息
 @return 行列数据信息。 数组中为行列的键值对。 Key: 是否有数据(@"1":有点  @"0":没有点) Value:NSArray 0:列，1:行
 */
+ (NSArray<NSArray <NSDictionary*>*> *)getRowColumnDataFromLatticeData:(NSArray<NSArray <NSNumber*>*> *)arrayM;

@end
