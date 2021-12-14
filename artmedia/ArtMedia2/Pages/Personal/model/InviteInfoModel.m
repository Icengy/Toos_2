//
//  InviteInfoModel.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "InviteInfoModel.h"

@implementation InviteInfoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"uname":@[@"uname", @"be_invited_user_name"],
             @"uid":@"be_invited_userid"
             };
}

@end
