//
//  YiBRechargeItemView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "YiBRechargeItemView.h"

#import "YiBRechargeItemCollectionCell.h"

@interface YiBRechargeItemView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong ,nonatomic) UICollectionViewFlowLayout *flowLayout;

@end

@implementation YiBRechargeItemView 


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }return self;
}

- (void)setup {
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [self addSubview:self.view];
    self.view.frame = self.bounds;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat width = (self.width - 12.0f*2)/3;
        _flowLayout.itemSize = CGSizeMake(width, width *69/107);
        _flowLayout.minimumInteritemSpacing = 12.0f;
        _flowLayout.minimumLineSpacing = 12.0f;
        _flowLayout.sectionInset = UIEdgeInsetsZero;
        
    }return _flowLayout;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.collectionView.collectionViewLayout = self.flowLayout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YiBRechargeItemCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([YiBRechargeItemCollectionCell class])];
    
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self.collectionView reloadData];
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    [self.collectionView reloadData];
}

#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YiBRechargeItemCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YiBRechargeItemCollectionCell class]) forIndexPath:indexPath];
    cell.num = _dataArray[indexPath.item];
    cell.selected = (_currentIndex == indexPath.item)?YES:NO;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(rechargeItemWillDisplayCellWithContentSize:)]) {
        [self.delegate rechargeItemWillDisplayCellWithContentSize:collectionView.contentSize];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _currentIndex = indexPath.item;
    [collectionView reloadData];
    if (self.delegate && [self.delegate respondsToSelector:@selector(rechargeItemDidSelectedItemAtIndex:)]) {
        [self.delegate rechargeItemDidSelectedItemAtIndex:indexPath.item];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return YES;
}

@end
