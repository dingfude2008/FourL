//
//  BaseViewController.m
//  FriedRice
//
//  Created by DFD on 2017/1/10.
//  Copyright © 2017年 DFD. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()<BLEManagerDelegate, BLEManagerOTADelegate>{
    UIView *disconnectTipsView;
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // DDBLE.delegate              = self;
    
    [self setUI];
}

- (void)dealloc{
    NSLog(@"%@销毁了", NSStringFromClass([self class]));
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (DDBLE.delegate != self) {
        DDBLE.delegate = self;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)setUI{
    
}

- (void)setupFont{
    // 设置字体
}

- (void)barbuttonItemLeftClick{
    [self.navigationController popViewControllerAnimated:YES];
}


/// 设置导航条
- (void)setupNavigationBar{
    
//    [self.view insertSubview:self.navigationBar atIndex:999];
//    
//    self.navigationBar.items = @[self.navItem];
//    
//    UIColor *navBarTintColor = DBackgroundColor;
//    
//    UIColor *navBarForegroundColor = [UIColor darkGrayColor];
//    
//    // 全局设置
//    // 设置导航条前景色
//    [self.navigationBar setBarTintColor:navBarTintColor];
//    
//    // 设置字体大小和颜色
//    [self.navigationBar setTitleTextAttributes: @{ NSForegroundColorAttributeName:navBarTintColor }];
//    [self.navigationBar setTintColor:navBarForegroundColor];
}

- (void)setupTableView{
    return;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
//
//#pragma mark - 懒加载
//- (UINavigationBar *)navigationBar{
//    if (!_navigationBar) {
//        _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, NavBarHeight)];
//    }
//    return _navigationBar;
//}
//
//- (UINavigationItem *)navItem{
//    if (!_navItem) {
//        _navItem = [[UINavigationItem alloc] init];
//    }
//    return _navItem;
//}

//- (void)setTitle:(NSString *)title{
//    // 单个的默认设置
//    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 120, 30)];
//    label.font = DFont_SemiboldCond(27);
//    label.backgroundColor = [UIColor clearColor];
//    label.textColor = DBlackTextColor;
//    label.text = title;
//    label.textAlignment = NSTextAlignmentCenter;
//    self.navItem.titleView = label;
//}


//#pragma mark UITableViewDataSource
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
//    return 0;
//}
//
//#pragma mark UITableViewDelegate
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return [[UITableViewCell alloc] init];
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//}

#pragma BLEManagerDelegate
- (void)Found_CBPeripherals:(NSMutableDictionary *)recivedTxt { }

- (void)CallBack_ConnetedPeripheral:(NSString *)uuidString { }

- (void)CallBack_DisconnetedPerpheral:(NSString *)uuidString { }

- (void)CallBack_WrotePerpheral:(NSString *)uuidString uuid:(NSString *)uuid { }

- (void)CallBack_Data:(BussinessCode)type obj:(NSObject *)obj {
    // NSLog(@"控制器收到回调 %d, %@", (int)type, obj);
    switch (type) {
        case Bussiness_GetVersion:{                  // 这几个在基类控制器中处理

        }break;
        case Bussiness_TurnOFF_OK:
        case Bussiness_SetLightState_OK:
            break;
    }
}

- (void)CallBack_ManageStateChange:(BOOL)isON { }

- (void)CallBack_Connecting { }


@end
