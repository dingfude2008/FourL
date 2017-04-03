//
//  ViewController.m
//  LED_Zheng
//
//  Created by DFD on 2017/4/2.
//  Copyright © 2017年 DFD. All rights reserved.
//

#import "ViewController.h"
#import "FontDataTool.h"


static const NSUInteger SIZE_HEIGHT = 12;

static const NSUInteger SIZE_WIDTH  = SIZE_HEIGHT * 1;

@interface ViewController (){
    NSMutableArray *arrView;
    __weak IBOutlet UITextField *texxField;
    
    __weak IBOutlet UIView *containerView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [FontDataTool setupData];
    
    NSString *string = @"黑固好";
    
    // [FontDataTool getLatticeDataArray:string];
    
    int tag = 5;
    arrView = [NSMutableArray array];
    
    for (int i = 0 ; i < SIZE_HEIGHT * SIZE_WIDTH; i++) {
        
        int row = i / SIZE_WIDTH;
        int column = i % SIZE_WIDTH;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(column * tag, row * tag, tag, tag)];
        
        view.tag = i;
        
        [arrView addObject:view];
        view.backgroundColor = [UIColor blackColor];
        [containerView addSubview:view];
    }

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self changeView];
}

- (void)changeView{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        size_t length = 0;
        
        texxField.text = @"好";
        
        NSString *string = texxField.text;
        
        
        NSArray *arrayColumnRowData = [FontDataTool getRowColumnDataFromText:string];
        NSLog(@"%@", arrayColumnRowData);
        NSLog(@"%@", arrayColumnRowData);
       
        NSArray *arrayFirst = arrayColumnRowData.firstObject;
        
        for (int i = 0; i < arrayFirst.count; i++) {

            
            NSDictionary *dicSimple = arrayFirst[i];
            if ([dicSimple.allKeys.firstObject intValue] == 1) {
                NSArray *columnRow = dicSimple.allValues;
                int column = [columnRow[0] intValue];
                int row = [columnRow[1] intValue];
                
                
                UIView *view = arrView[column + row * SIZE_WIDTH];
                
                view.backgroundColor = [UIColor redColor];
            }
        }
        
        
        
        //        size_t length1= 0;
        
        
        // 240 * 60 = 14400   57600   4倍
        
        // unsigned char * chars1 = [ImageHelper convertUIImageToBitmapRGBA8:image withSize:&length1];
        
        // 48 * 12  = 576  4  2304
        
        // UIImage *imageResult = [ImageHelper reSizeImage:image toSize:CGSizeMake(48, 12)];
        
//        unsigned char * chars = [ImageHelper convertUIImageToBitmapRGBA8:image withSize:&length];
//        
//        NSData *contentData = [NSData dataWithBytes:chars length:length];
//        
//        NSArray *result = [self getResultDataFromBMPData:contentData];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            for (int i = 0; i < arrView.count; i++) {
//                
//                UIView *view = arrView[i];
//                if ([result[i] boolValue]) {
//                    
//                    int row = i / SIZE_WIDTH;
//                    int column = i % SIZE_WIDTH;
//                    
//                    //NSLog(@"行：%d  列:%d, tag:%d", row, column, (int)view.tag);
//                    
//                    view.backgroundColor = [UIColor redColor];
//                }else{
//                    view.backgroundColor = [UIColor blackColor];
//                }
//            }
//        });
        
        //        chars = NULL;
        //        // 测试
        //        NSData *newData = [NSData dataWithBytes:chars length:length];
        
        
        
        // NSLog(@"result:%@", result);
    });
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
