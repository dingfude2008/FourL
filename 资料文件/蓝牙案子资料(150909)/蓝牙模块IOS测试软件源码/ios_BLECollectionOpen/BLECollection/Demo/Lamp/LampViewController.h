//
//  LampViewController.h
//  BLECollection
//
//  Created by rfstar on 14-1-2.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "RSColorPickerView.h"
#import "AppDelegate.h"
@interface LampViewController : BaseViewController <RSColorPickerViewDelegate>
{
    AppDelegate            *appDelegate;
}
@end
