//
//  MainView.m
//  BLECollection
//
//  Created by rfstar on 13-12-24.
//  Copyright (c) 2013年 rfstar. All rights reserved.
//

#import "MainView.h"
#import <QuartzCore/QuartzCore.h>
#import "Tools.h"

#define FIRST_VIEW  0
#define SECOND_VIEW 1
@implementation MainView
{
    NSInteger showState ;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor blackColor]];
        NSInteger  y = (frame.size.height-320)/2;
        _firstView = [[FirstView alloc]initWithFrame:CGRectMake(0, y, 320, 320)];
        _secondView = [[SecondView alloc]initWithFrame:CGRectMake(0, y, 320, 320)];
        _firstView.tag = 101;
        [_secondView setTag:102];
        
        int pageControl_y = 330;
        if(Tools.currentResolution == UIDevice_iPhone5){
   
            pageControl_y = 400;
        }
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, pageControl_y,320, 36)];
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor blueColor]];
        [_pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
        [_pageControl setNumberOfPages:2];
        
        [self addSubview:_secondView];
        [self addSubview:_firstView];
        
        [self addSubview:_pageControl];
        
        UISwipeGestureRecognizer *swipRight =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swip:)];
        [swipRight setDirection:UISwipeGestureRecognizerDirectionRight];
        [self addGestureRecognizer:swipRight];
        
        UISwipeGestureRecognizer *swipLeft =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swip:)];
        [swipLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self addGestureRecognizer:swipLeft];
    }
    return self;
}
-(void)swip:(UISwipeGestureRecognizer *)gesture
{
  
    if(gesture.direction == UISwipeGestureRecognizerDirectionLeft){
        if(showState == FIRST_VIEW)
        {
            showState = SECOND_VIEW;
            [self beginAnimatin:0];
            [_pageControl setCurrentPage:1];
        }
    }else if(gesture.direction == UISwipeGestureRecognizerDirectionRight){
     
        if(showState == SECOND_VIEW)
        {
            showState = FIRST_VIEW;
            [self beginAnimatin:1];
            [_pageControl setCurrentPage:0];
        }
    }
}
-(void)beginAnimatin:(NSInteger)direct
{
	CGContextRef context = UIGraphicsGetCurrentContext();
    
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:1.0];
    
    if(direct==0)
    {
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:self cache:YES];
        NSInteger purple = [[self subviews] indexOfObject:[self viewWithTag:102]];
        NSInteger maroon = [[self subviews] indexOfObject:[self viewWithTag:101]];
        [self exchangeSubviewAtIndex:purple withSubviewAtIndex:maroon];
    }else{
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
        NSInteger purple = [[self subviews] indexOfObject:[self viewWithTag:101]];
        NSInteger maroon = [[self subviews] indexOfObject:[self viewWithTag:102]];
        [self exchangeSubviewAtIndex:purple withSubviewAtIndex:maroon];
    }
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationFinished:)];
    
	[UIView commitAnimations];
}
@end
