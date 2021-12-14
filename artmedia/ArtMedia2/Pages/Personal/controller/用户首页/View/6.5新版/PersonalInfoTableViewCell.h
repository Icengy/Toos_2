//
//  PersonalInfoTableViewCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/9.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomPersonalModel;
NS_ASSUME_NONNULL_BEGIN

@protocol PersonalInfoItemDelegate <NSObject>
@required
/// 更换个人首页背景
/// @param sender sender
- (void)didSelectedInfoItemForChangeBg:(id)sender;

/// 点击个人头像
/// @param sender sender
- (void)didSelectedInfoItemForLogo:(id)sender;

/// 编辑信息
/// @param sender sender
- (void)didSelectedInfoItemForEditInfo:(id)sender;

/// 设置
/// @param sender sender
- (void)didSelectedInfoItemForSetting:(id)sender;

/// 消息中心
/// @param sender sender
- (void)didSelectedInfoItemForMessage:(id)sender;

/// 邀新
/// @param sender sender
- (void)didSelectedInfoItemForInvite:(id)sender;

/// 认证
/// @param sender sender
- (void)didSelectedInfoItemForIdentify:(id)sender;

/// 保证金
/// @param sender sender
- (void)didSelectedInfoItemForBond:(id)sender;

/// 点赞
/// @param sender sender
- (void)didSelectedInfoItemForThumbs:(id)sender;

/// 关注
/// @param sender sender
- (void)didSelectedInfoItemForFollow:(id)sender;

/// 粉丝
/// @param sender sender
- (void)didSelectedInfoItemForFans:(id)sender;

// 跳转会客详情
- (void)jumpTea_Meetting_Detail;

// 跳转开启会客
- (void)jumpTea_Meetting_Create;

// 跳转开启会客记录
- (void)jumpTea_Meetting_Record;

@end

@interface PersonalInfoTableViewCell : UITableViewCell

@property (nonatomic ,weak) id <PersonalInfoItemDelegate> delegate;
@property (nonatomic ,strong) CustomPersonalModel *model;

@end

NS_ASSUME_NONNULL_END
