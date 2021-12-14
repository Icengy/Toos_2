//
//  AMAuctionShoppingCartTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/11/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMAuctionBaseTableCell.h"

@class AMAuctionOrderBusinessModel;
@class AMAuctionLotModel;
NS_ASSUME_NONNULL_BEGIN

@class AMAuctionShoppingCartTableCell;
@protocol AMAuctionShoppingCartCellDelegate <NSObject>

@optional
- (void)shoppingCartCell:(AMAuctionShoppingCartTableCell *)cartCell didClickToSelected:(AMButton *)sender;

@end

@interface AMAuctionShoppingCartTableCell : AMAuctionBaseTableCell

@property (nonatomic, weak) id <AMAuctionShoppingCartCellDelegate> delegate;
@property (nonatomic, assign) BOOL hiddenBottomMargin;
@property (strong, nonatomic) AMAuctionLotModel *model;
- (void)fillData:(AMAuctionOrderBusinessModel *)model atIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
