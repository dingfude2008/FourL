//
//  KHorizontalScrolleView.m
//  BLECollection
//
//  Created by rfstar on 13-12-23.
//  Copyright (c) 2013年 Kevin.wu All rights reserved.
//

#import "KHorizontalScrolleView.h"
#import "Tools.h"
@implementation KHorizontalScrolleView

- (id)initWithFrame:(CGRect)frame

{
    NSLog(@"width  %f   height  %f",frame.size.width,frame.size.height);
    
//    CGRect rect =  CGRectMake(frame.origin.x,frame.size.height-HEIGHT, frame.size.width, HEIGHT);
    CGRect rect =  CGRectMake(frame.origin.x,frame.origin.y, frame.size.width, HEIGHT);
    self = [super initWithFrame:rect];
  
    if (self) {
        // Initialization code
        [self initScrolleView:CGRectMake(0, 0, rect.size.width ,HEIGHT )];
        [self addSubview:self.scrollView];
        [self setUserInteractionEnabled:YES];
        [self.scrollView setShowsHorizontalScrollIndicator:NO];
    }
    return self;
}//初始化 scrolleView
- (void) initScrolleView :(CGRect)frame
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.scrollView setShowsHorizontalScrollIndicator:YES];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setBackgroundColor:[UIColor lightGrayColor]];
    if([[[UIDevice currentDevice]systemVersion] intValue]>6)
    {
        [self.scrollView setBackgroundColor:[Tools colorWithHexString:@"#B0E2FF"]];
    }
}

-(void)setListItem:(NSMutableArray *)listArray
{
    self.listArray = listArray;
    [self showListItem];
}

-(void)showListItem
{
    float x = 0;
    NSInteger  position =0;
    for (BarItem *tmpItem in self.listArray)
    {
        KView *mView = [[KView alloc]initWithFrame:CGRectMake(x, 0,WIDTH, HEIGHT)];
        [mView setPosition:position];
        [mView setDelegate:self];
        [mView setBackgroundColor:[Tools colorWithHexString:@"#4A708B"]];
        if([[[UIDevice currentDevice]systemVersion] intValue]>6)
        {
            [mView setBackgroundColor:[Tools colorWithHexString:@"#EBEBEB"]];
        }
        
        [mView initView:tmpItem];
        
        [self.scrollView addSubview:mView];

        x = mView.frame.origin.x + mView.frame.size.width +2;
        position++;
    }
    [self.scrollView setContentSize:CGSizeMake(WIDTH*position+(position-1)*2, HEIGHT)];
}

#pragma mark-
#pragma mark KView 中的事件
-(void)kViewOnClick:(KView *)view Position:(NSInteger)position
{
    [self.delegate kHorizotalScrollViewItemClick:view Position:position];
}
@end
