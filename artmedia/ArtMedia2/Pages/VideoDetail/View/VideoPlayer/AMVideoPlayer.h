//
//  AMVideoPlayer.h
//  AMVideo
//
//  Created by QuintGao on 2018/9/23.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, AMVideoPlayerStatus) {
    AMVideoPlayerStatusUnload,      // 未加载
    AMVideoPlayerStatusPrepared,    // 准备播放
    AMVideoPlayerStatusLoading,     // 加载中
    AMVideoPlayerStatusPlaying,     // 播放中
    AMVideoPlayerStatusPaused,      // 暂停
    AMVideoPlayerStatusEnded,       // 播放完成
    AMVideoPlayerStatusError        // 错误
};

@class AMVideoPlayer;

@protocol AMVideoPlayerDelegate <NSObject>

- (void)player:(AMVideoPlayer *)player statusChanged:(AMVideoPlayerStatus)status;

- (void)player:(AMVideoPlayer *)player currentTime:(float)currentTime totalTime:(float)totalTime progress:(float)progress;

@end

@interface AMVideoPlayer : NSObject

@property (nonatomic, weak) id<AMVideoPlayerDelegate>     delegate;

@property (nonatomic, assign) AMVideoPlayerStatus         status;

@property (nonatomic, assign) BOOL                          isPlaying;

+ (instancetype)sharedSingleton;

/**
 根据指定url在指定视图上播放视频
 
 @param playView 播放视图
 @param url 播放地址
 */
- (void)playVideoWithView:(UIView *)playView url:(NSString *)url;

/**
 停止播放并移除播放视图
 */
- (void)removeVideo;

/**
 暂停播放
 */
- (void)pausePlay;

/**
 恢复播放
 */
- (void)resumePlay;

/**
 重新播放
 */
- (void)resetPlay;


/**
 销毁播放器，当页面退出时调用
 */
- (void)deallocPlay;

/**
 滑块滑动播放
 */
- (void)seekPlay:(CGFloat)sliderValue;

@end

NS_ASSUME_NONNULL_END
