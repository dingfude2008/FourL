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
#import <UIKit/UITextView.h>
#import "CollectionViewCell.h"
#import "FRSearchDeviceController.h"

static NSString *cellID = @"CollectionViewCell";

@interface ViewController () <UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate>{
    
    
    __weak IBOutlet UITextView *textView;
    __weak IBOutlet DFMatrixLedContainerView *containerView;
    
    __weak IBOutlet UIView *colectionContainerView;
    
    
    UICollectionView *_collectionView;
    NSArray *arrViewData;       // _collectionView的数据源
    
    NSArray *arraySelected;     // 用户选中的选项在数据源中的集合的索引的集合
    
    NSInteger editIndex;        // 要修改的是第几个选项
}

@property (nonatomic, strong) UIPickerView                  *pickView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [FontDataTool setupData];
    
    // textView.delegate = self;
    
    /*
     00：随机
     01：立即显示
     02：连续左移
     03：连续右移
     04：左移
     05：右移
     06：上移
     07：下移
     08：水平展开
     09：飘雪
     0A；闪烁
     0B：抖动
     */
    arrViewData = @[@{@"特效":@[@"随机",@"立即显示",@"连续左移",@"连续右移",@"左移",@"右移",@"上移",@"下移",@"水平展开",@"飘雪",@"闪烁",@"抖动"]},
                    @{@"字体":@[@"Default"]},
                    @{@"速度":@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20"]},
                    @{@"大小":@"12"},
                    @{@"停留时间":@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32"]},
                    @{@"颜色":@[@"红"]}];
    
    arraySelected = @[@2, @0, @9, @0, @0, @0];
 
    [self setupCollection];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textChanged:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:textView];
}



- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupCollection{
    
    CGFloat margin = 5;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    CGFloat width = (ScreenWidth - 3 * margin) / 2.0;
    layout.itemSize = CGSizeMake(width, 50);
    
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150) collectionViewLayout:layout];
    _collectionView.backgroundColor = self.view.backgroundColor;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.scrollEnabled = NO;
    [colectionContainerView addSubview:_collectionView];
    
    [_collectionView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellWithReuseIdentifier:cellID];
    
}

- (void)initPickerView{
    _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 256)];
    _pickView.backgroundColor = DWhite;
    
    [self.view addSubview:_pickView];
    _pickView.dataSource        = self;
    _pickView.delegate          = self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
    [self changeView];
}

- (void)changeView{
    
//    NSString *string = @"国标码+查询;汉#字国?家标准B编码:GB2312GBKGB18030floatpowfA因此我登上了 IRC (Internet Relay Chat)，在那里我遇到了一个很有意思的挑战。它是以 Clarus the dog cow 的形式出现的（译者注：一只像牛的狗，这个卡通形象由苹果传奇图形设计师 SusanKare 设计，在早期的 Mac 系统中，用来显示打印页面的朝向）。这只狗狗是以点阵图 (bitmap) 的形式出现的，通常情况下将其转换为 UIImage 并不是一件很容易的事。当然我觉得，应该有一种通用的方法能够将其转换为可重复使用的路径。";
//    
//    string = [string substringWithRange:NSMakeRange(arc4random() % (string.length - 4), 4)];
    
//    textView.text = string;
    
    
//    NSString *string = textView.text;
    NSString *string1;
    NSString *string2;
    NSString *string3;
    
    static int test1 = 0;
    test1++;
    switch (test1 % 3 ) {
        case 0:
            string1 = @"自由的乌鸦飞呀飞";
            break;
        case 1:
            string1 = @"神乎其技的二";
            break;
        case 2:
            string1 = @"卖女孩的小火柴";
            break;
    }
    
    static int test2 = 0;
    test2++;
    switch (test2 % 3 ) {
        case 0:
            string2 = @"JPEG compression";
            break;
        case 1:
            string2 = @"123456789";
            break;
        case 2:
            string2 = @"@#$%$#@!@#$$%$$##";
            break;
    }
    
    static int test3 = 0;
    test3++;
    switch (test3 % 3 ) {
        case 0:
            string3 = @"也对自己的身世有了更多的了解。";
            break;
        case 1:
            string3 = @"在向父亲证明自己的过程中，";
            break;
        case 2:
            string3 = @"浪却意外的卷入";
            break;
    }
    
    NSArray *arrayText = @[string1, string2, string3];
    
    NSMutableArray * arrayAdditional = [NSMutableArray array];
    NSMutableArray * arrayNumbers = [NSMutableArray array];
    
    for (int i = 0; i < 3; i++) {
        
        NSString *string = arrayText[i];
        // 点阵信息
        NSArray<NSArray <NSNumber*>*> * arrayNumbersSimple = [FontDataTool getLatticeDataArray:string];
        
        // 行列信息
        NSArray <NSArray <NSDictionary *>*>* arrayColumnRowData = [FontDataTool getRowColumnDataFromLatticeData:arrayNumbers];;
        [containerView setupData:arrayColumnRowData];
        
        
        //
        [arrayNumbers addObject:[NSObject conbineArray:arrayNumbersSimple]];
        
        if (i == 1) {
            [arrayAdditional addObject:@[@2, @2, @1, @0, @1, @[]]];
        }else{
            [arrayAdditional addObject:@[@4, @2, @1, @0, @1, @[]]];
        }
    }
    
    [DDBLE postTextArrayAdditional:arrayAdditional
                     textDataArray:arrayNumbers];
}

- (IBAction)buttonClick {
    FRSearchDeviceController *vc = [[FRSearchDeviceController alloc] init];
    [self presentViewController:vc animated:YES completion:NULL];
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
//    FRDiscoverViewModel *viewModel = self.listViewModel.discoverViewModelList[indexPath.row];
//    FRUserInfoController *vc = [[FRUserInfoController alloc] initWithUserAccount:viewModel.userAccount];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    return 6;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectionViewCell *cell = (CollectionViewCell *)
    [collectionView dequeueReusableCellWithReuseIdentifier:cellID
                                              forIndexPath:indexPath];
    NSDictionary *dictionary = arrViewData[indexPath.row];
    cell.titleLabel.text = [dictionary.allKeys.firstObject description];
    cell.tag = indexPath.row;
    return cell;
}

#pragma mark UIPickerViewDataSource;
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSDictionary *dictionary = arrViewData[editIndex];
    return dictionary.allValues.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSDictionary *dictionary = arrViewData[editIndex];
    return [dictionary.allValues[row] description];
}

//选中某一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)textChanged:(NSNotification *)obj{
    UITextView *textField = (UITextView *)obj.object;
    NSString *toBeString = textField.text;
    
    textView.text = toBeString;
    
    [self changeView];
}


@end
