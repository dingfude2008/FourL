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
    
    CGRect rectButton = self.button.titleLabel.frame;
    rectButton.origin.x = 5;
    self.button.titleLabel.frame = rectButton;
    
    CGRect rectImage = self.button.imageView.frame;
    rectImage.origin.x = self.bounds.size.width - 10;
    self.button.imageView.frame = rectImage;
    
    self.button.layer.borderWidth = 1;
    self.button.layer.cornerRadius = 3;
    self.button.layer.masksToBounds = YES;
}

- (IBAction)buttonClick {
    if (self.blockClick) {
        self.blockClick();
    }
}


@end
