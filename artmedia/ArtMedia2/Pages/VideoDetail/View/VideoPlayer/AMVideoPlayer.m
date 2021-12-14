//
//  AMVideoPlayer.m
//  AMVideo
//
//  Created by QuintGao on 2018/9/23.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import "AMVideoPlayer.h"

@import TXLiteAVSDK_Professional;
@interface AMVideoPlayer()<TXVodPlayListener>

@property (nonatomic, strong) TXVodPlayer   *player;

@property (nonatomic, assign) float         duration;

@property (nonatomic, assign) BOOL          isNeedResume;

@end

static AMVideoPlayer *_sharedSingleton = nil;
static dispatch_once_t onceToken;

@implementation AMVideoPlayer

+ (instancetype)sharedSingleton {
	dispatch_once(&onceToken, ^{
		//不能再使用alloc方法
		//因为已经重写了allocWithZone方法，所以这里要调用父类的分配空间的方法
		_sharedSingleton = [[super allocWithZone:NULL] init];
	});
	return _sharedSingleton;
}

// 防止外部调用alloc 或者 new
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
	return [AMVideoPlayer sharedSingleton];
}

// 防止外部调用copy
- (id)copyWithZone:(nullable NSZone *)zone {
	return [AMVideoPlayer sharedSingleton];
}

// 防止外部调用mutableCopy
- (id)mutableCopyWithZone:(nullable NSZone *)zone {
	return [AMVideoPlayer sharedSingleton];
}

- (instancetype)init {
    if (self = [super init]) {
        // 监听APP退出后台及进入前台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark - Notification
// APP退出到后台
- (void)appDidEnterBackground:(NSNotification *)notify {
    if (self.status == AMVideoPlayerStatusLoading || self.status == AMVideoPlayerStatusPlaying) {
        [self pausePlay];
        
        self.isNeedResume = YES;
    }
}

// APP进入前台
- (void)appWillEnterForeground:(NSNotification *)notify {
    if (self.isNeedResume && self.status == AMVideoPlayerStatusPaused) {
        self.isNeedResume = NO;
        
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self resumePlay];
        });
    }
}

#pragma mark - Public Methods
- (void)playVideoWithView:(UIView *)playView url:(NSString *)url {
    // 设置播放视图
    [self.player setupVideoWidget:playView insertIndex:0];
    
    // 准备播放
    [self playerStatusChanged:AMVideoPlayerStatusPrepared];
    
    // 开始播放
    if ([self.player startPlay:url] == 0) {
        // 这里可加入缓冲视图
    }else {
        [self playerStatusChanged:AMVideoPlayerStatusError];
    }
}

- (void)removeVideo {
    // 停止播放
    [self.player stopPlay];
    
    // 移除播放视图
    [self.player removeVideoWidget];
	
    // 改变状态
    [self playerStatusChanged:AMVideoPlayerStatusUnload];
}

- (void)pausePlay {
    [self playerStatusChanged:AMVideoPlayerStatusPaused];
    
    [self.player pause];
}

- (void)resumePlay {
    if (self.status == AMVideoPlayerStatusPaused) {
        [self.player resume];
        [self playerStatusChanged:AMVideoPlayerStatusPlaying];
    }
}

- (void)resetPlay {
    [self.player resume];
    [self playerStatusChanged:AMVideoPlayerStatusPlaying];
}

- (void)deallocPlay {
	onceToken = 0; // 只有置成0,GCD才会认为它从未执行过.它默认为0.这样才能保证下次再次调用shareInstance的时候,再次创建对象.
	_sharedSingleton = nil;
}

- (BOOL)isPlaying {
    return self.player.isPlaying;
}

/**
 滑块滑动播放
 */
- (void)seekPlay:(CGFloat)sliderValue {
    [self.player seek:sliderValue];
}

#pragma mark - Private Methods
- (void)playerStatusChanged:(AMVideoPlayerStatus)status {
    self.status = status;
    
    if ([self.delegate respondsToSelector:@selector(player:statusChanged:)]) {
        [self.delegate player:self statusChanged:status];
    }
}

- (NSString *)jsonStringFromDic:(NSDictionary *)dic {
    NSString *jsonStr = nil;
    
    if ([NSJSONSerialization isValidJSONObject:dic]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        
        jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonStr;
}

#pragma mark - TXVodPlayListener
- (void)onPlayEvent:(TXVodPlayer *)player event:(int)EvtID withParam:(NSDictionary *)param {
    switch (EvtID) {
//        case PLAY_EVT_CHANGE_RESOLUTION: {  // 视频分辨率改变
//            float width  = [param[@"EVT_PARAM1"] floatValue];
//            float height = [param[@"EVT_PARAM2"] floatValue];
//
//            if (width > height) {
//                [player setRenderMode:RENDER_MODE_FILL_EDGE];
//            }else {
//                [player setRenderMode:RENDER_MODE_FILL_EDGE];
//            }
//        }
//            break;
        case PLAY_EVT_PLAY_LOADING:{    // loading
            if (self.status == AMVideoPlayerStatusPaused) {
                [self playerStatusChanged:AMVideoPlayerStatusPaused];
            }else {
                [self playerStatusChanged:AMVideoPlayerStatusLoading];
            }
        }
            break;
        case PLAY_EVT_PLAY_BEGIN:{    // 开始播放
            [self playerStatusChanged:AMVideoPlayerStatusPlaying];
        }
            break;
        case PLAY_EVT_PLAY_END:{    // 播放结束
            if ([self.delegate respondsToSelector:@selector(player:currentTime:totalTime:progress:)]) {
                [self.delegate player:self currentTime:self.duration totalTime:self.duration progress:1.0f];
            }
            
            [self playerStatusChanged:AMVideoPlayerStatusEnded];
        }
            break;
        case PLAY_ERR_NET_DISCONNECT:{    // 失败，多次重连无效
            [self playerStatusChanged:AMVideoPlayerStatusError];
        }
            break;
        case PLAY_EVT_PLAY_PROGRESS:{    // 进度
            if (self.status == AMVideoPlayerStatusPlaying) {
                self.duration = [param[EVT_PLAY_DURATION] floatValue];
                
                float currTime = [param[EVT_PLAY_PROGRESS] floatValue];
                
                float progress = self.duration == 0 ? 0 : currTime / self.duration;
                
                if ([self.delegate respondsToSelector:@selector(player:currentTime:totalTime:progress:)]) {
                    [self.delegate player:self currentTime:currTime totalTime:self.duration progress:progress];
                }
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)onNetStatus:(TXVodPlayer *)player withParam:(NSDictionary *)param {
    
}

#pragma mark - 懒加载
- (TXVodPlayer *)player {
    if (!_player) {
        _player = [TXVodPlayer new];
        _player.vodDelegate = self;
        [_player setRenderMode:RENDER_MODE_FILL_EDGE];
    }
    return _player;
}

@end
