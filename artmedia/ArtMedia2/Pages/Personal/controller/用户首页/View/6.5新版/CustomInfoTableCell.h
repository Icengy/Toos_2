//
//  CustomInfoTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomPersonalModel;
NS_ASSUME_NONNULL_BEGIN

@class CustomInfoTableCell;
@protocol CustomInfoTableCellDelegate <NSObject>

@optional
- (void)headerView:(CustomInfoTableCell *)headView didClickToBack:(id _Nullable)sender;

/// 点击更多
- (void)headerView:(CustomInfoTableCell *)headView didClickToMore:(id _Nullable)sender;

/**
 点击关注
 */
- (void)headerView:(CustomInfoTableCell *)headView didClickToFollow:(id _Nullable)sender;

/**
 点击移除黑名单
 */
- (void)headerView:(CustomInfoTableCell *)headView didClickToRemoveBlack:(id _Nullable)sender;

/**
 编辑信息
 */
- (void)headerView:(CustomInfoTableCell *)headView didClickToEditInfo:(id _Nullable)sender;

@end

@interface CustomInfoTableCell : UITableViewCell

@property (nonatomic ,weak) id <CustomInfoTableCellDelegate> delegate;
@property (nonatomic ,strong) CustomPersonalModel *model;

@end

NS_ASSUME_NONNULL_END
