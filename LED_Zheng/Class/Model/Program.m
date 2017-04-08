
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
    NSArray *arrayLocal = GetUserDefault(ListDataLocal);
    if (!arrayLocal ){
        arrayLocal = @[];
    }
    NSMutableArray *arrayNew = [[NSArray yy_modelArrayWithClass:[Program class] json:arrayLocal] mutableCopy];
    
    BOOL isNew = YES;;
    for (int i = 0; i < arrayNew.count; i++) {
        Program *program = arrayNew[i];
        if (program.Id == self.Id) {
            isNew = NO;
            program = self;
            break;
        }
    }
    
    if (isNew) {
        [arrayNew addObject:self];
    }
    
    NSMutableArray *arrayDictionary = [@[] mutableCopy];
    
    for (int i = 0; i < arrayNew.count ; i++) {
        
        Program *p = arrayNew[i];
        NSDictionary *dictionary = [p yy_modelToJSONObject];
        [arrayDictionary addObject:dictionary];
    }
    SetUserDefault(ListDataLocal, arrayDictionary);
}

@end
