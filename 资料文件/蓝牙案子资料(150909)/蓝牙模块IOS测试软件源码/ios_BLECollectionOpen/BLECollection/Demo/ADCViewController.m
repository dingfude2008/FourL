//
//  ADCViewController.m
//  BLECollection
//
//  Created by rfstar on 14-4-30.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import "ADCViewController.h"
#define ADC0_SWITCH                 20001
#define ADC1_SWITCH                 20002
#define CLOSE_BTN                   20003
#define OPEN_BTN                    20004
#define ADC0_TXT                    20005
#define ADC1_TXT                    20006
#define ADC0_OPEN_BTN               20007
#define ADC1_OPEN_BTN               20008
#define GET_CIRCLE_TXT              20009
#define GET_CIRCLE_EDIT             20010
#define GET_CIRCLE_BTN              20011
#define SET_CIRCLE_BTN              20012


@interface ADCViewController ()
{
    UIFont *font;
}
@end

@implementation ADCViewController

-(id)initWithNib
{
    id tmp = [super initWithNib];
    if (self) {
        // Custom initialization
        [self setTitle:@"ADC输入（2路）"];
        appDelegate = [[UIApplication sharedApplication]delegate];
        font = [UIFont systemFontOfSize:15];
    }
    return tmp;
}
//想获取消息传递过来的数据 ，得先注册消息
-(void)initReceviceNotification
{
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver: self
           selector: @selector(ValueChangText:)
               name: @"VALUECHANGUPDATE"
             object: nil];
    
}
-(void)stopeReceive
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"VALUECHANGUPDATE" object:nil];
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:[self firstView]];
    [self.view addSubview:[self secondView]];
    [self.view addSubview:[self thirdView]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self initReceviceNotification];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [appDelegate.bleManager notification:0xFFA0 characteristicUUID:0xFFA1 p:appDelegate.bleManager.activePeripheral on:false];
    [self stopeReceive];
}
-(UIView *)firstView
{
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 300, 90)];
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
    [name setFont:font];
    [name setText:@"ADC0:"];
    UILabel *nameTxt = [[UILabel alloc]initWithFrame:CGRectMake(110, 10, 120, 30)];
    [nameTxt setTag:ADC0_TXT];
    nameTxt.text = @"0";
    [nameTxt setFont:font];
    UISwitch *switchADC0 = [UISwitch new];
    [switchADC0 setTag:ADC0_SWITCH];
    [switchADC0 setFrame:CGRectMake(230, 10, 0, 0)];
    [switchADC0 addTarget:self action:@selector(changeSwitchClick:) forControlEvents:UIControlEventValueChanged];
    
    
    UILabel *name1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, 100, 30)];
    [name1 setText:@"ADC1:"];
    [name1 setFont:font];
    UILabel *nameTxt1 = [[UILabel alloc]initWithFrame:CGRectMake(110, 45, 120, 30)];
    nameTxt1.text = @"0";
    [nameTxt1 setTag:ADC1_TXT];
    [nameTxt1 setFont:font];
    UISwitch *switchADC1 = [UISwitch new];
    [switchADC1 setTag:ADC1_SWITCH];
    [switchADC1 setFrame:CGRectMake(230, 45, 0, 0)];
    [switchADC1 addTarget:self action:@selector(changeSwitchClick:) forControlEvents:UIControlEventValueChanged];
    
    
    [contentView addSubview:name];
    [contentView addSubview:nameTxt];
    [contentView addSubview:name1];
    [contentView addSubview:nameTxt1];
    [contentView addSubview:switchADC0];
    [contentView addSubview:switchADC1];
    
    contentView.layer.cornerRadius = 10;
    [contentView.layer setBorderColor:[Tools colorWithHexString:@"#898989"].CGColor];
    [contentView.layer setBorderWidth:1];
    
    return contentView ;
}
-(UIView *)secondView
{
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(10, 113, 300, 165)];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [closeBtn setFrame:CGRectMake(20, 20, 260, 35)];
    [closeBtn setTitle:@"关闭两个ADC通道" forState:UIControlStateNormal];
    [closeBtn.layer setBorderWidth:1];
    [closeBtn.layer setBorderColor:[closeBtn titleColorForState:UIControlStateNormal].CGColor];
    [closeBtn.titleLabel setFont:font];
    [closeBtn.layer setCornerRadius:5];
    [closeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setTag:CLOSE_BTN];
    
    UIButton *adc0Btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [adc0Btn setTag:ADC0_OPEN_BTN];
    [adc0Btn setFrame:CGRectMake(20, 65, 125, 35)];
    
    [adc0Btn setTitle:@"打开ADC0通道" forState:UIControlStateNormal];
    [adc0Btn.layer setBorderWidth:1];
    [adc0Btn.layer setBorderColor:[adc0Btn titleColorForState:UIControlStateNormal].CGColor];
    [adc0Btn.titleLabel setFont:font];
    [adc0Btn.layer setCornerRadius:5];
    [adc0Btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *adc1Btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [adc1Btn setTag:ADC1_OPEN_BTN];
    [adc1Btn setFrame:CGRectMake(adc0Btn.frame.size.width+adc0Btn.frame.origin.x + 10, adc0Btn.frame.origin.y, adc0Btn.frame.size.width, 35)];
    [adc1Btn setTitle:@"打开ADC1通道" forState:UIControlStateNormal];
    [adc1Btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [adc1Btn.titleLabel setFont:font];
    [adc1Btn.layer setBorderWidth:1];
    [adc1Btn.layer setBorderColor:[adc1Btn titleColorForState:UIControlStateNormal].CGColor];
    [adc1Btn.layer setCornerRadius:5];
    
    UIButton *openBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [openBtn setTag:OPEN_BTN];
    [openBtn setFrame:CGRectMake(20, adc0Btn.frame.origin.y+adc0Btn.frame.size.height+10, 260, 35)];
    [openBtn setTitle:@"打开两个ADC通道" forState:UIControlStateNormal];
    [openBtn.layer setBorderWidth:1];
    [openBtn.layer setBorderColor:[openBtn titleColorForState:UIControlStateNormal].CGColor];
    [openBtn.titleLabel setFont:font];
    [openBtn.layer setCornerRadius:5];
    [openBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    [contentView addSubview:closeBtn];
    [contentView addSubview:adc0Btn];
    [contentView addSubview:adc1Btn];
    [contentView addSubview:openBtn];
    
    contentView.layer.cornerRadius = 10;
    [contentView.layer setBorderColor:[Tools colorWithHexString:@"#898989"].CGColor];
    [contentView.layer setBorderWidth:1];
    
    return contentView ;
}
-(UIView *)thirdView
{
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(10, 288, 300, 120)];
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
    [name setText:@"采集周期:"];
    [name setFont:font];
    UILabel *nameTxt = [[UILabel alloc]initWithFrame:CGRectMake(110, 10, 170, 30)];
    [nameTxt setTag:GET_CIRCLE_TXT];
    nameTxt.text = @"";
    [nameTxt setFont:font];
    
    UILabel *setName = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 100, 30)];
    [setName setText:@"设置周期:"];
    UITextView *setNameTxt = [[UITextView alloc]initWithFrame:CGRectMake(110, 40, 170, 30)];
    [setNameTxt setTag:GET_CIRCLE_EDIT];
    [setNameTxt setFont:font];
    setNameTxt.text = @"";
     [setNameTxt setReturnKeyType:UIReturnKeyDone];
    [setNameTxt setKeyboardType:UIKeyboardTypeNumberPad];
    
    UIButton *getBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [getBtn setTag:GET_CIRCLE_BTN];
    [getBtn setFrame:CGRectMake(20, 75, 120, 35)];
    [getBtn setTitle:@"获取周期" forState:UIControlStateNormal];
    [getBtn.layer setBorderWidth:1];
    [getBtn.layer setBorderColor:[getBtn titleColorForState:UIControlStateNormal].CGColor];
    [getBtn.titleLabel setFont:font];
    [getBtn.layer setCornerRadius:5];
    [getBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [setBtn setTag:SET_CIRCLE_BTN];
    [setBtn setFrame:CGRectMake(getBtn.frame.size.width+getBtn.frame.origin.x + 10, 75, 120, 35)];
    [setBtn setTitle:@"设置" forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [setBtn.titleLabel setFont:font];
    [setBtn.layer setBorderWidth:1];
    [setBtn.layer setBorderColor:[setBtn titleColorForState:UIControlStateNormal].CGColor];
    [setBtn.layer setCornerRadius:5];
    
    [contentView addSubview:name];
    [contentView addSubview:nameTxt];
    [contentView addSubview:getBtn];
    [contentView addSubview:setName];
    [contentView addSubview:setNameTxt];
    [contentView addSubview:setBtn];
    
    contentView.layer.cornerRadius = 10;
    [contentView.layer setBorderColor:[Tools colorWithHexString:@"#898989"].CGColor];
    [contentView.layer setBorderWidth:1];
    
    return contentView ;
}
//switch 事件
-(void)changeSwitchClick:(UISwitch *)sender
{
    if(sender.tag == ADC0_SWITCH){
        [appDelegate.bleManager notification:0xFFD0 characteristicUUID:0xFFD3 p:appDelegate.bleManager.activePeripheral on:sender.on];
    }else if(sender.tag == ADC1_SWITCH){
        [appDelegate.bleManager notification:0xFFD0 characteristicUUID:0xFFD4 p:appDelegate.bleManager.activePeripheral on:sender.on];
    }
}
-(IBAction)btnClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        
        case CLOSE_BTN:
            [self sendADCData:0x00];
            break;
        case ADC0_OPEN_BTN:
            [self sendADCData:0x01];
            break;
        case ADC1_OPEN_BTN:
            [self sendADCData:0x02];
            break;
        case OPEN_BTN:
            [self sendADCData:0x03];
            break;
        case GET_CIRCLE_BTN:
            [appDelegate.bleManager readValue:0xFFD0 characteristicUUID:0xFFD2 p:appDelegate.bleManager.activePeripheral];
            break;
        case SET_CIRCLE_BTN:
            [self writeCircleData];
            break;
        default:
            break;
    }
}
//处理开关ADC通道
-(void)sendADCData:(int) type
{
        Byte byteData[1];
        byteData[0] = type;
        [appDelegate.bleManager writeValue:0xFFD0 characteristicUUID:0xFFD1 p:appDelegate.bleManager.activePeripheral data:[[NSData alloc] initWithBytes:byteData length:1]];
}
//修改返回adc数据的周期
-(void)writeCircleData
{
    UITextView *editView = (UITextView *)[self.view viewWithTag:GET_CIRCLE_EDIT];
    [editView resignFirstResponder];
    if(![[editView text] isEqualToString:@""]){
        int value = [[editView text]intValue];
        Byte data[2];
        data[0] = (Byte)((value >> 8) & 0xFF);
        data[1] = (Byte)(value & 0xFF);
        NSData *dataValue = [[NSData alloc]initWithBytes:data length:2];
        [appDelegate.bleManager writeValue:0xFFD0 characteristicUUID:0xFFD2 p:appDelegate.bleManager.activePeripheral data:dataValue];
    }
}
//更新数据
-(void)ValueChangText:(NSNotification *)notification
{
    //这里取出刚刚从过来的字符串
    CBCharacteristic *tmpCharacter = (CBCharacteristic*)[notification object];
    NSString *uuidStr = [[tmpCharacter UUID] UUIDString];
    NSLog(@"character uuidString %@ ", uuidStr );
    UILabel *label;
     NSData *data = tmpCharacter.value;
    Byte *byteData = (Byte*)[data bytes];
    int value = 0;
    value = (int)(byteData[0] & 0xff) << 8;
    value += (int)(byteData[1] & 0xff);
    if([uuidStr isEqualToString:@"FFD3"])
    {
        label = (UILabel *)[self.view viewWithTag:ADC0_TXT];
    }else if ([uuidStr isEqualToString:@"FFD4"]){
        label = (UILabel *)[self.view viewWithTag:ADC1_TXT];
    }else if([uuidStr isEqualToString:@"FFD2"]){
        label = (UILabel *)[self.view viewWithTag:GET_CIRCLE_TXT];
        [label setText:[NSString stringWithFormat:@"%d ms",value]];
        return;
    }
    [label setText:[NSString stringWithFormat:@"%d ",value]];
}
#pragma ectends father fuction
-(void)keyboardShowOrHide:(Boolean)boo
{
    NSLog(@" jianpan    boo  %d",boo);
    if(boo){
        [UIView animateWithDuration:0.3f animations:^{
            CGRect curFrame=self.view.frame;
            self.view.frame=CGRectMake(curFrame.origin.x, curFrame.origin.y-216, curFrame.size.width, curFrame.size.height);
        }];
    }else{
        [UIView animateWithDuration:0.3f animations:^{
            CGRect curFrame=self.view.frame;
            self.view.frame=CGRectMake(curFrame.origin.x, curFrame.origin.y+216, curFrame.size.width, curFrame.size.height);
        }];
    }
}

@end
