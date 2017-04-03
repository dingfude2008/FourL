//
//  SendViewController.m
//  BLECollection
//
//  Created by rfstar on 14-1-3.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import "SendViewController.h"

@interface SendViewController ()

@end

@implementation SendViewController


-(id)initWithNib
{
    id tmp = [super initWithNib];
    if(self){
        
        [self setTitle:@"蓝牙数据通道"];
        
        _sendView  = [[SendDataView alloc]initWithFrame:self.view.frame];

        [_sendView textViewBecomeFirstResponder];
        [self.view addSubview:_sendView];
        
        _resetBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _resetBtn.frame = CGRectMake(10, _sendView. frame.origin.y+_sendView.frame.size.height+10, 90, 35);
        [_resetBtn setTitle:@"重置" forState:UIControlStateNormal];
        [_resetBtn addTarget:self action:@selector(resetText:) forControlEvents:UIControlEventTouchUpInside];
        
        _clearBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _clearBtn.frame = CGRectMake(116, _sendView. frame.origin.y+_sendView.frame.size.height+10, 90, 35);
        [_clearBtn setTitle:@"清除" forState:UIControlStateNormal];
        [_clearBtn addTarget:self action:@selector(clearText:) forControlEvents:UIControlEventTouchUpInside];
        
        _sendBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _sendBtn.frame = CGRectMake(222, _sendView.frame.origin.y+_sendView.frame.size.height+10, 90, 35);
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(sendData:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_resetBtn];
        [self.view addSubview:_clearBtn];
        [self.view addSubview:_sendBtn];
        
//        UIView *nib = [[NSBundle mainBundle] loadNibNamed:@"FFE9" owner:self options:nil][0];
//    
//        [self.view addSubview:nib];
    }
    return tmp;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)sendData:(id)sender
{
    [_sendView sendData];
}
-(IBAction)clearText:(id)sender
{
    [_sendView clearText];
}
-(IBAction)resetText:(id)sender
{
    [_sendView resetText];
    
}

@end
