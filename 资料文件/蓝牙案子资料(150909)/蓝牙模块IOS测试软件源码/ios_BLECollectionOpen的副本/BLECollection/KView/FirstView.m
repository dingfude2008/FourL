//
//  FirstView.m
//  BLECollection
//
//  Created by rfstar on 13-12-30.
//  Copyright (c) 2013年 rfstar. All rights reserved.
//

#import "FirstView.h"

@implementation FirstView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *back = [UIImage imageNamed:@"page1-640.png"];
        _background = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 320)];
        [_background setImage:back];
        [self addSubview:_background];
        [self.background setUserInteractionEnabled:YES];
        
        [self initButton];
    }
    return self;
}

- (void)initButton{
    _ffe5Btn = [[OBShapedButton alloc]initWithFrame:CGRectMake(51.5, 2, 150.5, 57)];
    [_ffe5Btn setTag:TAGTMP+BluetoothDataChannel];
    [_ffe5Btn setImage:[UIImage imageNamed:@"p1-1.png"] forState:UIControlStateHighlighted];
    [_ffe5Btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_background addSubview:_ffe5Btn];
    
    _ffe0Btn = [[OBShapedButton alloc]initWithFrame:CGRectMake(172.5, 42.5, 138, 57.5)];
    [_ffe0Btn setTag:TAGTMP+SerialDataChannel];
    [_ffe0Btn setImage:[UIImage imageNamed:@"p1-2.png"] forState:UIControlStateHighlighted];
    [_ffe0Btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_background addSubview:_ffe0Btn];
    
    _ffd0Btn = [[OBShapedButton alloc]initWithFrame:CGRectMake(7, 65, 100, 94)];
    [_ffd0Btn setTag:TAGTMP+ADCInput];
    [_ffd0Btn setImage:[UIImage imageNamed:@"p1-3.png"] forState:UIControlStateHighlighted];
        [_ffd0Btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_background addSubview:_ffd0Btn];
    
    _ffa0Btn = [[OBShapedButton alloc]initWithFrame:CGRectMake(94.0, 161.3, 125, 57)];
    [_ffa0Btn setTag:TAGTMP+RSSIReport];
    [_ffa0Btn setImage:[UIImage imageNamed:@"p1-4.png"] forState:UIControlStateHighlighted];
    [_ffa0Btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_background addSubview:_ffa0Btn];
    
    _ffb0Btn = [[OBShapedButton alloc]initWithFrame:CGRectMake(15.6,201.7,102,105.5)]; 
    [_ffb0Btn setTag:TAGTMP+PWMOutput];
    [_ffb0Btn setImage:[UIImage imageNamed:@"p1-6.png"] forState:UIControlStateHighlighted];
    [_ffb0Btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_background addSubview:_ffb0Btn];
    
    __180fBtn = [[OBShapedButton alloc ]initWithFrame:CGRectMake(153.5, 245, 141.5, 61)];
    [__180fBtn setTag:TAGTMP+BatteryReport];
    [__180fBtn setImage:[UIImage imageNamed:@"p1-5.png"] forState:UIControlStateHighlighted];
    [__180fBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_background addSubview:__180fBtn];
    
    
}
-(IBAction)buttonClick:(id)sender
{
    [_delegate firstViewOnClick:sender position:[sender tag]-TAGTMP];
}
@end
