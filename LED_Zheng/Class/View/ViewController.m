//
//  ViewController.m
//  LED_Zheng
//
//  Created by DFD on 2017/4/2.
//  Copyright © 2017年 DFD. All rights reserved.
//

#import "ViewController.h"
#import "FontDataTool.h"
#import "DFMatrixLedContainerView.h"

static const NSUInteger SIZE_HEIGHT = 12;

static const NSUInteger SIZE_WIDTH  = SIZE_HEIGHT * 4;

@interface ViewController (){
    NSMutableArray *arrView;
    __weak IBOutlet UITextField *texxField;
    
    __weak IBOutlet DFMatrixLedContainerView *containerView;
    
    NSTimer *timer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [FontDataTool setupData];
    
    NSString *string = @"黑固好";
    
    
    
    
    
    // [FontDataTool getLatticeDataArray:string];
    
    
//    matrixLedView.row = SIZE_HEIGHT;
//    matrixLedView.column = SIZE_WIDTH;
    
    
    
    
//    return;
//    int tag = 2;
//    arrView = [NSMutableArray array];
//    
//    for (int i = 0 ; i < SIZE_HEIGHT * SIZE_WIDTH; i++) {
//        
//        int row = i / SIZE_WIDTH;
//        int column = i % SIZE_WIDTH;
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(column * tag, row * tag, tag, tag)];
//        
//        view.tag = i;
//        
//        [arrView addObject:view];
//        view.backgroundColor = [UIColor blackColor];
//        [containerView addSubview:view];
//    }

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeView) userInfo:nil repeats:YES];
    }else{
        [timer invalidate];
        timer = nil;
    }
}

- (void)changeView{
    
    NSString *string = @"国标码+查询;汉#字国?家标准B编码:GB2312GBKGB18030floatpowfA因此我登上了 IRC (Internet Relay Chat)，在那里我遇到了一个很有意思的挑战。它是以 Clarus the dog cow 的形式出现的（译者注：一只像牛的狗，这个卡通形象由苹果传奇图形设计师 SusanKare 设计，在早期的 Mac 系统中，用来显示打印页面的朝向）。这只狗狗是以点阵图 (bitmap) 的形式出现的，通常情况下将其转换为 UIImage 并不是一件很容易的事。当然我觉得，应该有一种通用的方法能够将其转换为可重复使用的路径。";
    
    string = [string substringWithRange:NSMakeRange(arc4random() % (string.length - 4), 4)];
    
    texxField.text = string;
    
    
    NSArray <NSArray <NSDictionary *>*>* arrayColumnRowData = [FontDataTool getRowColumnDataFromText:string];
    [containerView setupData:arrayColumnRowData];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
