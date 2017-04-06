//
//  FontDataTool.m
//  BMPTool
//
//  Created by DFD on 2017/4/1.
//  Copyright © 2017年 DFD. All rights reserved.
//

#import "FontDataTool.h"
#include <string.h>

static NSString * const chineseDataArrayName = @"chinese_word.txt";         // 汉字的点阵名称
static NSString * const enlishDataArrayName = @"enlish_word.txt";           // 英文(符号)的点阵名称

static NSArray<NSString *> * chineseDataArray;                              // 汉字的点阵数据
static NSArray<NSString *> *enlishDataArray;                                // 英文(符号)点阵数据

static const int chineseDadaLength = 18;                                    // 汉字的字模数据长度
static const int enlishDadaLength = 9;                                      // 英文的字模数据长度

static const int enlishGBKMax = 0x7E;                                       // 英文字模数据范围最大（不等于）
static const int enlishGBKMin = 0x20;                                       // 英文字模数据范围最小（不等于）

static NSArray<NSString *> * chineseEmpty;                                  // 汉字的空数据字模
static NSArray<NSString *> * enlishEmpty;                                   // 英文的空数据字模

@interface FontDataTool()

@end


@implementation FontDataTool


/**
 初始化数据
 */
+ (void)setupData{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:chineseDataArrayName ofType:nil];
    NSError *error;
    NSString *stringData = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:path]
                                                    encoding:NSUTF8StringEncoding
                                                       error:&error];
    if (error) {
        NSLog(@"中文初始化失败!");
    }else{
        chineseDataArray =  [stringData componentsSeparatedByString:@","];
    }
    
    
    path = [[NSBundle mainBundle] pathForResource:enlishDataArrayName ofType:nil];
    stringData = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:path]
                                          encoding:NSUTF8StringEncoding
                                             error:&error];
    if (error) {
        NSLog(@"英文+符号初始化失败!");
    }else{
        enlishDataArray =  [stringData componentsSeparatedByString:@","];
    }
    
    chineseEmpty = @[@"0x00",@"0x00",@"0x00",@"0x00",@"0x00",@"0x00",@"0x00",@"0x00",@"0x00",@"0x00",@"0x00",@"0x00",@"0x00",@"0x00",@"0x00",@"0x00",@"0x00",@"0x00"];
    enlishEmpty = @[@"0x00",@"0x00",@"0x00",@"0x00",@"0x00",@"0x00",@"0x00",@"0x00",@"0x00"];
}

/**
 获取长文本的点阵数据， 其中包含了英文和中文
 
 @param string 文本
 @return NSArray<NSArray <NSNumber*>*> * 类型
 NSArray
 
 */
+ (NSArray<NSArray <NSNumber*>*> *)getLatticeDataArray:(NSString *)string{
    if (!chineseDataArray || !enlishDataArray) {
        NSLog(@"库文件为空");
        return nil;;
    }
    // 所有的机内码集合
    NSArray *arrayGBK = [self getGBKFromString:string];
    
    NSMutableArray *arrResult = [NSMutableArray array];
    for (int i = 0; i < arrayGBK.count; i++) {
        
        NSDictionary *dicSimple = arrayGBK[i];
        int gbkSimple = [dicSimple.allValues.firstObject intValue];
        
        NSLog(@"机内码:%@", [self intToHex:gbkSimple]);
        unsigned int address;
        NSArray *arraySimple;
        
        if ([dicSimple.allKeys.firstObject intValue] == 1) {        // 汉字
            if (gbkSimple == -1) {
                arraySimple = chineseEmpty;
            }else{
                unsigned char heigh = (gbkSimple >> 8) & 0xFF;
                unsigned char low =  gbkSimple & 0xFF;
                address = ZK_Address_H12X12(heigh, low);
                NSLog(@"中文:在字模数据中的索引:%@", @(address));
                arraySimple = [chineseDataArray subarrayWithRange:NSMakeRange(address, chineseDadaLength)];
            }
        }else{                                                      // 英文或者字符
            if (gbkSimple == -1) {
                arraySimple = chineseEmpty;
            }else{
                address = (gbkSimple - 0x20)* 9;
                NSLog(@"英文:在字模数据中的索引:%@", @(address));
                arraySimple = [enlishDataArray subarrayWithRange:NSMakeRange(address, enlishDadaLength)];            
            }
        }
        
        if (arraySimple) {
            NSLog(@"最终字模数据: \n%@", [arraySimple componentsJoinedByString:@","]);
            NSMutableArray * arraySimpleNumber = [NSMutableArray array];
            for (int i = 0; i < arraySimple.count; i++) {
                NSString *stringHex = arraySimple[i];
                int value = [self hexToInt:[stringHex substringFromIndex:2]];
                [arraySimpleNumber addObject:@(value)];
            }
            [arrResult addObject:arraySimpleNumber];
        }
    }
    return arrResult;
}

/**
 获取文本文字的机内码（GBK码）
 
 @param string 文本文字
 @return 数组  NSDictionary Key:  1：汉字  0：非汉字
 */
+ (NSArray<NSDictionary *> *)getGBKFromString:(NSString *)string{
    NSMutableArray *arrayResult = [NSMutableArray array];
    for (int i = 0; i < string.length; i++) {
        BOOL isChinese = NO;
        int gbk = [self getGBKFromSimpleString:[string substringWithRange:NSMakeRange(i, 1)]
                                     isChinese:&isChinese];
        [arrayResult addObject:@{(isChinese ? @"1" : @"0") : @(gbk)}];
    }
    return arrayResult;
}

/**
 获取单个字符的机内码（GBK码）
 
 @param string 单个字符
 @param isChinese 是否是中文
 @return 机内码
 */
+ (int)getGBKFromSimpleString:(NSString *)string
                    isChinese:(BOOL *)isChinese{
    if ([self isChinese:string]) {
        NSLog(@"%@:  ->汉字", string);
        *isChinese = YES;
        return [self getGBKFromChinese:string];
    }
    
    int ascCode = [string characterAtIndex:0];
    if (ascCode > enlishGBKMin && ascCode < enlishGBKMax) {
        NSLog(@"%@:  ->非汉字", string);
        *isChinese = NO;
        return ascCode;
    }
    NSLog(@"数据库中没找到--->%@", string);
    return -1;
}

/**
 判断单个字符是否是中文
 
 @param string 单个字符
 @return 是否
 */
+ (BOOL)isChinese:(NSString *)string{
    
    //
    //    const char *cString=[string UTF8String];
    //    size_t length = strlen(cString);
    //
    //    if (length == 3){
    //        return YES;
    //    }else if(length == 1){
    //        NSLog(@"--->1");
    //    }
    //    return NO;
    //
    //
    int value = [string characterAtIndex:0];
    if (value > 0x4e00 && value < 0x9fff) {
        return YES;
    }
    return NO;
}


/**
 获取单个中文字符的机内码（GBK码)
 
 @param string 单个中文字符
 @return 机内码
 */
+ (int)getGBKFromChinese:(NSString *)string{
    
    NSString *urlEncoded = (__bridge_transfer NSString *)
    CFURLCreateStringByAddingPercentEscapes(NULL,
                                            (__bridge CFStringRef)string,NULL,
                                            (CFStringRef)@"!*'\"();:@&=+$,?%#[]%",
                                            kCFStringEncodingGB_18030_2000);
    NSString *heigh1 = [urlEncoded substringWithRange:NSMakeRange(1, 1)];
    NSString *heigh2 = [urlEncoded substringWithRange:NSMakeRange(2, 1)];
    int heightValue = [self hexToInt:heigh1] * 16 + [self hexToInt:heigh2];
    
    NSString *low1 = [urlEncoded substringWithRange:NSMakeRange(4, 1)];
    NSString *low2 = [urlEncoded substringWithRange:NSMakeRange(5, 1)];
    int lowValue = [self hexToInt:low1] * 16 + [self hexToInt:low2];
    int result = heightValue * 256 + lowValue;
    return result;
}



/**
 获取被查找的数组在母数组中的索引，如果没有返回-1
 
 @param array 母数组
 @param checkArray 被查找的数组
 @return 索引
 */
+ (long long)getIndex:(NSArray *)array
           checkArray:(NSArray *)checkArray{
    for (long long i = 0; i < array.count; i++) {
        NSArray *array1 = [array subarrayWithRange:NSMakeRange(i, checkArray.count)];
        BOOL result = [self checkArrayEqual:array1 array2:checkArray];
        if (result) {
            return i;
        }
    }
    return -1;
}



/**
 判断两个数组(类型为 NSArray<NSString *> *) 是否相同
 
 @param array1 array1
 @param array2 array2
 @return 是否相同
 */
+ (BOOL)checkArrayEqual:(NSArray<NSString *> *)array1
                 array2:(NSArray<NSString *> *)array2{
    if (array1.count != array2.count) {
        return NO;
    }
    
    BOOL result = YES;
    for (int i = 0; i < array1.count; i++) {
        if ([[array1[i] description] isEqualToString:[array2[i] description]]) {
            result = YES;
            continue;
        }else{
            result = NO;
            break;
        }
    }
    
    return result;
}


/**
 把十进制数转化为十六进制字符串
 43981 -> ABCD      10 -> A
 @param tmpid 参数 int
 @return 转化后的NSString
 */
+ (NSString *)intToHex:(long long int)tmpid{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];   // %i
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
    }
    return str;
}


/**
 将十六进制字符串转换为十进制数字
 ABCD -> 43981    A -> 10
 @param string 十六进制字符串
 @return 十进制数字
 */
+ (int)hexToInt:(NSString *)string{
    if (string.length > 1) {
        int lengh = (int)string.length;
        int result = 0;
        for (int i = 0; i < lengh; i++) {
            NSString *tagSting = [string substringWithRange:NSMakeRange(i, 1)];
            int tagValue = [self hexToInt:tagSting] * pow(16, lengh - i - 1);
            result += tagValue;
        }
        return result;
    }
    if ([string isEqualToString:@"0"]) {
        return 0;
    } else if ([string isEqualToString:@"1"]) {
        return 1;
    } else if ([string isEqualToString:@"2"]) {
        return 2;
    } else if ([string isEqualToString:@"3"]) {
        return 3;
    } else if ([string isEqualToString:@"4"]) {
        return 4;
    } else if ([string isEqualToString:@"5"]) {
        return 5;
    } else if ([string isEqualToString:@"6"]) {
        return 6;
    } else if ([string isEqualToString:@"7"]) {
        return 7;
    } else if ([string isEqualToString:@"8"]) {
        return 8;
    } else if ([string isEqualToString:@"9"]) {
        return 9;
    } else if ([string isEqualToString:@"A"]) {
        return 10;
    } else if ([string isEqualToString:@"B"]) {
        return 11;
    } else if ([string isEqualToString:@"C"]) {
        return 12;
    } else if ([string isEqualToString:@"D"]) {
        return 13;
    } else if ([string isEqualToString:@"E"]) {
        return 14;
    } else if ([string isEqualToString:@"F"]) {
        return 15;
    }
    return 0;
}


/**
 通过文字，获取到行列数据信息
 
 @param string 文字
 @return 行列信息
 */
+ (NSArray<NSArray <NSDictionary*>*> *)getRowColumnDataFromText:(NSString *)string{
    NSArray *arrayNumbers = [self getLatticeDataArray:string];
    NSArray *arrayResult = [self getRowColumnDataFromLatticeData:arrayNumbers];
    return arrayResult;
}




/**
 通过字模数组信息，获取到行列数据信息

 @param arrayM 字模信息
 @return 行列数据信息。 数组中为行列的键值对。 Key: 是否有数据(@"1":有点  @"0":没有点) Value:NSArray 0:列，1:行
 */
+ (NSArray<NSArray <NSDictionary*>*> *)getRowColumnDataFromLatticeData:(NSArray<NSArray <NSNumber*>*> *)arrayM{
    
    NSMutableArray *arrayResult = [NSMutableArray array];
    NSMutableArray *arraySimple;
    for (int w = 0; w < arrayM.count; w++) {
        arraySimple = [NSMutableArray array];
        NSArray *array = arrayM[w];
        int i, j,CS=0;
        int n = 0;
        CS=0;
        int Longs;
        Longs=12;//控制列的,如果为中文这个值=12，英文则=6
        if (array.count == 18) {
            Longs = 12;
        }else{
            Longs = 6;
        }
        
        int addCount = 0;
        
        for(i=0;i<Longs;i+=2)//控制列的
        {
            if (i == 10) {
                NSLog(@"1");
            }
            
            n = [array[CS] intValue];
            for(j=0;j<4;j++)//0到3行
            {
                
                if(n&0x80)
                {
                    
                    [arraySimple addObject:@{@"1": @[@(i), @(j)]}];
                }
                else
                {
                    
                    [arraySimple addObject:@{@"0": @[@(i), @(j)]}];
                }
                n <<=1;
                
                if(n&0x80)
                {
                    
                    [arraySimple addObject:@{@"1": @[@(i+1), @(j)]}];
                }
                else
                {
                    
                    [arraySimple addObject:@{@"0": @[@(i+1), @(j)]}];
                }
                
                addCount += 2;
                n <<=1;
            }
            
            
            n = [array[CS+1] intValue];
            for(j=4;j<8;j++)//4到7行
            {
                if(n&0x80)
                {
                    
                    [arraySimple addObject:@{@"1": @[@(i), @(j)]}];
                }
                else
                {
                    
                    [arraySimple addObject:@{@"0": @[@(i), @(j)]}];
                }
                n <<=1;
                
                if(n&0x80)
                {
                    
                    [arraySimple addObject:@{@"1": @[@(i+1), @(j)]}];
                }
                else
                {
                    
                    [arraySimple addObject:@{@"0": @[@(i+1), @(j)]}];
                }
                
                addCount += 2;
                n <<=1;
            }
            
            
            n = [array[CS+2] intValue];
            for(j=8;j<12;j++)//8到11行
            {
                
                if(n&0x80)
                {
                    
                    [arraySimple addObject:@{@"1": @[@(i), @(j)]}];
                }
                else
                {
                    
                    [arraySimple addObject:@{@"0": @[@(i), @(j)]}];
                }
                n <<=1;
                
                if(n&0x80)
                {
                    
                    [arraySimple addObject:@{@"1": @[@(i+1), @(j)]}];
                }
                else
                {
                    
                    [arraySimple addObject:@{@"0": @[@(i+1), @(j)]}];
                }
                
                addCount += 2;
                n <<=1;
            }
            CS+=3;
        }
        
        [arrayResult addObject:arraySimple];
    }
    return arrayResult;
}


/*******************************************************************************************
 函数名：unsigned int ZK_Address_Add(unsigned char c1, unsigned char c2)
 作用:   汉字字符的地址计算
 返回值：开始地址
 参数:   c1：高位地址  c2:地位地址(汉字的机内码)
 ************************************************************************************************/
unsigned int ZK_Address_Add(unsigned char  c1, unsigned char  c2){
    unsigned int h=0;
    if(c2==0x7f) return (h);
    if(c1>=0xA1 && c1 <= 0xa9 && c2>=0xa1)      //Section 1
        h= (c1 - 0xA1) * 94 + (c2 - 0xA1);
    else if(c1>=0xa8 && c1 <= 0xa9 && c2<0xa1)      //Section 5
    {
        if(c2>0x7f)
            c2--;
        h=(c1-0xa8)*96 + (c2-0x40)+846;
    }
    
    if(c1>=0xb0 && c1 <= 0xf7 && c2>=0xa1)      //Section 2
        h= (c1 - 0xB0) * 94 + (c2 - 0xA1)+1038;
    else if(c1<0xa1 && c1>=0x81 && c2>=0x40 )   //Section 3
    {
        if(c2>0x7f)
            c2--;
        h=(c1-0x81)*190 + (c2-0x40) + 1038 +6768;
    }
    else if(c1>=0xaa && c2<0xa1)                //Section 4
    {
        if(c2>0x7f)
            c2--;
        h=(c1-0xaa)*96 + (c2-0x40) + 1038 +12848;
    }
    return(h);
}

/*******************************************************************************************
 函数名：unsigned int ZK_Address_H12X12 (unsigned char c1, unsigned char c2)
 作用:   汉字12X12的计算地址
 返回值：开始地址
 参数:   c1：高位地址  c2:地位地址(汉字的机内码)
 ************************************************************************************************/
unsigned int ZK_Address_H12X12 (unsigned char c1, unsigned char c2)
{
    unsigned int h;
    h=ZK_Address_Add(c1,c2)*18;//计算开始地址
    return(h);
}

    
@end
