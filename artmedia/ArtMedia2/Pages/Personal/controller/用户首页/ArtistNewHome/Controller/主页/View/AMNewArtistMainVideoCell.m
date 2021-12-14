//
//  AMNewArtistMainVideoCell.m
//  ArtMedia2
//
//  Created by 刘洋 on 2020/9/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMNewArtistMainVideoCell.h"

#import "AMNewArtistMainVideoCollectionCell.h"

@interface AMNewArtistMainVideoCell ()<UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeight;

@end


@implementation AMNewArtistMainVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setCollectionView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setData:(NSMutableArray *)data {
    _data = data;
    self.collectionHeight.constant = ((data.count / 3) + ((data.count%3)?1:0)) *((K_Width - 30.0f -8.0f *3)/3 + 8);
    
    [self.collectionView reloadData];
}

- (void)setCollectionView {
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((K_Width - 30 -8.0f*3)/3, (K_Width - 30 -8.0f*3)/3);
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource =self;
    self.collectionView.scrollEnabled = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([AMNewArtistMainVideoCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([AMNewArtistMainVideoCollectionCell class])];
    
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.videoPlayBlock) {
        self.videoPlayBlock(self.data[indexPath.row]);
    }
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.data.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AMNewArtistMainVideoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AMNewArtistMainVideoCollectionCell class]) forIndexPath:indexPath];
    cell.model = self.data[indexPath.row];
    return cell;
}

@end
