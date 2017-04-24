//
//  ListViewController.m
//  LED_Zheng
//
//  Created by DFD on 2017/4/7.
//  Copyright © 2017年 DFD. All rights reserved.
//

#import "ListViewController.h"
#import "ListViewCell.h"
#import "ViewController.h"

#import "FRSearchDeviceController.h"

static NSString *cellID = @"ListViewCell";

@interface ListViewController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>{
    __weak IBOutlet UIButton *bleButton;
    __weak IBOutlet UIButton *writeButton;
    Program * selectedModel;
    BOOL isAdd;
    NSMutableArray *selectedArray;          // 选中的数组
}

@property (weak, nonatomic) IBOutlet UITableView *listTabView;

@property (nonatomic, strong) NSMutableArray<Program *> *arrayData;


@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kString(@"节目列表");
    
    [bleButton setTitle:kString(@"点击选择连接的设备") forState:UIControlStateNormal];
    [bleButton sizeToFit];
    
    [writeButton setTitle:kString(@"发送节目") forState:UIControlStateNormal];
    [writeButton sizeToFit];
    
    [self.listTabView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
    
    self.listTabView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        view;
    });
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)loadData{
    
    [self refreshLeftBarButton];
    [self refreshRightBarButton];
    
    NSArray *array = [GetUserDefault(ListDataLocal) mutableCopy];
    if (!array) {
        self.arrayData = [@[] mutableCopy];
    }else{
        NSArray *arrayTag = [NSArray yy_modelArrayWithClass:[Program class] json:array];
        self.arrayData = [NSMutableArray arrayWithArray:arrayTag];
    }
    
    // 这里要排序
    [NSObject changeArray:self.arrayData orderWithKey:@"Id" ascending:YES];
    
    // 设置默认选中
    if (!selectedArray) {
        selectedArray = [NSMutableArray arrayWithCapacity:self.arrayData.count];
        for (int i = 0; i < self.arrayData.count; i++) {
            [selectedArray addObject:@YES];
        }
    }else if(selectedArray.count < self.arrayData.count){
        [selectedArray addObject:@YES];
    }
    
    [self.listTabView reloadData];
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return self.arrayData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ListViewCell *cell = [ListViewCell cellWithTableView:tableView];
    Program *model = self.arrayData[indexPath.row];
    cell.indexLabel.text = [@(indexPath.row + 1) description];
    cell.model = model;
    cell.selectedImv.hidden = ![selectedArray[indexPath.row] boolValue];
    
    DDWeakVV
    cell.editBlock = ^(Program *p){
        DDStrongVV
        [self editModel:p];
    };

    cell.deleteBlock = ^(Program *p){
        DDStrongVV
        [self deleteModel:p];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BOOL isSelected = [selectedArray[indexPath.row] boolValue];
    selectedArray[indexPath.row] = @(!isSelected);
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 0){
        if (buttonIndex != alertView.cancelButtonIndex) {
            NSLog(@"删除这条节目");
            if ([self.arrayData containsObject:selectedModel]) {
                NSUInteger index = [self.arrayData indexOfObject:selectedModel];
                [selectedArray removeObjectAtIndex:index];
                
                [self.arrayData removeObject:selectedModel];
                RemoveUserDefault(ListDataLocal);
                for (int i = 0; i < self.arrayData.count; i++) {
                    Program *p = self.arrayData[i];
                    [p save];
                }
                
                [self loadData];
            }
        }
    }else if (alertView.tag == 1){
        if (buttonIndex != alertView.cancelButtonIndex) {
            RemoveUserDefault(DefaultUUIDString);
            [DDBLE stopLink];
        }
    }else if (alertView.tag == 2){
        if (buttonIndex != alertView.cancelButtonIndex) {
            RemoveUserDefault(ListDataLocal);
            [self loadData];
        }
    }
}

- (void)deleteModel:(Program *)model{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kString(@"提示") message:kString(@"确认要删除这条节目吗?") delegate:self cancelButtonTitle:kString(@"取消") otherButtonTitles:kString(@"确定"), nil];
    selectedModel = model;
    [alert show];
}

- (void)editModel:(Program *)model{
    selectedModel = model;
    isAdd = NO;
    [self performSegueWithIdentifier:@"aaa" sender:nil];
}

- (void)addProgram{
    isAdd = YES;
    [self performSegueWithIdentifier:@"aaa" sender:nil];
}

- (void)clearProgram{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kString(@"提示") message:kString(@"清除所有节目吗?") delegate:self cancelButtonTitle:kString(@"取消") otherButtonTitles:kString(@"确定"), nil];
    alert.tag = 2;
    [alert show];
}



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ViewController *vc = (ViewController *)segue.destinationViewController;
    if (!isAdd) {
        vc.model = selectedModel;
    }
}


- (IBAction)buttonClick {
    if (DDBLE.connectState != ConnectState_Connected) {
        FRSearchDeviceController *vc = [[FRSearchDeviceController alloc] init];
        [self presentViewController:vc animated:YES completion:NULL];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kString(@"提示") message:kString(@"连接其他设备?") delegate:self cancelButtonTitle:kString(@"取消") otherButtonTitles:kString(@"确定"), nil];
        alert.tag = 1;
        [alert show];
    }
}


- (IBAction)writeButtonClick {
    
//    if (self.arrayData.count == 0) {
//        MBShow(@"没有节目");
//        return;
//    }
//    
//    BOOL isHasSelected = NO;
//    for (int i = 0; i < selectedArray.count; i++) {
//        if ([selectedArray[i] boolValue]) {
//            isHasSelected = YES;
//            break;
//        }
//    }
//    
//    if (!isHasSelected) {
//        MBShow(@"没有选中的节目");
//        return;
//    }
    
    if (DDBLE.connectState != ConnectState_Connected) {
        MBShow(@"没有连接设备");
        return;
    }
    
    NSMutableArray *arrayText = [NSMutableArray array];
    NSMutableArray * arrayAdditional = [NSMutableArray array];
    
    for (int i = 0; i < self.arrayData.count; i++) {
        // 过滤掉没有选中的
        if (![selectedArray[i] boolValue]) {
            continue;
        }
        Program *p = self.arrayData[i];
        [arrayText addObject:p.text];
        if (p.speed < [Program SpeedMin]) {         // 兼容上个版本
            p.speed = [Program SpeedMin];
        }
        [arrayAdditional addObject:@[ @(p.specialEffects),
                                      @(p.speed),
                                      @(p.residenceTime),
                                      @(p.border),
                                      @(p.showType),
                                      @(p.logo)
                                      ]];
    }
    
    NSMutableArray * arrayNumbers = [NSMutableArray array];
    
    for (int i = 0; i < arrayText.count; i++) {
        
        int specialEffects = [((NSArray *)arrayAdditional[i])[0] intValue];
        BOOL isStandUp = [((NSArray *)arrayAdditional[i])[4] intValue];
        NSLog(@"是否竖立显示:%@", @(isStandUp));
        
        BOOL isJustAdditonal = specialEffects == 2 || specialEffects == 3;
        
        NSString *string = arrayText[i];
        
        NSArray<NSArray <NSNumber*>*> * arrayNumbersSimple = [FontDataTool getLatticeDataArray:string];
        
        if (isStandUp) {
            arrayNumbersSimple = [FontDataTool getStandUpDataArray:arrayNumbersSimple];
        }
        
        NSArray<NSNumber*> *arrayCombineNumbersSimple = [FontDataTool combineLatticeDataArray:arrayNumbersSimple isJustAddLast:isJustAdditonal];
        
        [arrayNumbers addObject:arrayCombineNumbersSimple];
    }
    
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"模拟器");
#elif TARGET_OS_IPHONE
    
    if (DDBLE.connectState == ConnectState_Connected) {
        MBShowAll;
        [DDBLE postTextArrayAdditional:arrayAdditional
                         textDataArray:arrayNumbers];
    }
    
#endif

}

#pragma mark 刷新右上按钮
- (void)refreshRightBarButton{
    
    NSArray *array = GetUserDefault(ListDataLocal);
    if (array.count < 8) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
            [button addTarget:self action:@selector(addProgram) forControlEvents:UIControlEventTouchUpInside];
            button;
        })];
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark 刷新左上按钮
- (void)refreshLeftBarButton{
    NSArray *array = GetUserDefault(ListDataLocal);
    if (array.count == 0) {
        self.navigationItem.leftBarButtonItem = nil;
    }else{
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"clear"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(clearProgram) forControlEvents:UIControlEventTouchUpInside];
            [button sizeToFit];
            button;
        })];
    }
}


@end
