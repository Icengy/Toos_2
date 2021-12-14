//
//  MineInfoTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/9/2.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MineInfoTableCell;
@class CustomPersonalModel;
NS_ASSUME_NONNULL_BEGIN

@protocol MineInfoTableCellDelegate <NSObject>

@required

/// 更换背景图
- (void)infoCell:(MineInfoTableCell *)infoCell selectedForChangeBackgroundImage:(id)sender;
/// 点击用户头像
- (void)infoCell:(MineInfoTableCell *)infoCell selectedForLogo:(id)sender;

/// 点击子项
/// @param index 0:视频 1:喜欢 2:关注 3:粉丝
- (void)infoCell:(MineInfoTableCell *)infoCell selectedForItemAtIndex:(NSInteger)index;
/// 点击设置
- (void)infoCell:(MineInfoTableCell *)infoCell selectedForSetting:(id)sender;
/// 点击邀请好友
- (void)infoCell:(MineInfoTableCell *)infoCell selectedForInviteFriends:(id)sender;
/// 点击编辑
- (void)infoCell:(MineInfoTableCell *)infoCell selectedForEdit:(id)sender;
///点击认证
- (void)infoCell:(MineInfoTableCell *)infoCell selectedForAuth:(id)sender;
///点击前往艺术之家
- (void)infoCell:(MineInfoTableCell *)infoCell selectedForArtManage:(id)sender;

@end

@interface MineInfoTableCell : UITableViewCell

@property (nonatomic, weak) id <MineInfoTableCellDelegate> delegate;
@property (nonatomic, strong) CustomPersonalModel *model;

@end

NS_ASSUME_NONNULL_END
