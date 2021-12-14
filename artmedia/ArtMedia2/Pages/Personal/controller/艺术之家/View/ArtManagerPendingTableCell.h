//
//  ArtManagerPendingTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/9/3.
//  Copyright © 2020 翁磊. All rights reserved.
//
// 待处理模块
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ArtManagerPendingMenuItemIndex) {
    ArtManagerPendingMenuItemIndexOrderDaiFaHuo = 0,      //待发货订单
    ArtManagerPendingMenuItemIndexOrderDaiTuiHuo,           //待处理退货
    ArtManagerPendingMenuItemIndexMeetingDaiYueJian,           //待处理约见
    ArtManagerPendingMenuItemIndexMeetingDaiHuiKe            //待开始会客
};

@class ArtManagerPendingTableCell;
NS_ASSUME_NONNULL_BEGIN

@protocol ArtManagerPendingMenuItemDelegate <NSObject>

@required
/// 点击未完成菜单 index ArtManagerPendingMenuItemIndex
- (void)pendingMenuCell:(ArtManagerPendingTableCell *)pendingMenuCell didSelectedMenuItemWithIndex:(ArtManagerPendingMenuItemIndex)index;

@end

@interface ArtManagerPendingTableCell : UITableViewCell

@property (weak, nonatomic) id <ArtManagerPendingMenuItemDelegate> delegate;
/// 待处理约见
@property (nonatomic ,assign) NSInteger wait_deal_appointment;
/// 待处理会客
@property (nonatomic ,assign) NSInteger wait_deal_meeting;
/// 待处理退货数量
@property (nonatomic ,assign) NSInteger wait_deal_refund_num;
/// 待发货数量
@property (nonatomic ,assign) NSInteger wait_deliver_num;

@end

NS_ASSUME_NONNULL_END
