//
//  FRSearchDeviceCell.h
//  FriedRice
//
//  Created by DFD on 2017/3/13.
//  Copyright © 2017年 DFD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRSearchDeviceCell : UITableViewCell

@property (nonatomic, strong) CBPeripheral *device;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
