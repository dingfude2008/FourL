//
//  TransmitViewController.h
//  BLECollection
//
//  Created by rfstar on 14-1-13.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import "BaseViewController.h"
#import "ReceiveView.h"
#import "SendDataView.h"
#import "DialogView.h"
#import "HexKeyboardView.h"


#define    Encode_ASCII      1
#define  Encode_HEX         2

@interface TransmitViewController : BaseViewController <SendDataViewTextViewDelegate,DialogViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,HexKeyboardViewDelegate>
{
     NSUInteger               Encode;
     NSTimer                 *loopSendDataTimer;  //循环发送的timer
}

@property(nonatomic , strong) ReceiveView           *receiveView;
@property(nonatomic , strong) SendDataView          *sendView;
@property(nonatomic , strong) UIButton              *sendBtn,*resetBtn,*clearBtn,*intervalBtn;
@property(nonatomic , strong) UISwitch              *switchReceive,*switchAutoSend; //开关接收，自动发送开关

@property(nonatomic , strong) UISegmentedControl   *segmentedView;  //编码控制

@end

