//
//  ShortVideoEntranceViewController.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/24.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ShortVideoEntranceDelegate <NSObject>

@required
- (void)videoEntrance:(BaseViewController *)viewController clickToLogin:(id)sender;
- (void)videoEntrance:(BaseViewController *)viewController clickToAuth:(id)sender;

@optional
/// 点击拍摄
- (void)videoEntrance:(BaseViewController *)viewController clickToVideoShot:(id)sender;

/// 点击视频编辑 assets:选中的视频集合
- (void)videoEntrance:(BaseViewController *)viewController clickToVideoLoading:(id)sender;

/// 点击图片编辑 assets:选中的图片集合
- (void)videoEntrance:(BaseViewController *)viewController clickToImageLoading:(id)sender;

@end

@interface ShortVideoEntranceViewController : BaseViewController

@property (nonatomic ,weak) id <ShortVideoEntranceDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
