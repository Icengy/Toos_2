//
//  MyOrderModel.m
//  ArtMedia
//
//  Created by 美术传媒 on 2018/11/11.
//  Copyright © 2018 lcy. All rights reserved.
//

#import "MyOrderModel.h"

@implementation MyOrderModel

+ (NSDictionary *)modelCustomPropertyMapper {
	return @{
			 @"buyer_id":@[@"buyerid", @"buyer_id"],
			 @"oretapply":@[@"return_request", @"oretapply"],
			 @"apply_reason":@[@"return_reason", @"apply_reason"],
			 @"oretapplydate":@[@"request_date", @"oretapplydate"],
			 @"oret_deal_date":@[@"agree_date", @"oret_deal_date"],
			 @"ID":@[@"id", @"oid"]
			 };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
	return @{
			 @"send_delivery" : [MyAddressModel class],
             @"return_delivery" : [MyAddressModel class]
//			 @"apply_order" : [ApplyOrderModel class]
			 };
}

@end

@implementation ApplyOrderModel
+ (NSDictionary *)modelCustomPropertyMapper {
	return @{
			 @"ID":@"id"
			 };
}
@end
