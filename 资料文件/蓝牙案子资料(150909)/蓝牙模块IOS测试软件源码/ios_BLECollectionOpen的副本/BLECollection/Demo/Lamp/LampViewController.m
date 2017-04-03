//
//  LampViewController.m
//  BLECollection
//
//  Created by rfstar on 14-1-2.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import "LampViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Tools.h"

#define COLOR_LABEL     101
#define SAVE_COLOR      102
@interface LampViewController ()
{
         NSTimer                 *sendDataTimer;  //循环发送的timer
        int count ;
}
@end

@implementation LampViewController

-(id)initWithNib
{
     appDelegate = [[UIApplication sharedApplication]delegate];
    return  [super initWithNib];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    int y = 10;
    if(Tools.currentResolution == UIDevice_iPhone5)
    {
        y = 30;
    }  //pickerView
    UIView  *pickerView = [self colorPickerView:CGRectMake(15, y, 290, 330)] ;
    
    UIView  *controllerView = [self controllerView:CGRectMake(pickerView.frame.origin.x, y+pickerView.frame.origin.y+pickerView.frame.size.height, pickerView.frame.size.width, 50)];
    
    [self.view addSubview:pickerView];
    [self.view addSubview:controllerView];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [sendDataTimer invalidate]; //关闭时器
    sendDataTimer = nil;
}
-(UIView *)colorPickerView:(CGRect)frame
{
    UIView * contentView = [[UIView alloc]initWithFrame:frame];
    UILabel  *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];  //30
    [label setTag:COLOR_LABEL];
    [label.layer setCornerRadius:label.frame.size.height/2];
    [label.layer setBorderColor:[UIColor blackColor].CGColor];
    [label.layer setBorderWidth:.5];
    label.backgroundColor = [UIColor whiteColor];
    
    UIButton  *saveCurrentStateBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [saveCurrentStateBtn setFrame:CGRectMake(220, label.frame.origin.y, 80, 40)];
    [saveCurrentStateBtn setTitle:@"保存颜色" forState:UIControlStateNormal];
    [saveCurrentStateBtn addTarget:self action:@selector(buttonValueChange:) forControlEvents:UIControlEventTouchUpInside];
    
    RSColorPickerView *colorPicker = [[RSColorPickerView alloc]initWithFrame:CGRectMake(0, label.frame.size.height, frame.size.width, frame.size.height-label.frame.size.height)];
    [colorPicker setBackgroundColor:[UIColor clearColor]];
    [colorPicker setDelegate:self];
    [colorPicker setBrightness:1.0];
    [colorPicker.layer setShouldRasterize:YES];
    [colorPicker.layer setCornerRadius:colorPicker.frame.size.height/2];
    [colorPicker.layer setBorderColor:[UIColor blackColor].CGColor];
    [colorPicker.layer setBorderWidth:2];

    [contentView addSubview:label];
    [contentView addSubview:colorPicker];
    [contentView addSubview:saveCurrentStateBtn];
    return contentView;
}
-(void)colorPickerDidChangeSelection:(RSColorPickerView *)cp state:(NSInteger)state
{
    CGFloat redFloat,greenFloat,blueFloat;
    [[cp selectionColor] getRed:&redFloat green:&greenFloat blue:&blueFloat alpha:nil];
    //    NSLog(@"R:%d G:%d B:%d",(Byte)(255*redFloat), (Byte)(255*greenFloat), (Byte)(255*blueFloat));

    Byte  LEDdata[4];
    LEDdata[0] = (Byte)(255*blueFloat);
    LEDdata[1] = (Byte)(255*greenFloat);
    LEDdata[2] = (Byte)(255*redFloat);
    LEDdata[3] = 0x00;
  
    if(state == COLOR_BEGIN)
    {
         [self sendData:LEDdata];
        [sendDataTimer invalidate];
        sendDataTimer = [NSTimer scheduledTimerWithTimeInterval:0.001
                                                             target:self
                                                           selector:@selector(countTimes)
                                                           userInfo:nil repeats:YES];
    }else if(state == COLOR_MOVED){
        if(count == 20){
            [self sendData:LEDdata];
        }
    }else if(state == COLOR_ENDED){
        [self sendData:LEDdata];
        [sendDataTimer invalidate]; //关闭时器
        sendDataTimer = nil;
        count = 0;
    }

    UILabel *colorLabel = (UILabel *)[self.view viewWithTag:COLOR_LABEL];
    colorLabel.backgroundColor = [UIColor colorWithRed:((float)LEDdata[2])/255.0 green:((float)LEDdata[1])/255.0 blue:((float)LEDdata[0])/255.0 alpha:1.0];

}
-(void)countTimes
{
    if(count == 20)
    {
        count = 0;
    }
    count++;
}
-(UIView *)controllerView:(CGRect)frame
{
    UIView  *contentView = [[UIView alloc] initWithFrame:frame];
    contentView.layer.cornerRadius = 7.0;
    contentView.layer.borderColor = [Tools colorWithHexString:@"#7D9EC0"].CGColor;
    contentView.layer.borderWidth = 1;
    
    UILabel  *onOffLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, (frame.size.height-frame.size.height/2)/2, 60, frame.size.height/2 )];
    [onOffLabel setBackgroundColor:[UIColor clearColor]];
    [onOffLabel setText:@"开关："];
    UISwitch *switchBtn = [UISwitch new];
    [switchBtn setFrame:CGRectMake(200, (frame.size.height-switchBtn.frame.size.height)/2, frame.size.width-onOffLabel.frame.size.width, frame.size.height/2)];
    [switchBtn addTarget:self action:@selector(buttonValueChange:) forControlEvents:UIControlEventValueChanged];
    
    [contentView addSubview:onOffLabel];
    [contentView addSubview:switchBtn];

    return contentView;
}
//发送数据
-(void)sendData:(Byte[]) bytes
{
    NSData *data = [[NSData alloc]initWithBytes:bytes length:4];
    [appDelegate.bleManager writeValue:0xFFB0
                    characteristicUUID:0xFFB2
                                     p:appDelegate.bleManager.activePeripheral
                                  data:data];
}

-(IBAction)buttonValueChange:(id)sender
{
    if ([sender isKindOfClass:[UISwitch class]]) {
        UISwitch  *switchBtn = (UISwitch *)sender;
        [self sendOnOff:switchBtn.on];
    }else if([sender isKindOfClass:[UIButton class]]){
        [self sendOnOff:2];
    }
}

//控制灯的开关
-(void)sendOnOff:(int)flag
{
    Byte       messageByte[1];
    NSData *data = nil;
    switch (flag) {
        case 0:  //关
            messageByte[0] = 0x00;
            data = [[NSData alloc]initWithBytes:messageByte length:1];
            break;
        case 1:   //开
            messageByte[0] = 0x01;
            data = [[NSData alloc]initWithBytes:messageByte length:1];
            break;
        case 2:   //只在当前颜色
            messageByte[0] = 0x02;
            data = [[NSData alloc]initWithBytes:messageByte length:1];
            break;
        default:
            break;
    }
    [appDelegate.bleManager writeValue:0xFFB0
                    characteristicUUID:0xFFB1
                                     p:appDelegate.bleManager.activePeripheral
                                  data:data];
}
@end
