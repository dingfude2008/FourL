//
//  BLEViewController.h
//  BLECollection
//
//  Created by rfstar on 14-1-3.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//
//  通道的基类
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Tools.h"

@interface BLEViewController : UIViewController
{
    Boolean                 keyboardVisible;
}
-(id)initWithNib;

-(void)keyboardShowOrHide:(Boolean)boo;
@end
