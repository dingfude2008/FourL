//
//  ListView.h
//  BLECollection
//
//  Created by rfstar on 14-1-7.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "AppDelegate.h"
enum MODEl_STATE
{
    MODEL_NORMAL = 0,
    MODEL_CONNECTING = 1,
    MODEL_SCAN = 2,
    MODEL_CONECTED = 3,
} MODEL;

@protocol ListViewDelegate <NSObject>

-(void)listViewRefreshStateStart;
-(void)listViewRefreshStateEnd;

@end
@interface ListView : UIView  <UITableViewDataSource,UITableViewDelegate>
{
    AppDelegate     *appDelegate;
}
@property (nonatomic ,strong) UITableView           *listView;
@property (nonatomic , weak) id<ListViewDelegate> listDelegate;

-(void) startScan;
-(void) stopScan;

@end
