//
//  AMCourseOrderModel.h
//  ArtMedia2
//
//  Created by icnengy on 2020/10/9.
//  Copyright © 2020 翁磊. All rights reserved.
//
/*
 {
     {"courseOrderId": 1,                                     //直播订单ID主键
     "courseOrderNo": "354613621654",                        //直播订单编号
     "courseId": 254,                                        //课程ID
     "courseTitle": "xxxx",                                  // 课程标题
     "teacherName": "老王",                                  //讲师名称（艺术家名称）
     "memberId": 1,                                          //会员ID （购买人id）
     "memberMobile": "1546156154",                           //购买人电话
     "orderPrice": 100,                                      //订单金额
     "create_time": 1,                                       //支付时间
     "createUserId": 123,                                    //创建人ID
     "createUserName": "张三",                               //创建人名称
     "createTime": "2020-09-18 10:37:53",                    //创建时间
     "updateUserId": 123,                                    //修改人id
     "updateUserName": "张三",                               //修改人名称
     "updateTime": "2020-09-18 10:37:53",                    //修改时间
     "liveWatchCourse":{
         "watchCourseId": 1,                                //会员观看课程记表主键id
         "memberId":666,                                    //会员ID
         "courseId": 254,                                   //课程ID
         "chapterId": "xxxx",                               //章节id
         "videoSourceId": "xxxxxxxxxxx",                    //播课程视频资源ID
         "chapterPlayDuration": "02:30:10",                 //当前章节播放时长 HH:mm:dd时间字符,
         "create_time": 1,                                  //支付时间
         "createUserId": 123,                               //创建人ID
         "createUserName": "张三",                          //创建人名称
         "createTime": "2020-09-18 10:37:53",               //创建时间
         "updateUserId": 123,                               //修改人id
         "updateUserName": "张三",                          //修改人名称
         "updateTime": "2020-09-18 10:37:53",               //修改时间
     }
   },}
 */

#import "BaseModel.h"

@class AMCourseWatchModel;
NS_ASSUME_NONNULL_BEGIN

@interface AMCourseOrderModel : BaseModel

@property (nonatomic ,copy) NSString *courseOrderId;                                     //直播订单ID主键
@property (nonatomic ,copy) NSString *courseOrderNo;                       //直播订单编号
@property (nonatomic ,copy) NSString *courseId;                                      //课程ID
@property (nonatomic ,copy) NSString *courseTitle;                               // 课程标题
@property (nonatomic ,copy) NSString *teacherName;                                 //讲师名称（艺术家名称）
@property (nonatomic ,copy) NSString *memberId;                                        //会员ID （购买人id）
@property (nonatomic ,copy) NSString *memberMobile;                        //购买人电话
@property (nonatomic ,copy) NSString *orderPrice;                                     //订单金额
@property (nonatomic ,copy) NSString *create_time;                                   //支付时间

@property (nonatomic ,strong) AMCourseWatchModel *liveWatchCourse; //会员观看课程

@end


@interface AMCourseWatchModel : BaseModel

//@property (nonatomic ,copy) NSString *watchCourseId;                             //会员观看课程记表主键id
@property (nonatomic ,copy) NSString *memberId;                                 //会员ID
//@property (nonatomic ,copy) NSString *courseId;                                 //课程ID
@property (nonatomic ,copy) NSString *chapterId;                           //章节id
@property (nonatomic ,copy) NSString *videoSourceId;                   //播课程视频资源ID
@property (nonatomic ,copy) NSString *chapterPlayDuration;               //当前章节播放时长 HH:mm:dd时间字符,
@property (nonatomic ,copy) NSString *create_time;                                //支付时间

@end

NS_ASSUME_NONNULL_END
