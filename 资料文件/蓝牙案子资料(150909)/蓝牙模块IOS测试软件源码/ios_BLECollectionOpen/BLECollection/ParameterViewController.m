//
//  ParameterViewController.m
//  BLECollection
//
//  Created by Kevin on 14-4-22.
//  E-mail: wh19575782@163.com
//  Copyright (c) 2014年 rfstar. All rights reserved.
//
//   系统功能使能开关没做，因为模块没有保存手机端写入的数据

#import "ParameterViewController.h"
#import "DialogListView.h"

#define FIRST_HEIGHT  90
#define SECOND_HEIGHT 60
#define THIRD_HEIGHT 60
#define FOURTH_HEIGHT  145
#define FIFTH_HEIGHT 60
#define SIXTH_HEIGHT  90
#define SEVENTH_HEIGHT 60
#define EIGHTTH_HEIGHT  132
#define NINETH_HEIGHT  255
#define CELL_BORDER_COLOR    @"#898989"

#define FIRST_TXT_TAG                    101
#define FIRST_EDIT_TAG                   102
#define FIRST_REFRESH_BTN_TAG            103
#define FIRST_SET_BTN_TAG                104
#define SECOND_REFRESH_BTN_TAG           105
#define SECOND_TXT_TAG                   106
#define THIRD_TXT_TAG                    107
#define THIRD_REFRESH_BTN_TAG            108
#define FIFTH_REFRESH_BTN_TAG            110
#define FIFTH_REFRESH_TXT_TAG            1010
#define SIXTH_SET_BTN_TAG                111
#define SIXTH_REFRESH_BTN_TAG            1111
#define SIXTH_REFRESH_TXT_TAG            1110
#define SIXTH_SET_EDIT_TAG               1112
#define SEVENTH_REFRESH_BTN_TAG          112
#define SEVENTH_REFRESH_TXT_TAG          1120
#define EIGHTTH_REFRESH_BTN_TAG          113
#define EIGHTTH_REFRESH_TXT_TAG          1130
#define EIGHTTH_SET_EDIT_TAG             1131
#define EIGHTTH_SET_BTN_TAG              114

#define FF91                             0xFF91
#define FF92                             0xFF92
#define FF93                             0xFF93
#define FF94                             0xFF94
#define FF95                             0xFF95
#define FF96                             0xFF96
#define FF97                             0xFF97
#define FF98                             0xFF98
#define FF99                             0xFF99
#define FF9A                             0xFF9A

@interface ParameterViewController ()
{
    UIFont *font;
    DialogListView *dialogListView;
    
    NSMutableArray *array;
}
@end

@implementation ParameterViewController

- (id)initWithNib
{
    id tmp = [super initWithNib];
    if (self) {
        // Custom initialization
        [self setTitle:@"参数设置"];
        appDelegate = [[UIApplication sharedApplication]delegate];
    }
    return tmp;
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
-(void)stopeReceive
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"VALUECHANGUPDATE" object:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    font = [UIFont systemFontOfSize:15];
    
      CGRect tmpFrame  = CGRectMake(0,0, self.view.frame.size.width,self.view.frame.size.height-72);
    _listView = [[UITableView alloc]initWithFrame:tmpFrame style:UITableViewStylePlain];
    [_listView setBackgroundColor :[UIColor clearColor]];
    [_listView setDelegate:self];
    [_listView setDataSource:self];
    [_listView setSeparatorColor:[UIColor clearColor]];
    [self.view addSubview:_listView];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self initReceviceNotification];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [self stopeReceive];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 9;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    ModuleParatemCellTableViewCell *cell;
    if(indexPath.row == 0){
        NSString *identifier=@"TableCellIdentifier0";
         cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil)
        {
            cell = [[ModuleParatemCellTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] ;
            [cell addSubview: [self firstView]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
    }else if(indexPath.row == 1){
        NSString *identifier=@"TableCellIdentifier2";
        cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil)
        {
            cell = [[ModuleParatemCellTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] ;
        [cell addSubview: [self secondView]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        }
    }else if(indexPath.row == 2){
        NSString *identifier=@"TableCellIdentifier3";
        cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil)
        {
            cell = [[ModuleParatemCellTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] ;
        [cell addSubview: [self thirdView]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        }
    }else if(indexPath.row == 3){
        NSString *identifier=@"TableCellIdentifier4";
        cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil)
        {
            cell = [[ModuleParatemCellTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] ;
        [cell addSubview: [self fourthView]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        }
    }else if(indexPath.row == 4){
        NSString *identifier=@"TableCellIdentifier5";
        cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil)
        {
            cell = [[ModuleParatemCellTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] ;
        [cell addSubview: [self FifthView]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        }
    }else if(indexPath.row == 5){
        NSString *identifier=@"TableCellIdentifier6";
        cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil)
        {
            cell = [[ModuleParatemCellTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] ;
        [cell addSubview: [self SixthView]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
    }else if(indexPath.row == 6){
        NSString *identifier=@"TableCellIdentifier7";
        cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil)
        {
            cell = [[ModuleParatemCellTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] ;
        [cell addSubview: [self SeventhView]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        }
    }else if(indexPath.row == 7){
        NSString *identifier=@"TableCellIdentifier8";
        cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil)
        {
            cell = [[ModuleParatemCellTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] ;
        [cell addSubview: [self EightthView]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
    }else if(indexPath.row == 8){
        NSString *identifier=@"TableCellIdentifier9";
        cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil)
        {
            cell = [[ModuleParatemCellTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] ;
        [cell addSubview: [self NinethView]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        }
    }
    [cell setBackgroundColor :[Tools colorWithHexString:@"#E8E8E8"]];
    
    return  cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0 || indexPath.row == 5 || indexPath.row == 7)
    {
        
    }else{
        dialogListView = [[DialogListView alloc]initNib];
        [dialogListView setDelegage:self];
        [dialogListView showView:self.view];
        if(indexPath.row == 1){
            [self initFF92Array];
            [dialogListView setType:FF92];
            [[dialogListView title]setText:@"蓝牙通讯连接间隔"];
        }else if(indexPath.row == 2){
            [self initFF93Array];
            [dialogListView setType:FF93];
             [[dialogListView title]setText:@"设定串口波特率"];
        }else if (indexPath.row == 3) {
           [self initFF94Array];
            dialogListView.title.text = @"远程复位恢复控制通道";
            [dialogListView setType:FF94];
        }else if (indexPath.row == 4) {
            [self initFF95Array];
            dialogListView.title.text = @"设定广播周期";
            [dialogListView setType:FF95];
        }else if (indexPath.row == 6) {
            [self initFF97Array];
            dialogListView.title.text = @"设定发射功率";
            [dialogListView setType:FF97];
        }else if (indexPath.row == 8) {
            [self initFF99Array];
            dialogListView.title.text = @"远程控制扩展通道";
            [dialogListView setType:FF99];
        }
        [dialogListView setArray:array];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger position = indexPath.row;
    if (position == 0) {
        return FIRST_HEIGHT;
    }else if (position == 1){
        return SECOND_HEIGHT;
    }else if(position == 2){
        return  THIRD_HEIGHT;
    }else if(position == 3){
        return  FOURTH_HEIGHT;
    }else if(position == 4){
        return FIFTH_HEIGHT;
    }else if(position == 5){
        return SIXTH_HEIGHT;
    }else if (position == 6){
        return SEVENTH_HEIGHT;
    }else if(position == 7){
        return EIGHTTH_HEIGHT;
    }else if(position == 8){
        return NINETH_HEIGHT;
    }
    return  100;
}

#pragma mark- DialogListView
-(void)dialogListItemViewClick:(NSInteger)position Parameter:(Item *)item Type:(NSInteger)type
{
    NSLog(@" item  name : %@ %d type : %d",item.text,(int)item.numberID,(int)type);
    Byte  byte[1];
    byte[0] = (Byte)item.numberID;
    NSData *data = [[NSData alloc]initWithBytes:byte length:1];
    [appDelegate.bleManager writeValue:0xFF90 characteristicUUID:(int)type p:appDelegate.bleManager.activePeripheral data:data];
}
#pragma mark-   cellviews        begin
//第一个cellView
-(UIView *)firstView
{
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, FIRST_HEIGHT-10)];
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
    [name setText:@"设备名称:"];
    [name setFont:font];
    UILabel *nameTxt = [[UILabel alloc]initWithFrame:CGRectMake(110, 10, 120, 30)];
    nameTxt.text = @"";
    [nameTxt setFont:font];
    [nameTxt setTag:FIRST_TXT_TAG];
    UIButton *getBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [getBtn setFrame:CGRectMake(240, 10, 50, 28)];
    [getBtn setTitle:@"刷新" forState:UIControlStateNormal];
    [getBtn.layer setBorderWidth:1];
    [getBtn.layer setBorderColor:[getBtn titleColorForState:UIControlStateNormal].CGColor];
    [getBtn.titleLabel setFont:font];
    [getBtn.layer setCornerRadius:5];
    [getBtn setTag:FIRST_REFRESH_BTN_TAG];
    [getBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *setName = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 100, 30)];
    [setName setText:@"设置名称:"];
    UITextView *setNameTxt = [[UITextView alloc]initWithFrame:CGRectMake(110, 40, 120, 30)];
    [setNameTxt setFont:font];
    setNameTxt.text = @"";
    [setNameTxt setTag:FIRST_EDIT_TAG];
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [setBtn setTag:FIRST_SET_BTN_TAG];
    [setBtn setFrame:CGRectMake(240, 40, 50, 28)];
    [setBtn setTitle:@"设置" forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [setBtn.titleLabel setFont:font];
    [setBtn.layer setBorderWidth:1];
    [setBtn.layer setBorderColor:[setBtn titleColorForState:UIControlStateNormal].CGColor];
    [setBtn.layer setCornerRadius:5];
    
    [contentView addSubview:name];
    [contentView addSubview:nameTxt];
    [contentView addSubview:getBtn];
    [contentView addSubview:setName];
    [contentView addSubview:setNameTxt];
    [contentView addSubview:setBtn];
    
    contentView.layer.cornerRadius = 10;
    [contentView.layer setBorderColor:[Tools colorWithHexString:CELL_BORDER_COLOR].CGColor];
    [contentView.layer setBorderWidth:1];

    return contentView ;
}


//第二个cellView
-(UIView *)secondView
{
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, SECOND_HEIGHT-10)];
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
    [name setText:@"通讯连接间隔:"];
    [name setFont:font];
    UILabel *nameTxt = [[UILabel alloc]initWithFrame:CGRectMake(110, 10, 110, 30)];
    [nameTxt setTag:SECOND_TXT_TAG];
    nameTxt.text = @"";
    [nameTxt setFont:font];
        UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [setBtn setTag:SECOND_REFRESH_BTN_TAG];
    [setBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [setBtn setFrame:CGRectMake(220, 10, 50, 30)];
    [setBtn setTitle:@"刷新" forState:UIControlStateNormal];
    [setBtn.layer setBorderWidth:1];
    [setBtn.layer setBorderColor:[setBtn titleColorForState:UIControlStateNormal].CGColor];
    [setBtn.titleLabel setFont:font];
    [setBtn.layer setCornerRadius:5];
    
    [contentView addSubview:name];
    [contentView addSubview:nameTxt];
    [contentView addSubview:setBtn];
    
    contentView.layer.cornerRadius = 10;
    [contentView.layer setBorderColor:[Tools colorWithHexString:CELL_BORDER_COLOR].CGColor];
    [contentView.layer setBorderWidth:1];
    
    return contentView ;
}
//第三个cellView
-(UIView *)thirdView
{
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, SECOND_HEIGHT-10)];
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
    [name setText:@"串口波特率:"];
    [name setFont:font];
    UILabel *nameTxt = [[UILabel alloc]initWithFrame:CGRectMake(110, 10, 110, 30)];
    [nameTxt setTag:THIRD_TXT_TAG];
    nameTxt.text = @"";
    [nameTxt setFont:font];
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [setBtn setTag:THIRD_REFRESH_BTN_TAG];
    [setBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [setBtn setFrame:CGRectMake(220, 10, 50, 30)];
    [setBtn setTitle:@"刷新" forState:UIControlStateNormal];
    [setBtn.layer setBorderWidth:1];
    [setBtn.layer setBorderColor:[setBtn titleColorForState:UIControlStateNormal].CGColor];
    [setBtn.titleLabel setFont:font];
    [setBtn.layer setCornerRadius:5];
    
    [contentView addSubview:name];
    [contentView addSubview:nameTxt];
    [contentView addSubview:setBtn];
    
    contentView.layer.cornerRadius = 10;
    [contentView.layer setBorderColor:[Tools colorWithHexString:CELL_BORDER_COLOR].CGColor];
    [contentView.layer setBorderWidth:1];
    
    return contentView ;
}
//第四个cellView
-(UIView *)fourthView
{
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, FOURTH_HEIGHT-10)];
    UILabel *message = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 273, 90)];
    [message setText:@"　远程复位控制,写入 0x55 对模块进行复位\r\n　远程浅恢复控制,写入 0x35对模块进行浅恢复(仅仅恢复用户数据),并复位\r\n　远程深度恢复控制,写入 0x36 对模块进行深度恢复 (让模块所有参数回到出厂设置),并复位"];
    [message setFont:[UIFont systemFontOfSize:13]];
    [message setTextColor:[Tools colorWithHexString:@"#008B00"]];
    //自动折行设置
    message.lineBreakMode = UILineBreakModeWordWrap;
    message.numberOfLines = 0;
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(10, message.frame.origin.y+message.frame.size.height, 100, 30)];
    [name setText:@"远程复位控制"];
    [name setFont:font];

    [contentView addSubview:message];
    [contentView addSubview:name];
    
    contentView.layer.cornerRadius = 10;
    [contentView.layer setBorderColor:[Tools colorWithHexString:CELL_BORDER_COLOR].CGColor];
    [contentView.layer setBorderWidth:1];
    
    return contentView ;
}

//第五个cellView
-(UIView *)FifthView
{
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, SECOND_HEIGHT-10)];
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
    [name setText:@"设定广播周期:"];
    [name setFont:font];
    UILabel *nameTxt = [[UILabel alloc]initWithFrame:CGRectMake(110, 10, 110, 30)];
    [nameTxt setTag:FIFTH_REFRESH_TXT_TAG];
    nameTxt.text = @"";
    [nameTxt setFont:font];
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [setBtn setTag:FIFTH_REFRESH_BTN_TAG];
    [setBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [setBtn setFrame:CGRectMake(220, 10, 50, 30)];
    [setBtn setTitle:@"刷新" forState:UIControlStateNormal];
    [setBtn.layer setBorderWidth:1];
    [setBtn.layer setBorderColor:[setBtn titleColorForState:UIControlStateNormal].CGColor];
    [setBtn.titleLabel setFont:font];
    [setBtn.layer setCornerRadius:5];
    
    [contentView addSubview:name];
    [contentView addSubview:nameTxt];
    [contentView addSubview:setBtn];
    
    contentView.layer.cornerRadius = 10;
    [contentView.layer setBorderColor:[Tools colorWithHexString:CELL_BORDER_COLOR].CGColor];
    [contentView.layer setBorderWidth:1];
    
    return contentView ;
}
//第六个cellView
-(UIView *)SixthView
{
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, SIXTH_HEIGHT-10)];
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
    [name setText:@"产品识别码:"];
    [name setFont:font];
    UILabel *nameTxt = [[UILabel alloc]initWithFrame:CGRectMake(110, 10, 120, 30)];
    [nameTxt setTag:SIXTH_REFRESH_TXT_TAG];
    nameTxt.text = @"";
    [nameTxt setFont:font];
    UIButton *getBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [getBtn setFrame:CGRectMake(240, 10, 50, 28)];
    [getBtn setTitle:@"刷新" forState:UIControlStateNormal];
    [getBtn.layer setBorderWidth:1];
    [getBtn.layer setBorderColor:[getBtn titleColorForState:UIControlStateNormal].CGColor];
    [getBtn.titleLabel setFont:font];
    [getBtn.layer setCornerRadius:5];
    [getBtn setTag:SIXTH_REFRESH_BTN_TAG];
    [getBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    UILabel *setName = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 100, 30)];
    [setName setText:@"设置识别码:"];
    [setName setFont:font];
    UITextView *setNameTxt = [[UITextView alloc]initWithFrame:CGRectMake(110, 40, 120, 30)];
    [setNameTxt setKeyboardType:UIKeyboardTypeNumberPad];
    [setNameTxt setReturnKeyType:UIReturnKeyDone];
    [setNameTxt setFont:font];
    setNameTxt.text = @"";
    [setNameTxt setTag:SIXTH_SET_EDIT_TAG];
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [setBtn setTag:SIXTH_SET_BTN_TAG];
    [setBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [setBtn setFrame:CGRectMake(240, 40, 50, 30)];
    [setBtn setTitle:@"设置" forState:UIControlStateNormal];
    [setBtn.titleLabel setFont:font];
    [setBtn.layer setBorderWidth:1];
    [setBtn.layer setBorderColor:[setBtn titleColorForState:UIControlStateNormal].CGColor];
    [setBtn.layer setCornerRadius:5];
    
    [contentView addSubview:name];
    [contentView addSubview:nameTxt];
    [contentView addSubview:getBtn];
    [contentView addSubview:setName];
    [contentView addSubview:setNameTxt];
    [contentView addSubview:setBtn];
    
    contentView.layer.cornerRadius = 10;
    [contentView.layer setBorderColor:[Tools colorWithHexString:CELL_BORDER_COLOR].CGColor];
    [contentView.layer setBorderWidth:1];
    
    return contentView ;
}
//第七个cellView
-(UIView *)SeventhView
{
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, SECOND_HEIGHT-10)];
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
    [name setText:@"设定发射功率:"];
    [name setFont:font];
    UILabel *nameTxt = [[UILabel alloc]initWithFrame:CGRectMake(110, 10, 110, 30)];
    [nameTxt setTag:SEVENTH_REFRESH_TXT_TAG];
    nameTxt.text = @"";
    [nameTxt setFont:font];
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [setBtn setTag:SEVENTH_REFRESH_BTN_TAG];
    [setBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [setBtn setFrame:CGRectMake(220, 10, 50, 30)];
    [setBtn setTitle:@"刷新" forState:UIControlStateNormal];
    [setBtn.layer setBorderWidth:1];
    [setBtn.layer setBorderColor:[setBtn titleColorForState:UIControlStateNormal].CGColor];
    [setBtn.titleLabel setFont:font];
    [setBtn.layer setCornerRadius:5];
    
    [contentView addSubview:name];
    [contentView addSubview:nameTxt];
    [contentView addSubview:setBtn];
    
    contentView.layer.cornerRadius = 10;
    [contentView.layer setBorderColor:[Tools colorWithHexString:CELL_BORDER_COLOR].CGColor];
    [contentView.layer setBorderWidth:1];
    
    return contentView ;
}
//第八个cellView
-(UIView *)EightthView
{
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, EIGHTTH_HEIGHT-10)];
    UILabel *message = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 273, 47)];
    [message setText:@"　设定自定义广播数据 自定义广播数据,0 < n <= 16, 默认不保存,但可以通过向 FF99 写入 0x04 触发保存"];
    [message setFont:[UIFont systemFontOfSize:13]];
    [message setTextColor:[Tools colorWithHexString:@"#008B00"]];
    //自动折行设置
    message.lineBreakMode = UILineBreakModeWordWrap;
    message.numberOfLines = 0;
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(10, message.frame.origin.y+message.frame.size.height, 100, 30)];
    [name setText:@"广播内容:"];
    [name setFont:font];
    UILabel *nameTxt = [[UILabel alloc]initWithFrame:CGRectMake(110, message.frame.origin.y+message.frame.size.height, 120, 30)];
    [nameTxt setTag:EIGHTTH_REFRESH_TXT_TAG];
    nameTxt.text = @"";
    [nameTxt setFont:font];
    UIButton *getBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [getBtn setTag:EIGHTTH_REFRESH_BTN_TAG];
    [getBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [getBtn setFrame:CGRectMake(240, message.frame.origin.y+message.frame.size.height, 50, 28)];
    [getBtn setTitle:@"刷新" forState:UIControlStateNormal];
    [getBtn.layer setBorderWidth:1];
    [getBtn.layer setBorderColor:[getBtn titleColorForState:UIControlStateNormal].CGColor];
    [getBtn.titleLabel setFont:font];
    [getBtn.layer setCornerRadius:5];
    
    UILabel *setName = [[UILabel alloc]initWithFrame:CGRectMake(10, nameTxt.frame.origin.y+nameTxt.frame.size.height, 100, 30)];
    [setName setText:@"设定广播内容:"];
    [setName setFont:font];
    UITextView *setNameTxt = [[UITextView alloc]initWithFrame:CGRectMake(110, nameTxt.frame.origin.y+nameTxt.frame.size.height, 120, 30)];
    [setNameTxt setTag:EIGHTTH_SET_EDIT_TAG];
    [setNameTxt setFont:font];
    setNameTxt.text = @"";
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [setBtn setTag:EIGHTTH_SET_BTN_TAG];
    [setBtn setFrame:CGRectMake(240, nameTxt.frame.origin.y+nameTxt.frame.size.height, 50, 28)];
    [setBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [setBtn setTitle:@"设置" forState:UIControlStateNormal];
    [setBtn.titleLabel setFont:font];
    [setBtn.layer setBorderWidth:1];
    [setBtn.layer setBorderColor:[setBtn titleColorForState:UIControlStateNormal].CGColor];
    [setBtn.layer setCornerRadius:5];
    
    [contentView addSubview:message];
    [contentView addSubview:name];
    [contentView addSubview:nameTxt];
    [contentView addSubview:setName];
    [contentView addSubview:setNameTxt];
    [contentView addSubview:getBtn];
    [contentView addSubview:setBtn];
    
    contentView.layer.cornerRadius = 10;
    [contentView.layer setBorderColor:[Tools colorWithHexString:CELL_BORDER_COLOR].CGColor];
    [contentView.layer setBorderWidth:1];
    
    return contentView ;
}
//第九个cellView
-(UIView *)NinethView
{
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, NINETH_HEIGHT-10)];
    UILabel *message = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 270, 210)];
    [message setText:@"　　0x01:IO配置输出保存触发控制,写入 0x01 可触发保存 当前的 IO 配置以及输出状态,重新上电之后都会使用 当前 IO 配置以及输出状态 初始化 IO7~IO1,IO0 上电后 总默认为输入,做为恢复出 厂设置检测口;\n　　0x02:远程关机控制,当在 脉冲使能模式下,向此通道 写入 0x02,可对模块进行远 程关机\r\n　　0x03:远程蓝牙断线请求, 当在蓝牙已连接情况下,向此通道写入 0x03,可请求模块主动断开蓝牙。\n　　0x04:自定义广播数据保存触发控制,写入 0x04 可触发 保存当前自定义广播内容, 重新上电之后都会按照当前 广播内容广播。"
     ];
    [message setFont:[UIFont systemFontOfSize:13]];
    [message setTextColor:[Tools colorWithHexString:@"#008B00"]];
    //自动折行设置
    message.lineBreakMode = UILineBreakModeWordWrap;
    message.numberOfLines = 0;
    
    UILabel *setName = [[UILabel alloc]initWithFrame:CGRectMake(10, message.frame.origin.y+message.frame.size.height, 100, 30)];
    [setName setText:@"远程控制扩展"];
    [setName setFont:font];
    
    [contentView addSubview:message];
    [contentView addSubview:setName];
    
    contentView.layer.cornerRadius = 10;
    [contentView.layer setBorderColor:[Tools colorWithHexString:CELL_BORDER_COLOR].CGColor];
    [contentView.layer setBorderWidth:1];
    
    return contentView ;
}
//第十个cellView
//-(UIView *)TenthView
//{
//    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, NINETH_HEIGHT-10)];
//    UILabel *message = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 270, 210)];
//    [message setText:@"　　BIT0:使能模式设置,默认为 0, 对应低电平电平使能,1 表示脉 冲使能,当 EN 脚每收到一个脉 冲,模块将会在开机(开始广播) 和关机(停止广播)之间轮流切 换。有效脉宽 T,必须满足 W > 200ms。当广播时间超过 30s,仍 未被连接,则会自动进入关机状 态。\n　　BIT1:蓝牙异常(超时,非主动 断开)断线复位使能设置,默认为 0,对应蓝牙超时断线后不重启 模块,1 表示当蓝牙超时断线后 自动重启模块。\n　　BIT2~BIT7:暂未使用"];
//    [message setFont:[UIFont systemFontOfSize:13]];
//    [message setTextColor:[Tools colorWithHexString:@"#008B00"]];
//    //自动折行设置
//    message.lineBreakMode = UILineBreakModeWordWrap;
//    message.numberOfLines = 0;
//    
//    UILabel *setName = [[UILabel alloc]initWithFrame:CGRectMake(10, message.frame.origin.y+message.frame.size.height, 100, 30)];
//    [setName setText:@"远程控制扩展"];
//    [setName setFont:font];
//    
//    [contentView addSubview:message];
//    [contentView addSubview:setName];
//    
//    contentView.layer.cornerRadius = 10;
//    [contentView.layer setBorderColor:[Tools colorWithHexString:CELL_BORDER_COLOR].CGColor];
//    [contentView.layer setBorderWidth:1];
//    
//    return contentView ;
//}
#pragma mark cellviews        end
#pragma mark-

#pragma mark- cellviews 中的事件  begin
-(IBAction)btnClick:(id)sender
{
    if([sender isKindOfClass:[UIButton class]])
    {
        UIButton  *button = (UIButton *)sender;
        UITextView *editView ;
        switch ([button tag]) {
            case FIRST_REFRESH_BTN_TAG:
                [appDelegate.bleManager readValue:0xFF90 characteristicUUID:0xFF91 p:appDelegate.bleManager.activePeripheral];
                break;
            case FIRST_SET_BTN_TAG:
                editView = (UITextView *)[self.listView viewWithTag:FIRST_EDIT_TAG];
                [editView resignFirstResponder];
                   [self writeFF91];
                break;
            case SECOND_REFRESH_BTN_TAG:
                    [appDelegate.bleManager readValue:0xFF90 characteristicUUID:0xFF92 p:appDelegate.bleManager.activePeripheral];
                break;
            case THIRD_REFRESH_BTN_TAG:
                   [appDelegate.bleManager readValue:0xFF90 characteristicUUID:0xFF93 p:appDelegate.bleManager.activePeripheral];
                break;
            case FIFTH_REFRESH_BTN_TAG:
                   [appDelegate.bleManager readValue:0xFF90 characteristicUUID:0xFF95 p:appDelegate.bleManager.activePeripheral];
                break;
            case SIXTH_REFRESH_BTN_TAG:
                 [appDelegate.bleManager readValue:0xFF90 characteristicUUID:0xFF96 p:appDelegate.bleManager.activePeripheral];
                break;
            case SIXTH_SET_BTN_TAG:
                editView = (UITextView *)[self.listView viewWithTag:SIXTH_SET_EDIT_TAG];
                [editView resignFirstResponder];
                [self writeFF96];
                break;
            case SEVENTH_REFRESH_BTN_TAG:
                 [appDelegate.bleManager readValue:0xFF90 characteristicUUID:0xFF97 p:appDelegate.bleManager.activePeripheral];
                break;
            case EIGHTTH_REFRESH_BTN_TAG:
                   [appDelegate.bleManager readValue:0xFF90 characteristicUUID:0xFF98 p:appDelegate.bleManager.activePeripheral];
                break;
            case EIGHTTH_SET_BTN_TAG:
                editView = (UITextView *)[self.listView viewWithTag:EIGHTTH_SET_EDIT_TAG];
                [editView resignFirstResponder];
                [self writeFF98];
                break;
            default:
                break;
        }
        NSLog(@"button click  %d",(int)button.tag);
    }
}
#pragma mark cellviews 中的事件       end
#pragma mark-

#pragma mark 数据更新事件事件       end
#pragma mark-

//更新数据
-(void)ValueChangText:(NSNotification *)notification
{
    //这里取出刚刚从过来的字符串
    CBCharacteristic *tmpCharacter = (CBCharacteristic*)[notification object];
    UILabel *label ;
    NSString *uuidStr = [[tmpCharacter UUID] UUIDString];
    NSLog(@"character uuidString %@ ", uuidStr );
    if([uuidStr isEqualToString:@"FF91"])
    {
        label = (UILabel *)[self.listView viewWithTag:FIRST_TXT_TAG];
        [label setText:[[NSString alloc] initWithData:tmpCharacter.value encoding:NSUTF8StringEncoding]];
    }else if([uuidStr isEqualToString:@"FF92"])
    {
        label = (UILabel *)[self.listView viewWithTag:SECOND_TXT_TAG];
        NSData *data = tmpCharacter.value;
        Byte *byteData = (Byte*)[data bytes];
        [label setText:[self receiveFF92Data:(int)byteData[0]]];
    }else if([uuidStr isEqualToString:@"FF93"])
    {
        label = (UILabel *)[self.listView viewWithTag:THIRD_TXT_TAG];
        NSData *data = tmpCharacter.value;
        Byte *byteData = (Byte*)[data bytes];
        [label setText:[self receiveFF93Data:(int)byteData[0]]];
    }else if([uuidStr isEqualToString:@"FF95"])
    {
        label = (UILabel *)[self.listView viewWithTag:FIFTH_REFRESH_TXT_TAG];
        NSData *data = tmpCharacter.value;
        Byte *byteData = (Byte*)[data bytes];
        [label setText:[self receiveFF95Data:(int)byteData[0]]];
    }else if([uuidStr isEqualToString:@"FF96"])
    {
        label = (UILabel *)[self.listView viewWithTag:SIXTH_REFRESH_TXT_TAG];
        NSData *data = tmpCharacter.value;
        Byte *byteData = (Byte*)[data bytes];
        int value = 0;
        value = (int)(byteData[0] & 0xff) << 8;
        value += (int)(byteData[1] & 0xff);
        [label setText:[NSString stringWithFormat:@"%d",value]];
    }else if([uuidStr isEqualToString:@"FF97"])
    {
        label = (UILabel *)[self.listView viewWithTag:SEVENTH_REFRESH_TXT_TAG];
        NSData *data = tmpCharacter.value;
        Byte *byteData = (Byte*)[data bytes];
        [label setText:[self receiveFF97Data:(int)byteData[0]]];
    }else if([uuidStr isEqualToString:@"FF98"])
    {
        label = (UILabel *)[self.listView viewWithTag:EIGHTTH_REFRESH_TXT_TAG];
        [label setText:[[NSString alloc] initWithData:tmpCharacter.value encoding:NSUTF8StringEncoding]];
    }
}
//写入名称
-(void)writeFF91
{
    UITextView *editView = (UITextView *)[self.listView viewWithTag:FIRST_EDIT_TAG];
    if(![[editView text] isEqualToString:@""]){
        [appDelegate.bleManager writeValue:0xFF90 characteristicUUID:0xFF91 p:appDelegate.bleManager.activePeripheral data:[[editView text] dataUsingEncoding:NSUTF8StringEncoding]];
    }
}
//写入识别码
-(void)writeFF96
{
    UITextView *editView = (UITextView *)[self.listView viewWithTag:SIXTH_SET_EDIT_TAG];
    
    if(![[editView text] isEqualToString:@""]){
        int value = [[editView text]intValue];
        Byte data[2];
        data[0] = (Byte)((value >> 8) & 0xFF);
        data[1] = (Byte)(value & 0xFF);
        NSData *dataValue = [[NSData alloc]initWithBytes:data length:2];
        [appDelegate.bleManager writeValue:0xFF90 characteristicUUID:0xFF96 p:appDelegate.bleManager.activePeripheral data:dataValue];
    }
}
//修改广播数据
-(void)writeFF98
{
    UITextView *editView = (UITextView *)[self.listView viewWithTag:EIGHTTH_SET_EDIT_TAG];
    if(![[editView text] isEqualToString:@""]){
        [appDelegate.bleManager writeValue:0xFF90 characteristicUUID:0xFF98 p:appDelegate.bleManager.activePeripheral data:[[editView text] dataUsingEncoding:NSUTF8StringEncoding]];
    }
}
//处理FF92返回的数据
-(NSString *) receiveFF92Data:(int)type
{
    NSString *data;
    switch (type) {
		case 0:
			data = @"20ms";
			break;
		case 1:
			data = @"50ms";
			break;
		case 2:
			data = @"100ms";
			break;
		case 3:
			data = @"200ms";
			break;
		case 4:
			data = @"300ms";
			break;
		case 5:
			data = @"400ms";
			break;
		case 6:
			data = @"500ms";
			break;
		case 7:
			data = @"1000ms";
			break;
		case 8:
			data = @"2000ms";
			break;
		default:
			break;
    }
    
    return data;
}
// 处理ff93返回的数据
-(NSString *)receiveFF93Data:(int)type
{
    NSString *data;
    switch (type) {
		case 0:
			data = @"4800 bps";
			break;
		case 1:
			data = @"9600 bps";
			break;
		case 2:
			data = @"19200 bps";
			break;
		case 3:
			data = @"38400 bps";
			break;
		case 4:
			data = @"57600 bps";
			break;
		case 5:
			data = @"115200 bps";
			break;
		default:
			break;
    }
    return data;
}
-(NSString *)receiveFF95Data:(int)type
{
    NSString *data;
    switch (type) {
		case 0:
			data = @"200 ms";
			break;
		case 1:
			data = @"500 ms";
			break;
		case 2:
			data = @"1000 ms";
			break;
		case 3:
			data = @"1500 ms";
			break;
		case 4:
			data = @"2000 ms";
			break;
		case 5:
			data = @"2500 ms";
			break;
		case 6:
			data = @"3000 ms";
			break;
		case 7:
			data = @"4000 ms";
			break;
		case 8:
			data = @"5000 ms";
			break;
            
		default:
			break;
    }    return data;
}
// 处理ff97返回的数据
-(NSString *) receiveFF97Data:(int)type
{
    NSString * data ;
    switch (type) {
		case 0:
			data = @"+4 dBm";
			break;
		case 1:
			data = @"0 dBm";
			break;
		case 2:
			data = @"-6 dBm";
			break;
		case 3:
			data = @"-23 dBm";
			break;
            
		default:
			break;
    }
    return  data;
}

-(void) initFF92Array
{
    array = [[NSMutableArray alloc]init];
    Item *item = [Item new];
    item.numberID = 0;
    item.text = @"20ms";
    item.message = @"……";
    [array addObject:item];

    Item *item1 = [Item new];
    item1.numberID = 1;
    item1.text = @"50ms";
    item1.message = @"……";
    [array addObject:item1];
    
    Item *item2 = [Item new];
    item2.numberID = 2;
    item2.text = @"100ms";
    item2.message = @"……";
    [array addObject:item2];
    
    Item *item3 = [Item new];
    item3.numberID = 3;
    item3.text = @"200ms";
    item3.message = @"……";
    [array addObject:item3];
    
    Item *item4 = [Item new];
    item4.numberID = 4;
    item4.text = @"300ms";
    item4.message = @"……";
    [array addObject:item4];
    
    Item *item5 = [Item new];
    item5.numberID = 5;
    item5.text = @"400ms";
    item5.message = @"……";
    [array addObject:item5];
    
    Item *item6 = [Item new];
    item6.numberID = 6;
    item6.text = @"500ms";
    item6.message = @"……";
    [array addObject:item6];

    Item *item7 = [Item new];
    item7.numberID = 7;
    item7.text = @"1000ms";
    item7.message = @"……";
    [array addObject:item7];
    
    Item *item8 = [Item new];
    item8.numberID = 8;
    item8.text = @"2000ms";
    item8.message = @"……";
    [array addObject:item8];
}
/**
 * 设定串口波特率
 */
-(void)initFF93Array
{
    array = [[NSMutableArray alloc]init];
    Item *item = [Item new];
    item.numberID = 0;
    item.text = @"4800 bps";
    item.message = @"……";
    [array addObject:item];
    
    Item *item1 = [Item new];
    item1.numberID = 1;
    item1.text = @"9600 bps";
    item1.message = @"……";
    [array addObject:item1];
    
    Item *item2 = [Item new];
    item2.numberID = 2;
    item2.text = @"19200 bps";
    item2.message = @"……";
    [array addObject:item2];
    
    Item *item3 = [Item new];
    item3.numberID = 3;
    item3.text = @"38400 bps";
    item3.message = @"……";
    [array addObject:item3];
    
    Item *item4 = [Item new];
    item4.numberID = 4;
    item4.text = @"57600 bps";
    item4.message = @"……";
    [array addObject:item4];
    
    Item *item5 = [Item new];
    item5.numberID = 5;
    item5.text = @"115200 bps";
    item5.message = @"……";
    [array addObject:item5];

}
/*
 * 远程复位恢复控制通道
 */
-(void)initFF94Array
{
    array = [[NSMutableArray alloc]init];
    Item *item = [Item new];
    item.numberID = 0x55;
    item.text = @"远程复位控制";
    item.message = @"……";
    [array addObject:item];
    
    Item *item1 = [Item new];
    item1.numberID = 0x35;
    item1.text = @"远程浅恢复控制";
    item1.message = @"……";
    [array addObject:item1];
    
    Item *item2 = [Item new];
    item2.numberID = 0x36;
    item2.text = @"远程深度恢复控制";
    item2.message = @"……";
    [array addObject:item2];
}

/*
 * 设定广播周期
 */
-(void) initFF95Array
{
    array = [[NSMutableArray alloc]init];
    Item *item = [Item new];
    item.numberID = 0;
    item.text = @"200ms";
    item.message = @"……";
    [array addObject:item];
    
    Item *item1 = [Item new];
    item1.numberID = 1;
    item1.text = @"500ms";
    item1.message = @"……";
    [array addObject:item1];
    
    Item *item2 = [Item new];
    item2.numberID = 2;
    item2.text = @"1000ms";
    item2.message = @"……";
    [array addObject:item2];
    
    Item *item3 = [Item new];
    item3.numberID = 3;
    item3.text = @"1500ms";
    item3.message = @"……";
    [array addObject:item3];
    
    Item *item4 = [Item new];
    item4.numberID = 4;
    item4.text = @"2000ms";
    item4.message = @"……";
    [array addObject:item4];
    
    Item *item5 = [Item new];
    item5.numberID = 5;
    item5.text = @"2500ms";
    item5.message = @"……";
    [array addObject:item5];
    
    Item *item6 = [Item new];
    item6.numberID = 6;
    item6.text = @"3000ms";
    item6.message = @"……";
    [array addObject:item6];
    
    Item *item7 = [Item new];
    item7.numberID = 7;
    item7.text = @"4000ms";
    item7.message = @"……";
    [array addObject:item7];
    
    Item *item8 = [Item new];
    item8.numberID = 8;
    item8.text = @"5000ms";
    item8.message = @"……";
    [array addObject:item8];
}
/*
 * 设定发射功率
 */
-(void) initFF97Array
{
    array = [[NSMutableArray alloc]init];
    Item *item = [Item new];
    item.numberID = 0;
    item.text = @"+4 dBm";
    item.message = @"……";
    [array addObject:item];
    
    Item *item1 = [Item new];
    item1.numberID = 1;
    item1.text = @"0 dBm";
    item1.message = @"……";
    [array addObject:item1];
    
    Item *item2 = [Item new];
    item2.numberID = 2;
    item2.text = @"-6 dBm";
    item2.message = @"……";
    [array addObject:item2];
    
    Item *item3 = [Item new];
    item3.numberID = 3;
    item3.text = @"-23 dBm";
    item3.message = @"……";
    [array addObject:item3];
}
/*
 * 远程控制扩展通道
 */
-(void) initFF99Array
{
    array = [[NSMutableArray alloc]init];
    Item *item = [Item new];
    item.numberID = 0x01;
	item.text = @"0x01";
    item.message = @"IO配置输出保存触发控制";
    [array addObject:item];
    
    Item *item1 = [Item new];
    item1.numberID = 0x02;
    item1.text = @"0x02";
    item1.message = @"远程关机控制";
    [array addObject:item1];
    
    Item *item2 = [Item new];
    item2.numberID = 0x04;
   	item2.text = @"0x03";
    item2.message = @"远程蓝牙断线请求";
    [array addObject:item2];
    
    Item *item3 = [Item new];
    item3.numberID = 0x04;
    item3.text = @"0x04";
    item3.message = @"自定义广播数据保存触发控制";
    [array addObject:item3];
}

@end
