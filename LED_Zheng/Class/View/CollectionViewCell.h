//
//  CollectionViewCell.h
//  LED_Zheng
//
//  Created by DFD on 2017/4/4.
//  Copyright © 2017年 DFD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (nonatomic, copy) void (^blockClick)();

@end
