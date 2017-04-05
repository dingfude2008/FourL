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


#define ServerSendUUID                                  @"FFE5"             // 主服务UUID

#define W_SentData_UUID                                 @"FFE9"             // 读取设备名称


#define ServerReceiveUUID                               @"FFE0"             // 主服务UUID

#define R_Receive_UUID                                  @"FFE4"             // 读取设备名称


// 下面是全部的集合
#define Arr_R_UUID                                      @[R_Receive_UUID]


//*************************************************************************************

//--------------------------------------  设备名称   ----------------------------------

//*************************************************************************************


#define Filter_Name                                    @"Vitafun"

#define OtherFilter_Name                               @"Tv221u"

#define dataInterval                                    1.2                // 时间间隔


//*************************************************************************************

//--------------------------------------    数据     ----------------------------------

//*************************************************************************************



#define DataHead1                                       0x4C
#define DataHead2                                       0x43
#define DataHead3                                       0x59

#define DataHeadCheck_Correct                           0xCC
#define DataHeadCheck_WrongData                         0xEE
#define DataHeadCheck_WrongPassword                     0xEB
#define DataHeadCheck_NeedAgain                         0xEC





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





typedef NS_ENUM(NSUInteger, CommondCheckType){
    
    CommondCheckType_Correct = 0,
    CommondCheckType_WrongData,
    CommondCheckType_WrongPassword,
    CommondCheckType_NeedAgain,
    CommondCheckType_Error,
};





#endif /* BLEHeader_h */
