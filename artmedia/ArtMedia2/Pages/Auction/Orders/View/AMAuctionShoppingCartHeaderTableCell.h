//
//  AMAuctionShoppingCartHeaderTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/11/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMAuctionBaseTableCell.h"

@class AMAuctionOrderBusinessModel;
NS_ASSUME_NONNULL_BEGIN


@class AMAuctionShoppingCartHeaderTableCell;
@protocol AMAuctionShoppingCartHeaderDelegate <NSObject>

@optional
- (void)shoppingCartHeaderCell:(AMAuctionShoppingCartHeaderTableCell *)headerCell didClickToSelected:(AMButton *)sender;

@end

@interface AMAuctionShoppingCartHeaderTableCell : AMAuctionBaseTableCell

@property (nonatomic, weak) id <AMAuctionShoppingCartHeaderDelegate> delegate;
@property (nonatomic, assign) BOOL showStatus;
@property (nonatomic, strong) AMAuctionOrderBusinessModel *model;

@end

NS_ASSUME_NONNULL_END
