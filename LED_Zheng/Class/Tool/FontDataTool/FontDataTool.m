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
static NSString * const pictureDataArrayName = @"picture.txt";              // 图片的点阵名称

static NSArray<NSString *> * chineseDataArray;                              // 汉字的点阵数据
static NSArray<NSString *> *enlishDataArray;                                // 英文(符号)点阵数据
static NSArray<NSDictionary *> *pictureDataArray;                           // 图片点阵数据


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
    
    path = [[NSBundle mainBundle] pathForResource:pictureDataArrayName ofType:nil];
    stringData = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:path]
                                          encoding:NSUTF8StringEncoding
                                             error:&error];
    if (error) {
        NSLog(@"Logo初始化失败!");
    }else{
        NSArray<NSString *>* pictureStrings = [stringData componentsSeparatedByString:@"\n"];
        NSMutableArray *arrTag = [NSMutableArray array];
        // NSLog(@"%@", pictureStrings);
        pictureStrings = [pictureStrings subarrayWithRange:NSMakeRange(0, pictureStrings.count - 1)];
        [pictureStrings enumerateObjectsUsingBlock:^(NSString *simplePicture, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *arrayTag = [simplePicture componentsSeparatedByString:@"//"];
            NSString *key = arrayTag[1];
            key = [key substringToIndex:key.length - 1];
            NSString *stringValue = arrayTag[0];
            NSArray *arrayValue = [stringValue componentsSeparatedByString:@","];
            arrayValue = [arrayValue subarrayWithRange:NSMakeRange(0, 18)];
            [arrTag addObject:@{ key:arrayValue }];
        }];

        pictureDataArray = [arrTag mutableCopy];
    }
    
    chineseEmpty = @[@"0x00",@"0x00",@"0x00",@"0x00",@"0x00",@"0x00",@"0x00",@"0x00",@"0x00",@"0x00",@"0x00",@"0x00",@"0x00",@"0x00",@"0x00",@"0x00",@"0x00",@"0x00"];
    enlishEmpty = @[@"0x00",@"0x00",@"0x00",@"0x00",@"0x00",@"0x00",@"0x00",@"0x00",@"0x00"];
    
}


/**
 获取logo数据
 
 @return logo数据
 */
+ (NSArray<NSDictionary *> *)pictureDataArray{
    return pictureDataArray;
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
    return [arrResult mutableCopy];;
}


/**
 把原来的纯点阵数据转换为竖立的点阵数据

 @param array 纯点阵数据
 @return 转换后的点阵数据
 */
+ (NSArray<NSArray <NSNumber*>*> *)getStandUpDataArray:(NSArray<NSArray <NSNumber*>*> *)array{
    
    NSMutableArray *arrResult = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        NSArray *arrSimpleText = array[i];
        unsigned char dataNew[18];
        int countOld = (int)arrSimpleText.count;
        unsigned char data[countOld];
        
        for (int i = 0; i < 18;  i++) {
            dataNew[i] = 0;
        }
        
        for (int j = 0; j < arrSimpleText.count; j++) {
            data[j] = [arrSimpleText[j] intValue]; //  & 0xFF
        }
        
        NSLog(@"老数组:%@", [arrSimpleText componentsJoinedByString:@","]);

        N_S(data, dataNew, countOld);
        
        NSMutableArray *arrSimpleTextNew = [NSMutableArray array];
        for (int i = 0; i < 18; i++) {
            [arrSimpleTextNew addObject:@(dataNew[i])];
        }
        
        NSLog(@"新数组:%@", [arrSimpleTextNew componentsJoinedByString:@","]);
        
        [arrResult addObject:arrSimpleTextNew];
    }
    return arrResult;
}

/**
 组装点阵数据，方便发送给硬件
 
 // 补好每一屏幕的点阵数组，每一条都是整屏幕的, 补成72的倍数
 
 @param array 纯文本的点阵数据
 @param isJustLast 是否只用在最后补
 
 @return 返回组装好的点阵数据
 */
+ (NSArray<NSNumber*> *)combineLatticeDataArray:(NSArray<NSArray <NSNumber*>*> *)array
                                  isJustAddLast:(BOOL)isJustLast{
    NSMutableArray *arrayResult = [NSMutableArray array];
    int count = 0;
    if (isJustLast) {
        for (int i = 0; i < array.count; i++) {
            NSArray *arraySimpleWord = array[i];
            count += arraySimpleWord.count;
            [arrayResult addObjectsFromArray:arraySimpleWord];
        }
    }else{
        int countSimple = 0;    //记录72个的标记
        for (int i = 0; i < array.count; i++) {
            NSArray *arraySimpleWord = array[i];
            [arrayResult addObjectsFromArray:arraySimpleWord];
            
            count += arraySimpleWord.count;
            countSimple += arraySimpleWord.count;
            if (countSimple == 72) {
                countSimple = 0;
            }else if (i + 1 != array.count && countSimple == 63){
                NSArray *arrayNext = (NSArray *)array[i+1];
                if (arrayNext.count == 9) {
                    [arrayResult addObjectsFromArray:arrayNext];
                    count += arrayNext.count;
                }else{
                    [arrayResult addObjectsFromArray:@[@0,@0,@0,@0,@0,@0,@0,@0,@0]];
                    count += 9;
                }
                countSimple = 0;
            }
        }
        
    }
    
    if (count % 72 != 0) {
        int needAddAddtionCount = 72 - (count % 72);
        for (int i = 0; i < needAddAddtionCount; i++) {
            [arrayResult addObject:@0];
        }
    }
    
    return [arrayResult mutableCopy];
}



/**
 获取预览的文字

 @param array 一条节目的点阵数据
 @param endLocation 结束的位置
  @return 组装好的显示文字
 */
+ (NSArray<NSArray <NSNumber*>*> *)getShowTextData:(NSArray<NSArray <NSNumber*>*> *)array
         endLocation:(int)endLocation{
    
    // 截断，光标后面的不要了
    NSArray<NSArray <NSNumber*>*> *arrayTag = [array subarrayWithRange:NSMakeRange(0, endLocation)];
    
    int countAll = 0;
    for (int i = 0; i < arrayTag.count; i++) {
        NSArray *arrayTag1 = array[i];
        countAll += arrayTag1.count;
    }
    
    // 不够一屏幕显示的
    if (countAll <= 72) {
        return arrayTag;
    }
    
    
    NSMutableArray *arrayResult = [NSMutableArray array];
    int countSimple = 0;    //记录72个的标记
    for(int i = (int)arrayTag.count - 1; i >= 0; i--){
        NSArray *arraySimple = arrayTag[i];
        if (countSimple < 63) {
            [arrayResult addObject:arraySimple];
            countSimple += arraySimple.count;
        } else if (countSimple == 63) {
            if (arraySimple.count == 18) {
                break;
            }else{
                [arrayResult addObject:arraySimple];
                break;
            }
        }
    }
    
    NSArray *arrResult_Flip = [self flipArray:arrayResult];
    return arrResult_Flip;
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
    return [arrayResult mutableCopy];
}

// 翻转数组
+ (NSArray *)flipArray:(NSArray *)array{
    NSMutableArray *arrayResult = [NSMutableArray array];
    for (int i = (int)array.count - 1; i >= 0; i--) {
        [arrayResult addObject:array[i]];
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
    if (ascCode >= enlishGBKMin && ascCode < enlishGBKMax) {
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
    const char *cString=[string UTF8String];
    size_t length = strlen(cString);

    if (length == 3){
        return YES;
    }
    NSLog(@"--->不是汉字:%@", string);
    return NO;
//    int value = [string characterAtIndex:0];
//    if (value > 0x4e00 && value < 0x9fff) {
//        return YES;
//    }
//    return NO;
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
        NSArray *array1 = [array subarrayWithRange:NSMakeRange((NSUInteger)i, checkArray.count)];
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
    arrayM = [arrayM mutableCopy];
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



//正常的字库转换为竖立显示的字库，转换之后不管是中文还是英文都变成了12x12点
//Data:原始字库数据，DataNEW：转换为竖立显示之后的数据，Longs数据长度，中文Longs=18,英文Longs=9
//正常的字库转换为竖立显示的字库，转换之后不管是中文还是英文都变成了12x12点
//Data:原始字库数据，DataNEW：转换为竖立显示之后的数据，Longs数据长度，中文Longs=18,英文Longs=9
void N_S(unsigned char Data[],unsigned char DataNEW[],char Longs)
{
    int i,j,CS=0;
    unsigned char LS1,LS;
    
    unsigned char DataLS[20];
    if(Longs==9)
    {
//        //1.填充开头的2列
//        DataLS[0]=0;
//        DataLS[1]=0;
//        DataLS[2]=0;
//        //2.中间部分的数据
//        for(i=0;i<9;i++)
//        {
//            DataLS[i+3]=Data[i];
//        }
//        //3.填充尾部的4列
//        DataLS[12]=0;
//        DataLS[13]=0;
//        DataLS[14]=0;
//        
//        DataLS[15]=0;
//        DataLS[16]=0;
//        DataLS[17]=0;
        
        
        //1.填充开头的2列
        DataLS[0]=0;
        DataLS[1]=0;
        DataLS[2]=0;
        DataLS[3]=0;
        DataLS[4]=0;
        DataLS[5]=0;
        
        //2.中间部分的数据
        for(i=0;i<9;i++)
        {
            DataLS[i+6]=Data[i];
        }
        //3.填充尾部的4列
        DataLS[15]=0;
        DataLS[16]=0;
        DataLS[17]=0;
        
    }
    else
    {
        for(i=0;i<Longs;i++)
        {
            DataLS[i]=Data[i];
        }
    }
    
    for(i=0;i<3;i++)
    {
        for(j=15+i;j>0;j-=6)
        {
            LS=(DataLS[j]<<1)&0x80;//6移到7位置
            LS1=(DataLS[j]<<2)&0x40;//4移到6位置
            LS|=LS1;
            LS1=(DataLS[j]>>2)&0x20;//7移到5位置
            LS|=LS1;
            LS1=(DataLS[j]>>1)&0x10;//5移到4位置
            LS|=LS1;
            
            LS1=(DataLS[j-3]>>3)&0x08;//6移到3位置
            LS|=LS1;
            LS1=(DataLS[j-3]>>2)&0x04;//4移到2位置
            LS|=LS1;
            LS1=(DataLS[j-3]>>6)&0x02;//7移到1位置
            LS|=LS1;
            LS1=(DataLS[j-3]>>5)&0x01;//5移到0位置
            LS|=LS1;
            DataNEW[CS]=LS;
            
            LS=(DataLS[j]<<5)&0x80;//2移到7位置
            LS1=(DataLS[j]<<6)&0x40;//0移到6位置
            LS|=LS1;
            LS1=(DataLS[j]<<2)&0x20;//3移到5位置
            LS|=LS1;
            LS1=(DataLS[j]<<3)&0x10;//1移到4位置
            LS|=LS1;
            
            LS1=(DataLS[j-3]<<1)&0x08;//2移到3位置
            LS|=LS1;
            LS1=(DataLS[j-3]<<2)&0x04;//0移到2位置
            LS|=LS1;
            LS1=(DataLS[j-3]>>2)&0x02;//3移到1位置
            LS|=LS1;
            LS1=(DataLS[j-3]>>1)&0x01;//1移到0位置
            LS|=LS1;
            DataNEW[CS+3]=LS;
            CS++;
        }
        CS+=3;
    } 
}

@end
