//
//  ViewController.m
//  LED_Zheng
//
//  Created by DFD on 2017/4/2.
//  Copyright © 2017年 DFD. All rights reserved.
//

#import "ViewController.h"
#import "FontDataTool.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [FontDataTool setupData];
    
    NSString *string = @"黑固好";
    
    [FontDataTool getLatticeDataArray:string];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
