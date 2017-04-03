//
//  ReceiveView.m
//  BLECollection
//
//  Created by rfstar on 14-1-8.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import "ReceiveView.h"
#import "Tools.h"
#import <QuartzCore/QuartzCore.h>

@implementation ReceiveView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initView];
        IsAscii = YES  ;   //为ascii显示
        receiveByteSize = 0 ;
        isReceive = NO;
        receiveSBString = [NSMutableString new];
    }
    return self;
}
//想获取消息传递过来的数据 ，得先注册消息
-(void)initReceviceNotification
{

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver: self
           selector: @selector(ValueChangText:)
               name: @"VALUECHANGUPDATE"
             object: nil];

}
-(void)initView
{
    UIFont  *labelFont =  [UIFont fontWithName:@"Courier" size:15];
    appDelegate = [[UIApplication sharedApplication]delegate];
    UILabel *receiveDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(17,10 , 60, 19)];
    [receiveDataLabel setText:@"长度："];
    [receiveDataLabel setBackgroundColor:[UIColor clearColor]];
    [receiveDataLabel setFont:labelFont];
    _bytesSizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(receiveDataLabel.frame.origin.x+receiveDataLabel.frame.size.width,receiveDataLabel.frame.origin.y , 83, receiveDataLabel.frame.size.height)];
    [_bytesSizeLabel setText:@"0"];
    [_bytesSizeLabel setBackgroundColor:[UIColor clearColor]];
    [_bytesSizeLabel setFont:labelFont];
    
    UILabel *PKSLabel = [[UILabel alloc]initWithFrame:CGRectMake(_bytesSizeLabel.frame.origin.x+_bytesSizeLabel.frame.size.width,receiveDataLabel.frame.origin.y, 50, receiveDataLabel.frame.size.height)];
    [PKSLabel setText:@"PKS："];
    [PKSLabel setBackgroundColor:[UIColor clearColor]];
    [PKSLabel setFont:labelFont];
    _PKSSizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(PKSLabel.frame.origin.x+PKSLabel.frame.size.width,receiveDataLabel.frame.origin.y , 93, receiveDataLabel.frame.size.height)];
    [_PKSSizeLabel setText:@"0"];
    [_PKSSizeLabel setBackgroundColor:[UIColor clearColor]];
    [_PKSSizeLabel setFont:labelFont];
    
    float  height = 285;
        SBLength  =  300;  //最多显示300个
    if([Tools currentResolution] == UIDevice_iPhone5)
    {
        height = 370;
        SBLength = 370;
    }
    _receiveDataTxt = [[UITextView alloc]initWithFrame:CGRectMake(10,receiveDataLabel.frame.origin.y +receiveDataLabel.frame.size.height, 300, height)];
    [_receiveDataTxt setEditable:NO];
    UIFont *font = [UIFont fontWithName:@"Courier-Bold" size:18];

//    NSLog(@" font array %@", [UIFont familyNames]);
    [_receiveDataTxt setFont:font];
    [_receiveDataTxt setReturnKeyType:UIReturnKeyDone];
    
    [self addSubview:receiveDataLabel];
    [self addSubview:_bytesSizeLabel];
    [self addSubview:PKSLabel];
    [self addSubview:_PKSSizeLabel];
    [self addSubview:_receiveDataTxt];
    
    self.receiveDataTxt.layer.cornerRadius = 10;
    self.receiveDataTxt.layer.borderWidth = 1;
    self.receiveDataTxt.layer.borderColor = [Tools colorWithHexString:@"#7D9EC0"].CGColor;
    [self setFrame:CGRectMake(0, 0, self.frame.size.width,_receiveDataTxt.frame.origin.y+_receiveDataTxt.frame.size.height)];

}
//调整receiveDataTxt的高
-(void)setMessageHeightCut:(int)y
{
    [_receiveDataTxt  setFrame:CGRectMake(_receiveDataTxt.frame.origin.x, _receiveDataTxt.frame.origin.y, _receiveDataTxt.frame.size.width, _receiveDataTxt.frame.size.height-y)];
    [self setFrame:CGRectMake(0,-7.5, self.frame.size.width,_receiveDataTxt.frame.origin.y+_receiveDataTxt.frame.size.height)];
    
     SBLength = 185;
}
-(void)clearText
{
    receiveByteSize = 0;
    countPKSSize = 0;
    [_receiveDataTxt setText:@""];
    [_bytesSizeLabel setText:@"0"];
    [_PKSSizeLabel setText:@"0"];
    receiveSBString = nil;
    receiveSBString = [NSMutableString new];
}
-(void)stopeReceive
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"VALUECHANGUPDATE" object:nil];
}
-(void)receiveEnable:(Boolean)boo  //是否接收数据
{
    isReceive = &boo;
    if(boo){
        [appDelegate.bleManager notification:0xFFE0 characteristicUUID:0xFFE4 p:appDelegate.bleManager.activePeripheral on:YES];
        [_receiveDataTxt setUserInteractionEnabled:NO];
        [_receiveDataTxt setBackgroundColor:[Tools colorWithHexString:@"#C1C1C1"]];
        
    }else{
        
        [appDelegate.bleManager notification:0xFFE0 characteristicUUID:0xFFE4 p:appDelegate.bleManager.activePeripheral on:NO];
        [_receiveDataTxt setUserInteractionEnabled:YES];
        [_receiveDataTxt setBackgroundColor:[UIColor whiteColor]];
        [self performSelector:@selector(setText:) withObject:nil afterDelay:0.02]; //20ms后执行
    }
}
-(void)setText:(id) objectect //赋值
{
    [_receiveDataTxt setText:receiveSBString];
    [self performSelector:@selector(scrollBottom:) withObject:nil afterDelay:0.05]; //200ms后执行
}
-(void)scrollBottom:(id)object  //滚动到底部
{
    float  y = _receiveDataTxt.contentSize.height-_receiveDataTxt.bounds.size.height;
    
    if(y>0)
    {
        CGPoint position =CGPointMake(0,y);
        [_receiveDataTxt setContentOffset:position animated:NO];
    }
    NSLog(@"  _receiveDataTxt  width %f  _receiveDataTxt height %f  y %f" ,_receiveDataTxt.contentSize.height,_receiveDataTxt.bounds.size.height,y);
}
//更新数据
-(void)ValueChangText:(NSNotification *)notification
{
    if(isReceive)  //为真时，才接收数据
    {
        //这里取出刚刚从过来的字符串
        CBCharacteristic *tmpCharacter = (CBCharacteristic*)[notification object];
        CHAR_STRUCT buf1;
        //将获取的值传递到buf1中；
        [tmpCharacter.value getBytes:&buf1 length:tmpCharacter.value.length];
        receiveByteSize += tmpCharacter.value.length;  //计算收到的所有数据包的长度
        countPKSSize++;
        if(IsAscii) //Ascii
        {
            for(int i =0;i<tmpCharacter.value.length;i++)
            {
                [receiveSBString appendString:[Tools stringFromHexString:[NSString stringWithFormat:@"%02X",buf1.buff[i]&0x000000ff]]];
            }
        }else {//十六进制显示
            for(int i =0;i<tmpCharacter.value.length;i++)
            {
                [receiveSBString appendString:[NSString stringWithFormat:@"%02X",buf1.buff[i]&0x000000ff]];
            }        }
        
        if(receiveSBString.length<=SBLength)  //处理返回的数据，让界面上显示最新的数据，为receiveSBString的后300个
        {
            [_receiveDataTxt setText:receiveSBString];
        }else{
            NSInteger index = receiveSBString.length - SBLength;
            NSLog(@" 截取数据 的长度 %d" ,(int)index);
            NSString *tmpStr = [receiveSBString substringFromIndex:index];
            [_receiveDataTxt setText:tmpStr];
        }
        _bytesSizeLabel.text =  [NSString stringWithFormat:@"%ld",receiveByteSize];
        _PKSSizeLabel.text = [NSString stringWithFormat:@"%d",countPKSSize];
    }
}
-(void)setIsAscii:(BOOL)boo //为假时显示 hex 
{
    IsAscii = boo;
    [self clearText];
}
@end
