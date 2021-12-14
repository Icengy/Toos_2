//
//  VideoGoodsModel.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/1.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "VideoGoodsModel.h"

@implementation VideoGoodsModel

+ (NSDictionary *)modelCustomPropertyMapper {
	return @{
			 @"name":@[@"gname", @"aname"],
			 @"describe":@[@"gdescribe", @"describe", @"description"],
			 @"price":@[@"price", @"gprice"],
			 @"freeshipping":@[@"gfreeshipping", @"freeshipping"],
			 @"uid":@[@"guid",@"uid"],
			 @"banner":@[@"gbanner", @"banner"],
			 @"sellprice":@[@"gsellprice", @"sellprice"],
			 @"vipprice":@[@"gvipprice", @"vipprice"],
			 @"stocknum":@[@"gstocknum", @"stocknum"],
			 @"sellnum":@[@"gsellnum", @"sellnum"],
			 @"state":@[@"gstate", @"state"],
			 @"status":@[@"gstatus", @"status"],
			 @"auctionpic":@[@"gauctionpic", @"goods_albums"],
			 @"ID":@[@"gid", @"id"],
			 @"addtime":@[@"gaddtime", @"addtime"],
			 @"delete":@[@"gdelete", @"delete"],
			 @"state_reason":@[@"gstate_reason", @"state_reason"],
			 @"state_time":@[@"gstate_time", @"state_time"],
			 @"tid":@[@"gtid", @"tid"],
			 @"type":@[@"gtype", @"type"],
			 @"cate_id":@[@"acate_id", @"cate_id"],
			 @"cate_name":@[@"acate_name", @"cate_name", @"gcate_name"],
             @"classModel":@[@"category", @"good_category", @"classModel"]
			 };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
	return @{
			 @"auctionpic":[VideoGoodsImageModel class],
             @"classModel":[GoodsClassModel class]
			 };
}

@end


@implementation GoodsClassModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"id":@[@"sid",@"tid", @"id"],
             @"uid":@"be_invited_userid",
             @"tcate_name":@[@"cate_name", @"tcate_name"]
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"secondcate":[GoodsClassModel class]
             };
}

@end
