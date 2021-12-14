//
//  ArtManagerMenuTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/9/3.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ArtManagerMenuItemIndex) {
    ArtManagerMenuItemIndexIncome = 0,     //我的收入
    ArtManagerMenuItemIndexAgentAccount,       //经纪人账户
    ArtManagerMenuItemIndexSale,        //销售订单
    ArtManagerMenuItemIndexMeetingManage,   //会客管理
    ArtManagerMenuItemIndexMeetingAppointmentManage, // 约见管理
    ArtManagerMenuItemIndexHelp // 帮助中心
};

@class ArtManagerMenuTableCell;
NS_ASSUME_NONNULL_BEGIN

@protocol ArtManagerMenuItemDelegate <NSObject>

@required
/// 点击菜单 index ArtManagerMenuItemIndex
- (void)menuCell:(ArtManagerMenuTableCell *)menuCell didSelectedMenuItemWithIndex:(ArtManagerMenuItemIndex)index;

@end

@interface ArtManagerMenuTableCell : UITableViewCell
@property (weak, nonatomic) id <ArtManagerMenuItemDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
