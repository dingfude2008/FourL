//
//  DialogView.h
//  BLECollection
//
//  Created by rfstar on 14-1-15.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DialogViewDelegate <NSObject>

@required  -(UIView *)dialogContentView;
@optional
     -(void)dialogShow;
     -(void)dialogDimissed;
@end
@interface DialogView : NSObject

@property (nonatomic , strong) id<DialogViewDelegate> delegate;

-(id)initNib;
-(void)showDialogView:(UIView *)tmpView ;
-(void)hideDialogView;
-(IBAction)hideDialogAction:(id)sender;
@end
