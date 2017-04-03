//
//  SendDataView.h
//  BLECollection
//
//  Created by rfstar on 14-1-3.
//  Copyright (c) 2014年 rfstar. All rights reserved.
// 用于发送数据

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "Tools.h"

@protocol SendDataViewTextViewDelegate <NSObject>

-(BOOL)sendDataTextViewShouldBeginEditing:(UITextView *)textView;  //开始编辑
-(BOOL)sendDataTextViewShouldEndEditing:(UITextView *)textView;    //结束编辑

@end
@interface SendDataView : UIView <UITextViewDelegate>

{
    AppDelegate            *appDelegate;
    long                   sendByteSize;
    NSString               *sendMessage;
    BOOL              IsAscii ;          //默认为Ascii显示
}

@property(nonatomic , strong) UITextView         *messageTxt;

//要发送的数据长度和发送的所有数据长度的总和
@property(nonatomic , strong) UILabel            *lengthTxt,*sendBytesSizeTxt,*intervalTxt;
@property(nonatomic , strong) UILabel            *lengthLabel, *byteLabel,*intervalLabel;

@property(nonatomic , strong) id<SendDataViewTextViewDelegate> delegate;


-(void)clearText;
-(void)sendData;
-(void)resetText;
-(void)textViewBecomeFirstResponder;

-(void)setIsAscii:(BOOL)boo; //为假时显示 hex

@end
