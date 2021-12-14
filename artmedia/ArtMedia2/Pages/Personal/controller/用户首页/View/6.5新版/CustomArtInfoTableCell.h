//
//  CustomArtInfoTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/7/8.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomPersonalModel;
NS_ASSUME_NONNULL_BEGIN

@class CustomArtInfoTableCell;
@protocol CustomArtInfoTableCellDelegate <NSObject>

@optional
- (void)headerView:(CustomArtInfoTableCell *)headView didClickToBack:(id _Nullable)sender;

/// 点击更多
- (void)headerView:(CustomArtInfoTableCell *)headView didClickToMore:(id _Nullable)sender;

/**
 点击关注
 */
- (void)headerView:(CustomArtInfoTableCell *)headView didClickToFollow:(id _Nullable)sender;

/**
 点击移除黑名单
 */
- (void)headerView:(CustomArtInfoTableCell *)headView didClickToRemoveBlack:(id _Nullable)sender;

/**
 点击编辑个人资料
 */
- (void)headerView:(CustomArtInfoTableCell *)headView didClickToEditInfo:(id _Nullable)sender;

/**
 点击约见(预约)
 */
- (void)headerView:(CustomArtInfoTableCell *)headView didClickToMeeting:(id _Nullable)sender;

/**
 点击约见设置
 */
- (void)headerView:(CustomArtInfoTableCell *)headView didClickToMeetingSetting:(id _Nullable)sender;

@end

@interface CustomArtInfoTableCell : UITableViewCell

@property (nonatomic ,weak) id <CustomArtInfoTableCellDelegate> delegate;
@property (nonatomic ,strong) CustomPersonalModel *model;

@end

NS_ASSUME_NONNULL_END
