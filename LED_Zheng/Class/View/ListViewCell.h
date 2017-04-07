//
//  ListViewCell.h
//  LED_Zheng
//
//  Created by DFD on 2017/4/7.
//  Copyright © 2017年 DFD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ListViewCellDelegate <NSObject>

- (void)deleteModel:(Program *)model;

- (void)editModel:(Program *)model;

@end

@interface ListViewCell : UITableViewCell


@property (nonatomic, assign) id<ListViewCellDelegate> delegate;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) Program *model;

@end
