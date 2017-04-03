//
//  ReceiveViewController.m
//  BLECollection
//
//  Created by rfstar on 14-1-8.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import "ReceiveViewController.h"

@interface ReceiveViewController ()

@end

@implementation ReceiveViewController

-(id)initWithNib
{
    id tmp = [super initWithNib];
    if(self){
  
    }
    return tmp;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _receiveView  = [[ReceiveView alloc]initWithFrame:self.view.frame];
    
    [self setTitle:@"串口数据通道"];
    
    _resetBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _resetBtn.frame = CGRectMake(10, _receiveView. frame.origin.y+_receiveView.frame.size.height+10, 90, 35);
    [_resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [_resetBtn addTarget:self action:@selector(clearText:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel  *onOffLabel = [[UILabel alloc]initWithFrame:CGRectMake(190, _resetBtn.frame.origin.y+2, 50, 30)];
    [onOffLabel setText:@"接收："];
    [onOffLabel setBackgroundColor:[UIColor clearColor]];
    [onOffLabel setFont:[UIFont systemFontOfSize:14]];
    
    _switchOnOff = [[UISwitch alloc]initWithFrame:CGRectMake(onOffLabel.frame.size.height+onOffLabel.frame.origin.x+10, onOffLabel.frame.origin.y, 35, 30)];
    [_switchOnOff addTarget:self action:@selector(sendData:) forControlEvents:UIControlEventValueChanged];
    [_switchOnOff setOn:NO];
    
    [self.view addSubview:_receiveView];
    [self.view addSubview:onOffLabel];
    [self.view addSubview:_resetBtn];
    [self.view addSubview:_switchOnOff];
}
-(void)viewWillAppear:(BOOL)animated
{
    [_receiveView initReceviceNotification];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [_receiveView stopeReceive];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)sendData:(id)sender
{
    UISwitch *tmpSwitch = (UISwitch *)sender;
    [_receiveView receiveEnable:tmpSwitch.on];
}
-(IBAction)clearText:(id)sender
{
    [_receiveView clearText];
}
@end
