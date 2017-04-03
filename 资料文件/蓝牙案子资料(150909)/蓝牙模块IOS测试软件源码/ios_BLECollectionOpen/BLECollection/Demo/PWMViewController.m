//
//  PWMViewController.m
//  BLECollection
// pwm输出（4路） 服务uuid: ffb0
//  Created by rfstar on 14-1-15.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import "PWMViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Tools.h"

#define                   PWM1              200
#define                   PWM2              201
#define                   PWM3              202
#define                   PWM4              203
#define                   PWMSIGNAL         204
#define                   PWM_TIME_WIDTH    205

@interface PWMViewController ()
{
    
}
@end

@implementation PWMViewController

-(id)initWithNib
{
    id tmp = [super initWithNib];
    if(self){
         appDelegate = [[UIApplication sharedApplication]delegate];
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
        [self initView];
        [self.view addSubview:_scrollView];
    }
    return tmp;
}

-(void)initView
{
    [self setTitle:@"PWM输出"];
    
    UILabel  *fourLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 300, 15)];
    [fourLabel setText:@"初始化四路PWM通道"];
//    [fourLabel setTextAlignment:NSTextAlignmentCenter];
    [fourLabel setFont:[UIFont systemFontOfSize:14]];
    [fourLabel setBackgroundColor:[UIColor clearColor]];
    NSArray  *fourWaysArray = [[NSArray alloc]initWithObjects:@"全低脉宽",@"全高脉宽",@"当前输出脉宽",nil];
    UISegmentedControl      * fourWaysChannelSegment = [[UISegmentedControl alloc]initWithItems:fourWaysArray];
    [fourWaysChannelSegment setSegmentedControlStyle:UISegmentedControlStyleBar];
    int x = 10,y = 70,height = 60;
    int width = self.view.frame.size.width-x*2;
    [fourWaysChannelSegment setFrame:CGRectMake(x, fourLabel.frame.origin.y+fourLabel.frame.size.height+3,width,fourWaysChannelSegment.frame.size.height)];
    [fourWaysChannelSegment setSelectedSegmentIndex:1];
    [fourWaysChannelSegment addTarget:self action:@selector(fourWaysSegmentValueChange:) forControlEvents:UIControlEventValueChanged];
    
    UISlider  *PWM1Slider =[UISlider new];
    [PWM1Slider setTag:PWM1];
    UISlider  *PWM2Slider =[UISlider new];
    [PWM2Slider setTag:PWM2];
    UISlider  *PWM3Slider =[UISlider new];
    [PWM3Slider setTag:PWM3];
    UISlider  *PWM4Slider =[UISlider new];
    [PWM4Slider setTag:PWM4];
    
 
    [self.scrollView addSubview:fourLabel];
    [self.scrollView addSubview:fourWaysChannelSegment];
    [self.scrollView addSubview:[self sliderInit:CGRectMake(x, y, width,height) slider:PWM1Slider labelText:@"PWM1(0~255) P11"]];
    [self.scrollView addSubview:[self sliderInit:CGRectMake(x, y*2, width, height) slider:PWM2Slider labelText:@"PWM2(0~255) P10"]];
    [self.scrollView addSubview:[self sliderInit:CGRectMake(x, y*3, width, height) slider:PWM3Slider labelText:@"PWM3(0~255) P07"]];
    [self.scrollView addSubview:[self sliderInit:CGRectMake(x, y*4, width, height) slider:PWM4Slider labelText:@"PWM4(0~255) p06"]];
     
    [self.scrollView addSubview:[self outSignalFrequencyView:CGRectMake(x, y*5, width, height)]];
    UIView *changeTimeView = [self changeTimeWidth:CGRectMake(x, y*6, width, height)];
    [self.scrollView addSubview:changeTimeView];
    [self.scrollView setContentSize:CGSizeMake(320, changeTimeView.frame.size.height+changeTimeView.frame.origin.y+x)];
}
#pragma mark- FFB1 为 4 通道 PWM 初始化模式设置通道
-(IBAction)fourWaysSegmentValueChange:(id)sender
{
    UISegmentedControl  *segmented = (UISegmentedControl *)sender;
    
    Byte       messageByte[1];
    NSData *data = nil;
    switch (segmented.selectedSegmentIndex) {
        case 0:
            messageByte[0] = 0x00;
            break;
        case 1:
            messageByte[0] = 0x01;
            break;
        case 2:
            messageByte[0] = 0x02;
            break;
        default:
            break;
    }
        data = [[NSData alloc]initWithBytes:messageByte length:1];
    [appDelegate.bleManager writeValue:0xFFB0
                    characteristicUUID:0xFFB1
                                     p:appDelegate.bleManager.activePeripheral
                                  data:data];
}

//初始slider 中的text,value,slider以及相应事件
-(UIView *)sliderInit:(CGRect)frame slider:(UISlider *)slider labelText:(NSString *)text
{
    UIView  *contentView = [[UIView alloc]initWithFrame:frame];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(7.5, 0, frame.size.width-45, 15)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:text];
    [label setFont:[UIFont systemFontOfSize:14]];
    
    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x+label.frame.size.width, 0, 70, 15)];
    [valueLabel setBackgroundColor:[UIColor clearColor]];
    [valueLabel setText:@"255"];
    [valueLabel setTag:slider.tag+100];
    [valueLabel setTextAlignment:NSTextAlignmentLeft];
    [valueLabel setFont:[UIFont systemFontOfSize:14]];
    
    UIView  *sliderView = [[UIView alloc]initWithFrame:CGRectMake(0, label.frame.size.height+3, frame.size.width, frame.size.height-label.frame.size.height)];

    [sliderView setBackgroundColor:[UIColor whiteColor]];
    [sliderView.layer setCornerRadius:7.5];
    [sliderView.layer setBorderWidth:1];
    [sliderView.layer setBorderColor:[Tools colorWithHexString:@"#7D9EC0"].CGColor];
    
    int x = 10,y = (sliderView.frame.size.height-slider.frame.size.height)/2;
    [slider setFrame:CGRectMake(x, y , contentView.frame.size.width-x*2, slider.frame.size.height)];
    [slider setMinimumValue:0];
    [slider setMaximumValue:255];
    [slider setValue:255];
    [slider addTarget:self action:@selector(PWMSliderAction:) forControlEvents:UIControlEventValueChanged];
    [sliderView addSubview:slider];
    
    [contentView addSubview:label];
    [contentView addSubview:valueLabel]; 
    [contentView addSubview:sliderView];
    return contentView;
}

-(IBAction)PWMSliderAction:(id)sender
{
    UISlider  *slider = (UISlider *)sender;
    UILabel   *valueText =(UILabel *)[self.view viewWithTag:slider.tag+100];
    [valueText setText:[NSString stringWithFormat:@"%.0f",slider.value]];
    
    [self sendFFB2Data:slider.tag];
}
//发送数据
-(void) sendFFB2Data:(NSInteger) index
{

    if(index>=PWM1 && index<=PWM4)
    {
        UISlider *slider1 = (UISlider *)[self.view viewWithTag:PWM1];
        UISlider *slider2 = (UISlider *)[self.view viewWithTag:PWM2];
        UISlider *slider3 = (UISlider *)[self.view viewWithTag:PWM3];
        UISlider *slider4 = (UISlider *)[self.view viewWithTag:PWM4];

        Byte      FFB2Byte[4];
        NSData *data;
        FFB2Byte[0] =(int)slider1.value;
        FFB2Byte[1] =(int)slider2.value;
        FFB2Byte[2] = (int)slider3.value;
        FFB2Byte[3] = (int)slider4.value;
    
        data = [[NSData alloc]initWithBytes:FFB2Byte length:4];
        [appDelegate.bleManager writeValue:0xFFB0
                        characteristicUUID:0xFFB2
                                         p:appDelegate.bleManager.activePeripheral
                                      data:data];

    }else if(index == PWMSIGNAL){
        
        UISlider *slider = (UISlider *)[self.view viewWithTag:PWMSIGNAL];
        int value = (int)slider.value;
        Byte      FFB3Byte[2];
        memcpy(&value, FFB3Byte, 2);
        NSData *data = [[NSData alloc]initWithBytes:FFB3Byte length:2];
        NSLog(@"send FFB3 data  %@  %d",data ,(int)slider.value);

        [appDelegate.bleManager writeValue:0xFFB0
                        characteristicUUID:0xFFB3
                                         p:appDelegate.bleManager.activePeripheral
                                      data:data];

    }else if(index == PWM_TIME_WIDTH){
        UISlider *slider = (UISlider *)[self.view viewWithTag:PWM_TIME_WIDTH];
        int value = (int)slider.value;
        Byte      FFB4Byte[2];
        memcpy(&value, FFB4Byte, 2);
        NSData *data = [[NSData alloc]initWithBytes:FFB4Byte length:2];
        NSLog(@"send FFB4 data  %@  %d",data ,(int)slider.value);
        
        [appDelegate.bleManager writeValue:0xFFB0
                        characteristicUUID:0xFFB4                                         p:appDelegate.bleManager.activePeripheral
                                      data:data];
    }

}
//pwm输出信号频率设置，四路相同，默认为0x8235(120Hz)
-(UIView *)outSignalFrequencyView:(CGRect)frame
{
    UIView  *contentView = [[UIView alloc]initWithFrame:frame];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(7.5, 0, frame.size.width-45, 15)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:@"信号频率设置(500~65535)"];
    [label setFont:[UIFont systemFontOfSize:14]];
    
    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x+label.frame.size.width, 0, 70, 15)];
    [valueLabel setBackgroundColor:[UIColor clearColor]];
    [valueLabel setText:@"500"];
    [valueLabel setTag:PWMSIGNAL+100];
    [valueLabel setTextAlignment:NSTextAlignmentLeft];
    [valueLabel setFont:[UIFont systemFontOfSize:14]];
    
    UIView  *sliderView = [[UIView alloc]initWithFrame:CGRectMake(0, label.frame.size.height+3, frame.size.width, frame.size.height-label.frame.size.height)];
    
    [sliderView setBackgroundColor:[UIColor whiteColor]];
    [sliderView.layer setCornerRadius:7.5];
    [sliderView.layer setBorderWidth:1];
    [sliderView.layer setBorderColor:[Tools colorWithHexString:@"#7D9EC0"].CGColor];
    
     UISlider  *slider = [UISlider new];
    [slider setTag:PWMSIGNAL];
    int x = 10,y = (sliderView.frame.size.height-slider.frame.size.height)/2;
    [slider setFrame:CGRectMake(x, y , contentView.frame.size.width-x*2, slider.frame.size.height)];
    [slider setMinimumValue:500];
    [slider setMaximumValue:65535];
    [slider setValue:500];
    [slider addTarget:self action:@selector(PWMSliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [sliderView addSubview:slider];
    
    [contentView addSubview:label];
    [contentView addSubview:valueLabel];
    [contentView addSubview:sliderView];
    return contentView;
}

//pwm转变时间宽度，默认是0x0000
-(UIView *)changeTimeWidth:(CGRect)frame
{
    
    UIView  *contentView = [[UIView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height+40)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(7.5, 0, frame.size.width-45, 15)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:@"PWM转变时间宽度(0~65535)"];
    [label setFont:[UIFont systemFontOfSize:14]];
    
    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x+label.frame.size.width, 0, 70, 15)];
    [valueLabel setBackgroundColor:[UIColor clearColor]];
    [valueLabel setText:@"0"];
    [valueLabel setTag:PWM_TIME_WIDTH+100];
    [valueLabel setTextAlignment:NSTextAlignmentLeft];
    [valueLabel setFont:[UIFont systemFontOfSize:14]];
    
    UIView  *sliderView = [[UIView alloc]initWithFrame:CGRectMake(0, label.frame.size.height+3, frame.size.width, frame.size.height-label.frame.size.height+40)];
    
    [sliderView setBackgroundColor:[UIColor whiteColor]];
    [sliderView.layer setCornerRadius:7.5];
    [sliderView.layer setBorderWidth:1];
    [sliderView.layer setBorderColor:[Tools colorWithHexString:@"#7D9EC0"].CGColor];
    
    UISlider  *slider = [UISlider new];
    [slider setTag:PWM_TIME_WIDTH];
    int x = 10,y = (sliderView.frame.size.height-slider.frame.size.height)/2;
    [slider setFrame:CGRectMake(x, y-20 , contentView.frame.size.width-x*2, slider.frame.size.height)];
    [slider setMinimumValue:0];
    [slider setMaximumValue:65535];
    [slider setValue:0];
    [slider addTarget:self action:@selector(PWMSliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [sliderView addSubview:slider];
    
    UIButton *onBtn,*offBtn;
    onBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    offBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [onBtn setTag:10001];
    [offBtn setTag:10002];
    
    [onBtn setTitle:@"开" forState:UIControlStateNormal];
    [offBtn setTitle:@"关" forState:UIControlStateNormal];
    [onBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [onBtn setTitleColor:[Tools colorWithHexString:@"#FF3E96"] forState:UIControlStateHighlighted];
    [onBtn.layer setBorderWidth:1];
    [onBtn.layer setBorderColor:[Tools colorWithHexString:@"#898989"].CGColor];
    [onBtn.layer setCornerRadius:5];
    [onBtn setFrame:CGRectMake(20, slider.frame.origin.y+slider.frame.size.height+20, 120, 35)];
    
    [offBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [offBtn setTitleColor:[Tools colorWithHexString:@"#FF3E96"] forState:UIControlStateHighlighted];
    [offBtn.layer setBorderWidth:1];
    [offBtn.layer setBorderColor:[Tools colorWithHexString:@"#898989"].CGColor];
    [offBtn.layer setCornerRadius:5];
    [offBtn setFrame:CGRectMake(onBtn.frame.origin.x+onBtn.frame.size.width+20, slider.frame.origin.y+slider.frame.size.height+20, onBtn.frame.size.width, 35)];
    [onBtn addTarget:self action:@selector(onOrOffAction:) forControlEvents:UIControlEventTouchUpInside];
    [offBtn addTarget:self action:@selector(onOrOffAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [contentView addSubview:label];
    [contentView addSubview:valueLabel];
    [contentView addSubview:sliderView];
    [contentView addSubview:onBtn];
    [contentView addSubview:offBtn];
    return contentView;
}
-(IBAction)onOrOffAction:(id)sender
{
    UIButton  * button = (UIButton *)sender;
    
    UISlider *slider1 = (UISlider *)[self.view viewWithTag:PWM1];
    UISlider *slider2 = (UISlider *)[self.view viewWithTag:PWM2];
    UISlider *slider3 = (UISlider *)[self.view viewWithTag:PWM3];
    UISlider *slider4 = (UISlider *)[self.view viewWithTag:PWM4];
    
    Byte      FFB2Byte[4];
    NSData *data;

    if ([button tag] == 10001) {
        FFB2Byte[0] =(int)slider1.value;
        FFB2Byte[1] =(int)slider2.value;
        FFB2Byte[2] = (int)slider3.value;
        FFB2Byte[3] = (int)slider4.value;
    }else if([button tag] == 10002){
        FFB2Byte[0] =(int)0xff;
        FFB2Byte[1] =(int)0xff;
        FFB2Byte[2] = (int)0xff;
        FFB2Byte[3] = (int)0xff;
    }
    
    data = [[NSData alloc]initWithBytes:FFB2Byte length:4];
    [appDelegate.bleManager writeValue:0xFFB0
                    characteristicUUID:0xFFB2
                                     p:appDelegate.bleManager.activePeripheral
                                  data:data];
}
@end
