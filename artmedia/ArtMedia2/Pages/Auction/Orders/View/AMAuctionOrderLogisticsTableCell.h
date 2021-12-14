//
//  AMAuctionOrderLogisticsTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/11/13.
//  Copyright © 2020 翁磊. All rights reserved.
//
// 拍屏订单物流信息
//


#import "AMAuctionBaseTableCell.h"

#pragma mark - 弹出框
typedef NS_ENUM(NSUInteger, AMAuctionOrderLogisticsStyle) {
    /// 默认（物流）
    AMAuctionOrderLogisticsStyleDefault = 0,
    /// 地址
    AMAuctionOrderLogisticsStyleAddress
};


@class MyAddressModel;
NS_ASSUME_NONNULL_BEGIN

@interface AMAuctionOrderLogisticsTableCell : AMAuctionBaseTableCell

@property (nonatomic ,strong) MyAddressModel *addressModel;
@property (nonatomic ,assign) AMAuctionOrderLogisticsStyle style;

@end

NS_ASSUME_NONNULL_END
