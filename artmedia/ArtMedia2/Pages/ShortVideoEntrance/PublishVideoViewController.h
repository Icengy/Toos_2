//
//  PublishVideoViewController.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/24.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "BaseViewController.h"

@class VideoListModel;
@class AMVideoEditer;
NS_ASSUME_NONNULL_BEGIN

@interface PublishVideoViewController : BaseViewController
/// 视频编辑工具
@property (nonatomic, strong) AMVideoEditer *   videoEdit;

/// 视频model
@property (nonatomic ,strong) VideoListModel *videoModel;

@end

NS_ASSUME_NONNULL_END
