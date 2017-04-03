//
//  SendDataView.m
//  BLECollection
//
//  Created by rfstar on 14-1-3.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import "SendDataView.h"

@implementation SendDataView
{
    UIFont *labelfont;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        appDelegate = [[UIApplication sharedApplication]delegate];
        [self initView];
        IsAscii = YES;
    }
    return self;
}
-(void)initView{
    
    labelfont = [UIFont fontWithName:@"Courier" size:15];
    
    _lengthLabel = [[UILabel alloc]initWithFrame:CGRectMake(17,15 , 60, 19)];
    [_lengthLabel setText:@"长度："];
    [_lengthLabel setBackgroundColor:[UIColor clearColor]];
    [_lengthLabel setFont:labelfont];
    _lengthTxt = [[UILabel alloc]initWithFrame:CGRectMake(_lengthLabel.frame.origin.x+_lengthLabel.frame.size.width,_lengthLabel.frame.origin.y, 83, _lengthLabel.frame.size.height)];
    [_lengthTxt setText:@"0"];
    [_lengthTxt setBackgroundColor:[UIColor clearColor]];
    [_lengthTxt setFont:labelfont];
    
     _byteLabel = [[UILabel alloc]initWithFrame:CGRectMake(_lengthTxt.frame.size.width+_lengthTxt.frame.origin.x,_lengthLabel.frame.origin.y, 60, _lengthLabel.frame.size.height)];
    [_byteLabel setBackgroundColor:[UIColor clearColor]];
    [_byteLabel setText:@"发送："];
    [_byteLabel setFont:labelfont];
    _sendBytesSizeTxt = [[UILabel alloc]initWithFrame:CGRectMake(_byteLabel.frame.size.width+_byteLabel.frame.origin.x,_lengthLabel.frame.origin.y, 83, _lengthLabel.frame.size.height)];
    [_sendBytesSizeTxt setBackgroundColor:[UIColor clearColor]];
    [_sendBytesSizeTxt setText:@"0"];
    [_sendBytesSizeTxt setFont:labelfont];
    
    _messageTxt = [[UITextView alloc]initWithFrame:CGRectMake(10,_byteLabel.frame.origin.y +_byteLabel.frame.size.height, 300, 90)];
     UIFont *font = [UIFont fontWithName:@"Courier-Bold" size:18];
    [_messageTxt setFont:font];
    [_messageTxt setDelegate:self];
    [_messageTxt setReturnKeyType:UIReturnKeyDone];
    [_messageTxt setText:@"Hello"];
    _messageTxt.layer.cornerRadius = 7;
    _messageTxt.layer.borderWidth = 1;
    _messageTxt.layer.borderColor = [Tools colorWithHexString:@"#7D9EC0"].CGColor;

    [_lengthTxt setText:[NSString stringWithFormat:@"%d",(int)[_messageTxt.text length]]];
    [self addSubview:_byteLabel];
    [self addSubview:_lengthLabel];
    [self addSubview:_lengthTxt];
    [self addSubview:_sendBytesSizeTxt];
    [self addSubview:_messageTxt];
    
    [self setFrame:CGRectMake(0, self.frame.origin.y, self.frame.size.width,_messageTxt.frame.origin.y+_messageTxt.frame.size.height)];
}
-(void)textViewBecomeFirstResponder
{
    [self.messageTxt becomeFirstResponder];
}
#pragma mark- UITextView
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
        NSString *length = [NSString stringWithFormat:@"%d",(int)textView.text.length];
        [_lengthTxt setText:length];
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if(_delegate != nil)
        return  [_delegate sendDataTextViewShouldBeginEditing:textView];
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if(_delegate != nil)
        return  [_delegate sendDataTextViewShouldEndEditing:textView];
    return YES;
}
#pragma mark- button click
-(void)clearText
{
    sendByteSize = 0;
    [_lengthTxt setText:@"0"];
    [_sendBytesSizeTxt setText:@"0"];
    [_messageTxt setText:@""];
}
-(void)resetText
{
    if(IsAscii)
    {
        [_messageTxt setText:@"Hello"];
    }else{
        [_messageTxt setText:[Tools stringToHex:@"Hello"]];
    }
    [self textViewDidChange:_messageTxt];
}
-(void)sendData
{
    NSString  *message =nil;
    if (IsAscii) {
        message = _messageTxt.text;
    }else{ //将显示十六进制的字符串，转化为ascii码发送
        message = [Tools stringFromHexString:_messageTxt.text];
    }

    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSASCIIStringEncoding],"%s",&messageByte[index]);
        }
          NSLog(@" message tmpString  : %@  end",tmpString);
    }
    NSLog(@" message   : %@  end",message);
    char lengthChar = 0 ;
    int  p = 0 ;
    while (length>0) {   //蓝牙数据通道 可写入的数据为20个字节
        if (length>20) {
            lengthChar = 20 ;
        }else if (length>0){
            lengthChar = length;
        }else
            return;
        NSData *data = [[NSData alloc]initWithBytes:&messageByte[p] length:lengthChar];
        NSLog(@" data %@",data);
        
        [appDelegate.bleManager writeValue:0xFFE5
                        characteristicUUID:0xFFE9
                                         p:appDelegate.bleManager.activePeripheral
                                      data:data];
        length -= lengthChar ;
        p += lengthChar;
        sendByteSize += lengthChar;
        NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
        _sendBytesSizeTxt.text = cs;
    }
}

-(void)setIsAscii:(BOOL)boo //为假时显示 hex
{
    IsAscii = boo;

//    [self clearText];
}
@end
