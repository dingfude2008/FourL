//
//  KHorizontalScrolleView.h
//  BLECollection
//
//  Created by rfstar on 13-12-23.
//  Copyright (c) 2013年 Kevin.wu All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KView.h"
#import "BarItem.h"

@protocol KHorizotalScorllViewDelegate <NSObject>

- (void) kHorizotalScrollViewItemClick:(UIView *)view Position:(NSInteger)position;

@end
@interface KHorizontalScrolleView : UIView <KViewDeledgate>

@property NSMutableArray *listArray;
@property (nonatomic,strong) UIScrollView  *scrollView;
@property (nonatomic,strong) id<KHorizotalScorllViewDelegate> delegate;

- (void) setListItem:(NSMutableArray *) listArray;

@end

