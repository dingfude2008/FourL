//
//  ReceiveView.h
//  BLECollection
//
//  Created by rfstar on 14-1-8.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface ReceiveView : UIView
{
    AppDelegate       *appDelegate;
    long              receiveByteSize;  //返回数据的长度
    int               countPKSSize;     //计算收到数据包的次数
    NSMutableString   *receiveSBString;  //接收到的数据
    Boolean           *isReceive;       //是否继续接收发过来的数据
    NSInteger         SBLength;            //控制显示字符的长度
    BOOL              IsAscii ;          //默认为Ascii显示
}
@property(nonatomic, strong)UITextView           *receiveDataTxt;
@property(nonatomic, strong)UILabel              *bytesSizeLabel,*PKSSizeLabel;

-(void)initReceviceNotification;
-(void)clearText;
-(void)receiveEnable:(Boolean)boo; //是否接收返回的数据
-(void)stopeReceive;
-(void)setIsAscii:(BOOL)boo;

//对receiveDataTxt的frame进行调整
-(void)setMessageHeightCut:(int)y;
@end
