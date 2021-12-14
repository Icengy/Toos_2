//
//  IdentifyModel.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/14.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "IdentifyModel.h"

@implementation IdentifyModel

+ (NSDictionary *)modelCustomPropertyMapper {
	return @{
        @"ID":@"id"
			 };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"cateinfo":[ArtsFieldModel class]
             };
}

@end

@implementation ArtsFieldModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"id":@[@"sid", @"id"],
             @"uid":@"be_invited_userid"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"secondcate":[ArtsFieldModel class]
             };
}

@end
