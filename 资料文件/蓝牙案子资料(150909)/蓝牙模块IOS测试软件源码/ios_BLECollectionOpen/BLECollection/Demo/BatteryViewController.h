//
//  BatteryViewController.h
//  BLECollection
//
//  Created by rfstar on 14-4-30.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import "BLEViewController.h"
#import "AppDelegate.h"
#import "Tools.h"

@interface BatteryViewController : BLEViewController
{
    AppDelegate            *appDelegate;
}

@property (nonatomic , strong) UILabel                      *label;
@property (nonatomic , strong) UIButton                     *button;
@end
