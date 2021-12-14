//
//  WalletRevenueEstimateTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/11.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletRevenueEstimateTableCell : BaseTableViewCell

@property (nonatomic ,assign) AMWalletItemStyle style;

@property (nonatomic ,strong) NSDictionary *estimateData;

@end

NS_ASSUME_NONNULL_END
