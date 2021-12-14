//
//  UserInfoModel.m
//  ArtMedia
//
//  Created by 美术传媒 on 2018/10/25.
//  Copyright © 2018 lcy. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

+ (NSDictionary *)modelCustomPropertyMapper {
	return @{
			 @"username":@[@"uname", @"username"],
			 @"is_collect":@[@"iscollect", @"is_collect"],
			 @"is_bind_wechat":@[@"isBindOpenid", @"is_bind_wechat"],
			 @"is_collect" :@[@"iscollect", @"is_collect"],
             @"token":@[@"token", @"mscmToken"]
			 };
}

@end


@implementation UserAuthInfoModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"auth_data" : [UserAuthInfoModel class]
//             @"apply_order" : [ApplyOrderModel class]
             };
}


@end
