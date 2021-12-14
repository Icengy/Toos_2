//
//  AMAuctionOrderAddressTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/11/13.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMAuctionBaseTableCell.h"

@class MyAddressModel;
NS_ASSUME_NONNULL_BEGIN

@interface AMAuctionOrderAddressTableCell : AMAuctionBaseTableCell

@property (nonatomic ,strong) MyAddressModel *addressModel;

@end

NS_ASSUME_NONNULL_END
