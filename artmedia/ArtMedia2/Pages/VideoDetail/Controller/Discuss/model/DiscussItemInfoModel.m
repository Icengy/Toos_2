//
//  DiscussItemInfoModel.m
//  ArtMedia2
//
//  Created by icnengy on 2020/7/9.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "DiscussItemInfoModel.h"

@implementation DiscussItemInfoModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"user_info" : [UserInfoModel class],
             @"to_user_info" : [UserInfoModel class],
             @"reply_data" : [DiscussItemInfoModel class]
             };
}

@end
