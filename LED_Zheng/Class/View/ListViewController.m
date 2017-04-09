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
}

@property (weak, nonatomic) IBOutlet UITableView *listTabView;

@property (nonatomic, strong) NSMutableArray<Program *> *arrayData;




@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kString(@"节目列表");
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [button addTarget:self action:@selector(addProgram) forControlEvents:UIControlEventTouchUpInside];
        button;
    })];
    
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

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self loadData];
}

- (void)loadData{
    NSArray *array = [GetUserDefault(ListDataLocal) mutableCopy];
    if (!array) {
        self.arrayData = [@[] mutableCopy];
    }else{
        NSArray *arrayTag = [NSArray yy_modelArrayWithClass:[Program class] json:array];
        self.arrayData = [NSMutableArray arrayWithArray:arrayTag];
    }
    
    NSLog(@"----》 %@", @(self.arrayData.count));
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
    NSLog(@"个数:%@", @(self.arrayData.count));
    return self.arrayData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ListViewCell *cell = [ListViewCell cellWithTableView:tableView];
    Program *model = self.arrayData[indexPath.row];
    cell.model = model;
    
    DDWeakVV
    cell.editBlock = ^(Program *p){
        DDStrongVV
        [self editModel:p];
    };

    cell.deleteBlock = ^(Program *p){
        DDStrongVV
        [self deleteModel:p];
    };
    return cell;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 0) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            NSLog(@"删除这条节目");
            if ([self.arrayData containsObject:selectedModel]) {
                [self.arrayData removeObject:selectedModel];
                
                RemoveUserDefault(ListDataLocal);
                for (int i = 0; i < self.arrayData.count; i++) {
                    Program *p = self.arrayData[i];
                    [p save];
                }
                
                [self.listTabView reloadData];
            }
        }
    }else{
        if (buttonIndex != alertView.cancelButtonIndex) {
            RemoveUserDefault(DefaultUUIDString);
            [DDBLE stopLink];
        }
    }
}

- (void)deleteModel:(Program *)model{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kString(@"提示") message:kString(@"确认删除这条节目吗?") delegate:self cancelButtonTitle:kString(@"取消") otherButtonTitles:kString(@"确定"), nil];
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
    
    if (self.arrayData.count == 0) {
        MBShow(@"没有节目");
        return;
    }
    
    NSMutableArray *arrayText = [NSMutableArray array];
    NSMutableArray * arrayAdditional = [NSMutableArray array];
    
    for (int i = 0; i < self.arrayData.count; i++) {
        Program *p = self.arrayData[i];
        [arrayText addObject:p.text];
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
        
        int specialEffects = [((NSArray *)arrayAdditional.lastObject)[0] intValue];
        BOOL isJustAdditonal = specialEffects == 2 || specialEffects == 3;
        
        NSString *string = arrayText[i];
        // 点阵信息
        NSArray<NSArray <NSNumber*>*> * arrayNumbersSimple = [FontDataTool getLatticeDataArray:string];
        
        // 补好每一屏幕的点阵数组，每一条都是整屏幕的, 补成72的倍数
        NSArray<NSNumber*> *arrayCombineNumbersSimple = [FontDataTool combineLatticeDataArray:arrayNumbersSimple isJustAddLast:isJustAdditonal];
        //
        [arrayNumbers addObject:arrayCombineNumbersSimple];
    }
    MBShowAll;
    [DDBLE postTextArrayAdditional:arrayAdditional
                     textDataArray:arrayNumbers];
    
}


@end
