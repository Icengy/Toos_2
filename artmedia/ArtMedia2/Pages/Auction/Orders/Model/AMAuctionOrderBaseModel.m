//
//  AMAuctionLotModel.m
//  ArtMedia2
//
//  Created by icnengy on 2020/11/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMAuctionOrderBaseModel.h"

@implementation AMAuctionOrderBaseModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _isSelect = YES;
    }
    return self;
}

@end

@implementation AMAuctionLotModel

@end


@implementation AMAuctionOrderBusinessModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"lots":@[@"lots", @"unsettledGoodsList", @"auctionGoodOrderDetailList"]
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"lots":[AMAuctionLotModel class]
             };
}

@end
