//
//  ListViewCell.m
//  LED_Zheng
//
//  Created by DFD on 2017/4/7.
//  Copyright © 2017年 DFD. All rights reserved.
//

#import "ListViewCell.h"

@interface ListViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;



@end

@implementation ListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)deleteButtonClick {
    if (self.deleteBlock) {
        self.deleteBlock(self.model);
    }
}

- (IBAction)editButtonClick {
    if (self.editBlock) {
        self.editBlock(self.model);
    }
}

- (void)setModel:(Program *)model{
    if (_model != model) {
        _model = model;
        self.titleLabel.text = model.text;
        self.valueLabel.text = [NSString stringWithFormat:@"%@:%@ %@:%d%@",
                                kString(@"动画"),
                                model.specialEffectsString,
                                kString(@"停留"),
                                model.residenceTime,
                                kString(@"秒")];
    }
}


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"ListViewCell";
    ListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
