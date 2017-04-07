//
//  Program.h
//  LED_Zheng
//
//  Created by DFD on 2017/4/7.
//  Copyright © 2017年 DFD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Program : NSObject

@property (nonatomic, copy  ) NSString *text;           // 文字

@property (nonatomic, assign) int specialEffects;       // 特效  0x00 - 0xAB

@property (nonatomic, assign) int speed;                // 速度  0x01 - 0x20

@property (nonatomic, assign) int residenceTime;        // 停留时间   0x00 - 0x32

@property (nonatomic, assign) int border;               // 边框      0：不带边框  1：带

@property (nonatomic, copy) NSString * specialEffectsString;    // 特效  0x00 - 0xAB

@end
