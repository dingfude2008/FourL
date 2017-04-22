//
//  ViewController.m
//  LED_Zheng
//
//  Created by DFD on 2017/4/2.
//  Copyright © 2017年 DFD. All rights reserved.
//

#import "ViewController.h"
#import "DFMatrixLedContainerView.h"
#import <UIKit/UITextView.h>
#import "CollectionViewCell.h"

// 动画， 速度， 停留时间， 边框， 显示类型， Logo
#define DefaultDeviceValues           @[@0, @1, @3, @0, @0, @0]



static NSString *cellID = @"CollectionViewCell";

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate>{
    
    __weak IBOutlet UITextView *myTextView;
    __weak IBOutlet DFMatrixLedContainerView *containerView;
    
    __weak IBOutlet UIView *colectionContainerView;
    
    UICollectionView *_collectionView;
    NSArray *arrViewData;       // _collectionView的数据源
    
    NSArray *arraySelected;     // 用户选中的选项在数据源中的集合的索引的集合
    
    NSArray *arrPickView;       // pickView的数据源
    
    int editRow;
    
    NSRange lastRange;          // 最后生效的区间
}

@property (nonatomic, strong) UIPickerView          *pickView;
@property (nonatomic, strong) UIView              * ViewCover;        // 输入时的视图覆盖
@property (nonatomic, strong) UIVisualEffectView *  ViewEffectBody;   // 输入时的视图覆盖  里面的毛玻璃
@property (nonatomic, strong) UIVisualEffectView *  ViewEffectHead;   // 毛玻璃头部

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
        [button sizeToFit];
        [button addTarget:self action:@selector(barbuttonItemLeftClick) forControlEvents:UIControlEventTouchUpInside];
        
        button;
    })];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 50)];
        [button setTitle:kString(@"确定") forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(barbuttonItemRightClick) forControlEvents:UIControlEventTouchUpInside];
        
        button;
    })];
    
    NSMutableArray *arrSpeed = [NSMutableArray array];
    for (int i = [Program SpeedMin]; i <= [Program SpeedMax]; i++) {
        [arrSpeed addObject:[@(i) description]];
    }
    
    NSMutableArray *arrTime = [NSMutableArray array];
    for (int i = [Program ResidenceTimeMin]; i <= [Program ResidenceTimeMax]; i++) {
        [arrTime addObject:[@(i) description]];
    }
    
    
    arrViewData = @[@{@"动画":@[@"随机",@"立即显示",@"连续左移",@"连续右移",@"左移",@"右移",@"上移",@"下移",@"水平展开",@"飘雪",@"闪烁",@"抖动"]},
                    @{@"速度":arrSpeed},
                    @{@"停留时间":arrTime},
                    @{@"边框": @[@"无", @"有"]},
                    @{@"显示类型":@[@"正常",@"竖立"]},
                    @{@"Logo":[FontDataTool pictureDataArray]}];
    
 
    [self setupCollection];
    
    [self initViewCover];
    
    [self initPickerView];
    
    if (self.model) {
        arraySelected = @[@(self.model.specialEffects),
                          @(self.model.speed),
                          @(self.model.residenceTime),
                          @(self.model.border),
                          @(self.model.showType),
                          @(self.model.logo)];
        myTextView.text = self.model.text;
        lastRange = NSMakeRange(0, myTextView.text.length);
        [self setText:myTextView.text];
    }else{
        arraySelected = DefaultDeviceValues;
    }
    
    myTextView.delegate = self;
}



- (void)barbuttonItemRightClick{
    
    if (myTextView.text.length == 0) {
        MBShow(@"文字不能为空");
        return;
    }
    
    if (!self.model) {
        self.model = [[Program alloc] init];
        self.model.Id = [[NSDate date] timeIntervalSince1970];
    }
    
    self.model.text                 = myTextView.text;
    self.model.specialEffects       = [arraySelected[0] intValue];
    self.model.speed                = [arraySelected[1] intValue];
    self.model.residenceTime        = [arraySelected[2] intValue];
    self.model.border               = [arraySelected[3] intValue];
    self.model.showType             = [arraySelected[4] intValue];
    self.model.logo                 = [arraySelected[5] intValue];
    
    [self.model save];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setupCollection{
    
    CGFloat margin = 5;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    CGFloat width = (ScreenWidth - 20 - 3 * margin) / 2.0;
    layout.itemSize = CGSizeMake(width, 50);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth-20, 150) collectionViewLayout:layout];
    _collectionView.backgroundColor = self.view.backgroundColor;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.scrollEnabled = NO;
    [colectionContainerView addSubview:_collectionView];
    
    [_collectionView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellWithReuseIdentifier:cellID];
    
}

- (void)initPickerView{
    
    _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 20 - 256, ScreenWidth, 256)];
    _pickView.backgroundColor = DClear;
    _pickView.tintColor = [UIColor darkGrayColor];
    
    self.pickView.delegate = self;
    self.pickView.dataSource = self;
    [self.ViewCover addSubview:_pickView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
 
    [self toolCancelBtnClick];
    
    // [self changeView];
}


- (void)setText:(NSString *)text{
    
    if (text.length == 0) {
        return;
    }
    
    int endLocation = (int)lastRange.length + (int)lastRange.location;
    
    NSLog(@"%@ %@", text, @(endLocation));
    
    NSLog(@"要从 %d 的位置往前显示一屏的文字: %@", endLocation, text);
    
    // 纯点阵信息
    NSArray<NSArray <NSNumber*>*> * arrayNumbersSimple = [FontDataTool getLatticeDataArray:text];
    
    arrayNumbersSimple = [FontDataTool getShowTextData:arrayNumbersSimple endLocation:endLocation];
    
    if ([arraySelected[4] intValue] == 1) {
        arrayNumbersSimple = [FontDataTool getStandUpDataArray:arrayNumbersSimple];
        
        if (arrayNumbersSimple.count > 4) {
            // 截取前4个
            arrayNumbersSimple = [arrayNumbersSimple subarrayWithRange:NSMakeRange(arrayNumbersSimple.count - 4, 4)];
        }
    }
    
    // 测试竖立
//    arrayNumbersSimple = [FontDataTool getStandUpDataArray:arrayNumbersSimple];
    
    
    // 行列信息
    NSArray <NSArray <NSDictionary *>*>* arrayColumnRowData = [FontDataTool getRowColumnDataFromLatticeData:arrayNumbersSimple];
    
    [containerView setupData:arrayColumnRowData];
}


- (void)changeView{
    
    // return;
    NSArray *arrayText;
    static int test = 0;
    test++;
    test = 1;
    switch (test % 3 ) {
        case 0:
            arrayText = @[@"自由的a乌鸦飞呀飞f", @"JP我的你的EG compression", @"也对自D己的身DEF世有了更多的了解。"];
            break;
        case 1:
            arrayText = @[@"神乎其A技的B二我的", @"ABCDEFT我擦", @"在向父S亲证明A自己的过程中，"];
            break;
        case 2:
            arrayText = @[@"卖女孩A的小火柴", @"12345我ABD6789", @"浪却意?外的卷入"];
            break;
    }
    
    arrayText = @[@"我的123你好你好"];
    
    NSMutableArray * arrayAdditional = [NSMutableArray array];
    NSMutableArray * arrayNumbers = [NSMutableArray array];
    
    for (int i = 0; i < 1; i++) {
        
        // 动作 +        速度 +     停留       + 边框
        // 0x00-0xAB    0x01-0x20  0x00-0x32   0x00-0x01
        
        if (i == 1) {
            [arrayAdditional addObject:@[@2, @2, @1, @0, @1, @[]]];
        }else{
//            [arrayAdditional addObject:@[@2, @2, @1, @0, @1, @[]]];
            [arrayAdditional addObject:@[@2, @1, @1, @0, @0, @0]];
        }
        
        int specialEffects = [((NSArray *)arrayAdditional.lastObject)[0] intValue];
        BOOL isJustAdditonal = specialEffects == 2 || specialEffects == 3;
        
        NSString *string = arrayText[i];
        // 点阵信息
        NSArray<NSArray <NSNumber*>*> * arrayNumbersSimple = [FontDataTool getLatticeDataArray:string];
        
        // 补好每一屏幕的点阵数组，每一条都是整屏幕的, 补成72的倍数
        NSArray<NSNumber*> *arrayCombineNumbersSimple = [FontDataTool combineLatticeDataArray:arrayNumbersSimple isJustAddLast:isJustAdditonal];
        //
        [arrayNumbers addObject:arrayCombineNumbersSimple];
    }
    
    [DDBLE postTextArrayAdditional:arrayAdditional
                     textDataArray:arrayNumbers];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self toolCancelBtnClick];
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    editRow = (int)indexPath.row;
    
    NSDictionary *dictionary = arrViewData[editRow];
    arrPickView = dictionary.allValues.firstObject;

    [self.pickView reloadAllComponents];
    
    [self.pickView selectRow:[arraySelected[editRow] intValue] inComponent:0 animated:NO];
    
    [self showViewCover];
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
    NSString *string = [dictionary.allKeys.firstObject description];
    cell.titleLabel.text = kString(string);
    NSArray *arrValues = dictionary.allValues.firstObject;
    
    if (indexPath.row != 5) {
        cell.valueLabel.text = kString([arrValues[[arraySelected[indexPath.row] intValue]] description]);
    }else{
        NSDictionary *dictionary = arrValues[[arraySelected[indexPath.row] intValue]];
        cell.valueLabel.text = [NSString stringWithFormat:@"~%@", dictionary.allKeys.firstObject];
    }
    
    return cell;
}

#pragma mark UIPickerViewDataSource;
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return arrPickView.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    if(editRow != 5){
//        return kString([arrPickView[row] description]);
//    }
//    return nil;
//}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    if(editRow == 5){
        NSDictionary *dictionary = (NSDictionary *)arrPickView[row];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.bmp",[dictionary.allKeys.firstObject description]]];
        image = [image resizedImage:2];
        UIImageView *imageV = [[UIImageView alloc] initWithImage:image];
        return imageV;
    }else{
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor blackColor];
        label.text = kString([arrPickView[row] description]);
        [label sizeToFit];
        return label;
    }
}

//选中某一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    NSMutableArray *arrNew = [arraySelected mutableCopy];
    arrNew[editRow] = @(row);
    arraySelected = [arrNew mutableCopy];
    [_collectionView reloadData];
    NSLog(@"选中某一行 - >%@", arrPickView[row]);
    if (editRow == 4) {
        [self setText:myTextView.text];
    }
}

-(void)initViewCover{
    self.ViewCover = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight)];
    self.ViewCover.backgroundColor = DClear;
    
    if(SystemVersion >= 8){
        self.ViewEffectBody = [[UIVisualEffectView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        self.ViewEffectBody.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self.ViewEffectBody.alpha = 0;
        [self.view addSubview:self.ViewEffectBody];
        
        self.ViewEffectHead = [[UIVisualEffectView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 65)];
        self.ViewEffectHead.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self.ViewEffectHead.alpha = 0;
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.ViewEffectHead];
    }
    [self.view addSubview:self.ViewCover];
}

// 显示覆盖图层
-(void)showViewCover{
    [UIView animateWithDuration:0.5 animations:^{
        [self.ViewCover setFrame:CGRectMake(0 , 0, ScreenWidth, ScreenHeight)];
        self.ViewEffectBody.alpha = self.ViewEffectHead.alpha = 0.8;
    } completion:^(BOOL finished) {}];
}

-(void)toolCancelBtnClick{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.5 animations:^{
        if (self.ViewCover) {
            [self.ViewCover setFrame:CGRectMake(0 , ScreenHeight, ScreenWidth, ScreenHeight)];
            self.ViewEffectBody.alpha = self.ViewEffectHead.alpha = 0;
        }
    } completion:^(BOOL finished) {
    }];
}

-(void)toolOKBtnClick{
    [UIView animateWithDuration:0.5 animations:^{
        [self.ViewCover setFrame:CGRectMake(0 , ScreenHeight, ScreenWidth, ScreenHeight)];
        self.ViewEffectBody.alpha = self.ViewEffectHead.alpha = 0;
    } completion:^(BOOL finished) {
    }];
}


- (void)textViewDidEndEditing:(UITextView *)textView{
    
    NSRange _range = textView.selectedRange;
//    
//    textView.text = @"我A则Sbce";
//    _range = NSMakeRange(0, 1);
    
    lastRange = _range;
    [self setText:textView.text];
}



@end
