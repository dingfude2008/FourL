//
//  BaseViewController.m
//  BLECollection
//
//  Created by rfstar on 14-1-2.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import "BaseViewController.h"
#import "Tools.h"
#import "ScanViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController


-(id)initWithNib
{
    if(Tools.currentResolution == UIDevice_iPhone4s)
    {
        [self.view setFrame:CGRectMake(0, 0, 320, 416)];
        
    }else if(Tools.currentResolution == UIDevice_iPhone5){
        [self.view setFrame:CGRectMake(0, 0, 320, 502)];
        
    }
    UIBarButtonItem *scanDeviceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(refreshBlEDevice:)];
    self.navigationItem.rightBarButtonItem = scanDeviceItem;
    
    [self.view setBackgroundColor:[Tools colorWithHexString:@"#E0EEE0"]];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(systemKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(systemKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    keyboardVisible = NO;
    return  self;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}
-(void)setBarItem:(BarItem *)barItem
{
    _barItem = barItem;
    [self setTitle:_barItem.name];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)systemKeyboardShow:(NSNotification *)notification
{
    keyboardVisible = YES;
    [self keyboardShowOrHide:keyboardVisible];
}
-(void)systemKeyboardHide:(NSNotification *)notification
{
    keyboardVisible = NO;
    [self keyboardShowOrHide:keyboardVisible];
}
-(void)keyboardShowOrHide:(Boolean)boo
{
    
}


-(IBAction)refreshBlEDevice:(id)sender{
    
    ScanViewController  *scanView = [ScanViewController new];
    [self.navigationController pushViewController:scanView animated:YES];
}
@end
