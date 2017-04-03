//
//  BLEViewController.m
//  BLECollection
//
//  Created by rfstar on 14-1-3.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import "BLEViewController.h"
#import "Tools.h"
#import "ScanViewController.h"

@interface BLEViewController ()

@end

@implementation BLEViewController

-(id)initWithNib
{
    if(Tools.currentResolution == UIDevice_iPhone4s)
    {
        [self.view setFrame:CGRectMake(0, 0, 320, 416)];
        
    }else if(Tools.currentResolution == UIDevice_iPhone5){
        [self.view setFrame:CGRectMake(0, 0, 320, 502)];
        
    }
    [self.view setUserInteractionEnabled:YES];
    [self.view setBackgroundColor:[Tools colorWithHexString:@"#E0EEE0"]];
    
    UIBarButtonItem *scanDeviceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(refreshBlEDevice:)];
    self.navigationItem.rightBarButtonItem = scanDeviceItem;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(systemKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(systemKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    keyboardVisible = NO;
    return  self;
}
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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)refreshBlEDevice:(id)sender{
    
    ScanViewController  *scanView = [ScanViewController new];
    [self.navigationController pushViewController:scanView animated:YES];
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

@end
