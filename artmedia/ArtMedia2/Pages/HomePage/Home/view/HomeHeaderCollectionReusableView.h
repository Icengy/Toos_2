//
//  HomeHeaderCollectionReusableView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/29.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoArtModel;
@class HomeInforModel;
@class HomeHeaderCollectionReusableView;
NS_ASSUME_NONNULL_BEGIN

@interface HomeBannerModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *addtime;
@property (nonatomic, copy) NSString *adsbanner;
@property (nonatomic, copy) NSString *adssort;
@property (nonatomic, copy) NSString *adsstate;
@property (nonatomic, copy) NSString *adstitle;
@property (nonatomic, copy) NSString *adstype;

@property (nonatomic, copy) NSString *picture_height;
@property (nonatomic, copy) NSString *picture_width;
@property (nonatomic, copy) NSString *slogan_type;

@property (nonatomic, copy) NSString *adsurlid;//跳转需要的ID，艺术家ID，视频ID
@property (nonatomic, copy) NSString *jump_type;//0.无跳转   2.商品   4.艺术家首页   6.短视频   7.http协议 8功能栏目（jump_id：1会客厅，2创作视频
@property (copy , nonatomic) NSString *jump_name;//类型是7，这个参数就是http链接，跳转webView

@end

@protocol HomeHeaderDelegate <NSObject>

@optional

/// 点击banner
- (void)homeHeader:(HomeHeaderCollectionReusableView *)header didSelectBannerItem:(HomeBannerModel *)bannerModel;
/// 点击艺术家
- (void)homeHeader:(HomeHeaderCollectionReusableView *)header didSelectArtsItem:(NSUInteger)artIndex;
/// 点击公告
- (void)homeHeader:(HomeHeaderCollectionReusableView *)header didSelectNoitceItem:(NSUInteger)noticeIndex;
/// 点击会客厅
- (void)homeHeader:(HomeHeaderCollectionReusableView *)header didSelectedMeeting:(id)sender;

@end

@interface HomeHeaderCollectionReusableView : UICollectionReusableView

@property (nonatomic ,weak) id <HomeHeaderDelegate> delegate;

@property (nonatomic ,strong) NSArray <HomeBannerModel *>*bannerImgUriArray;
@property (nonatomic ,strong) HomeBannerModel *adModel;
@property (nonatomic ,strong) NSArray <VideoArtModel *>*artsArray;
@property (nonatomic ,strong) NSArray <HomeInforModel *>*noticeArray;

@end

NS_ASSUME_NONNULL_END
