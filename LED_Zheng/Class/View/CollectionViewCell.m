//
//  CollectionViewCell.m
//  LED_Zheng
//
//  Created by DFD on 2017/4/4.
//  Copyright © 2017年 DFD. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.button.layer.borderWidth = 1;
    self.button.layer.cornerRadius = 5;
    self.button.layer.masksToBounds = YES;
    self.button.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.button setBackgroundColor:[UIColor clearColor]];
}


@end
