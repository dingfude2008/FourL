//
//  ReceiveViewController.h
//  BLECollection
//
//  Created by rfstar on 14-1-8.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLEViewController.h"
#import "ReceiveView.h"

@interface ReceiveViewController : BLEViewController

@property(nonatomic , strong) ReceiveView   *receiveView;

@property(nonatomic , strong) UIButton     *resetBtn;
@property(nonatomic , strong) UISwitch     *switchOnOff;

@end
