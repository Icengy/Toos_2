//
//  MineAuctionItemTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/11/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MineAuctionItemTableCell;
NS_ASSUME_NONNULL_BEGIN
@protocol MineAuctionItemDelegate <NSObject>

@required
/// index 0:未结拍品 1:pm订单 2:参拍记录 3:保证金
- (void)auctionCell:(MineAuctionItemTableCell *)auctionCell didSelectedAuctionCellWithIndex:(NSInteger)index;

@end

@interface MineAuctionItemTableCell : UITableViewCell

@property (weak ,nonatomic) id <MineAuctionItemDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
