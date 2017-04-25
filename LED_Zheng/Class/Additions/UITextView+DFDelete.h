//
//  UITextView+DFDelete.h
//  LED_Zheng
//
//  Created by DFD on 2017/4/25.
//  Copyright © 2017年 DFD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DFTextViewDelegate <UITextFieldDelegate>
@optional
- (BOOL)textViewWillDeleteBackward:(UITextView *)textView;
@end

@interface UITextView (DFDelete)

@property (weak, nonatomic) id<DFTextViewDelegate> delegate;

@end

/**
 *  监听删除按钮
 *  object:UITextView
 */
extern NSString * const DFTextViewWillDeleteBackwardNotification;


