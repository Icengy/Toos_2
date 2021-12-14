//
//  AMMeetingSettingBView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/8/18.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMMeetingSettingBView.h"

#import "AMMeetingSettingBondCollectionCell.h"

@implementation AMMeetingBondModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"id":@[@"basicTeaPriceId", @"id"],
             };
}

@end

@interface AMMeetingSettingBView () <UICollectionViewDelegate ,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionView_height_constraint;

@property (weak, nonatomic) IBOutlet UIView *currentView;
@property (weak, nonatomic) IBOutlet UILabel *currentLabel;

@property (nonatomic ,assign) NSInteger selectedIndex;

@end

@implementation AMMeetingSettingBView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((K_Width - 15.0f*3)/2, 55.0f);
    layout.sectionInset = UIEdgeInsetsMake(0, 15.0f, 0, 15.0f);
    layout.minimumLineSpacing = 15.0f;
    layout.minimumInteritemSpacing = 15.0f;
    
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([AMMeetingSettingBondCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([AMMeetingSettingBondCollectionCell class])];
}

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

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    if (_selectedIndex < [self.collectionView numberOfItemsInSection:0]) {
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedIndex inSection:0] animated:YES scrollPosition:(UICollectionViewScrollPositionNone)];
    }
}

- (void)setPriceStr:(NSString *)priceStr {
    _priceStr = priceStr;
    _currentView.hidden = ![ToolUtil isEqualToNonNull:_priceStr];
    _currentLabel.text = [NSString stringWithFormat:@"¥%.2f/人", _priceStr.doubleValue];
}

- (void)reloadData {
    
    NSInteger index = _dataArray.count/2 + _dataArray.count%2;
    CGFloat height = 55.0f *index + 15.0f *(index - 1) + 44.0f;
    if (self.delegate && [self.delegate respondsToSelector:@selector(settingBCell:didLoadItemsToHeight:)]) {
        [self.delegate settingBCell:self didLoadItemsToHeight:height];
    }
    [self.collectionView reloadData];
    
    if ([ToolUtil isEqualToNonNull:self.priceStr]) {
        __block NSInteger index = 0;
        [_dataArray enumerateObjectsUsingBlock:^(AMMeetingBondModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.teaPrice isEqualToString:_priceStr]) {
                index = idx;
            }
        }];
        self.selectedIndex = index;
    }
}

#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AMMeetingSettingBondCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AMMeetingSettingBondCollectionCell class]) forIndexPath:indexPath];
    
    if (_dataArray.count) cell.bondNum = _dataArray[indexPath.item].teaPrice;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:(UICollectionViewScrollPositionNone)];
    if (indexPath.item != _selectedIndex) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(settingBCell:didSelectedItem:)]) {
            [self.delegate settingBCell:self didSelectedItem:_dataArray[indexPath.item].teaPrice];
        }
    }
}

@end
