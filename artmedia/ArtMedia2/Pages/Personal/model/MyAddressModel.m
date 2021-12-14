//
//  MyAddressModel.m
//  ArtMedia
//
//  Created by 美术传媒 on 2018/11/15.
//  Copyright © 2018 lcy. All rights reserved.
//

#import "MyAddressModel.h"

@implementation MyAddressModel

+ (NSDictionary *)modelCustomPropertyMapper {
	return @{
			 @"reciver":@[@"recipient", @"reciver", @"reciverName"],
			 @"phone":@[@"tel", @"phone", @"reciverMobile"],
			 @"devlivery_comp":@[@"devlivery_comp", @"delivery_comp", @"logisticsCompany"],
			 @"devlivery_no":@[@"devlivery_no", @"delivery_no", @"courierNumber"],
			 @"ID":@"id",
             @"address":@[@"reciverAddress", @"address"]
			 };
}

@end
