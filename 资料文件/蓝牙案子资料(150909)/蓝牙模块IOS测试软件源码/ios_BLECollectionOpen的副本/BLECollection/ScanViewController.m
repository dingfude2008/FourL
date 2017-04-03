//
//  ScanViewController.m
//  BLECollection
//
//  Created by rfstar on 14-1-10.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import "ScanViewController.h"
@interface ScanViewController ()

@end

@implementation ScanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setTitle:@"设备扫描"];
    
    _listView = [[ListView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [self.view addSubview:_listView];
    [_listView setListDelegate:self];
    
    _progressView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(180, 0, 30, 30)];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] > 6.0){
        [_progressView setColor :[UIColor blueColor]];
    }
    [_listView startScan];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [_listView stopScan];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)refreshBtnClick:(id)sender
{
    [_listView startScan];
}
#pragma mark- ListView
-(void)listViewRefreshStateStart
{
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:_progressView];
    [_progressView startAnimating];
    [self.navigationItem setRightBarButtonItem:rightBtn];
}
-(void)listViewRefreshStateEnd
{
    [_progressView stopAnimating];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshBtnClick:)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
}

@end
