//
//  ImproveDataBCell.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/23.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "ImproveDataBCell.h"
#import "IdentifyModel.h"

#import "ImproveDataBImageCell.h"

@interface ImproveDataBCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeightConstraint;

@end

@implementation ImproveDataBCell {
    BOOL _hadWillDisplay;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    _subTitleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    
    _hadWillDisplay = NO;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 10.0f;
    flowLayout.minimumInteritemSpacing = 10.0f;
    flowLayout.sectionInset = UIEdgeInsetsMake(10.0f, 10.0f, 0, 0);

    _collectionView.collectionViewLayout = flowLayout;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ImproveDataBImageCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([ImproveDataBImageCell class])];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x += 10.0f;
    frame.size.width -= 20.0f;
    [super setFrame:frame];
}

- (void)setModel:(IdentifyModel *)model {
	_model = model;
    NSLog(@"_model.imgs = %@",_model.imgs);
    _hadWillDisplay = NO;
    [_collectionView reloadData];
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_model.imgs.count >= 9)
        return _model.imgs.count;
    return _model.imgs.count + 1;
}

//flowLayout.itemSize = CGSizeMake((K_Width- ADAptationMargin*3)/2, (K_Width- ADAptationMargin*3)/2);
//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (collectionView.width- 10.0f*3)/4;
    return CGSizeMake(width, width);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImproveDataBImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ImproveDataBImageCell class]) forIndexPath:indexPath];
    if (indexPath.item == [collectionView numberOfItemsInSection:indexPath.section] - 1) {
        if (_model.imgs.count == 9) {
            cell.imageStr = _model.imgs[indexPath.item];
        }else
            cell.imageStr = nil;
    }else
       cell.imageStr = _model.imgs[indexPath.item];
    
    cell.deleteImageBlock = ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didSelectedToDeleteImage:)]) {
            [self.delegate cell:self didSelectedToDeleteImage:indexPath.item];
        }
    };
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didSelectedToPickImages:)]) {
        [self.delegate cell:self didSelectedToPickImages:nil];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (_hadWillDisplay) return;
    _hadWillDisplay = YES;
    CGSize contentSize = collectionView.contentSize;
    if (contentSize.height < 60.0f) contentSize.height = 60.0f;
    _collectionHeightConstraint.constant = collectionView.contentSize.height;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:willDisplayCell:)]) {
        [self.delegate cell:self willDisplayCell:contentSize.height];
    }
}

@end
