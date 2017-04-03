//
//  DialogListView.h
//  BLECollection
//
//  Created by rfstar on 14-4-29.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import "DialogView.h"
#import "Item.h"

@protocol DialoglistViewDelegate <NSObject>

-(void)dialogListItemViewClick:(NSInteger)position  Parameter:(Item *) item Type:(NSInteger)type;

@end
@interface DialogListView : NSObject <DialogViewDelegate,UITableViewDataSource,UITableViewDelegate>

{
    NSMutableArray   * array;
}
@property(strong,nonatomic) UILabel                             *title;
@property(nonatomic,strong) UITableView                         *listView;
@property(nonatomic,assign) id<DialoglistViewDelegate>          delegage;
@property(assign,nonatomic) NSInteger                           type;

- (id)initNib;
- (void)setArray:(NSMutableArray *) arrayTmp;
- (void)showView:(UIView *) parentView;
@end
