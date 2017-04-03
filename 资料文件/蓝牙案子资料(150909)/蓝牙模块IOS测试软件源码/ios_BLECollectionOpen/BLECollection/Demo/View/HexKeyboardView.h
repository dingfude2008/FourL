//
//  HexKeyboardView.h
//  BLECollection
//
//  Created by rfstar on 14-1-16.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DialogView.h"
@protocol HexKeyboardViewDelegate <NSObject>

@required
-(void) hexKeybordViewPressedValue:(NSString *)value;
-(void) hexKeybordViewPressedValueOfDel;
-(void) hexKeybordViewPressedValueOfClr;
-(void) hexKeybordViewPressedValueOfEnter;
-(void) hexKeybordViewShow;
-(void) hexKeybordViewDimissed;
@end
@interface HexKeyboardView : NSObject <DialogViewDelegate>

@property(nonatomic , weak) id<HexKeyboardViewDelegate> delegate;
- (id)initNib;
- (void)showView:(UIView *) parentView;

@end
