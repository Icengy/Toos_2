//
//  GoodsPartBannerView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/7/22.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsPartBannerView;
NS_ASSUME_NONNULL_BEGIN

@protocol GoodsPartBannerDelegate <NSObject>

@optional
- (void)bannerView:(GoodsPartBannerView *)bannerView didSelectBannerWithIndex:(NSInteger)index;
- (void)bannerView:(GoodsPartBannerView *)bannerView didSelectedBack:(id _Nullable)sender;
- (void)bannerView:(GoodsPartBannerView *)bannerView didSelectedShare:(id _Nullable)sender;
- (void)bannerView:(GoodsPartBannerView *)bannerView didSelectedIDCard:(id _Nullable)sender;
- (void)bannerView:(GoodsPartBannerView *)bannerView didSelectedEdit:(id _Nullable)sender;

@end

@interface GoodsPartBannerView : UIView

@property (nonatomic ,weak) id <GoodsPartBannerDelegate> delegate;

@property (nonatomic ,strong) UserInfoModel *model;
/// 是否已出售
@property (nonatomic ,assign) BOOL status;

@property (nonatomic ,strong) NSArray *bannerImgUriArray;

@property (nonatomic ,strong) NSArray <NSString *>*bannerUrl;

@end

NS_ASSUME_NONNULL_END
