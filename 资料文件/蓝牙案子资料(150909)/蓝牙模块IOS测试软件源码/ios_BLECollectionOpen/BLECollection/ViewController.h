//
//  ViewController.h
//  BLECollection
//
//  Created by rfstar on 13-12-23.
//  Copyright (c) 2013年 rfstar. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KHorizontalScrolleView.h"
#import "MainView.h"

@interface ViewController : UIViewController<KHorizotalScorllViewDelegate,FirstViewDelegate,SecondViewDelegate>

@property ( nonatomic , strong ) KHorizontalScrolleView    *scrollBar;
@property ( nonatomic , strong ) MainView                  *mainView;

@end
