//
//  AMAuctionOrderModel.m
//  ArtMedia2
//
//  Created by icnengy on 2020/11/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMAuctionOrderModel.h"

@implementation AMAuctionOrderModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"lotModel":@[@"lotModel", @"auctionGoodOrderDetailInfo"]
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"lotModel":[AMAuctionLotModel class],
             @"logisticsInfo":[MyAddressModel class]
             };
}

@end
