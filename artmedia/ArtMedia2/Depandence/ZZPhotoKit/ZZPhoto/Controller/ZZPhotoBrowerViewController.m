//
//  ZZPhotoBrowerViewController.m
//  ZZPhotoKit
//
//  Created by 袁亮 on 16/5/27.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import "ZZPhotoBrowerViewController.h"
#import "ZZPhotoBrowerCell.h"
#import "ZZPageControl.h"
#import "ZZPhoto.h"

#import "ZZPhotoHud.h"
#import "ZZPhotoAlert.h"


@interface ZZPhotoBrowerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *picBrowse;
@property (nonatomic, assign) NSInteger        numberOfItems;

@property (nonatomic, strong) UIBarButtonItem  *backBarButton;
@property (nonatomic, strong) UIButton  *selectedBtn;

///完成按钮
@property (nonatomic, strong) UIButton                    *doneBtn;
///小红点
@property (nonatomic, strong) UILabel                     *totalRound;
///序列
@property (nonatomic, strong) UILabel                     *orderRound;

@end

@implementation ZZPhotoBrowerViewController

- (UIBarButtonItem *)backBarButton
{
    if (!_backBarButton) {
        UIButton *back_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [back_btn setImage:[UIImage imageNamed:@"back_button_normal"] forState:UIControlStateNormal];
        [back_btn setImage:[UIImage imageNamed:@"back_button_normal"] forState:UIControlStateHighlighted];
        
        [back_btn addTarget:self action:@selector(backItemMethod) forControlEvents:UIControlEventTouchUpInside];
        
        _backBarButton = [[UIBarButtonItem alloc] initWithCustomView:back_btn];
    }
    return _backBarButton;
}

- (UIButton *)selectedBtn{
    if (!_selectedBtn) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(selectItemMethod:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:Pic_btn_UnSelected forState:UIControlStateNormal];
        [button setImage:Pic_Btn_Selected forState:UIControlStateSelected];
        
        _selectedBtn = button;
        
    }
    return _selectedBtn;
}

- (UILabel *)totalRound{
    if (!_totalRound) {
        _totalRound = [[UILabel alloc]initWithFrame:CGRectMake(ZZ_VW - 90, 10, 22, 22)];
        
        _totalRound.backgroundColor = [UIColor redColor];
        _totalRound.layer.masksToBounds = YES;
        _totalRound.textAlignment = NSTextAlignmentCenter;
        _totalRound.textColor = [UIColor whiteColor];
        _totalRound.text = @"0";
        [_totalRound.layer setCornerRadius:CGRectGetHeight([_totalRound bounds]) / 2];
    }
    return _totalRound;
}

- (UILabel *)orderRound {
    if (!_orderRound) {
        _orderRound = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100.0f, 44.0f)];
        
        _orderRound.textAlignment = NSTextAlignmentLeft;
        _orderRound.textColor = [UIColor blackColor];
        _orderRound.text = @"0/0";
    }
    return _orderRound;
}

- (UIButton *)doneBtn {
    if (!_doneBtn) {
        _doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(ZZ_VW - 60, 0, 50, 44)];
        [_doneBtn addTarget:self action:@selector(backItemMethod) forControlEvents:UIControlEventTouchUpInside];
        _doneBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [_doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _doneBtn;
}

- (void)selectItemMethod:(UIButton *)sender {
    if (self.selectArray.count + 1 > _maxSelectNum) {
        [self showSelectPhotoAlertView:_maxSelectNum];
        return;
    }
    sender.selected = !sender.selected;
    _scrollIndex = (NSInteger)(self.picBrowse.contentOffset.x/ self.view.frame.size.width);
    ZZPhoto *selectedPhtot = (ZZPhoto *)[_photoData objectAtIndex:_scrollIndex];
    if (sender.selected) {
        selectedPhtot.isSelect = YES;
        [_selectArray addObject:selectedPhtot];
    }else {
        selectedPhtot.isSelect = NO;
        [_selectArray removeObject:selectedPhtot];
    }
    
    self.totalRound.text = [NSString stringWithFormat:@"%@",@(_selectArray.count)];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(browerViewController:didSelectedWithIndex:selectArray:)]) {
        [self.delegate browerViewController:self didSelectedWithIndex:_scrollIndex selectArray:_selectArray.copy];
    }
}

-(void)backItemMethod
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
-(void) makeCollectionViewUI
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    /*
     *   创建核心内容 UICollectionView
     */
    self.view.backgroundColor = [UIColor blackColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = (CGSize){self.view.frame.size.width, self.view.frame.size.height-StatusNav_Height - 44.0f - SafeAreaBottomHeight};
    flowLayout.minimumLineSpacing = 0.0f;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _picBrowse = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _picBrowse.backgroundColor = [UIColor clearColor];
    _picBrowse.pagingEnabled = YES;
    
    _picBrowse.showsHorizontalScrollIndicator = NO;
    _picBrowse.showsVerticalScrollIndicator = NO;
    [_picBrowse registerClass:[ZZPhotoBrowerCell class] forCellWithReuseIdentifier:NSStringFromClass([ZZPhotoBrowerCell class])];
    _picBrowse.dataSource = self;
    _picBrowse.delegate = self;
    _picBrowse.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_picBrowse];
    
    NSLayoutConstraint *list_top = [NSLayoutConstraint constraintWithItem:_picBrowse attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0.0f];
    
    NSLayoutConstraint *list_bottom = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_picBrowse attribute:NSLayoutAttributeBottom multiplier:1 constant:44.0f + SafeAreaBottomHeight];
    
    NSLayoutConstraint *list_left = [NSLayoutConstraint constraintWithItem:_picBrowse attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0.0f];
    
    NSLayoutConstraint *list_right = [NSLayoutConstraint constraintWithItem:_picBrowse attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0.0f];
    
    [self.view addConstraints:@[list_top,list_bottom,list_left,list_right]];
    
}

- (void)makeTabbarUI
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = ZZ_RGB(245, 245, 245);
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:self.doneBtn];
    [view addSubview:self.totalRound];
    [view addSubview:self.orderRound];
    [self.view addSubview:view];
    NSLayoutConstraint *tab_left = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1 constant:0.0f];
    
    NSLayoutConstraint *tab_right = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1 constant:0.0f];
    
    NSLayoutConstraint *tab_bottom = [NSLayoutConstraint constraintWithItem:_picBrowse attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:0.0f];
    
    NSLayoutConstraint *tab_height = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44+SafeAreaBottomHeight];
    
    [self.view addConstraints:@[tab_left,tab_right,tab_bottom,tab_height]];
    
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZZ_VW, 1)];
    viewLine.backgroundColor = ZZ_RGB(230, 230, 230);
    viewLine.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:viewLine];
}

- (void)updateData {
    [_picBrowse reloadData];
    //滚动到指定位置
    [_picBrowse layoutIfNeeded];
    [_picBrowse scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_scrollIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
    self.totalRound.text = [NSString stringWithFormat:@"%@",@(self.selectArray.count)];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"预览";
    self.navigationItem.leftBarButtonItem = self.backBarButton;
    UIBarButtonItem *selectedItem = [[UIBarButtonItem alloc] initWithCustomView:self.selectedBtn];
    self.navigationItem.rightBarButtonItem = selectedItem;
    
    // 更新UI
    [self makeCollectionViewUI];
    //创建底部工具栏
    [self makeTabbarUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateData];
}

//-(void) viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//
//    //滚动到指定位置
//
//    [_picBrowse scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_scrollIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
//}

#pragma mark --- UICollectionviewDelegate or dataSource
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _photoData.count;
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZPhotoBrowerCell *browerCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ZZPhotoBrowerCell class]) forIndexPath:indexPath];

    if ([[_photoData objectAtIndex:indexPath.row] isKindOfClass:[ZZPhoto class]]) {
        //加载相册中的数据时实用
        ZZPhoto *photo = [_photoData objectAtIndex:indexPath.row];
        [browerCell loadPHAssetItemForPics:photo.asset];
    }

    return browerCell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[ZZPhotoBrowerCell class]]) {
        [(ZZPhotoBrowerCell *)cell recoverSubview];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[ZZPhotoBrowerCell class]]) {
        [(ZZPhotoBrowerCell *)cell recoverSubview];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger currentIndex = (NSInteger)(scrollView.contentOffset.x/self.view.frame.size.width);
    NSLog(@"%@ - %@",@(currentIndex), @(_scrollIndex));
    self.orderRound.text = [NSString stringWithFormat:@"%@/%@", @(currentIndex+1), @(self.photoData.count)];
    if ([_selectArray containsObject:[_photoData objectAtIndex:currentIndex]]) {
        self.selectedBtn.selected = YES;
    }else {
        self.selectedBtn.selected = NO;
    }
}


-(void) showIn:(UIViewController *)controller
{
    [controller.navigationController pushViewController:self animated:YES];
}

- (void)showSelectPhotoAlertView:(NSInteger)photoNumOfMax
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:[NSString stringWithFormat:Alert_Max_Selected,(long)photoNumOfMax]preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }];
    
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
