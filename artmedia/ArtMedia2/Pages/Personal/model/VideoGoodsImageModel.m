//
//  VideoGoodsImageModel.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/1.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "VideoGoodsImageModel.h"

@implementation VideoGoodsImageModel

+ (NSDictionary *)modelCustomPropertyMapper {
	return @{
			 @"addtime":@[@"aaddtime", @"addtime"],
			 @"gid":@[@"gid", @"agid"],
			 @"ID":@[@"aid", @"id"],
			 @"imgsrc":@[@"aimgsrc", @"image"],
			 @"mimgsrc":@[@"amimgsrc", @"image_m"],
			 @"simgsrc":@[@"asimgsrc", @"image_s"],
			 @"sort":@[@"asort", @"sort"],
			 @"state":@[@"astate", @"state"],
			 @"type":@[@"atype", @"type"],
			 };
}

@end
