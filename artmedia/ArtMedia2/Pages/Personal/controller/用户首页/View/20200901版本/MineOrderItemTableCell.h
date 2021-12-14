//
//  MineOrderItemTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/9/2.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomPersonalUnreadOrderModel;
@class MineOrderItemTableCell;
NS_ASSUME_NONNULL_BEGIN

@protocol MineOrderItemDelegate <NSObject>

@required
/// index 0:待付款 1:待发货 2:待收货 3:已完成 4:退货
- (void)orderCell:(MineOrderItemTableCell *)walletCell didSelectedOrderCellWithIndex:(NSInteger)index;
- (void)orderCell:(MineOrderItemTableCell *)walletCell didSelectedToAll:(id)sender;

@end

@interface MineOrderItemTableCell : UITableViewCell

@property (nonatomic ,strong) CustomPersonalUnreadOrderModel *unreadModel;
@property (weak ,nonatomic) id <MineOrderItemDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
