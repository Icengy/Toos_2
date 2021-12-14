//
//  AMCourseModel.m
//  ArtMedia2
//
//  Created by icnengy on 2020/10/9.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMCourseModel.h"

#import "AMCourseChapterModel.h"

@implementation AMCourseModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"course_description":@"description",
             @"courseId":@[@"courseId", @"id"],
             @"courseChapters":@"liveCourseChapterList",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"courseChapters":[AMCourseChapterModel class]
             };
}

@end
