//
//  AMTRTCVideoView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/8/20.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMMeetingRoomMemberModel;
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, VideoViewType) {
    VideoViewType_Local,
    VideoViewType_Remote,
};

@class AMTRTCVideoView;

@protocol AMTRTCVideoViewDelegate <NSObject>

@required
- (void)reloadUserStateWithModel:(AMMeetingRoomMemberModel *)model;

@optional
- (void)onMuteVideoBtnClick:(AMTRTCVideoView*)view stateChanged:(BOOL)stateChanged;
- (void)onMuteAudioBtnClick:(AMTRTCVideoView*)view stateChanged:(BOOL)stateChanged;
- (void)onViewTap:(AMTRTCVideoView*)view touchCount:(NSInteger)touchCount;
@end

@interface AMTRTCVideoView : UIImageView


+ (instancetype)newVideoViewWithType:(VideoViewType)type userId:( NSString  * _Nullable )userId;
+ (instancetype)newVideoViewWithType:(VideoViewType)type userId:(NSString *_Nullable )userId userName:(NSString * _Nullable)userName;

@property (nonatomic, weak) id<AMTRTCVideoViewDelegate> delegate;

@property (nonatomic, strong) AMMeetingRoomMemberModel *userModel;
/// 用户uid
@property (nonatomic, copy, readonly) NSString* userId;
/// 用户名
@property (nonatomic, copy) NSString* userName;
/// 视频类型 本地/远程
@property (nonatomic, assign, readonly) VideoViewType videoType;
/// 布局类型
@property (nonatomic, assign) TCLayoutType layoutType;

///是否是会主
@property (nonatomic, assign) BOOL isMaster;
/// 是否是自己
@property (nonatomic, assign) BOOL isSelf;
/// 是否显示网络信号强度
@property (nonatomic, assign) BOOL isShowNetworkIndicator;
/// 是否显示渐变
@property (nonatomic, assign) BOOL isShowGradinent;

- (void)hiddenTag:(BOOL)hidden;
- (void)setNetworkIndicatorImage:(UIImage *_Nullable)image;


@end

NS_ASSUME_NONNULL_END
