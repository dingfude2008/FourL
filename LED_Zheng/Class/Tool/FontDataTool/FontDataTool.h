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
 通过长文本，获取到行列数据信息

 @param string 长文本
 @return 行列信息  NSArray 中是一个字符算一个元素，汉字算一个，英文字母算一个，符号也算一个元素
 NSDictionary Key： 1：要显示  0:不显示
              Value: NSArray 两个元素，  0: 列  1:行
 */
+ (NSArray<NSArray <NSDictionary*>*> *)getRowColumnDataFromText:(NSString *)string;

/**
 通过长文本， 获取对应的的点阵数据

 @param string 文本
 @return NSArray<NSArray <NSNumber*>*> * 类型
 子元素 NSArray 是一个（汉字、字母，符号）
 NSNumber 是点阵字符的10进制数据
 */
+ (NSArray<NSArray <NSNumber*>*> *)getLatticeDataArray:(NSString *)string;

/**
 通过字模数组信息，获取到行列数据信息
 
 @param arrayM 字模信息
 @return 行列数据信息。 数组中为行列的键值对。 Key: 是否有数据(@"1":有点  @"0":没有点) Value:NSArray 0:列，1:行
 */
+ (NSArray<NSArray <NSDictionary*>*> *)getRowColumnDataFromLatticeData:(NSArray<NSArray <NSNumber*>*> *)arrayM;




@end
