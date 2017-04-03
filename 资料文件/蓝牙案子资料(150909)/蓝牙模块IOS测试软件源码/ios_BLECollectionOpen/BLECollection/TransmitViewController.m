//
//  TransmitViewController.m
//  BLECollection
//
//  Created by rfstar on 14-1-13. //  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import "TransmitViewController.h"
#import "DialogView.h"

@interface TransmitViewController ()
{
    DialogView         *dialogView;
    NSMutableArray     *pickerArray; //发送数据的间隔
    float              intervalTimer;
}
@end

@implementation TransmitViewController

-(id)initWithNib
{
    Encode = Encode_ASCII;
    intervalTimer = 0.01;  //初始为0.5秒
    return [super initWithNib];
}
- (void)viewDidLoad
{
    [super viewDidLoad]; 
    _receiveView  = [[ReceiveView alloc]initWithFrame:self.view.frame];
    [_receiveView setMessageHeightCut:100];
    
    _sendView = [[SendDataView alloc]initWithFrame:CGRectMake(0, _receiveView.frame.size.height-20,self.view.frame.size.width, self.view.frame.size.height)];
    [_sendView setDelegate:self];
    
    [self.view addSubview:_receiveView];
    [self.view addSubview:_sendView];
    UIView  *tmpView = [self controlView:CGRectMake(0, _sendView.frame.origin.y+_sendView.frame.size.height , 320, 100)];
    [self.view addSubview: tmpView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [_switchReceive setOn:NO];
    [_receiveView initReceviceNotification];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [_receiveView stopeReceive];
    [loopSendDataTimer invalidate]; //关闭时器
    loopSendDataTimer = nil;
}

-(UIView *)controlView:(CGRect)frame
{
    UIFont  *font = [UIFont systemFontOfSize:14] ;
    UIView  *controlView = [[UIView alloc]initWithFrame:frame];
    [controlView setBackgroundColor:[UIColor clearColor]];
    
    NSArray *array = [[NSArray alloc]initWithObjects:@"ASCII",@"HEX", nil];
    _segmentedView = [[UISegmentedControl alloc]initWithItems:array];
    [_segmentedView setFrame:CGRectMake(10, 5, 143, 25)];
    [_segmentedView setSegmentedControlStyle:UISegmentedControlStyleBar];
    [_segmentedView setSelectedSegmentIndex:0];
    [_segmentedView addTarget:self action:@selector(segmentedControl:) forControlEvents:UIControlEventValueChanged];
    
    UILabel *intervalLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 5, 70, 25)];
    [intervalLabel setFont:font];
    [intervalLabel setBackgroundColor:[UIColor clearColor]];
    [intervalLabel setText:@"发送间隔："];
    _intervalBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [_intervalBtn setFrame:CGRectMake(intervalLabel.frame.origin.x+intervalLabel.frame.size.width, intervalLabel.frame.origin.y, 78, 25)];
    [_intervalBtn setTitle:@"0.5s" forState:UIControlStateNormal];
    [_intervalBtn addTarget:self action:@selector(dialogClick:) forControlEvents:UIControlEventTouchUpInside];
    [_intervalBtn setTitleColor:[Tools colorWithHexString:@"#404040"] forState:UIControlStateNormal];
    [_intervalBtn setTitleColor:[Tools colorWithHexString:@"#7D9EC0"] forState:UIControlStateHighlighted];
    [_intervalBtn setTitleColor:[Tools colorWithHexString:@"#B5B5B5"] forState:UIControlStateDisabled];
    [_intervalBtn.layer setBorderColor:[Tools colorWithHexString:@"#7D9EC0"].CGColor];
    [_intervalBtn.layer setBorderWidth:1];
    [_intervalBtn.layer setCornerRadius:5];
    
    UILabel *autoLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, intervalLabel.frame.origin.y+intervalLabel.frame.size.height+5, 70, 25)];
    [autoLabel setFont:font];
    [autoLabel setBackgroundColor:[UIColor clearColor]];
    [autoLabel setText:@"自动发送："];
    _switchAutoSend = [[UISwitch alloc]initWithFrame:CGRectMake(autoLabel.frame.size.width+autoLabel.frame.origin.x, autoLabel.frame.origin.y, 60, 40)];
    [_switchAutoSend addTarget:self action:@selector(loopSendData:) forControlEvents:UIControlEventValueChanged];
    
    UILabel *receiveLabel =[[UILabel alloc]initWithFrame:CGRectMake(160, autoLabel.frame.origin.y, 70, 25)];
    [receiveLabel setText:@"接收数据："];
    [receiveLabel setFont:font];
    [receiveLabel setBackgroundColor:[UIColor clearColor]];
    _switchReceive = [[UISwitch alloc]initWithFrame:CGRectMake(receiveLabel.frame.size.width +receiveLabel.frame.origin.x, autoLabel.frame.origin.y, 60, 40)];
    
    _resetBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_resetBtn setFrame:CGRectMake(10, autoLabel.frame.origin.y+autoLabel.frame.size.height+5, 90, 30)];
    [_resetBtn  setTitle:@"重置" forState:UIControlStateNormal];
    _clearBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_clearBtn setFrame: CGRectMake(116, _resetBtn.frame.origin.y, 90, 30)];
    [_clearBtn setTitle:@"清除" forState:UIControlStateNormal];
    _sendBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_sendBtn setFrame: CGRectMake(222, _resetBtn.frame.origin.y, 90, 30)];
    [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
   
    [_switchReceive setOn:NO];
    [_switchReceive addTarget:self action:@selector(receiveData:) forControlEvents:UIControlEventValueChanged];
    [_resetBtn addTarget:self action:@selector(resetText:) forControlEvents:UIControlEventTouchUpInside];
    [_clearBtn addTarget:self action:@selector(clearText:) forControlEvents:UIControlEventTouchUpInside];
    [_sendBtn addTarget:self action:@selector(sendData:) forControlEvents:UIControlEventTouchUpInside];
    
    [controlView addSubview:_segmentedView];
    [controlView addSubview:intervalLabel];
    [controlView addSubview:_intervalBtn];
    [controlView addSubview:autoLabel];
    [controlView addSubview:_switchAutoSend];
    [controlView addSubview:receiveLabel];
    [controlView addSubview:_switchReceive];
    [controlView addSubview:_resetBtn];
    [controlView addSubview:_clearBtn];
    [controlView addSubview:_sendBtn];
    return controlView;
}

-(IBAction)sendData:(id)sender
{
    [_sendView sendData];
}
-(IBAction)clearText:(id)sender
{
    [_sendView clearText];
    [_receiveView clearText];
    [_switchAutoSend setOn:NO animated:YES];
}
-(IBAction)resetText:(id)sender
{
    [_sendView resetText];
}
-(IBAction)receiveData:(id)sender //打开接收数据的通道
{
    UISwitch *tmpSwitch = (UISwitch *)sender;
    [_receiveView receiveEnable:tmpSwitch.on];
}
-(IBAction)loopSendData:(id)sender //开启循环发送数据事件
{
    UISwitch       *tmpSwitch = (UISwitch *)sender;
    if(tmpSwitch.on)
    {
        [loopSendDataTimer invalidate];
        loopSendDataTimer = [NSTimer scheduledTimerWithTimeInterval:intervalTimer
                                                             target:self
                                                           selector:@selector(sendData:)
                                                           userInfo:nil repeats:YES];

    } else {
        [loopSendDataTimer invalidate]; //关闭时器
        loopSendDataTimer = nil;
    }
    [_intervalBtn setEnabled:!tmpSwitch.on];
    [_sendBtn setEnabled:!tmpSwitch.on];
}
#pragma mark- SendDataView
-(BOOL)sendDataTextViewShouldBeginEditing:(UITextView *)textView
{

    if (Encode == Encode_ASCII) {
        [UIView animateWithDuration:0.3f animations:^{
            CGRect curFrame=self.view.frame;
            self.view.frame=CGRectMake(curFrame.origin.x, curFrame.origin.y-215, curFrame.size.width, curFrame.size.height);
        }];
    }else if (Encode == Encode_HEX){
        NSArray *tmpViews = [self.view.window subviews];
        NSLog(@"tmp views   count : %d", (int)tmpViews.count);
        HexKeyboardView       *hexKeyboaryView = [[HexKeyboardView alloc]initNib];
        [hexKeyboaryView setDelegate:self];
        [hexKeyboaryView showView:self.view];
        return NO;
    }
    return YES;
}
-(BOOL)sendDataTextViewShouldEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3f animations:^{
        CGRect curFrame=self.view.frame;
        self.view.frame=CGRectMake(curFrame.origin.x, curFrame.origin.y+215, curFrame.size.width, curFrame.size.height);
    }];
    return YES;
}

#pragma mark- DialogView
-(IBAction)dialogClick:(id)sender
{
    if (dialogView == nil) {
        dialogView = [[DialogView alloc]initNib];
        [dialogView setDelegate:self];
        [dialogView showDialogView:self.view];
    }
}
-(UIView *)dialogContentView
{
    CGRect    frame;
    if([Tools currentResolution] == UIDevice_iPhone4s)
    {
        frame = CGRectMake(0, 264, 320, 216);
    }else if([Tools currentResolution ] == UIDevice_iPhone5){
        frame = CGRectMake(0, 352, 320, 216);
    }
    UIView  *contentView = [[UIView alloc]initWithFrame:frame];
    UIPickerView  *picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, 320, 216)];
    [picker setBackgroundColor:[Tools colorWithHexString:@"#EBEBEB"]];
    [picker setDelegate:self];
    [picker setDataSource:self];
    [contentView addSubview:picker];
    pickerArray = [NSMutableArray new];
    float interval = 0.5;
    for (int index =0; index <15; index++) {
        [pickerArray addObject:[NSNumber numberWithFloat:interval]];
        if(interval<1)
            interval += 0.1;
        else
            interval += 1;
    }
    return contentView;
}
-(void)dialogShow  //显示时向上滑动
{
    [UIView animateWithDuration:0.3f animations:^{
        CGRect curFrame=self.view.frame;
        self.view.frame=CGRectMake(curFrame.origin.x, curFrame.origin.y-216, curFrame.size.width, curFrame.size.height);
    }];
}
-(void)dialogDimissed
{
    dialogView = nil;
    [UIView animateWithDuration:0.3f animations:^{
        CGRect curFrame=self.view.frame;
        self.view.frame=CGRectMake(curFrame.origin.x, curFrame.origin.y+216, curFrame.size.width, curFrame.size.height);
    }];
}

#pragma mark- UIPickerView
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%.1fs",[[pickerArray objectAtIndex:row]floatValue]];
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [pickerArray count];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *retval = (id)view;
    if (!retval) {
        retval= [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 0.0f, [pickerView rowSizeForComponent:component].width-12, [pickerView rowSizeForComponent:component].height)] ;
    }
    [retval setBackgroundColor:[UIColor clearColor]];
    retval.textAlignment =  NSTextAlignmentCenter;
    [retval setText:[NSString stringWithFormat:@"%.1fs",[pickerArray[row] floatValue]]];
    return retval;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    intervalTimer = [pickerArray[row] floatValue];
    [_intervalBtn setTitle:[NSString stringWithFormat:@"%.1fs",[pickerArray[row] floatValue]] forState:UIControlStateNormal];
}

#pragma mark-   UISegmentedControl
-(void)segmentedControl:(UISegmentedControl *)sender
{
    if(sender.selectedSegmentIndex == 0)
    {
        Encode = Encode_ASCII;
        [_receiveView setIsAscii:YES];
        [_sendView setIsAscii:YES];
        [_sendView.messageTxt setText:[Tools stringFromHexString:_sendView.messageTxt.text]];
    }else{
        Encode = Encode_HEX;
        [_receiveView setIsAscii:NO];
        [_sendView setIsAscii:NO];
        [_sendView.messageTxt setText:[Tools stringToHex:_sendView.messageTxt.text]];
    }
    [_receiveView.receiveDataTxt setText:@""];
}
#pragma keyboardView
-(void)keyboardShowOrHide:(Boolean)boo   //判断键盘是否显示
{
    [_segmentedView setEnabled:!boo];
    [_intervalBtn setEnabled:!boo];
}
#pragma mark-  HexKeyboardView
-(void)hexKeybordViewPressedValue:(NSString *)value
{
    NSMutableString  *tmpstr = [[NSMutableString alloc]initWithString:_sendView.messageTxt.text];
    [tmpstr appendString:value];
    [_sendView.messageTxt setText:[Tools stringAppendSpace:tmpstr]];
}
-(void)hexKeybordViewShow
{
    [_sendView.messageTxt setText:[Tools stringAppendSpace:_sendView.messageTxt.text]];
    [UIView animateWithDuration:0.3f animations:^{
        CGRect curFrame=self.view.frame;
        self.view.frame=CGRectMake(curFrame.origin.x, curFrame.origin.y-216, curFrame.size.width, curFrame.size.height);
    }];
}
-(void)hexKeybordViewDimissed
{
    if(![_sendView.messageTxt.text isEqualToString:@""])
    [_sendView.messageTxt setText:[Tools stringAppendZero:_sendView.messageTxt.text]];
    [UIView animateWithDuration:0.3f animations:^{
        CGRect curFrame=self.view.frame;
        self.view.frame=CGRectMake(curFrame.origin.x, curFrame.origin.y+216, curFrame.size.width, curFrame.size.height);
    }];
}
-(void)hexKeybordViewPressedValueOfClr
{
    [_sendView.messageTxt setText:@""];
}
-(void)hexKeybordViewPressedValueOfDel
{
    [_sendView.messageTxt setText:[Tools stringRemoveLast:_sendView.messageTxt.text]];
}
-(void)hexKeybordViewPressedValueOfEnter
{
    
}
@end
