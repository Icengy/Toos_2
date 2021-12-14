//
//  AMAuctionRecordTableViewCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/11/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMAuctionBaseTableCell.h"

@class AMAuctionRecordModel;
NS_ASSUME_NONNULL_BEGIN

@interface AMAuctionRecordTableViewCell : AMAuctionBaseTableCell

@property (nonatomic ,strong) AMAuctionRecordModel *model;

@end

NS_ASSUME_NONNULL_END
