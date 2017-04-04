//
//  DFMatrixLedView.h
//  LED_Zheng
//
//  Created by DFD on 2017/4/4.
//  Copyright © 2017年 DFD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DFMatrixLedView : UIView


@property (nonatomic, assign) NSUInteger row;

@property (nonatomic, assign) NSUInteger column;

@property (nonatomic, strong) NSArray *pointsArray;


- (void)beginAnimation;

- (void)endAnimation;


@end
