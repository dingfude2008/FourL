//
//  ScanBLEView.m
//  BLECollection
//
//  Created by rfstar on 14-1-3.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import "ScanBLEView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ScanBLEView

{
    UIView *dialogView;
    UIButton *dialogShowOrHideBtn;
}

-(id)initNib:(UIView *)tmpView
{
    CGRect frame ;
    if(Tools.currentResolution == UIDevice_iPhone4s)
    {
       frame = CGRectMake(20, 0, 280, 320);
        
    }else if(Tools.currentResolution == UIDevice_iPhone5){
       frame = CGRectMake(20, 0, 280, 400);
        
    }
    [self showDialogView:tmpView frame:frame ];
    return self;
}

-(IBAction)doneAction:(id)sender{
    [self hideDialogView];
}
-(void)showDialogView:(UIView *)tmpView frame:(CGRect)frame{
    dialogShowOrHideBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
//    dialogShowOrHideBtn.backgroundColor = [UIColor redColor];
    [dialogShowOrHideBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    [tmpView.window addSubview:dialogShowOrHideBtn];

    dialogView = [[UIView alloc]initWithFrame:frame];
    
    dialogView.layer.cornerRadius = 10;
    dialogView.layer.borderWidth = 1;
    dialogView.layer.borderColor = [UIColor grayColor].CGColor;
    [dialogView setBackgroundColor:[UIColor whiteColor]];
    [self initList:dialogView.frame];
    [dialogView setClipsToBounds:YES];
    
    [tmpView.window addSubview:dialogView];
    
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    CGSize dialogSize = [dialogView sizeThatFits:CGSizeZero];
    CGRect startRect = CGRectMake(0.0,
                                  screenRect.origin.y + screenRect.size.height,
                                  dialogSize.width, dialogSize.height);
    dialogView.frame = startRect;
    // compute the end frame
    CGRect endRect = CGRectMake(20.0,100,dialogSize.width,dialogSize.height);
    // start the slide up animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    // we need to perform some post operations after the animation is complete
    [UIView setAnimationDelegate:self];
    dialogView.frame = endRect;
    
    [UIView commitAnimations];
}
-(void)initList:(CGRect)tmpFrame{
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 280, 35)];
    [title setBackgroundColor:[UIColor lightGrayColor]];
    [title setFont:[UIFont systemFontOfSize:14]];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setText:@"蓝牙列表"];
    [dialogView addSubview:title];
    
    CGRect frame  = CGRectMake(0,title.frame.size.height, tmpFrame.size.width, tmpFrame.size.height-title.frame.size.height);
    _listView = [[ListView alloc]initWithFrame:frame];
    _listView.layer.cornerRadius = [title.layer cornerRadius];
    [dialogView addSubview:_listView];
}
-(void)hideDialogView
{
    if(dialogView != nil)
    {
        NSLog(@" dismiss dialogView");
        CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
        CGRect endFrame = dialogView.frame;
        endFrame.origin.y = screenRect.origin.y + screenRect.size.height;
        
        // start the slide down animation
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        
        // we need to perform some post operations after the animation is complete
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(slideDownDidStop)];
        
        dialogView.frame = endFrame;
        [UIView commitAnimations];
        [dialogShowOrHideBtn setHidden:YES];
        dialogShowOrHideBtn = nil;
    }
}
@end
