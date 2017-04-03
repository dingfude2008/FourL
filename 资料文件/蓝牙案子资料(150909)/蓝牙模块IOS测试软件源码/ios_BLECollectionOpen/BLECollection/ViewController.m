//
//  ViewController.m
//  BLECollection
//
//  Created by rfstar on 13-12-23.
//  Copyright (c) 2013年 rfstar. All rights reserved.
//

#import "ViewController.h"
#import "Tools.h"
#import "LampViewController.h"
#import "SendViewController.h"
#import "ReceiveViewController.h"
#import "ScanViewController.h"
#import "TransmitViewController.h"
#import "PWMViewController.h"
#import "ParameterViewController.h"
#import "BatteryViewController.h"
#import "RssiViewController.h"
#import "ADCViewController.h"

@interface ViewController ()
{
    NSMutableArray *array ;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(Tools.currentResolution == UIDevice_iPhone4s)
    {
        [self.view setFrame:CGRectMake(0, 0, 320, 480)];

    }else if(Tools.currentResolution == UIDevice_iPhone5){
        [self.view setFrame:CGRectMake(0, 0, 320, 568)];
    }
    [self setTitle:@"CubicBLE"];
    UIBarButtonItem *scanDeviceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(refreshBlEDevice:)];
    self.navigationItem.rightBarButtonItem = scanDeviceItem;
    
    
    //下个viewController改为返回键
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
    returnButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = returnButtonItem;
    
    
    self.scrollBar = [[KHorizontalScrolleView alloc]initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.scrollBar setDelegate:self];

  
     array  = [NSMutableArray new];
    BarItem *barItem0 = [[BarItem alloc]init];
    barItem0.imageNormal = @"transmit_n.png";
    barItem0.imagePressed  = @"transmit_n.png";
    barItem0.name = @"双向透传";
    BarItem *barItem1 = [[BarItem alloc]init];
    barItem1.imageNormal = @"liebiao_d.png";
    barItem1.imagePressed = @"liebiao_n.png";
    barItem1.name = @"灯控";
    BarItem *barItem2 = [[BarItem alloc]init];
    BarItem *barItem3 = [[BarItem alloc]init];
    BarItem *barItem4 = [[BarItem alloc]init];
    BarItem *barItem5 = [[BarItem alloc]init];
    [array addObject:barItem0];
    [array addObject:barItem1];
    [array addObject:barItem2];
    [array addObject:barItem3];
    [array addObject:barItem4];
    [array addObject:barItem5];
    [self.scrollBar setListItem:array];
    

     NSLog(@" version %f",[[[UIDevice currentDevice] systemVersion]floatValue]);
    int y = 0;
    if([[[UIDevice currentDevice]systemVersion]intValue]>6){  //系统版本大于6时，和顶部间隔为66
        y = 65;
    }
    self.mainView = [[MainView alloc]initWithFrame:CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height -self.scrollBar.frame.size.height-65)];
    [self.mainView setBackgroundColor:[UIColor whiteColor]];
    [self.mainView.firstView setDelegate:self];
    [self.mainView.secondView setDelegate:self];
    
    [self.scrollBar setFrame:CGRectMake(0, self.mainView.frame.origin.y+self.mainView.frame.size.height, 320, HEIGHT)];
    NSLog(@"scroller view  height: %f  ",self.scrollBar.scrollView.contentSize.height);
  
    [self.view addSubview:self.mainView];
    [self.view  addSubview:self.scrollBar];
}
#pragma mark- KHorizontalScrolleView  事件
-(void)kHorizotalScrollViewItemClick:(UIView *)view Position:(NSInteger)position
{
    BaseViewController * baseView = nil;
    switch (position) {
        case 0:
            baseView = [[TransmitViewController alloc]initWithNib];
            break;
        case 1:
            baseView = [[LampViewController alloc]initWithNib];
            break;
        default:
            break;
    }
    [baseView setBarItem:[array objectAtIndex:position]];
    [self.navigationController pushViewController:baseView animated:YES];
}

-(IBAction)refreshBlEDevice:(id)sender{

    ScanViewController  *scanView = [ScanViewController new];
    [self.navigationController pushViewController:scanView animated:YES];
}

#pragma mark- firstView 事件
-(void)firstViewOnClick:(UIButton *)button position:(NSInteger)position
{
    BLEViewController *sampleController = nil;
    if(position == BluetoothDataChannel)  //蓝牙数据通道
    {
       sampleController = [[SendViewController alloc]initWithNib];
       
    }else if(position == SerialDataChannel){
        sampleController = [[ReceiveViewController alloc]initWithNib];

    }else if(position == PWMOutput){
        sampleController = [[PWMViewController alloc]initWithNib];
    }else if (position == BatteryReport)
    {
        sampleController = [[BatteryViewController alloc]initWithNib];
    }else if(position == RSSIReport){
        sampleController = [[RssiViewController alloc]initWithNib];
    }else if (position == ADCInput){
        sampleController = [[ADCViewController alloc]initWithNib];
    }
     [self.navigationController pushViewController:sampleController animated:YES];
}
#pragma mark- secondView事件
-(void)secondViewOnClick:(UIButton *)button position:(NSInteger)position
{
//    NSLog(@" second view %d ",position);
     BLEViewController *sampleController = nil;
     if(position == ModuleParameter){
        sampleController = [[ParameterViewController alloc]initWithNib];
     }
    [self.navigationController pushViewController:sampleController animated:YES];
}

@end
