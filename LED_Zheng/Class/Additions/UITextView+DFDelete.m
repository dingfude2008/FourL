//
//  UITextView+DFDelete.m
//  LED_Zheng
//
//  Created by DFD on 2017/4/25.
//  Copyright © 2017年 DFD. All rights reserved.
//

#import "UITextView+DFDelete.h"
#import <objc/runtime.h>

NSString * const DFTextViewWillDeleteBackwardNotification = @"com.dfd.textfield.did.notification";
@implementation UITextView (DFDelete)

+ (void)load {
    Method method1 = class_getInstanceMethod([self class], NSSelectorFromString(@"deleteBackward"));
    Method method2 = class_getInstanceMethod([self class], @selector(df_deleteBackward));
    method_exchangeImplementations(method1, method2);
}

- (void)df_deleteBackward {
    id <DFTextViewDelegate> delegate  = (id<DFTextViewDelegate>)self.delegate;
    BOOL isDeleted = [delegate textViewWillDeleteBackward:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:DFTextViewWillDeleteBackwardNotification object:self];
    
    if (!isDeleted) {
        [self df_deleteBackward];
    }
}
@end
