//
//  BLEHeader.h
//  FriedRice
//
//  Created by DFD on 2017/2/15.
//  Copyright © 2017年 DFD. All rights reserved.
//

#ifndef BLEHeader_h
#define BLEHeader_h

//*************************************************************************************

//--------------------------------------   UUID(统一大写写)   --------------------------

//*************************************************************************************


#define ServerUUID                                      @"FFE5"             // 主服务UUID

#define RW_Control_UUID                                 @"FFE0"             // 读取设备名称


// 下面是全部的集合
#define Arr_R_UUID                                      @[RW_Control_UUID]


//*************************************************************************************

//--------------------------------------  设备名称   ----------------------------------

//*************************************************************************************


#define Filter_Name                                    @"Vitafun"

#define OtherFilter_Name                               @"Vf_for_chen"

#define dataInterval                                    1.2                // 时间间隔


//*************************************************************************************

//--------------------------------------    数据     ----------------------------------

//*************************************************************************************



#define DataFirst                                       0xA5
#define DataOOOO                                        0x00

#define DDSearchTime                                    10



/**
 连接状态
 
 - ConnectState_Disconnect: 未连接
 - ConnectState_Connected: 已连接
 - ConnectState_Connecting: 连接中
 */
typedef NS_ENUM(NSUInteger, ConnectState) {
    ConnectState_Disconnect = 0,
    ConnectState_Connecting,
    ConnectState_Connected
};




typedef NS_ENUM(NSUInteger, BussinessCode){
    
    // ------------------------ 公用
    Bussiness_GetVersion = 0,                       // 设备版本
    Bussiness_TurnOFF_OK,                           // 关闭设备回调
    Bussiness_SetLightState_OK,                     // 灯光生效后回调
};



#endif /* BLEHeader_h */
