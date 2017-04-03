//
//  PWMViewController.h
//  BLECollection
//
//  Created by rfstar on 14-1-15.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import "BLEViewController.h"
#import "AppDelegate.h"

@interface PWMViewController : BLEViewController
{
    AppDelegate            *appDelegate;
}
@property (nonatomic , strong) UIScrollView         *scrollView;
@end
