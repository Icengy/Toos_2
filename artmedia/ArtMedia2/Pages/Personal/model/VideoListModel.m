//
//  VideoListModel.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/30.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "VideoListModel.h"

@implementation VideoColumnModel

@end

@implementation VideoListModel

+ (NSDictionary *)modelCustomPropertyMapper {
	return @{
			 @"goodsModel" :@[@"goodsdata", @"stock_data", @"good_data", @"goodsModel"],
			 @"image_width":@[@"width", @"pic_width"],
			 @"image_height":@[@"height", @"pic_height"],
			 @"ID":@"id"
			 };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
	return @{
			 @"artModel" : [VideoArtModel class],
			 @"goodsModel" :[VideoGoodsModel class],
			 @"itemSizeModel" :[VideoItemSizeModel class],
             @"columnModel" : [VideoColumnModel class]
			 };
}

@end
