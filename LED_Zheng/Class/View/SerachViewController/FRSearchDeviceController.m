//
//  FRSearchDeviceController.m
//  FriedRice
//
//  Created by DFD on 2017/2/15.
//  Copyright © 2017年 DFD. All rights reserved.
//

#import "FRSearchDeviceController.h"

#import "FRSearchDeviceCell.h"

static NSString * const cellId = @"FRSearchDeviceCell";


typedef NS_ENUM(NSUInteger, ViewState) {
    ViewState_BleOff = 0,               // 蓝牙关闭
    ViewState_SearchIng,                // 正在搜索
    ViewState_NOFound,                  // 没有发现
    ViewState_Select,                   // 选择设备
    ViewState_Connecting                // 正在连接
};

@interface FRSearchDeviceController (){
    NSDate *beginDate;
    BOOL swtRefresh;                            // 刷新开关
    NSTimer *timer;
    CBPeripheral *cbp;                          // 记录点击的设备UUIDString
    BOOL isRegister;                            // 时候是注册跳进来的
    
}

@property (strong, nonatomic) NSMutableDictionary *          dicData;           // 数据源
@property (weak, nonatomic) IBOutlet UILabel *              promptLabel;
@property (weak, nonatomic) IBOutlet UIView *               containerView;      // 放 菊花 的容器
@property (weak, nonatomic) IBOutlet UIView *               container2View;     // 放 tableView 的容器

@property (weak, nonatomic) IBOutlet UIButton *tryButton;




@property (nonatomic, assign) ViewState                     viewState;          // 当前的界面状态

@end

@implementation FRSearchDeviceController

- (instancetype)initWithRegister{
    if (self = [super init]) {
        isRegister = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkLink) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [timer invalidate];
    timer = nil;
    DDBLE.delegate = nil;
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}


- (void)setUI{
    [super setUI];
    
    
    if (!self.tabView) {
        self.tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, RealWidth(611), 180) style:UITableViewStylePlain];
        self.tabView.delegate = self;
        self.tabView.dataSource = self;
        self.tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tabView.backgroundColor = [UIColor clearColor];
        [self.container2View addSubview:self.tabView];
        [self.tabView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
    }
    
    self.tryButton.layer.cornerRadius = 5;
    self.tryButton.layer.masksToBounds = YES;
    self.tryButton.hidden = YES;
    [self.tryButton setTitle:kString(@"重新尝试") forState:UIControlStateNormal];
    
    UIButton *leftBtn = [[UIButton alloc] init];
    [leftBtn setTitle:kString(@"返回") forState:UIControlStateNormal];
    [leftBtn addTarget:self
                action:@selector(barbuttonItemLeftClick)
      forControlEvents:UIControlEventTouchUpInside];
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    [self beginSearchAgain];
}

- (void)setupDisconnectTipsView{
    // 重写父类
}


- (void)barbuttonItemLeftClick{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:NULL];
    });
}



-(void)beginSearchAgain{
    if (!DDBLE.isOn) {
        self.viewState = ViewState_BleOff;
        return;
    }
    
    self.viewState = ViewState_SearchIng;
    beginDate = [NSDate date];
    
    [DDBLE startScan];
    
    [self.dicData removeAllObjects];
    [self.tabView reloadData];
    
    DDWeakVV
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        DDStrongVV
        if(self.dicData.count){
            self.tabView.userInteractionEnabled = YES;
        }
        
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DDSearchTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        DDStrongVV
        if(!self.dicData.count){
            if (self.view.window) {
                if (DDBLE.isOn) {
                    self.viewState = ViewState_NOFound;
                }
            }
        }
    });
}

- (void)checkisLinkAfterConnecting{
    if (DDBLE.connectState != ConnectState_Connected) {
        if (self.view.window) {
            MBHide
            MBShow(@"请尝试重新连接");
            swtRefresh = NO;
            [self beginSearchAgain];
        }
    }
}


- (void)checkLink{
    if (DDBLE.connectState == ConnectState_Connected){
        [timer invalidate];
        timer = nil;
    }
}


- (void)Found_CBPeripherals:(NSMutableDictionary *)recivedTxt{
    if(!swtRefresh){
        
        DDWeakVV
        dispatch_async(dispatch_get_main_queue(), ^{
            DDStrongVV
            
            if (self.dicData.count != recivedTxt.count || (recivedTxt > 0 && [[NSDate date] timeIntervalSinceDate:beginDate] > 0.5)) {
                self.dicData = [recivedTxt mutableCopy];
                self.tabView.userInteractionEnabled = YES;
                NSLog(@"刷新界面");
                if (self.viewState != ViewState_Select) {
                    self.viewState = ViewState_Select;
                }
                
                beginDate = [NSDate date];
                [self.tabView reloadData];
            }
        });
    }
}

- (void)CallBack_ConnetedPeripheral:(NSString *)uuidString{
    
    NSLog(@"连接成功了");
    dispatch_async(dispatch_get_main_queue(), ^{
        MBHide
        [self dismissViewControllerAnimated:YES completion:NULL];
    });
}

- (void)CallBack_ManageStateChange:(BOOL)isON {
    NSLog(@"当前蓝牙开关状态:%@", @(isON));
    dispatch_async(dispatch_get_main_queue(), ^{
        if (isON) {
            [self beginSearchAgain];
        }else{
            self.viewState = ViewState_BleOff;
        }
    });
}


#pragma mark UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return self.dicData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    FRSearchDeviceCell *cell = [FRSearchDeviceCell cellWithTableView:tableView];
    cell.device = (CBPeripheral *)self.dicData.allValues[indexPath.row];    
    return cell;
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [DDBLE stopScan];
    
    FRSearchDeviceCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cbp = cell.device;
    
    swtRefresh = YES;
    
    MBShowAll;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.viewState = ViewState_Connecting;
        [DDBLE retrievePeripheral:cbp.identifier.UUIDString];
        
        [self performSelector:@selector(checkisLinkAfterConnecting) withObject:nil afterDelay:10];
        // 这里防止用户点击后， 连接不上， 是因为设备已经长时间没有连接停止广播造成的
        beginDate = [NSDate date];
        [self.tabView reloadData];
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tryButtonClick {
    [self beginSearchAgain];
    self.viewState = ViewState_SearchIng;
}


- (void)setViewState:(ViewState)viewState{
    _viewState = viewState;
    
    _tryButton.hidden = YES;
    _container2View.hidden = YES;
    
    switch (viewState) {
        case ViewState_BleOff:
            _promptLabel.text = kString(@"蓝牙开关已关闭");
            break;
        case ViewState_SearchIng:
            _promptLabel.text = kString(@"搜索中");
            break;
        case ViewState_NOFound:
            _promptLabel.text = kString(@"没有发现可用设备");
            _tryButton.hidden = NO;
            break;
        case ViewState_Select:
            _promptLabel.text = kString(@"设备");
            _container2View.hidden = NO;
            break;
        case ViewState_Connecting:{
            _promptLabel.text = kString(@"连接中");
        }
            break;
    }
    [_promptLabel sizeToFit];
}
- (IBAction)backClick {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
