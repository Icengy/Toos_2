//
//  ReceivableModel.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/13.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "ReceivableModel.h"

@implementation ReceivableModel

+ (NSDictionary *)modelCustomPropertyMapper {
	return @{
			 @"id":@[@"gid", @"id"]
			 };
}

@end
