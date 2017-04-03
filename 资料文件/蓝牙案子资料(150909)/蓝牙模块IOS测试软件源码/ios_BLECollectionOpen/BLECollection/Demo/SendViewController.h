//
//  SendViewController.h
//  BLECollection
//
//  Created by rfstar on 14-1-3.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLEViewController.h"
#import "SendDataView.h"
@interface SendViewController :  BLEViewController

@property(nonatomic , strong) SendDataView          *sendView;

@property(nonatomic , strong) UIButton           *sendBtn,*resetBtn,*clearBtn;
@end
