//
//  AMMeetingMemberViewController.h
//  ArtMedia2
//
//  Created by icnengy on 2020/8/19.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BaseViewController.h"

@class LS_TRTCParams;
@class AMTRTCVideoView;
@class AMMeetingRoomMemberModel;
@class AMMeetingMemberViewController;
NS_ASSUME_NONNULL_BEGIN

@protocol AMMeetingMemberControllerDelegate <NSObject>

@optional
- (void)memberController:(AMMeetingMemberViewController *)memberController didSelected:(AMButton *)sender onVideoWithModel:(AMMeetingRoomMemberModel *)model;
- (void)memberController:(AMMeetingMemberViewController *)memberController didSelected:(AMButton *)sender onAudioWithModel:(AMMeetingRoomMemberModel *)model;

@end

@interface AMMeetingMemberViewController : BaseViewController

@property (weak, nonatomic) id <AMMeetingMemberControllerDelegate> delegate;
@property (assign, nonatomic) AMMeetingMemberStyle style;
@property (strong, nonatomic) LS_TRTCParams *params;

@property (strong, nonatomic) NSArray <AMMeetingRoomMemberModel *>*totalMembers;

@end

NS_ASSUME_NONNULL_END
