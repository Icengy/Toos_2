//
//  AMMeetingMasterManageView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/8/31.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BasePopView.h"
#import "HK_tea_managerModel.h"
typedef NS_ENUM(NSUInteger, AMMeetingMasterManageStyle) {
    /// 会客未开始
    AMMeetingMasterManageStyleDetault = 0,
    /// 会客已开始
    AMMeetingMasterManageStyleHadBegin
};

//typedef NS_ENUM(NSUInteger, AMMeetingMasterManageViewStyle) {
//    /// 编辑会客
//    AMMeetingMasterManageViewStyleEdit = 0,
//    /// 邀请列表
//    AMMeetingMasterManageViewStyleInviteList,
//    /// 取消会客
//    AMMeetingMasterManageViewStyleMeetingCancel
//};

NS_ASSUME_NONNULL_BEGIN

@class AMMeetingMasterManageView;
@protocol AMMeetingMasterManageViewDelegate <NSObject>

@required
- (void)manageView:(AMMeetingMasterManageView *)manageView didSelectedItemForInviteList:(id)sender;

@optional
- (void)manageView:(AMMeetingMasterManageView *)manageView didSelectedItemForCancel:(id)sender;
- (void)manageView:(AMMeetingMasterManageView *)manageView didSelectedItemForMeetingCancel:(id)sender;
- (void)manageView:(AMMeetingMasterManageView *)manageView didSelectedItemForEdit:(id)sender;

@end

@interface AMMeetingMasterManageView : BasePopView

@property (nonatomic ,weak) id <AMMeetingMasterManageViewDelegate> delegate;
@property (nonatomic ,assign) AMMeetingMasterManageStyle style;
@property (nonatomic , strong) HK_tea_managerModel *model;
@end

NS_ASSUME_NONNULL_END
