//
//  LastestLivechapterModel.h
//  ArtMedia2
//
//  Created by LY on 2020/10/26.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LastestLivechapterModel : NSObject
/*
 "courseId": 254,                                    //课程ID
 "chapterId": 12,                                    //章节id
 "chapterTitle": "xxxx",                             //章节标题
 "chapterSort": 10,                                  //章节排序(课时序号)
 "liveStartTime": "2020-09-18 10:37:53",             //开播时间
 "teacherId": 1,                                     //讲师id
 "teacherName": "xxxx",                              //讲师名称
 */
@property (nonatomic , copy) NSString *courseId;
@property (nonatomic , copy) NSString *chapterId;
@property (nonatomic , copy) NSString *chapterTitle;
@property (nonatomic , copy) NSString *chapterSort;
@property (nonatomic , copy) NSString *liveStartTime;
@property (nonatomic , copy) NSString *teacherId;
@property (nonatomic , copy) NSString *teacherName;
@end

NS_ASSUME_NONNULL_END
