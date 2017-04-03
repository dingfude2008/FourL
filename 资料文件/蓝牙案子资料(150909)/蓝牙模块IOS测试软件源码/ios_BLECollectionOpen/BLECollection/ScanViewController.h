//
//  ScanViewController.h
//  BLECollection
//
//  Created by rfstar on 14-1-10.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import "BLEViewController.h"
#import "ListView.h"
@interface ScanViewController : BLEViewController<ListViewDelegate>

@property (strong, nonatomic) ListView                *listView ;
@property (strong, nonatomic) UIActivityIndicatorView *progressView;
@end
