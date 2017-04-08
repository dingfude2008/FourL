//
//  ListViewCell.h
//  LED_Zheng
//
//  Created by DFD on 2017/4/7.
//  Copyright © 2017年 DFD. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ListViewCell : UITableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, copy) void (^editBlock)(Program *model);

@property (nonatomic, copy) void (^deleteBlock)(Program *model);



@property (nonatomic, strong) Program *model;

@end
