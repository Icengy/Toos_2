//
//  VideoArtModel.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/5.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "VideoArtModel.h"

@implementation VideoArtModel

+ (NSDictionary *)modelCustomPropertyMapper {
	return @{
			 @"art_name":@[@"uname", @"art_name"],
			 @"is_collect" :@[@"iscollect", @"is_collect"],
			 @"ID":@"id"
			 };
}

@end
