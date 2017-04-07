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

@interface ListViewController ()<UITableViewDelegate, UITableViewDataSource, ListViewCellDelegate, UIAlertViewDelegate>{
    __weak IBOutlet UITableView *tabView;
    NSArray<Program *> *arrayData;
    
    __weak IBOutlet UIButton *bleButton;
    __weak IBOutlet UIButton *writeButton;
}




@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
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
    
    [tabView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
    
}

- (void)loadData{
    NSArray *array = GetUserDefault(ListDataLocal);
    
//    NSMutableArray *arrTest = [@[] mutableCopy];
//    for (int i = 0; i < 2; i ++) {
//        Program *p = [[Program alloc ] init];
//        p.text = i == 0 ? @"自由的a乌鸦飞呀飞f" : @"JP我的你的EG compression";
//        p.specialEffects = i == 0 ? 2 : 4;
//        p.speed = 1;
//        p.residenceTime = 1;
//        p.border = 0;
//        [arrTest addObject:p];
//    }
//    
//    arrayData = arrTest;
//    return;
//    
    if (array) {
        arrayData = @[];
    }else{
        arrayData = [NSArray yy_modelArrayWithClass:[Program class] json:arrayData];
    }
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return arrayData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ListViewCell *cell = [ListViewCell cellWithTableView:tableView];
    Program *model = arrayData[indexPath.row];
    cell.model = model;
    cell.delegate = self;
    return cell;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != alertView.cancelButtonIndex) {
        NSLog(@"删除这条节目");
    }
}

- (void)deleteModel:(Program *)model{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kString(@"提示") message:kString(@"确认删除这条节目吗?") delegate:self cancelButtonTitle:kString(@"取消") otherButtonTitles:kString(@"确定"), nil];
    [alert show];
}

- (void)editModel:(Program *)model{
    [self performSegueWithIdentifier:@"aaa" sender:model];
}

- (void)addProgram{
    [self performSegueWithIdentifier:@"aaa" sender:nil];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    ViewController *vc = (ViewController *)segue.destinationViewController;
    vc.model = sender;
}


- (IBAction)buttonClick {
    if (DDBLE.connectState != ConnectState_Connected) {
        FRSearchDeviceController *vc = [[FRSearchDeviceController alloc] init];
        [self presentViewController:vc animated:YES completion:NULL];
    }
}


- (IBAction)writeButtonClick {
    
}






@end
