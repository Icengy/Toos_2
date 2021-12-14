//
//  HomeHeaderCollectionReusableView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/29.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "HomeHeaderCollectionReusableView.h"

#import <SDCycleScrollView.h>
#import <GYRollingNoticeView.h>

#import "RecommendArtsCollectionCell.h"
#import "HomeNoticeCell.h"

#import "VideoArtModel.h"
#import "HomeInforModel.h"

@implementation HomeBannerModel

@end

#pragma mark -
@interface HomeHeaderCollectionReusableView () <UICollectionViewDelegate, UICollectionViewDataSource, GYRollingNoticeViewDelegate, GYRollingNoticeViewDataSource, SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bannerCarrier;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerCarrier_height_constraint;

@property (weak, nonatomic) IBOutlet SDCycleScrollView *bannerView;

@property (weak, nonatomic) IBOutlet UIView *artsContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *artsContentTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *artsTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *artsTitleHeightConstraint;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic ,strong) UICollectionViewFlowLayout *layout;

@property (weak, nonatomic) IBOutlet UIView *noticeContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noticeContentTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noticeContentHeightConstraint;
@property (weak, nonatomic) IBOutlet GYRollingNoticeView *noticeView;

@property (weak, nonatomic) IBOutlet AMButton *toMeetingBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toMeeting_height_constraint;


@property (weak, nonatomic) IBOutlet UIView *marignView;

@end

@implementation HomeHeaderCollectionReusableView

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];

        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.itemSize = CGSizeMake(_collectionView.height - ADAptationMargin, _collectionView.height - ADAptationMargin);
        _layout.minimumLineSpacing = ADAptationMargin;
        _layout.minimumInteritemSpacing = CGFLOAT_MIN;
        _layout.sectionInset = UIEdgeInsetsMake(0.0f, ADAptationMargin, ADAptationMargin, ADAptationMargin);

    }return _layout;
}

- (void)dealloc {
    if (_noticeView) {
        [_noticeView stopRoll];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _bannerView.delegate = self;
    _bannerView.showPageControl = YES;
    _bannerView.pageControlDotSize = CGSizeMake(8.0, 8.0);
    _bannerView.pageDotColor = Color_Whiter;
    _bannerView.currentPageDotColor = UIColorFromRGB(0xC92F2F);
    _bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    _bannerView.hidesForSinglePage = YES;
    _bannerView.autoScrollTimeInterval = 3.0;
    _bannerView.placeholderImage = ImageNamed(@"PersonalDefaultHeader");
    
    //背景色
    _bannerView.backgroundColor = Color_Whiter;
    //是否自动滚动, 默认YES
    _bannerView.autoScroll = YES;
    //轮播图片的ContentMode, 默认为UIViewContentModeScaleToFill
    //        _bannerView.bannerImageViewContentMode = UIViewContentModeCenter;
    //是否无限循环,默认YES: 滚动到第四张图就不再滚动了
    _bannerView.infiniteLoop = YES;
    //翻页的位置
    _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    
    _collectionView.collectionViewLayout = self.layout;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.alwaysBounceHorizontal = YES;
    
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RecommendArtsCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([RecommendArtsCollectionCell class])];
    
    _noticeView.delegate = self;
    _noticeView.dataSource = self;
    _noticeView.stayInterval = 3.0f;
    [_noticeView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeNoticeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HomeNoticeCell class])];
}

- (void)setBannerImgUriArray:(NSArray<HomeBannerModel *> *)bannerImgUriArray {
    _bannerImgUriArray = bannerImgUriArray;
    if (_bannerImgUriArray.count) {
        _bannerCarrier.hidden = NO;
        
        HomeBannerModel *model = _bannerImgUriArray.firstObject;
        if (model && model.picture_width.doubleValue != 0) {
            _bannerCarrier_height_constraint.constant = K_Width *( model.picture_height.doubleValue/model.picture_width.doubleValue);
        }else
            _bannerCarrier_height_constraint.constant = 0.0f;
        
        NSMutableArray *bannerUrls = [NSMutableArray new];
        [_bannerImgUriArray enumerateObjectsUsingBlock:^(HomeBannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [bannerUrls insertObject:obj.adsbanner atIndex:bannerUrls.count];
        }];
        _bannerView.imageURLStringsGroup = bannerUrls.copy;
    }else {
        _bannerCarrier.hidden = YES;
        _bannerCarrier_height_constraint.constant = 0.0f;
    }
}

- (void)setAdModel:(HomeBannerModel *)adModel {
    _adModel = adModel;
    
    if (_adModel) {
        _toMeetingBtn.hidden = NO;
        _toMeetingBtn.imageView.contentMode = UIViewContentModeScaleToFill;
        
        if (_adModel && _adModel.picture_width.doubleValue != 0) {
            _toMeeting_height_constraint.constant = K_Width *( _adModel.picture_height.doubleValue/_adModel.picture_width.doubleValue);
        }else
            _toMeeting_height_constraint.constant = 0.0f;
        
        [[UIImageView new] am_setImageWithURL:_adModel.adsbanner placeholderImage:ImageNamed(@"home_ad_2") contentMode:UIViewContentModeScaleToFill completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [_toMeetingBtn setImage:image forState:UIControlStateNormal];
        }];
    }else {
        _toMeetingBtn.hidden = YES;
        _toMeeting_height_constraint.constant = 0.0f;
    }
}

- (void)setArtsArray:(NSArray<VideoArtModel *> *)artsArray {
    _artsArray = artsArray;
    if (_artsArray.count) {
        _artsContentView.hidden = NO;
        _artsContentTopConstraint.constant = ADAptationMargin;
        _artsTitleHeightConstraint.constant = 40.0f;
        [self.collectionView reloadData];
    }else {
        _artsContentView.hidden = YES;
        _artsContentTopConstraint.constant = 0.0f;
        _artsTitleHeightConstraint.constant = 0.0f;
    }
}

- (void)setNoticeArray:(NSArray <HomeInforModel *>*)noticeArray {
    _noticeArray = noticeArray;
    if (_noticeArray.count) {
        _noticeContentView.hidden = NO;
        _noticeContentHeightConstraint.constant = 50.0f;
        _noticeContentTopConstraint.constant = ADAptationMargin;
        [_noticeView reloadDataAndStartRoll];
    }else {
        _noticeContentView.hidden = YES;
        _noticeContentHeightConstraint.constant = 0.0f;
        _noticeContentTopConstraint.constant = 0.0f;
        [_noticeView stopRoll];
    }
}

#pragma mark -
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    HomeBannerModel *model = [self.bannerImgUriArray objectAtIndex:index];
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeHeader:didSelectBannerItem:)]) {
        [self.delegate homeHeader:self didSelectBannerItem:model];
    }
}

#pragma mark -
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.artsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RecommendArtsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RecommendArtsCollectionCell class]) forIndexPath:indexPath];
    
    cell.artModel = self.artsArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeHeader:didSelectArtsItem:)]) {
        [self.delegate homeHeader:self didSelectArtsItem:indexPath.item];
    }
}

#pragma mark -
- (NSInteger)numberOfRowsForRollingNoticeView:(GYRollingNoticeView *)rollingView {
    return self.noticeArray.count;
}

- (GYNoticeViewCell *)rollingNoticeView:(GYRollingNoticeView *)rollingView cellAtIndex:(NSUInteger)index {
    HomeNoticeCell *cell = [rollingView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeNoticeCell class])];
    cell.noticeModel = self.noticeArray[index];
    return cell;
}

- (void)didClickRollingNoticeView:(GYRollingNoticeView *)rollingView forIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeHeader:didSelectNoitceItem:)]) {
        [self.delegate homeHeader:self didSelectNoitceItem:index];
    }
}

#pragma mark -
- (IBAction)clickToMeeting:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeHeader:didSelectBannerItem:)]) {
        [self.delegate homeHeader:self didSelectBannerItem:self.adModel];
    }
}

@end
