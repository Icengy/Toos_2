//
//  AMMeetingPleaseUserModel.h
//  ArtMedia2
//
//  Created by icnengy on 2020/8/27.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AMMeetingPleaseUserModel : NSObject


@property (nonatomic ,copy) NSString *teaAboutInfoId;//  (约见会客信息ID)
@property (nonatomic ,copy) NSString *artistId;//         (会员id)
@property (nonatomic ,copy) NSString *teaStartTime;//   (会客开始时间)
@property (nonatomic ,copy) NSString *teaDesc;//        (会客说明)
@property (nonatomic ,copy) NSString *teaSignUpEndTime;// (会客报名截止时间)
@property (nonatomic ,copy) NSString *peopleMin;//      (会客最小人数)
@property (nonatomic ,copy) NSString *peopleMax;//     (会客最大人数)
@property (nonatomic ,copy) NSString *infoStatus;//       (会客状态 1:待开始 2:进行中 3:已结束 4:已取消)
@property (nonatomic ,copy) NSString *cancelReason;//     (取消会客原因)
@property (nonatomic ,copy) NSString *createUserId;//     (创建人id)
@property (nonatomic ,copy) NSString *createUserName;//   (创建人姓名)
@property (nonatomic ,copy) NSString *createTime;//  (创建时间,及预约时间)
@property (nonatomic ,copy) NSString *updateUserId;//     (更新人id)
@property (nonatomic ,copy) NSString *updateUserName;//   (更新人姓名)
@property (nonatomic ,copy) NSString *updateTime;//       (更新时间)
@property (nonatomic ,copy) NSString *teaSystemStatus;//  (约见状态 1:开启 2:关闭)
@property (nonatomic ,copy) NSString *count;//            (确认参会总人数)
@property (nonatomic ,copy) NSString *utype;//": 3,               (角色类型：1普通用户，2经纪人，3艺术家)
@property (nonatomic ,copy) NSString *uname;//": "艺术家测试2",   (用户昵称)
@property (nonatomic ,copy) NSString *realname;//         (真实姓名)
@property (nonatomic ,copy) NSString *headimg;// "/Upload/headimg/userDefaultIcon.jpeg",  (用户头像)
@property (nonatomic ,copy) NSString *id;//": 2                   (用户id)
@property (nonatomic ,copy) NSString *teaAboutOrderId;// 订单ID


#pragma mark - 本地参数
@property (nonatomic ,assign) BOOL isSelected;// (是否选中)

@end

NS_ASSUME_NONNULL_END
