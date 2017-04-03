//
//  ParameterViewController.h
//  BLECollection
//
//  Created by rfstar on 14-4-22.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import "BLEViewController.h"
#import "ModuleParatemCellTableViewCell.h"
#import "AppDelegate.h"
#import "DialogListView.h"


@interface ParameterViewController : BLEViewController <UITableViewDataSource,UITableViewDelegate,DialoglistViewDelegate>
{
    AppDelegate            *appDelegate;
}
@property (nonatomic ,strong) UITableView           *listView;

@end
