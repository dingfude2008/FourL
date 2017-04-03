//
//  BaseViewController.h
//  BLECollection
//
//  Created by rfstar on 14-1-2.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarItem.h"
@interface BaseViewController : UIViewController
{
    Boolean                 keyboardVisible;
}
@property (nonatomic, assign) BarItem *barItem;

-(id)initWithNib;
-(void)keyboardShowOrHide:(Boolean)boo;
@end
