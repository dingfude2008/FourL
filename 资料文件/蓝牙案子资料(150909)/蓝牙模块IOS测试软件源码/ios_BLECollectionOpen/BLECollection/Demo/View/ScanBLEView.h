//
//  ScanBLEView.h
//  BLECollection
//
//  Created by rfstar on 14-1-3.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tools.h"
#import "ListView.h"

@interface ScanBLEView : NSObject

@property (nonatomic ,strong) UIButton              *refreshBtn;

@property (nonatomic ,strong) NSMutableArray        *arraySource;

@property (nonatomic ,strong) ListView              *listView;

-(id)initNib:(UIView *)tmpView;
-(void)hideDialogView;

-(IBAction)doneAction:(id)sender;
@end
