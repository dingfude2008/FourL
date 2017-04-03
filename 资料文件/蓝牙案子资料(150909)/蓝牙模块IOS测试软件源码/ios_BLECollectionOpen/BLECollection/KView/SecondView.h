//
//  SecondView.h
//  BLECollection
//
//  Created by rfstar on 13-12-30.
//  Copyright (c) 2013年 rfstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBShapedButton.h"

#define TurntimingOutput           11         //定时翻转输出(2路)    fff0
#define LevelCountingPulse         12         //电平脉宽计数(2路)    fff0
#define PortTimingEventsConfig     13         //端口定时事件配置     fe00
#define ProgrammableIO             14         //可编程IO(8路)       fff0
#define DeviceInformation          15         //设备信息            180a
#define ModuleParameter            16         //模块参数设置        ff90
#define Anti_hijackingKey          17         //防支持密钥          ffc0
#define TagTmp                     1000

@protocol SecondViewDelegate;
@interface SecondView : UIView

@property (nonatomic , strong) OBShapedButton        *timingOutputBtn,*countPluseBtn,*timingConfigurationBtn,*programmableBtn,*deviceInformationBtn,*moduleSettingBtn,*anti_hijackingBtn;
@property (nonatomic , strong) UIImageView     *background;
@property (nonatomic , assign) id<SecondViewDelegate> delegate;

-(IBAction)secondOnclick:(id)sender;
@end

@protocol SecondViewDelegate <NSObject>

-(void)secondViewOnClick:(UIButton *)button position:(NSInteger)position;

@end
