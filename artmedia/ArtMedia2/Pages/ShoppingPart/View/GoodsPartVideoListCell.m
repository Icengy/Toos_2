//
//  GoodsPartVideoListCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/7/22.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "GoodsPartVideoListCell.h"

#import "GoodsPartVideoListCollectionCell.h"

#import "AMEmptyView.h"

@interface GoodsPartVideoListCell () <UICollectionViewDelegate ,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic ,strong) UICollectionViewFlowLayout *layout;

@end

@implementation GoodsPartVideoListCell

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];

        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.itemSize = CGSizeMake(_collectionView.height - 15.0f, _collectionView.height - 15.0f);
        _layout.minimumLineSpacing = 10.0f;
        _layout.minimumInteritemSpacing = CGFLOAT_MIN;
        _layout.sectionInset = UIEdgeInsetsMake(0.0f, 15.0f, 15.0f, 15.0f);

    }return _layout;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _collectionView.collectionViewLayout = self.layout;
    _collectionView.alwaysBounceHorizontal = YES;
    
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsPartVideoListCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([GoodsPartVideoListCollectionCell class])];
    
    _collectionView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self titleStr:nil detailStr:nil action:@selector(reloadData:)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setVideoArray:(NSArray *)videoArray {
    _videoArray = videoArray;
    [self.collectionView ly_updataEmptyView:!_videoArray.count];
    if (_videoArray.count) [self.collectionView reloadData];
}

#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.videoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GoodsPartVideoListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GoodsPartVideoListCollectionCell class]) forIndexPath:indexPath];
    
    cell.videoInfo = (NSDictionary *)self.videoArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(listCell:didSelectVideoItem:)]) {
        [self.delegate listCell:self didSelectVideoItem:indexPath.item];
    }
}

- (void)reloadData:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(listCell:didReloadData:)]) {
        [self.delegate listCell:self didReloadData:sender];
    }
}

@end
