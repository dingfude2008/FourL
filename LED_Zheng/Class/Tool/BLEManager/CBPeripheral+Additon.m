//
//  CBPeripheral+Additon.m
//  FriedRice
//
//  Created by DFD on 2017/3/16.
//  Copyright © 2017年 DFD. All rights reserved.
//

#import "CBPeripheral+Additon.h"
#import <objc/runtime.h>

static char isArisKey;

@implementation CBPeripheral (Additon)

- (void)setIsAris:(BOOL)isAris{
    objc_setAssociatedObject(self, &isArisKey, @(isAris), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isAris{
    return [objc_getAssociatedObject(self, &isArisKey) boolValue];
}

@end
