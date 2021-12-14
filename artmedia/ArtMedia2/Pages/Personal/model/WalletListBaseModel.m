//
//  WalletListModel.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/17.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "WalletListBaseModel.h"

@implementation WalletListBaseModel

@end

@implementation WalletRevenueListMeetingModel

@end

@implementation WalletRevenueListCourseModel

@end

@implementation WalletRevenueListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"tea_info":[WalletRevenueListMeetingModel class],
             @"course_info":[WalletRevenueListCourseModel class]
             };
}

@end


@implementation WalletEstimateListModel

@end

@implementation WalletBalanceListModel

@end

@implementation WalletYBListModel

@end
