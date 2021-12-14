//
//  AMCourseModel.h
//  ArtMedia2
//
//  Created by icnengy on 2020/10/9.
//  Copyright © 2020 翁磊. All rights reserved.
//
// 课程model
//
/*
 {
     "courseId": 1,                                   课程id
     "teacherId": 2,                                  讲师id
     "teacherName": "老王",                           讲师名称
     "courseClassId": 22,                              二级分类id
     "parentCourseClassId": 1,                        一级分类id
     "courseTitle": "xxxx",                            课程标题
     "publishStatus": 1,                              发布状态 1:已发布;2:未发布',
     "description": "描述xxxxxxxxxxxxxx",             课程描述,
     "verifyStatus": 1,                               审核状态 1:初始状态;2:已发布未审核=审核中;3:审核失败;4:审核通过,
     "liveCourseStatus": 1,                           课程状态 1:初始状态;2:已发布未审核=审核中;3:审核失败;4:待授课;5:授课中;6:授课直播中;7:授课完结,
     "upperStatus": 1,                                课程上下架状态 1 是，2 否;默认上架状态
     "verifyRemark": "xxxxxxxxxxxxxx",                审核备注
     "isFree": 1,                                     当前课程是否是免费，1 是，2 否
     "coursePrice": 1000,                             课程销售价格，可免费观看价格设置未0，不免费设置价格大于10个艺币
     "totalLessonNum": 1000,                          总课时，根据课程章节自动计算
     "totalLiveLessonNum": 10,                       已播总课时，根据已播章节自动计算
     "coverImage": "xxx.jpg",                         课程封面图片路径
     "buyCount": 200,                                 销售数量=购课人数
     "createUserId": 123,                             创建人ID
     "createUserName": "张三",                        创建人名称
     "createTime": "2020-09-18 10:37:53",             创建时间
     "updateUserId": 123,                             修改人id
     "updateUserName": "张三",                        修改人名称
     "updateTime": "2020-09-18 10:37:53",             修改时间
     "isMySelf": 0,                                   是否课程属于本人标识，1 是，2 否
     "userType": 3,                                   当前用户类型：1普通用户，2经纪人，3艺术家，4影视明星，5歌手
     "isBuy":1,                                       是否已经购买，1 是，2 否，适用于非艺术家用户
     "courseChapterList":[....]
 }
 */

#import "BaseModel.h"
#import "AMCourseChapterModel.h"
#import "LastestLivechapterModel.h"
#import "LiveWatchCourseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AMCourseModel : BaseModel 

@property (nonatomic ,copy) NSString *courseId;
@property (nonatomic ,copy) NSString *teacherId;//讲师id
@property (nonatomic ,copy) NSString *teacherName;//讲师名称
@property (nonatomic ,copy) NSString *headimg;//讲师头像地址
@property (nonatomic ,copy) NSString *utype;//用户角色：1普通用户，2经纪人，3艺术家，4影视明星，5歌手

@property (nonatomic ,copy) NSString *courseClassId;//二级分类id
@property (nonatomic ,copy) NSString *parentCourseClassId;//一级分类id
@property (nonatomic ,copy) NSString *courseTitle;//课程标题
@property (nonatomic ,copy) NSString *coverImage;//课程封面图片路径
@property (nonatomic ,copy) NSString *course_description;//课程描述,

@property (nonatomic ,copy) NSString *publishStatus;//发布状态 1:已发布;2:未发布',
@property (nonatomic ,copy) NSString *verifyStatus;//审核状态 1:初始状态;2:已发布未审核=审核中;3:审核失败;4:审核通过,
@property (nonatomic ,copy) NSString *liveCourseStatus;//课程状态 1:初始状态;2:已发布未审核=审核中;3:审核失败;4:待授课;5:授课中;6:授课直播中;7:授课完结,
@property (nonatomic ,copy) NSString *upperStatus;//课程上下架状态 1 是，2 否;默认上架状态
@property (nonatomic ,copy) NSString *verifyRemark;//审核备注
@property (nonatomic ,copy) NSString *isFree;//当前课程是否是免费，1 是，2 否
@property (nonatomic ,copy) NSString *coursePrice;//课程销售价格，可免费观看价格设置未0，不免费设置价格大于10个艺币
//@property (nonatomic , assign) NSInteger coursePrice;
@property (nonatomic ,copy) NSString *totalLessonNum;//总课时，根据课程章节自动计算
@property (nonatomic ,copy) NSString *totalLiveLessonNum;//已播总课时，根据已播章节自动计算

@property (nonatomic ,copy) NSString *buyCount;//销售数量=购课人数
@property (nonatomic ,copy) NSString *isMySelf;//是否课程属于本人标识，1 是，2 否
@property (nonatomic ,copy) NSString *userType;//当前用户类型：1普通用户，2经纪人，3艺术家，4影视明星，5歌手
@property (nonatomic ,copy) NSString *isBuy;//是否已经购买，1 是，2 否，适用于非艺术家用户
@property (nonatomic ,strong) NSArray <AMCourseChapterModel *>*courseChapters;//课时列表


@property (nonatomic , strong) LastestLivechapterModel *lastestLivechapter;
@property (nonatomic , strong) LiveWatchCourseModel *liveWatchCourse;

@end

NS_ASSUME_NONNULL_END
