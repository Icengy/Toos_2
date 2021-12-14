//
//  AMCourseChapterModel.h
//  ArtMedia2
//
//  Created by icnengy on 2020/10/9.
//  Copyright © 2020 翁磊. All rights reserved.
//
// 课时model
//
/*
 {
     "chapterId": 1,                                //课时主键id
     "courseId": 2,                                 //课程主键id
     "teacherId": 123,                              //讲师id
     "teacherName": "张三",                         //讲师名字
     "chapterSort": 1,                              // 课时序号
     "chapterTitle":"课时标题",                     //课时标题
     "courseType": 0,                               //课时类型，1 直播课，2：点播课
     "isFree": 0,                                   //是否免费 1:免费;2:收费',
     "liveStartTime": "2020-09-28 15:55:29",        // 开播时间
     "actualStartTime": "2020-09-28 15:55:29",      // 开播时间
     "liveStatus": 0,                               //直播状态 1:未直播;2:直播中;3:直播中讲师离开直播间；4:直播已结束=回放视频生成中;5:回放视频生成失败;6:回放视频生成成功,
     "createUserId": 123,                           //创建人ID
     "createUserName": "张三",                      //创建人名称
     "createTime": "2020-09-18 10:37:53",           //创建时间
     "updateUserId": 123,                           //修改人id
     "updateUserName": "张三",                      //修改人名称
     "updateTime": "2020-09-18 10:37:53"            //修改时间
 }
 */

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AMCourseChapterModel : BaseModel

@property (nonatomic ,copy) NSString *courseId;      //课程主键id
@property (nonatomic ,copy) NSString *teacherId;            //讲师id
@property (nonatomic ,copy) NSString *teacherName;          //讲师名字
@property (nonatomic ,copy) NSString *chapterSort;         // 课时序号
@property (nonatomic ,copy) NSString *chapterTitle;          //课时标题
@property (nonatomic ,copy) NSString *courseType;     //课时类型，1 直播课，2：点播课
@property (nonatomic ,copy) NSString *isFree;         //是否免费 1:免费;2:收费',
@property (nonatomic ,copy) NSString *liveStartTime;        // 开播时间
@property (nonatomic ,copy) NSString *actualStartTime;      // 实际开播时间
@property (nonatomic ,copy) NSString *liveStatus;                             //直播状态 1:未直播;2:直播中;3:直播中讲师离开直播间；4:直播已结束=回放视频生成中;5:回放视频生成失败;6:回放视频生成成功,
@property (nonatomic ,copy) NSString *videoSourceId;      //云端视频资源
@property (nonatomic , copy) NSString *chapterId;//课时id
@end

NS_ASSUME_NONNULL_END
