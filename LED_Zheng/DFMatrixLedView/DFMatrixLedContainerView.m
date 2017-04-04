//
//  DFMatrixLedContainerView.m
//  LED_Zheng
//
//  Created by DFD on 2017/4/4.
//  Copyright © 2017年 DFD. All rights reserved.
//

#import "DFMatrixLedContainerView.h"
#import "DFMatrixLedView.h"

@implementation DFMatrixLedContainerView

- (void)setupData:(NSArray <NSArray <NSDictionary *>*>*)array{
    
    for(UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self layoutIfNeeded];
    
    CGFloat height = self.bounds.size.height;
    int width;
    
    int offest = 0;
    for (int i = 0; i < array.count; i++) {
        NSArray *arraySub = array[i];
        
        double sqrtValue = sqrt ((double)arraySub.count);
        if((int)sqrtValue == sqrtValue){        // 汉字的点阵数据是正方形的
            width = height;
        }else{
            width = height / 2;
        }
        DFMatrixLedView * matrixLedView = [[DFMatrixLedView alloc] initWithFrame:CGRectMake(offest, 0, width, height)];
        offest += width;
        matrixLedView.row = 12;
        matrixLedView.column = width == height ? 12 : 6;
        matrixLedView.pointsArray = arraySub;
        
        [self addSubview:matrixLedView];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            matrixLedView.layer.borderWidth = 1;
//            matrixLedView.layer.borderColor = [UIColor redColor].CGColor;
//            [self addSubview:matrixLedView];
//        }); 
    }
}



@end
