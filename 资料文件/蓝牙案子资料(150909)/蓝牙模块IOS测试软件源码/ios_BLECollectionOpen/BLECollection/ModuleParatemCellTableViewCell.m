//
//  ModuleParatemCellTableViewCell.m
//  BLECollection
//
//  Created by rfstar on 14-4-22.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import "ModuleParatemCellTableViewCell.h"
#import "Tools.h"
@implementation ModuleParatemCellTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setFrame:(CGRect)frame
{
    UIView *tempView = [[UIView alloc]initWithFrame:frame];
    [self setSelectedBackgroundView:tempView];
    [self selectedBackgroundView].backgroundColor = [Tools colorWithHexString:@"#1E90FF"];
    
    tempView.layer.cornerRadius = 10;
    [tempView.layer setBorderColor:[Tools colorWithHexString:@"#898989"].CGColor];
    [tempView.layer setBorderWidth:1];
    frame.origin.x += 10;
    frame.origin.y += 10;
    frame.size.width -= 20;
    frame.size.height -= 10;
    [super setFrame:frame];
}
@end
