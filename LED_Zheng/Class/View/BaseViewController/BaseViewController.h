//
//  BaseViewController.h
//  FriedRice
//
//  Created by DFD on 2017/1/10.
//  Copyright © 2017年 DFD. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BaseViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

/**
 自定义的导航条目 - 以后设置导航栏内容，统一使用 navItem
 */
@property (nonatomic, strong) UINavigationItem *navItem;

/**
 表格视图 - 如果用户没有登录，就不创建
 */
@property (nonatomic, strong) UITableView *tabView;

// 可供重写
- (void)setUI;

// 默认的返回事件
- (void)barbuttonItemLeftClick;

// 这里要让子类可以在重写的时候调用基类的方法
- (void)CallBack_Data:(BussinessCode)type obj:(NSObject *)obj;

@end
