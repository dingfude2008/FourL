//
//  DFMatrixLedView.m
//  LED_Zheng
//
//  Created by DFD on 2017/4/4.
//  Copyright © 2017年 DFD. All rights reserved.
//

#import "DFMatrixLedView.h"

@interface DFMatrixLedView(){
    NSMutableArray *arrayView;
}



@end

@implementation DFMatrixLedView




- (void)setPointsArray:(NSArray *)pointsArray{
    _pointsArray = pointsArray;
    
    CGFloat heigh = self.bounds.size.height / 12;
    
    for (int i = 0; i < pointsArray.count; i++) {
        
        NSDictionary *dicSimple = pointsArray[i];
        
        NSArray *columnRow = dicSimple.allValues.firstObject;
        int column = [columnRow[0] intValue];
        int row = [columnRow[1] intValue];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(column * heigh, row * heigh, heigh, heigh)];
        
        if ([dicSimple.allKeys.firstObject intValue] == 1) {
            imageView.image = [UIImage imageNamed:@"on"];
        }else{
            imageView.image = [UIImage imageNamed:@"off"];
        }
        [self addSubview:imageView];
        
    }
}

@end
