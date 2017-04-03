//
//  KView.h
//  BLECollection
//
//  Created by rfstar on 13-12-24.
//  Copyright (c) 2013年 rfstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BarItem.h"

#define HEIGHT      50
#define WIDTH       62

@protocol KViewDeledgate;

@interface KView : UIControl

@property NSInteger position;
@property (nonatomic,retain) id<KViewDeledgate> delegate;

@property (nonatomic,retain) NSString *text;

@property (nonatomic,retain) UIImageView       *imageview;
@property (nonatomic,retain) UILabel           *nameLabel;

- (void) initView :(BarItem *) item;

@end

@protocol KViewDeledgate <NSObject>

-(void) kViewOnClick:(KView *)view Position:(NSInteger)position;

@end