//
//  DialogView.m
//  BLECollection
//
//  Created by rfstar on 14-1-15.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import "DialogView.h"
#import "Tools.h"
@implementation DialogView

{
    UIView *dialogView;
    UIButton   *hidebtn;
    CGRect frame ;
}
-(id)initNib
{
    if(Tools.currentResolution == UIDevice_iPhone4s)
    {
        frame = CGRectMake(0, 0, 320, 480);
        
    }else if(Tools.currentResolution == UIDevice_iPhone5){
        frame = CGRectMake(0, 0, 320, 600);
        
    }
    return self;
}

-(void)showDialogView:(UIView *)tmpView {

      NSLog(@" show dialogView1111111");
    hidebtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    [hidebtn setBackgroundColor:[Tools colorWithHexString:@"#000000"]];
    hidebtn.alpha = .5f;
    [hidebtn addTarget:self action:@selector(hideDialogAction:) forControlEvents:UIControlEventTouchUpInside];
     dialogView = [[UIView alloc]initWithFrame:frame];

    [dialogView addSubview:hidebtn];
    [tmpView.window addSubview:dialogView];
    [dialogView setBackgroundColor:[UIColor clearColor]];
    [dialogView addSubview:[_delegate dialogContentView]];
    
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    CGSize dialogSize = [dialogView sizeThatFits:CGSizeZero];
    CGRect startRect = CGRectMake(0.0,
                                  screenRect.origin.y + screenRect.size.height,
                                  dialogSize.width, dialogSize.height);
    dialogView.frame = startRect;
    // compute the end frame
    CGRect endRect = CGRectMake(0,0,dialogSize.width,dialogSize.height);
    // start the slide up animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    // we need to perform some post operations after the animation is complete
    [UIView setAnimationDelegate:self];
    dialogView.frame = endRect;
    
    [UIView commitAnimations];
    [_delegate dialogShow];
}
-(void)hideDialogView
{
      NSLog(@" dismiss dialogView1111111");
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

        [_delegate dialogDimissed];
    }
}
-(IBAction)hideDialogAction:(id)sender{
    [self hideDialogView];
}
@end
