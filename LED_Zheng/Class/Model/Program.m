
//
//  Program.m
//  LED_Zheng
//
//  Created by DFD on 2017/4/7.
//  Copyright © 2017年 DFD. All rights reserved.
//

#import "Program.h"

@implementation Program

- (void)setSpecialEffects:(int)specialEffects{
    _specialEffects = specialEffects;
    switch (specialEffects) {
        case 0:
            _specialEffectsString = kString(@"随机");
            break;
        case 1:
            _specialEffectsString = kString(@"立即显示");
            break;
        case 2:
            _specialEffectsString = kString(@"连续左移");
            break;
        case 3:
            _specialEffectsString = kString(@"连续右移");
            break;
        case 4:
            _specialEffectsString = kString(@"左移");
            break;
        case 5:
            _specialEffectsString = kString(@"右移");
            break;
        case 6:
            _specialEffectsString = kString(@"上移");
            break;
        case 7:
            _specialEffectsString = kString(@"下移");
            break;
        case 8:
            _specialEffectsString = kString(@"水平展开");
            break;
        case 9:
            _specialEffectsString = kString(@"飘雪");
            break;
        case 10:
            _specialEffectsString = kString(@"闪烁");
            break;
        case 11:
            _specialEffectsString = kString(@"抖动");
            break;
    }
}



- (void)setBorder:(int)border{
    _border = border;
    switch (border) {
        case 0:
            _borderString = kString(@"无");
            break;
        case 1:
            _borderString = kString(@"有");
            break;
    }
}

- (void)setShowType:(int)showType{
    _showType = showType;
    switch (showType) {
        case 0:
            _showTypeString = kString(@"正常显示");
            break;
        case 1:
            _showTypeString = kString(@"竖立显示");
            break;
    }
}

- (NSString *)description{
    return  [self yy_modelDescription];
}

- (void)save{
    NSArray *arrayLocal = [GetUserDefault(ListDataLocal) mutableCopy];
    if (!arrayLocal ){
        arrayLocal = @[];
    }
    NSMutableArray *arrayNew = [[NSArray yy_modelArrayWithClass:[Program class] json:arrayLocal] mutableCopy];
    
    BOOL isNew = YES;
    Program *programOld;
    for (int i = 0; i < arrayNew.count; i++) {
        programOld = arrayNew[i];
        if (programOld.Id == self.Id) {
            isNew = NO;
            break;
        }
    }
    
    if (!isNew) {
         [arrayNew removeObject:programOld];
    }
    
    [arrayNew addObject:self];
    
    NSMutableArray *arrayDictionary = [@[] mutableCopy];
    
    for (int i = 0; i < arrayNew.count ; i++) {
        
        Program *p = arrayNew[i];
        NSDictionary *dictionary = [p yy_modelToJSONObject];
        [arrayDictionary addObject:dictionary];
    }
    
    // RemoveUserDefault(ListDataLocal);
    SetUserDefault(ListDataLocal, arrayDictionary);
}





+ (int)SpeedMax{
    return 32;
}

+ (int)SpeedMin{
    return 1;
}

+ (int)ResidenceTimeMax{
    return 50;
}

+ (int)ResidenceTimeMin{
    return 0;
}



@end
