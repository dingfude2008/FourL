//
//  BLEManager.m
//  FriedRice
//
//  Created by DFD on 2017/2/15.
//  Copyright © 2017年 DFD. All rights reserved.
//

#import "BLEManager.h"

#define ST_ERROR(description) [NSError errorWithDomain:@"com.xinyi" code:0 userInfo:@{NSLocalizedDescriptionKey:description}]

static BLEManager *bleManager;
@interface BLEManager()<CBCentralManagerDelegate,CBPeripheralDelegate>{
    dispatch_queue_t __syncQueueMangerDidUpdate;
    NSMutableArray* _knownPeripherals; // 记住原来已经连接过的设备，强引用  // = [NSMutableArray array];
}

// 视频缓冲相关
@property (nonatomic, assign) BOOL          isVideoBuffer;          // 记录当前的数据写入方式 视频缓冲

@property (nonatomic, copy  ) NSArray *     videoBufferArray;       // 视频缓冲数组

@property (nonatomic, assign) int           videoBufferSingleLength;// 视频缓冲数组中每几个是一组

@property (nonatomic, assign) int           videoBufferTagValue;    // 视频缓冲保留值，用于记录 (上一次移动的最后位置)

@property (nonatomic, assign) int           videoBufferOffest;      // 已经拼接的视频缓存组数 (一个动作算一个)

// OTA 相关
@property (nonatomic, assign) BOOL          isOTA;                  //  记录当前的数据写入方式  OTA升级

@property (nonatomic, assign) NSUInteger    otaSubDataOffset;       //  已经写入的数据长度

@property (nonatomic, copy  ) NSData *      otaData;                // 记录 ota 传输的 data

@end



@implementation BLEManager

#pragma mark - 属性

#pragma mark - 实现.h接口协议
/**
 *  实例化 单例方法
 */

+ (BLEManager *)sharedManager{
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        bleManager = [[BLEManager alloc] init];
        [self resetBLE];
    });
    return bleManager;
}

/**
 *  重置所有状态
 */
+ (void)resetBLE{
    bleManager.isOn = YES; // 默认打开，如果是没有打开的话，还是可以回调的
    bleManager -> __syncQueueMangerDidUpdate = dispatch_get_global_queue(0, 0);
    bleManager.connetNumber = 100000000;
    bleManager.connetInterval = 1;
    bleManager.dicFound = [@{} mutableCopy];
    bleManager.isFailToConnectAgain = YES;
}

-(void)startScan{
    if (!self.manager){
        _knownPeripherals = [NSMutableArray array];
        dispatch_queue_t centralQueue = dispatch_queue_create("com.xinyi.Coasters", DISPATCH_QUEUE_SERIAL);
        self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:centralQueue options:@{CBCentralManagerOptionShowPowerAlertKey : @YES}];//[[CBCentralManager alloc] initWithDelegate:self queue:centralQueue];
    }
    
    if (!self.isScaning){
        self.manager.delegate = self;
        [self.manager scanForPeripheralsWithServices:nil
                                             options:@{CBCentralManagerScanOptionAllowDuplicatesKey: @YES}];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DDSearchTime * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
            [self stopScan];
        });
    }
    self.isScaning = YES;
}

- (void)stopScan{
    if (self.manager){
        if (self.isScaning) {
            [self.manager stopScan];
        }
    }
    self.isScaning = NO;
}

- (void)connect:(NSString *)uuidString{
    if (uuidString) {
        CBPeripheral *peripheral = [self.dicFound objectForKey:uuidString];
        if (peripheral) {
            BOOL _ISON = NO;
            if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 10) {
                if (self.manager.state == CBManagerStatePoweredOn) {
                    _ISON = YES;
                }
            }else if (self.manager.state == CBCentralManagerStatePoweredOn) {
                _ISON = YES;
            }
            if (_ISON) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(CallBack_Connecting)]) {
                    self.connectState = ConnectState_Connecting;
                    [self.delegate CallBack_Connecting];
                }
                [self.manager connectPeripheral:peripheral options:nil];
            }
        }
    }
}

-(void)stopLink{
    self.isFailToConnectAgain = NO;
    self.connectState = ConnectState_Disconnect;
    if (self.per) {
        [self.manager cancelPeripheralConnection:self.per];
    }
}


-(void)retrievePeripheral:(NSString *)uuidString{
    NSUUID *nsUUID = [[NSUUID UUID] initWithUUIDString:uuidString];
    if(!nsUUID) return;
    BOOL isResStart = NO;
    if(nsUUID){
        NSArray *peripheralArray = [self.manager retrievePeripheralsWithIdentifiers:@[nsUUID]];
        // NSLog(@"NSUUID=%@", @(peripheralArray.count));
        if([peripheralArray count] > 0){
            for(CBPeripheral *peripheral in peripheralArray){
                [self startScan]; //
                peripheral.delegate = self;
                if (self.delegate && [self.delegate respondsToSelector:@selector(CallBack_Connecting)]) {
                    self.connectState = ConnectState_Connecting;
                    [self.delegate CallBack_Connecting];
                }
                if (![_knownPeripherals containsObject:peripheral]) {
                    [_knownPeripherals addObject:peripheral];
                }
                
                [self.manager connectPeripheral:peripheral options:nil];
            }
        }else{
            CBUUID *cbUUID = [CBUUID UUIDWithNSUUID:nsUUID];
            if (cbUUID){
                NSArray *connectedPeripheralArray = [self.manager retrieveConnectedPeripheralsWithServices:@[cbUUID]];
                // NSLog(@"CBUUID=%@", @(connectedPeripheralArray.count));
                if([connectedPeripheralArray count] > 0){
                    for(CBPeripheral *peripheral in connectedPeripheralArray){
                        [self startScan];
                        peripheral.delegate = self;
                        if (self.delegate && [self.delegate respondsToSelector:@selector(CallBack_Connecting)]) {
                            self.connectState = ConnectState_Connecting;
                            [self.delegate CallBack_Connecting];
                        }
                        if (![_knownPeripherals containsObject:peripheral]) {
                            [_knownPeripherals addObject:peripheral];
                        }
                        [self.manager connectPeripheral:peripheral options:nil];
                    }
                }else{
                    isResStart = YES;
                }
            }
        }
    }
    
    if (isResStart){
        [self startScan];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
            if ([self.dicFound.allKeys containsObject:uuidString]) {
                [self connect:uuidString];
            }
        });
    }
}

- (void)setPer:(CBPeripheral *)per{
    _per = per;
    if (per) {
        self.connectState = ConnectState_Connected;
    }else{
        self.connectState = ConnectState_Disconnect;
    }
}


#pragma mark - CBCentralManagerDelegate 中心设备代理

/**
 *  当Central Manager被初始化，我们要检查它的状态，以检查运行这个App的设备是不是支持BLE
 *
 *  @param central 中心设备
 */
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    dispatch_barrier_async(__syncQueueMangerDidUpdate, ^{
           BOOL _ISON = NO;
           if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 10) {
               if (self.manager.state == CBManagerStatePoweredOn) {
                   _ISON = YES;
               }
           }else if (self.manager.state == CBCentralManagerStatePoweredOn) {
               _ISON = YES;
           }
           
           if (_ISON) {
               self.isOn = YES;
               [self.manager scanForPeripheralsWithServices:nil
                                                    options:@{CBCentralManagerScanOptionAllowDuplicatesKey: @YES}];
               if(self.delegate && [self.delegate respondsToSelector:@selector(CallBack_ManageStateChange:)]){
                   [self.delegate CallBack_ManageStateChange:YES];
               }
           }else{
               self.isOn      = NO;
               self.per       = nil;
               self.isOK      = NO;
               [self.delegate CallBack_DisconnetedPerpheral:@""];
               if(self.delegate && [self.delegate respondsToSelector:@selector(CallBack_ManageStateChange:)]){
                   [self.delegate CallBack_ManageStateChange:NO];
               }
           }
       });
}


-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    float distance = powf(10, (abs([RSSI intValue]) - 59) / (10 * 2.0));
    NSLog(@"设备名称 : %@ %@  距离 %.1f米", peripheral.name, [peripheral.identifier UUIDString], distance);
    
    if (peripheral.name && (([peripheral.name rangeOfString:Filter_Name].length) || ([peripheral.name rangeOfString:OtherFilter_Name].length))){
        peripheral.isAris = YES;
        [self.dicFound setObject:peripheral forKey:[peripheral.identifier UUIDString]];
    }
    
    if (self.dicFound.count > 0 ){
        [self.delegate Found_CBPeripherals:self.dicFound];
    }
    
    if (self.connectState == ConnectState_Connected) {
        [self stopScan];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
    self.per = peripheral;
    [self.manager stopScan];
    self.isFailToConnectAgain = YES;
    NSString *uuidString = [peripheral.identifier UUIDString];
    SetUserDefault(DefaultUUIDString, uuidString);
    NSLog(@"连接成功 - %@", uuidString);
    if ([self.delegate respondsToSelector:@selector(CallBack_ConnetedPeripheral:)]) {
        [self.delegate CallBack_ConnetedPeripheral:uuidString];
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"无法连接");
    if (self.isFailToConnectAgain){
        [self retrievePeripheral:[peripheral.identifier UUIDString]];
    }
}


- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"------------- > 连接被断开了");
    NSString *uuidString = [[peripheral identifier] UUIDString];
    
    self.per = nil;
    self.isOK = NO;
    if ([self.delegate respondsToSelector:@selector(CallBack_DisconnetedPerpheral:)]) {
        [self.delegate CallBack_DisconnetedPerpheral:uuidString];
    }
    
    if (self.isFailToConnectAgain){
        [self retrievePeripheral:[peripheral.identifier UUIDString]];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if (!error){
        peripheral.delegate = self;
        for (CBService *service in peripheral.services){
            [peripheral discoverCharacteristics:nil forService:service];  // 扫描特性
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (!error){
        for (CBCharacteristic *chara in [service characteristics]){
            NSString *uuidString = [chara.UUID UUIDString];
            if ([Arr_R_UUID containsObject:uuidString]) {
                NSLog(@"订阅特性");
                [peripheral setNotifyValue:YES forCharacteristic:chara];   // 订阅特性
            }
        }
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error){
        NSLog(@"error  %@",error.localizedDescription);
    }
    
    NSString *uuid = [characteristic.UUID UUIDString];
    //如果不是我们要特性就退出
    if (![Arr_R_UUID containsObject:uuid]){
        return;
    }
    
    if (characteristic.isNotifying){
        NSLog(@"外围特性通知开始");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
           
            NSLog(@"发送获取设备信息的指令");
            
        });
    }else{
        NSLog(@"外围设备特性通知结束，也就是用户要下线或者离开%@",characteristic);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    NSData *data = characteristic.value;   // 数据集合   长度和协议匹配
    NSString *uu = [characteristic.UUID UUIDString];
    
    [data LogDataAndPrompt:@"收到指令 "];
    
    if ([Arr_R_UUID containsObject:uu]){
        [self setData:data
           peripheral:peripheral
            charaUUID:uu];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    NSString *uu = [characteristic.UUID UUIDString];
    uu = uu;
    
    if (!error) {
        
        NSLog(@"写入成功");
        if ([self.delegate respondsToSelector:@selector(CallBack_WrotePerpheral:uuid:)]) {
            [self.delegate CallBack_WrotePerpheral:peripheral.identifier.UUIDString
                                              uuid:uu];
        }
    }
    
    
}

// 通知回调
- (void)setData:(NSData *)data peripheral:(CBPeripheral *)peripheral charaUUID:(NSString *)charaUUID{
    NSString *uuid = [[peripheral identifier] UUIDString];
    Byte *bytes = (Byte *)data.bytes;
    
    if ([self checkData:data]){
        if ([charaUUID isEqualToString:RW_Control_UUID]){
            
        }
    }
}



-(void)readChara:(NSString *)uuidString charUUID:(NSString *)charUUID{
    NSArray *arry = [self.per services];
    if (!self.per) {
        NSLog(@"没有当前连接设备");
        return;
    }
    if (!arry.count){
        NSLog(@"当前连接的设备服务为空");
        return;
    }
    for (CBService *ser in arry){
        NSString *serverUUIDTag = ServerUUID;
        if ([[ser.UUID UUIDString] isEqualToString:serverUUIDTag]){
            for (CBCharacteristic *chara in [ser characteristics]){
                if ([[chara.UUID UUIDString] isEqualToString:charUUID]){
                    NSLog(@"开始读  %@", charUUID);
                    [self.per readValueForCharacteristic:chara];
                    break;
                }
            }
        }
    }
}


- (void)Command:(NSData *)data uuidString:(NSString *)uuidString charaUUID:(NSString *)charaUUID{
    if(!self.per || !data){
      return;
    }
    NSArray *arry = [self.per services];
    if (!arry.count){
        NSLog(@"当前连接的设备服务为空");
        return;
    }
    for (CBService *ser in arry){
        NSString *serverUUID = [ser.UUID UUIDString];
        NSString *serverUUIDTag = ServerUUID;
        if ([serverUUID isEqualToString:serverUUIDTag]){
            for (CBCharacteristic *chara in [ser characteristics]){
                if ([[chara.UUID UUIDString] isEqualToString:charaUUID]){
                    [data LogDataAndPrompt:@"写入" promptOther:charaUUID];
                    
                    [self.per writeValue:data
                       forCharacteristic:chara
                                    type:CBCharacteristicWriteWithResponse];
                    break;
                }
            }
            break;
        }
    }
}


// 验证数据是否正确
- (BOOL)checkData:(NSData *)data{
    if (!data) {
        return  NO;
    }
    NSUInteger count = data.length;
    Byte *bytes = (Byte *)data.bytes;
    int sum = 0;
    
    for (int i = 0; i < count - 1; i++) {
        sum += bytes[i];
    }
    BOOL isTrue = (sum & 0xFF) == bytes[count - 1];
    return isTrue;
}

- (Byte)getCheck:(char[])chars
          length:(int)length{
    int sum = 0;
    for (int i = 0; i < length - 1; i++) {
        sum += chars[i];
    }
    return sum & 0xFF;
}



@end
