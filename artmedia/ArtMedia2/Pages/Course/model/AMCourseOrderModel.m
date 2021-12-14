//
//  AMCourseOrderModel.m
//  ArtMedia2
//
//  Created by icnengy on 2020/10/9.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMCourseOrderModel.h"

@implementation AMCourseOrderModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"id":@[@"courseOrderId", @"id"]
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"liveWatchCourse":[AMCourseWatchModel class]
             };
}

@end


@implementation AMCourseWatchModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"course_description":@"description",
             @"id":@[@"courseId", @"id", @"watchCourseId"],
             };
}

@end
