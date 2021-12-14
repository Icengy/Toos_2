//
//  CustomPersonalModel.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/29.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "CustomPersonalModel.h"

#import "VideoListModel.h"
#import "AMNewArtistTimeLineModel.h"

@implementation CustomPersonalModel

+ (NSDictionary *)modelCustomPropertyMapper {
	return @{
			 @"userData":@[@"userData", @"user_info"],
             @"unreadModel":@[@"wait_deal_order_count", @"unreadModel"]
			 };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
	return @{
			 @"userData":[UserInfoModel class],
             @"videoData":[VideoListModel class],
             @"unreadModel":[CustomPersonalUnreadOrderModel class],
             @"meetingData":[AMNewArtistTimeLineModel class]
			 };
}

@end

@implementation CustomPersonalUnreadOrderModel

@end
