//
//  AMMeetingMemberModel.h
//  ArtMedia2
//
//  Created by icnengy on 2020/8/29.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AMMeetingMemberModel : NSObject

@property (nonatomic ,copy) NSString *peopleInviteId;//": 1,      (约见人员邀请主键)
@property (nonatomic ,copy) NSString *teaAboutOrderId;//": 1,   (约见预约订单id)
@property (nonatomic ,copy) NSString *teaAboutInfoId;//": 1,     (约见会客信息ID)
@property (nonatomic ,copy) NSString *memberId;//": 1,           (会员id)
@property (nonatomic ,copy) NSString *status;//": 1,               (邀请人员信息状态 1:已参加 2:不参加 3:待确认)
@property (nonatomic ,copy) NSString *createUserId;//": 1,       (创建人id)
@property (nonatomic ,copy) NSString *createUserName;//": "官方",    (创建人姓名)
@property (nonatomic ,copy) NSString *createTime;//": "2020-08-17 14:39:04",  (创建时间)
@property (nonatomic ,copy) NSString *updateUserId;//": 1,                    (更新人id)
@property (nonatomic ,copy) NSString *updateUserName;//": "官方",             (更新人姓名)
@property (nonatomic ,copy) NSString *updateTime;//": "2020-08-18 15:54:26",  (更新时间)
@property (nonatomic ,copy) NSString *count;//": null,                        (确认参会总人数)
@property (nonatomic ,copy) NSString *utype;//": 3,                           (角色类型：1普通用户，2经纪人，3艺术家)
@property (nonatomic ,copy) NSString *uname;//": "艺术家测试1",               (用户昵称)
@property (nonatomic ,copy) NSString *realname;//": "",                       (真实姓名)
@property (nonatomic ,copy) NSString *headimg;//": "/Upload/headimg/userDefaultIcon.jpeg",  (用户头像)
@property (nonatomic ,copy) NSString *id;//": 1                               (用户id)

@end

NS_ASSUME_NONNULL_END
