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
 组装点阵数据，方便发送给硬件

 @param array 纯文本的点阵数据
 @param isJustLast 是否只用在最后补
 
 @return 返回组装好的点阵数据
 */
+ (NSArray<NSNumber*> *)combineLatticeDataArray:(NSArray<NSArray <NSNumber*>*> *)array
                                  isJustAddLast:(BOOL)isJustLast;

/**
 通过字模数组信息，获取到行列数据信息
 
 @param arrayM 字模信息
 @return 行列数据信息。 数组中为行列的键值对。 Key: 是否有数据(@"1":有点  @"0":没有点) Value:NSArray 0:列，1:行
 */
+ (NSArray<NSArray <NSDictionary*>*> *)getRowColumnDataFromLatticeData:(NSArray<NSArray <NSNumber*>*> *)arrayM;



/**
 获取预览的文字
 
 @param array 一条节目的点阵数据
 @param endLocation 结束的位置
 @return 组装好的显示文字
 */
+ (NSArray<NSArray <NSNumber*>*> *)getShowTextData:(NSArray<NSArray <NSNumber*>*> *)array
                                    endLocation:(int)endLocation;


/**
 把原来的纯点阵数据转换为竖立的点阵数据
 
 @param array 纯点阵数据
 @return 转换后的点阵数据
 */
+ (NSArray<NSArray <NSNumber*>*> *)getStandUpDataArray:(NSArray<NSArray <NSNumber*>*> *)array;

@end
