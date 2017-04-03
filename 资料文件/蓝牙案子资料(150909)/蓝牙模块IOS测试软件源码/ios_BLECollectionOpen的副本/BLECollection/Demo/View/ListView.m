//
//  ListView.m
//  BLECollection
//
//  Created by rfstar on 14-1-7.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import "ListView.h"

@implementation ListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect tmpFrame  = CGRectMake(0,0, frame.size.width, frame.size.height);
        _listView = [[UITableView alloc]initWithFrame:tmpFrame style:UITableViewStylePlain];
        [_listView setDelegate:self];
        [_listView setDataSource:self];
        [self addSubview:_listView];
    
        appDelegate = [[UIApplication sharedApplication] delegate];
    }
    return self;
}


- (void)ScanPeripheral {

//    MODE = 0 ;
    if (appDelegate.bleManager.activePeripheral){
        if(appDelegate.bleManager.activePeripheral.state == CBPeripheralStateConnected){
            [[appDelegate.bleManager CM] cancelPeripheralConnection:[appDelegate.bleManager activePeripheral]];        
        }
    }
    //    if (appDelegate.bleManager.peripherals)
    //        appDelegate.bleManager.peripherals = nil;
    
    [appDelegate.bleManager.peripherals removeAllObjects];
    [appDelegate.bleManager.activeCharacteristics removeAllObjects];
    [appDelegate.bleManager.activeDescriptors removeAllObjects];
    appDelegate.bleManager.activePeripheral = nil;
    appDelegate.bleManager.activeService = nil;
    
    //定时扫描持续时间 10 秒，之后打印扫描到的信息
    [appDelegate.bleManager findBLEPeripherals:10];                                  //开始扫描1分钟

}
-(void)startScan{
    [self initNotification];
    [_listDelegate listViewRefreshStateStart];
    [self ScanPeripheral];
    MODEL = MODEL_NORMAL;
}
- (void)stopScan{
       [appDelegate.bleManager stopScan];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc  removeObserver:self name:@"DIDCONNECTEDBLEDEVICE" object:nil];
    [nc  removeObserver:self name:@"STOPSCAN" object:nil];
    [nc  removeObserver:self name:@"BLEDEVICEWITHRSSIFOUND" object:nil];
    [nc  removeObserver:self name:@"SERVICEFOUNDOVER" object:nil];
    [nc  removeObserver:self name:@"DOWNLOADSERVICEPROCESSSTEP" object:nil]; 
}
-(void)initNotification
{
    //设定通知
    //发现BLE外围设备
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

    //成功连接到指定外围BLE设备
    [nc addObserver: self
           selector: @selector(didConectedbleDevice:)
               name: @"DIDCONNECTEDBLEDEVICE"
             object: nil];
    
    [nc addObserver: self
           selector: @selector(stopScanBLEDevice:)
               name: @"STOPSCAN"
             object: nil];
    
    [nc addObserver: self
           selector: @selector(bleDeviceWithRSSIFound:)
               name: @"BLEDEVICEWITHRSSIFOUND"
             object: nil];
    
    [nc addObserver: self
           selector: @selector(ServiceFoundOver:)
               name: @"SERVICEFOUNDOVER"
             object: nil];
    
    [nc addObserver: self
           selector: @selector(DownloadCharacteristicOver:)
               name: @"DOWNLOADSERVICEPROCESSSTEP"
             object: nil];

}

//扫描ble设备
-(void)stopScanBLEDevice:(CBPeripheral *)peripheral {
    NSLog(@" BLE外设 列表 被更新 ！\r\n");
    [_listView reloadData];
    [_listDelegate listViewRefreshStateEnd];
}

//服务发现完成之后的回调方法
-(void)ServiceFoundOver:(CBPeripheral *)peripheral {
    NSLog(@" 获取所有的服务 ");
    MODEL = MODEL_SCAN;  //2
    [_listView reloadData];
}

//成功扫描所有服务特征值
-(void)DownloadCharacteristicOver:(CBPeripheral *)peripheral {
    MODEL = MODEL_CONECTED;  //3
   NSLog(@" 获取所有的特征值 ! \r\n");
     [_listView reloadData];
}

-(void)bleDeviceWithRSSIFound:(NSNotification *) notification{   //此方法刷新次数过多，会导致tableview界面无法刷新的情况发生
    NSLog(@" 更新RSSI 值 ！\r\n");
    [_listView reloadData];
}

//连接成功
-(void)didConectedbleDevice:(CBPeripheral *)peripheral {
     NSLog(@" BLE 设备连接成功   ！\r\n");
     MODEL = MODEL_CONNECTING ;  //1
     [_listView reloadData];
    [appDelegate.bleManager.activePeripheral discoverServices:nil];
    
    
}

#pragma mark- UITableView
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return appDelegate.bleManager.peripherals.count;             //直接返回，类属性成员t 的peripherals  变长数组的长度
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier=@"TableCellIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] ;
    }

    CBPeripheral *cbPeripheral = [appDelegate.bleManager.peripherals objectAtIndex:[indexPath row]];
    if(cbPeripheral.name !=nil)
        cell.textLabel.text = [cbPeripheral name];
    else
        cell.textLabel.text = @"暂无";
    
    if (cbPeripheral == appDelegate.bleManager.activePeripheral) {  //判定是哪一个蓝牙设备
        
          NSLog(@" BLE refresh item   ！\r\n");
        if (MODEL == MODEL_NORMAL) {
            [[cell detailTextLabel] setText: @"-----"];
        }else if (MODEL == MODEL_CONNECTING){
            [[cell detailTextLabel] setText: @"Connecting..."];
        }else if (MODEL == MODEL_SCAN){
            [[cell detailTextLabel] setText: @"Scanning..."];
        }else if (MODEL == MODEL_CONECTED){
            [[cell detailTextLabel] setText: @"Connected"];
        }
    }else {
        [[cell detailTextLabel]setText:@""];
    }
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (appDelegate.bleManager.activePeripheral)
        if(appDelegate.bleManager.activePeripheral.state == CBPeripheralStateConnected)
            [appDelegate.bleManager.CM cancelPeripheralConnection:appDelegate.bleManager.activePeripheral];
    
    [appDelegate.bleManager.activeCharacteristics removeAllObjects];
    [appDelegate.bleManager.activeDescriptors removeAllObjects];
    appDelegate.bleManager.activePeripheral = nil;
    appDelegate.bleManager.activeService = nil;
    
    //发出通知新页面，对指定外围设备进行连接
    [appDelegate.bleManager connectPeripheral:[appDelegate.bleManager.peripherals objectAtIndex:indexPath.row]];
}
@end
