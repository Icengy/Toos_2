//
//  AMVideoControlIerItemView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/10/28.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AMVideoControlIerItemDelegate.h"

@class VideoListModel;
@class GKSliderView;
@class AMVideoControlIerItemView;

NS_ASSUME_NONNULL_BEGIN
@interface AMVideoControlIerItemView : UIView

@property (nonatomic, weak) id <AMVideoControlIerItemViewDelegate>  delegate;
@property (nonatomic, weak) id <ZFSliderViewDelegate>  sliderDelegate;

@property (nonatomic, strong) VideoListModel        *model;

// 视频封面图:显示封面并播放视频
@property (nonatomic) UIImageView           *coverImgView;
@property (nonatomic) GKSliderView          *sliderView;

- (void)startLoading;
- (void)stopLoading;

- (void)showPlayBtn;
- (void)hidePlayBtn;

- (void)setProgress:(float)progress;
- (void)setCurrentTime:(float)currentTime totalTime:(float)totalTime progress:(float)progress;

@end

NS_ASSUME_NONNULL_END
