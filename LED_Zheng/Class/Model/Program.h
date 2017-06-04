//
//  Program.h
//  LED_Zheng
//
//  Created by DFD on 2017/4/7.
//  Copyright © 2017年 DFD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Program : NSObject

@property (nonatomic, assign) double  Id;               // 编号

@property (nonatomic, copy  ) NSString *text;           // 文字

@property (nonatomic, assign) int specialEffects;       // 特效  0x00 - 0x0B

@property (nonatomic, copy) NSString * specialEffectsString;    //

@property (nonatomic, assign) int speed;                // 速度  0x01 - 0x20          1-32

@property (nonatomic, assign) int residenceTime;        // 停留时间   0x00 - 0x32      0-50

@property (nonatomic, assign) int border;               // 边框      0：不带边框  1：带

@property (nonatomic, copy) NSString * borderString;    //

@property (nonatomic, assign) int showType;             // 显示类型     0：正常显示  1：竖显示

@property (nonatomic, copy) NSString * showTypeString;  //

@property (nonatomic, assign) int logo;                 // logo 的索引  未使用

@property (nonatomic, copy) NSString * logoString;      // 未使用


- (void)save;


+ (int)SpeedMax;

+ (int)SpeedMin;

+ (int)ResidenceTimeMax;

+ (int)ResidenceTimeMin;




@end
