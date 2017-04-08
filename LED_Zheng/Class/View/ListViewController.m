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
    NSArray<Program *> *arrayData;
    __weak IBOutlet UIButton *bleButton;
    __weak IBOutlet UIButton *writeButton;
}

@property (weak, nonatomic) IBOutlet UITableView *listTabView;




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
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    [self loadData];
}

- (void)loadData{
    NSArray *array = GetUserDefault(ListDataLocal);
    
    if (!array) {
        arrayData = [@[] mutableCopy];
    }else{
        arrayData = [NSArray yy_modelArrayWithClass:[Program class] json:array];
    }
    
    NSLog(@"----》 %@", @(arrayData.count));
    
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
    NSLog(@"个数:%@", @(arrayData.count));
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
