//
//  HelperConfig.h
//  常用分类收集
//
//  Created by 丁付德 on 16/8/3.
//  Copyright © 2016年 dfd. All rights reserved.
//

#ifndef HelperMacro_h
#define HelperMacro_h

#ifdef __OBJC__         // OC 下的宏命令

#define APPID                   1089456223


#ifndef __OPTIMIZE__
    #define NSLog(...) NSLog(__VA_ARGS__)
#else
    #define NSLog(...) {}
#endif




// ------- 本地存储
#define GetUserDefault(k)       [[NSUserDefaults standardUserDefaults] objectForKey:k]
#define SetUserDefault(k, v)    [[NSUserDefaults standardUserDefaults] setObject:v forKey:k]; \
                                [[NSUserDefaults standardUserDefaults] synchronize];
#define RemoveUserDefault(k)    [[NSUserDefaults standardUserDefaults] removeObjectForKey:k]; \
                                [[NSUserDefaults standardUserDefaults] synchronize];



// ------- 声明

#define DDWeakVV          DDWeak(self)
#define DDStrongVV        DDStrong(self)

#define DDWeak(type)      __weak typeof(type) weak##type = type;
#define DDStrong(type)    __strong typeof(type) type = weak##type;

// 系统相关
#define SystemVersion    [[[UIDevice currentDevice] systemVersion] doubleValue]  // 当前系统版本

#define IS_IPad          [[UIDevice currentDevice].model rangeOfString:@"iPad"].length > 0// 是否是ipad

// ------- 系统相关
#define IPhone4          (ScreenHeight == 480)
#define IPhone5          (ScreenHeight == 568)
#define IPhone6          (ScreenHeight == 667)
#define IPhone6P         (ScreenHeight == 736)


#define SystemVersion    [[[UIDevice currentDevice] systemVersion] doubleValue]  // 当前系统版本

// 中英文
#define kString(_S)      NSLocalizedString(_S, @"")
#define St(_k)           [@(_k) description]



// ------- 宽高
#define ScreenHeight     [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth      [[UIScreen mainScreen] bounds].size.width
#define StateBarHeight   20
#define NavBarHeight     64
#define BottomHeight     49
#define RealHeight(_k)   ScreenHeight * (_k / 1334.0)
#define RealWidth(_k)    ScreenWidth * (_k / 750.0)
#define ScreenRadio      0.562                           // 屏幕宽高比


// ------- 显示
//#define MBShowAll        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//#define MBHide           [MBProgressHUD hideHUDForView:self.view animated:YES];
#define MBShowAll        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
#define MBShowAllText(_k) [MBProgressHUD showHUDAddedToWithText:_k view:[[UIApplication sharedApplication].delegate window] animated:YES];
#define MBHide           [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];


#define MBShow(_k)       [MBProgressHUD show:kString(_k) toView:[[UIApplication sharedApplication].delegate window]];

#define DefaultUUIDString                   @"DefaultUUIDString"


//    #define TESTACCOUNT                         @"dingfude@qq.com"
//    #define TESTPASSWORD                        @"abcD123"

#define Border(_label, _color) _label.layer.borderWidth = 1; _label.layer.borderColor = _color.CGColor;

// ------- 颜色
#define RGBA(_R,_G,_B,_A)       [UIColor colorWithRed:_R / 255.0f green:_G / 255.0f blue:_B / 255.0f alpha:_A]
#define RGB(_R,_G,_B)           RGBA(_R,_G,_B,1)
#define DWhite                  [UIColor whiteColor]
#define DRed                    [UIColor redColor]
#define DBlue                   [UIColor blueColor]
#define DBlack                  [UIColor blackColor]
#define DYellow                 [UIColor yellowColor]
#define DBlack                  [UIColor blackColor]
#define DClear                  [UIColor clearColor]
#define DLightGray              [UIColor lightGrayColor]
#define DWhiteA(_k)             [[UIColor whiteColor] colorWithAlphaComponent:_k]
#define DBlackA(_k)             [[UIColor blackColor] colorWithAlphaComponent:_k]


#define DBlackTextColor                     [UIColor cz_colorWithHex:0x333333]  // 导航栏 标题 黑框按钮文字
#define DNormalTextColor                    [UIColor cz_colorWithHex:0x2A2A2A]  // 正文文字 正在聊天
#define DTimeAndDistanceTextColor           [UIColor cz_colorWithHex:0x949494]  // 聊天列表时间数字 发现页距离
#define DMessageAndSexTextColor             [UIColor cz_colorWithHex:0x737373]  // 聊天列表文字内容 发现页性取向
#define DRequestTextColor                   [UIColor cz_colorWithHex:0x38a915]  // 聊天列表互动请求
#define DSayHellowTextColor                 [UIColor cz_colorWithHex:0xeb8916]  // 聊天列表打招呼
#define DTipsButtonSwithBackgroundColor     [UIColor cz_colorWithHex:0xff3366]  // 提示类文字 按钮颜色 开关
#define DTipsButtonDisEnableBackgroundColor [UIColor cz_colorWithHex:0xfba8b7]  // 聊天消息的边框色
#define DChatBorderColor                    [UIColor cz_colorWithHex:0xe5e5e5]  // 聊天消息的边框色



// --------------------------------------------- 配置类
#define VFIP                                @"192.168.0.236"
#define VFClient                            @"VitaFun"





#endif


#endif /* HelperConfig_h */
