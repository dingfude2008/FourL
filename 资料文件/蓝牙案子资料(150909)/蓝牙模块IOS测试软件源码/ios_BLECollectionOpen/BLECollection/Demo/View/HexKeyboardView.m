//
//  HexKeyboardView.m
//  BLECollection
//
//  Created by rfstar on 14-1-16.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import "HexKeyboardView.h"
#import "Tools.h"
#import <QuartzCore/QuartzCore.h>

@implementation HexKeyboardView
{
    UIView     *parent;
    DialogView *dialog ;
    NSString   *messageHex;
}
- (id)initNib
{
    return self;
}
-(void)showView:(UIView *)parentView
{
     dialog = [[DialogView alloc]initNib];
    [dialog setDelegate:self];
    [dialog showDialogView:parentView];
    parent = parentView;
}
#pragma DialogView
-(UIView *)dialogContentView
{
    UIView *tmpView = [[NSBundle mainBundle] loadNibNamed:@"HexKeyboardView" owner:self options:nil][0];
    [tmpView setBackgroundColor:[Tools colorWithHexString:@"#EBEBEB"]];
    if([[[UIDevice currentDevice]systemVersion] intValue]<7)
    {
        [tmpView setBackgroundColor:[Tools colorWithHexString:@"#7A7A7A"]];
    }
    
    NSArray  *buts = [tmpView subviews];
    for (UIView *tmpBtn in buts) {    //给button添加事件
        if ([tmpBtn isKindOfClass:[UIButton class]]) {
            UIButton  *button = (UIButton *)tmpBtn;
            if([[[UIDevice currentDevice]systemVersion] intValue]>6)
            {
                [button.layer setBorderColor:[Tools colorWithHexString:@"#6495ED"].CGColor];
                [button.layer setBorderWidth:1];
                [button.layer setCornerRadius:7.5];
                [button setTitleColor:[Tools colorWithHexString:@"#7D26CD"] forState:UIControlStateHighlighted];
            }
            [button addTarget:self action:@selector(HexInputKey:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    CGRect    frame;
    if([Tools currentResolution] == UIDevice_iPhone4s)
    {
        frame = CGRectMake(0, 264, tmpView.frame.size.width, tmpView.frame.size.height);
    }else if([Tools currentResolution ] == UIDevice_iPhone5){
        frame = CGRectMake(0, 352, tmpView.frame.size.width, tmpView.frame.size.height);
    }
    [tmpView setFrame:frame];
    return tmpView;
}
-(void)dialogDimissed
{
    [_delegate hexKeybordViewDimissed];
}
-(void)dialogShow
{
    [_delegate hexKeybordViewShow];
}

- (IBAction)HexInputKey:(UIButton *)sender {

    UIButton *myButton1 = sender ;

    if (myButton1.tag==17)//<--
    {
        NSRange range=  NSMakeRange (0,messageHex.length-1);
        messageHex = [messageHex substringWithRange:range];
    }
    else{
        switch (myButton1.tag) {
            case 101:  //Done
                [dialog hideDialogView];
                [_delegate hexKeybordViewPressedValueOfEnter];
                break;
            case 102:       //Del
                [_delegate hexKeybordViewPressedValueOfDel];
                break;
            case 103:       //Clr
                [_delegate hexKeybordViewPressedValueOfClr];
                break ;
            case 10://
                if ((messageHex.length<40)) {
                  messageHex  = [NSString stringWithFormat:@"%s","a"];
                }break;
            case 11://
                if ((messageHex.length<40)) {
                  messageHex  = [NSString stringWithFormat:@"%s","b"];
                }break;
            case 12://
                if ((messageHex.length<40)) {
                  messageHex  = [NSString stringWithFormat:@"%s","c"];
                }break;
            case 13://
                if ((messageHex.length<40)) {
                  messageHex  = [NSString stringWithFormat:@"%s","d"];
                }break;
            case 14://
                if ((messageHex.length<40)) {
                  messageHex  = [NSString stringWithFormat:@"%s","e"];
                }break;
            case 15://
                if ((messageHex.length<40)) {
                  messageHex  = [NSString stringWithFormat:@"%s","f"];
                }break;
            default://'0'-'9','A''B''C''D''E''F'
                if ((messageHex.length<40)) {
                  messageHex  = [NSString stringWithFormat:@"%d",(int)(myButton1.tag)];
                }break;
        }
    }
    if(myButton1.tag>=0 && myButton1.tag <16)
    {
        [_delegate hexKeybordViewPressedValue:messageHex];
    }
}
@end
