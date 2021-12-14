//
//  GoodsIDCardView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/9/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BasePopView.h"

@class GoodsIDCardView;
NS_ASSUME_NONNULL_BEGIN

@protocol GoodsIDCardViewDelegate <NSObject>

@optional

/// 分享
/// @param cardView cardView
/// @param type 0 微信 1 微信朋友圈
/// @param image 要分享的图片
- (void)cardView:(GoodsIDCardView *)cardView clickToShare:(NSInteger)type withImage:(UIImage *_Nullable)image;

/// 保存本地
/// @param cardView cardView
/// @param image idcard image
- (void)cardView:(GoodsIDCardView *)cardView clickToSaveLocal:(UIImage *_Nullable)image;

@end

@interface GoodsIDCardView : BasePopView

+ (GoodsIDCardView *)shareInstance:(NSString *_Nullable)idcardUrl delegate:(id <GoodsIDCardViewDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
