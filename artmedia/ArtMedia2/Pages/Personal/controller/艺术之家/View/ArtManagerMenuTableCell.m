//
//  ArtManagerMenuTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/9/3.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "ArtManagerMenuTableCell.h"

#import "ArtManagerMenuItemCollectionCell.h"

#define ArtManagerMenuItemWidth  ((K_Width-20.0f)/3)
#define ArtManagerMenuItemHeight  80
@interface ArtManagerMenuTableCell () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collection_hegiht_constraint;

@end

@implementation ArtManagerMenuTableCell {
    NSArray *_titleArray, *_imageArray;
}

- (instancetype) initWithCoder:(NSCoder *)coder {
    if ([super initWithCoder:coder]) {
        _titleArray = @[@"我的收入", @"经纪人账户", @"销售订单", @"会客管理", @"约见管理",@"帮助中心"];
        NSMutableArray *imageArray = @[].mutableCopy;
        [_titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [imageArray addObject:[NSString stringWithFormat:@"am_%@",obj]];
        }];
        _imageArray = imageArray.copy;
    }return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _collection_hegiht_constraint.constant = ArtManagerMenuItemHeight *2;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(ArtManagerMenuItemWidth, ArtManagerMenuItemHeight);
    layout.minimumLineSpacing = CGFLOAT_MIN;
    layout.minimumInteritemSpacing = CGFLOAT_MIN;
    layout.sectionInset = UIEdgeInsetsZero;
    
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ArtManagerMenuItemCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([ArtManagerMenuItemCollectionCell class])];
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

#pragma mark -
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _titleArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ArtManagerMenuItemCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ArtManagerMenuItemCollectionCell class]) forIndexPath:indexPath];
    
    cell.titleStr = [_titleArray objectAtIndex:indexPath.item];
    cell.imageStr = [_imageArray objectAtIndex:indexPath.item];
    @weakify(self)
    cell.selectedItemBlock = ^(id  _Nonnull sender) {
        @strongify(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(menuCell:didSelectedMenuItemWithIndex:)]) {
            [self.delegate menuCell:self didSelectedMenuItemWithIndex:(ArtManagerMenuItemIndex)indexPath.item];
        }
    };
    
    return cell;
}

@end
