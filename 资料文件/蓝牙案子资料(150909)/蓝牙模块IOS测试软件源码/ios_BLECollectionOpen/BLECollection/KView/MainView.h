//
//  MainView.h
//  BLECollection
//
//  Created by rfstar on 13-12-24.
//  Copyright (c) 2013年 rfstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstView.h"
#import "SecondView.h"
@interface MainView : UIView

@property (nonatomic , strong) FirstView    *firstView;
@property (nonatomic , strong) SecondView   *secondView;
@property (nonatomic , strong) UIPageControl  *pageControl;
@end
