
//  FirstView.h
//  BLECollection
//
//  Created by rfstar on 13-12-30.
//  Copyright (c) 2013年 rfstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBShapedButton.h"

#define BluetoothDataChannel   1  //蓝牙数据通道  ffe5
#define SerialDataChannel      2  //串口数据通道  ffe0
#define ADCInput               3  //ADC输入（2路）ffd0
#define RSSIReport             4  //RSSI 报告    ffa0
#define PWMOutput              5  //pwm输出（4路）ffb0
#define BatteryReport          6  //电池电量报告   180f
#define TAGTMP                 1000

@protocol FirstViewDelegate;
@interface FirstView : UIView

@property (nonatomic , strong) OBShapedButton        *ffe5Btn,*ffe0Btn,*ffd0Btn,*ffa0Btn,*ffb0Btn,*_180fBtn;
@property (nonatomic , strong) UIImageView     *background;

@property (nonatomic , strong) id<FirstViewDelegate> delegate;
@end

@protocol  FirstViewDelegate <NSObject>

-(void)firstViewOnClick:(UIButton *)button position:(NSInteger)position;

@end