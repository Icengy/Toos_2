//
//  AMCourseChapterModel.m
//  ArtMedia2
//
//  Created by icnengy on 2020/10/9.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMCourseChapterModel.h"

@implementation AMCourseChapterModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"course_description":@"description",
             @"id":@[@"chapterId", @"id"],
             @"courseChapters":@"courseChapterList",
             };
}

//+ (NSDictionary *)modelContainerPropertyGenericClass {
//    return @{
//             @"courseChapterList":[AMCourseChapterModel class]
//             };
//}


@end
