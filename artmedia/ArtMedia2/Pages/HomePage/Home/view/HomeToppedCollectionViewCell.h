//
//  HomeToppedCollectionViewCell.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/19.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoListModel;
NS_ASSUME_NONNULL_BEGIN

@interface HomeToppedCollectionViewCell : UICollectionViewCell

@property (nonatomic ,strong) VideoListModel *model;

@property(nonatomic,copy) void(^clickToCollectBlock)(VideoListModel *model);
@property(nonatomic,copy) void(^clickToThumbsBlock)(VideoListModel *model);
@property(nonatomic,copy) void(^clickToShowMenu)(VideoListModel *model);
///访问商品页面
@property(nonatomic,copy) void(^clickToShoppingBlock)(VideoListModel *model);
///访问他人首页
@property(nonatomic,copy) void(^clickToVisitBlock)(VideoListModel *model);
@property(nonatomic,copy) void(^clickToPlayBlock)(VideoListModel *model);

@end

NS_ASSUME_NONNULL_END
