//
//  FRSearchDeviceCell.m
//  FriedRice
//
//  Created by DFD on 2017/3/13.
//  Copyright © 2017年 DFD. All rights reserved.
//

#import "FRSearchDeviceCell.h"

@interface FRSearchDeviceCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation FRSearchDeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setDevice:(CBPeripheral *)device{
    _device = device;
    self.titleLabel.text = device.name;
    [self.titleLabel sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"FRSearchDeviceCell";
    FRSearchDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}
@end
