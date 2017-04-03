//
//  RssiViewController.m
//  BLECollection
//
//  Created by rfstar on 14-4-30.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import "RssiViewController.h"


#define GETRSSI_BTN                 10001
#define GETCIRCLE_BTN               10002
#define SETCIRCLE_BTN               10003
#define GETRSSI_TXT                 10004
#define GETCIRCLE_TXT               10005
#define SETCIRCLR_EDIT              10006

@interface RssiViewController ()
{
     UIFont *font;
}
@end

@implementation RssiViewController

-(id)initWithNib
{
    id tmp = [super initWithNib];
    if (self) {
        // Custom initialization
        [self setTitle:@"电池电量报告"];
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:[self firstView]];
    [self.view addSubview:[self secondView]];
}
-(UIView *)firstView
{
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 300, 93)];
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
    [name setText:@"信号:"];
    [name setFont:font];
    UILabel *nameTxt = [[UILabel alloc]initWithFrame:CGRectMake(110, 10, 120, 30)];
    nameTxt.text = @"0";
    [nameTxt setTag:GETRSSI_TXT];
    [nameTxt setFont:font];
    
    UILabel *Txt = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, 90, 30)];
    [Txt setText:@"消息使能："];
    UISwitch *switchView = [UISwitch new];
    [switchView setFrame:CGRectMake(Txt.frame.origin.x+Txt.frame.size.width+5, 45, 0, 0)];
    [switchView addTarget:self action:@selector(changeSwitchClick:) forControlEvents:UIControlEventValueChanged];
    
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [setBtn setTag:GETRSSI_BTN];
    [setBtn setFrame:CGRectMake(170, 45, 120, 35)];
    [setBtn setTitle:@"获取信号" forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [setBtn.titleLabel setFont:font];
    [setBtn.layer setBorderWidth:1];
    [setBtn.layer setBorderColor:[setBtn titleColorForState:UIControlStateNormal].CGColor];
    [setBtn.layer setCornerRadius:5];
    
    [contentView addSubview:name];
    [contentView addSubview:Txt];
    [contentView addSubview:nameTxt];
    [contentView addSubview:switchView];
    [contentView addSubview:setBtn];
    
    contentView.layer.cornerRadius = 10;
    [contentView.layer setBorderColor:[Tools colorWithHexString:@"#898989"].CGColor];
    [contentView.layer setBorderWidth:1];
    
    return contentView ;
}
-(UIView *)secondView
{
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(10, 113, 300, 123)];
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
    [name setText:@"RSSI周期:"];
    [name setFont:font];
    UILabel *nameTxt = [[UILabel alloc]initWithFrame:CGRectMake(110, 10, 170, 30)];
    [nameTxt setTag:GETCIRCLE_TXT];
    nameTxt.text = @"";
    [nameTxt setFont:font];

    UILabel *setName = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 100, 30)];
    [setName setText:@"设置周期:"];
    UITextView *setNameTxt = [[UITextView alloc]initWithFrame:CGRectMake(110, 40, 170, 30)];
    [setNameTxt setTag:SETCIRCLR_EDIT];
    [setNameTxt setFont:font];
    setNameTxt.text = @"";
    [setNameTxt setKeyboardType:UIKeyboardTypeNumberPad];
    
    UIButton *getBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [getBtn setFrame:CGRectMake(20, 75, 120, 35)];
    [getBtn setTag:GETCIRCLE_BTN];
    [getBtn setTitle:@"获取周期" forState:UIControlStateNormal];
    [getBtn.layer setBorderWidth:1];
    [getBtn.layer setBorderColor:[getBtn titleColorForState:UIControlStateNormal].CGColor];
    [getBtn.titleLabel setFont:font];
    [getBtn.layer setCornerRadius:5];
    [getBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [setBtn setTag:SETCIRCLE_BTN];
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

-(void)changeSwitchClick:(UISwitch *)sender
{
    [appDelegate.bleManager notification:0xFFA0 characteristicUUID:0xFFA1 p:appDelegate.bleManager.activePeripheral on:sender.on];
}
-(IBAction)btnClick:(id)sender
{
    UIButton  *button = (UIButton *)sender;
    if ([button tag] == GETRSSI_BTN) {
        [appDelegate.bleManager readValue:0xFFA0 characteristicUUID:0xFFA1 p:appDelegate.bleManager.activePeripheral];
    }else if([button tag] == GETCIRCLE_BTN){
         [appDelegate.bleManager readValue:0xFFA0 characteristicUUID:0xFFA2 p:appDelegate.bleManager.activePeripheral];
    }else if([button tag] == SETCIRCLE_BTN){
        UITextView *editView = (UITextView *)[self.view viewWithTag:SETCIRCLR_EDIT];
        
        if(![[editView text] isEqualToString:@""]){
            int value = [[editView text]intValue];
            Byte data[2];
            data[0] = (Byte)((value >> 8) & 0xFF);
            data[1] = (Byte)(value & 0xFF);
            NSData *dataValue = [[NSData alloc]initWithBytes:data length:2];
            [appDelegate.bleManager writeValue:0xFFA0 characteristicUUID:0xFFA2 p:appDelegate.bleManager.activePeripheral data:dataValue];
        }
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
    if([uuidStr isEqualToString:@"FFA1"])
    {
        label = (UILabel *)[self.view viewWithTag:GETRSSI_TXT];
        Byte *byteData = (Byte*)[[tmpCharacter value] bytes];
         NSLog(@"character value %@ ", tmpCharacter.value );
        [label setText:[NSString stringWithFormat:@"%d ",(int)byteData[0]-0xFF]];
    }else if ([uuidStr isEqualToString:@"FFA2"]){
        label = (UILabel *)[self.view viewWithTag:GETCIRCLE_TXT];
        NSData *data = tmpCharacter.value;
        Byte *byteData = (Byte*)[data bytes];
        int value = 0;
        value = (int)(byteData[0] & 0xff) << 8;
        value += (int)(byteData[1] & 0xff);
        [label setText:[NSString stringWithFormat:@"%d ms",value]];
    }
}

@end
