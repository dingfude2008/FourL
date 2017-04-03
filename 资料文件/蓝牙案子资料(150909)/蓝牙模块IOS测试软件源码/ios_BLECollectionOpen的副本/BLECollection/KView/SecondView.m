//
//  SecondView.m
//  BLECollection
//
//  Created by rfstar on 13-12-30.
//  Copyright (c) 2013年 rfstar. All rights reserved.
//

#import "SecondView.h"

@implementation SecondView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _background = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 320)];
        [_background setImage:[UIImage imageNamed:@"page2-640.png"]];
        [_background setUserInteractionEnabled:YES];
        [self addSubview:_background];
        
        [self initButton];
    }
    return self;
}

-(void)initButton
{
    _countPluseBtn = [[OBShapedButton alloc]initWithFrame:CGRectMake(9, 39.5, 142, 64.5)];
    [_countPluseBtn setTag:TagTmp+LevelCountingPulse ];
    [_countPluseBtn setImage:[UIImage imageNamed:@"p2-10.png"] forState:UIControlStateHighlighted];
    [_countPluseBtn addTarget:self action:@selector(secondOnclick:) forControlEvents:UIControlEventTouchUpInside];
    [_background addSubview:_countPluseBtn];
    
    _timingConfigurationBtn = [[OBShapedButton alloc]initWithFrame:CGRectMake(198, 47, 111.5, 111.5)];
    [_timingConfigurationBtn setTag:TagTmp+PortTimingEventsConfig];
    [_timingConfigurationBtn setImage:[UIImage imageNamed:@"p2-9.png"] forState:UIControlStateHighlighted];
    [_timingConfigurationBtn addTarget:self action:@selector(secondOnclick:) forControlEvents:UIControlEventTouchUpInside];
    [_background addSubview:_timingConfigurationBtn];
    
    _programmableBtn = [[OBShapedButton alloc]initWithFrame:CGRectMake(4, 96.7, 141, 63)];
     _programmableBtn.tag = TagTmp+ProgrammableIO;
    [_programmableBtn setImage:[UIImage imageNamed:@"p2-11.png"] forState:UIControlStateHighlighted];
    [_programmableBtn addTarget:self action:@selector(secondOnclick:) forControlEvents:UIControlEventTouchUpInside];
    [_background addSubview:_programmableBtn];
    
    _deviceInformationBtn = [[OBShapedButton alloc]initWithFrame:CGRectMake(89.5, 157.5, 124.5, 60)];
    _deviceInformationBtn.tag = TagTmp + DeviceInformation;
    [_deviceInformationBtn setImage:[UIImage imageNamed:@"p2-12.png"] forState:UIControlStateHighlighted];
    [_deviceInformationBtn addTarget:self action:@selector(secondOnclick:) forControlEvents:UIControlEventTouchUpInside];
    [_background addSubview:_deviceInformationBtn];
    
    _moduleSettingBtn = [[OBShapedButton alloc]initWithFrame:CGRectMake(35.5, 244, 118, 66.5)];
    _moduleSettingBtn.tag = TagTmp + ModuleParameter;
    [_moduleSettingBtn setImage:[UIImage imageNamed:@"p2-13.png"] forState:UIControlStateHighlighted];
    [_moduleSettingBtn addTarget:self action:@selector(secondOnclick:) forControlEvents:UIControlEventTouchUpInside];
    [_background addSubview:_moduleSettingBtn];
    
    _anti_hijackingBtn = [[OBShapedButton alloc]initWithFrame:CGRectMake(213.5, 206, 84.5, 100)];
    _anti_hijackingBtn.tag = TagTmp + Anti_hijackingKey;
    [_anti_hijackingBtn setImage:[UIImage imageNamed:@"p2-7.png"] forState:UIControlStateHighlighted];
    [_anti_hijackingBtn addTarget:self action:@selector(secondOnclick:) forControlEvents:UIControlEventTouchUpInside];
    [_background addSubview:_anti_hijackingBtn];
    
    _timingOutputBtn = [[OBShapedButton alloc]initWithFrame:CGRectMake(122, 1.5, 154.5, 64)];
    _timingOutputBtn.tag = TagTmp + TurntimingOutput;
    [_timingOutputBtn setImage:[UIImage imageNamed:@"p2-8.png"] forState:UIControlStateHighlighted];
    [_timingOutputBtn addTarget:self action:@selector(secondOnclick:) forControlEvents:UIControlEventTouchUpInside];
    [_background addSubview:_timingOutputBtn];
}

-(IBAction)secondOnclick:(id)sender
{
    [_delegate secondViewOnClick:sender position:[sender tag]-TagTmp];
}
@end
