//
//  LiveWatchCourseModel.h
//  ArtMedia2
//
//  Created by LY on 2020/10/26.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiveWatchCourseModel : NSObject
/*
 "watchCourseId": 1,                                //会员观看课程记表主键id
 "memberId":666,                                    //会员ID
 "courseId": 254,                                   //课程ID
 "chapterId": "xxxx",                               //章节id
 "chapterTitle": "xxxx",                            //章节标题
 "videoSourceId": "xxxxxxxxxxx",                    //播课程视频资源ID
 "chapterPlayDuration": "02:30:10",                 //当前章节播放时长 HH:mm:dd时间字符,
 "create_time": 1,                                  //支付时间
 "createUserId": 123,                               //创建人ID
 "createUserName": "张三",                          //创建人名称
 "createTime": "2020-09-18 10:37:53",               //创建时间
 "updateUserId": 123,                               //修改人id
 "updateUserName": "张三",                          //修改人名称
 "updateTime": "2020-09-18 10:37:53",               //修改时间
 */
@property (nonatomic , copy) NSString *watchCourseId;
@property (nonatomic , copy) NSString *memberId;
@property (nonatomic , copy) NSString *courseId;
@property (nonatomic , copy) NSString *chapterId;
@property (nonatomic , copy) NSString *chapterTitle;
@property (nonatomic , copy) NSString *videoSourceId;
@property (nonatomic , copy) NSString *chapterPlayDuration;
@property (nonatomic , copy) NSString *create_time;
@property (nonatomic , copy) NSString *createUserId;
@property (nonatomic , copy) NSString *createUserName;
@property (nonatomic , copy) NSString *createTime;
@property (nonatomic , copy) NSString *updateUserId;
@property (nonatomic , copy) NSString *updateUserName;
@property (nonatomic , copy) NSString *updateTime;
@end

NS_ASSUME_NONNULL_END
