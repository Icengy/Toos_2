//
//  ArtistHeadCell.h
//  ArtMedia2
//
//  Created by 刘洋 on 2020/9/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPersonalModel.h"
NS_ASSUME_NONNULL_BEGIN

@class ArtistHeadCell;

@protocol ArtistHeadCellDelegate <NSObject>

@optional
- (void)headButtonClick:(ArtistHeadCell *)cell buttonTitle:(NSString *)title;


- (void)headerView:(ArtistHeadCell *)headView didClickToBack:(id _Nullable)sender;

/// 点击更多
- (void)headerView:(ArtistHeadCell *)headView didClickToMore:(id _Nullable)sender;

/**
 点击关注
 */
- (void)headerView:(ArtistHeadCell *)headView didClickToFollow:(id _Nullable)sender;

/**
 点击移除黑名单
 */
- (void)headerView:(ArtistHeadCell *)headView didClickToRemoveBlack:(id _Nullable)sender;

/**
 点击编辑个人资料
 */
- (void)headerView:(ArtistHeadCell *)headView didClickToEditInfo:(id _Nullable)sender;

/**
 点击约见(预约)
 */
- (void)headerView:(ArtistHeadCell *)headView didClickToMeeting:(id _Nullable)sender;

/**
 点击约见设置
 */
- (void)headerView:(ArtistHeadCell *)headView didClickToMeetingSetting:(id _Nullable)sender;

@end

@interface ArtistHeadCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (nonatomic ,weak) id <ArtistHeadCellDelegate> delegate;
@property (nonatomic ,strong) CustomPersonalModel *model;
@property (nonatomic , assign) NSInteger orderStatus;//判断已约见还是未约见 1:可约见 2:已预约 3:不显示 4:未支付

@end

NS_ASSUME_NONNULL_END
