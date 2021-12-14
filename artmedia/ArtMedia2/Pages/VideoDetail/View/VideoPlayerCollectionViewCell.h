//
//  VideoPlayerCollectionViewCell.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/25.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AMVideoViewModel.h"
#import "AMVideoControlIerItemDelegate.h"
#import "AMVideoControlIerItemView.h"

@class VideoListModel;
@class VideoPlayerCollectionViewCell;
NS_ASSUME_NONNULL_BEGIN

@interface VideoPlayerCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id <VideoPlayerCellDelegate> delegate;
@property (nonatomic, weak) id <ZFSliderViewDelegate>  sliderDelegate;

@property (nonatomic, strong) VideoListModel *videoModel;

// 当前播放内容的视图
@property (nonatomic) AMVideoControlIerItemView      *controlView;
// 当前播放内容的索引
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@end

NS_ASSUME_NONNULL_END
