//
//  VideoPlayerViewController.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/25.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoPlayerViewController : BaseViewController

/// 播放形式
@property (nonatomic ,assign) MyVideoShowStyle style;
/// 播放位置
@property (nonatomic ,assign) NSInteger playIndex;
/// 视频列表接口
@property (nonatomic ,copy, nullable) NSString *urlStr;
/// 视频列表参数
@property (nonatomic ,strong, nullable) NSDictionary *params;

@property (nonatomic ,strong, nullable) NSArray *listVideos;
// 传入model数组，播放一组(个)视频，并指定播放位置 page用于加载更多
- (instancetype)initWithStyle:(MyVideoShowStyle)style videos:(NSArray *)videos playIndex:(NSInteger)playIndex listUrlStr:(NSString *_Nullable)urlStr params:(NSDictionary *_Nullable)params;


@property (nonatomic ,copy, nullable) NSString *videoID;
//传入单个视频id，播放单个视频
- (instancetype)initWithVideoID:(NSString *)videoID;

@end

NS_ASSUME_NONNULL_END
