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
 获取文本的点阵数据

 @param string 文本
 @return NSArray<NSArray <NSNumber*>*> * 类型
 */
+ (NSArray<NSArray <NSNumber*>*> *)getLatticeDataArray:(NSString *)string;

@end
