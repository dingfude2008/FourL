//
//  BatteryViewController.m
//  BLECollection
//
//  Created by rfstar on 14-4-30.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import "BatteryViewController.h"

@interface BatteryViewController ()

@end

@implementation BatteryViewController

-(id)initWithNib
{
    id tmp = [super initWithNib];
    if (self) {
        // Custom initialization
        [self setTitle:@"电池电量报告"];
        appDelegate = [[UIApplication sharedApplication]delegate];
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
    // Do any additional setup after loading the view.
    
    UILabel  *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, 80, 60)];
    [nameLabel setText:@"电量："];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(150, 30, 150, 60)];;
    [_label setText:@"0%"];
    
    _button =[UIButton buttonWithType:UIButtonTypeCustom];
    [_button setFrame:CGRectMake(30, 100, 260, 50)];
    [_button.layer setCornerRadius:5];
    [_button setTitle:@"获取电量" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [_button.layer setBorderColor:[Tools colorWithHexString:@"#898989"].CGColor];
    [_button.layer setBorderWidth:1];
    [_button.layer setBackgroundColor:[Tools colorWithHexString:@"#EEEEE0"].CGColor];
    
    [self.view addSubview:nameLabel];
    [self.view addSubview:_label];
    [self.view addSubview:_button];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self initReceviceNotification];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [self stopeReceive];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)action:(id)sender
{
    [appDelegate.bleManager readValue:0x180F characteristicUUID:0x2A19 p:appDelegate.bleManager.activePeripheral];
}
//更新数据
-(void)ValueChangText:(NSNotification *)notification
{
    //这里取出刚刚从过来的字符串
    CBCharacteristic *tmpCharacter = (CBCharacteristic*)[notification object];
    NSString *uuidStr = [[tmpCharacter UUID] UUIDString];
    NSLog(@"character uuidString %@ ", uuidStr );
    if([uuidStr isEqualToString:@"2A19"])
    {
        Byte *byteData = (Byte*)[[tmpCharacter value] bytes];
        [_label setText:[NSString stringWithFormat:@"%d%%",byteData[0]]];
    }
}

@end
