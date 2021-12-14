//
//  AMAuctionOrderInfoTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/11/13.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMAuctionBaseTableCell.h"

@class AMAuctionOrderModel;
NS_ASSUME_NONNULL_BEGIN

@interface AMAuctionOrderInfoTableCell : AMAuctionBaseTableCell

@property (nonatomic ,strong) AMAuctionOrderModel *model;

@end

NS_ASSUME_NONNULL_END
