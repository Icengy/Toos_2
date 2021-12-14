//
//  AMMeetingOrderManagerListModel.h
//  ArtMedia2
//
//  Created by icnengy on 2020/8/28.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AMMeetingOrderManagerListModel : NSObject

@property (nonatomic, copy) NSString *teaAboutOrderId;//": 4, 订单id
@property (nonatomic, copy) NSString *artistId;//": null, 艺术家id
@property (nonatomic, copy) NSString *teaAboutOrderNo;//": null, 订单编号
@property (nonatomic, copy) NSString *memberId;//": null, 会员id
@property (nonatomic, copy) NSString *addressId;//": null,地址id
@property (nonatomic, copy) NSString *backingName;//": null,后援证书名
@property (nonatomic, copy) NSString *subscribeEndTime;//": null, 预约截止时间
@property (nonatomic, copy) NSString *securityStatus;//": null, 保证金状态
@property (nonatomic, copy) NSString *securityDeposit;//": null,保证金
@property (nonatomic, copy) NSString *payStatus;//": null, 支付状态
@property (nonatomic, copy) NSString *payTime;//": null,支付时间
@property (nonatomic, assign) NSInteger orderStatus;//": 4,订单状态
@property (nonatomic, copy) NSString *statusTime;//": null, 状态时间
@property (nonatomic, copy) NSString *createUserId;//": null,创建用户id
@property (nonatomic, copy) NSString *createUserName;//": null, 创建人名字
@property (nonatomic, copy) NSString *createTime;//": null, 创建时间
@property (nonatomic, copy) NSString *updateUserId;//": null, 更新用户id
@property (nonatomic, copy) NSString *updateUserName;//": null, 更新人名字
@property (nonatomic, copy) NSString *updateTime;//": "2020-08-19 19:34:28",
@property (nonatomic, copy) NSString *id;//": 1, 用户id
@property (nonatomic, copy) NSString *headimg;//": "/Upload/headimg/userDefaultIcon.jpeg", 用户头像
@property (nonatomic, copy) NSString *lastSyncDate;//": null,  最后上线时间
@property (nonatomic, copy) NSString *uname;//": "艺术家测试1",
@property (nonatomic, copy) NSString *artistTitle;//": "",  用户头衔
@property (nonatomic, copy) NSString *i;//": null,
@property (nonatomic, copy) NSString *peopleMax;//": null,
@property (nonatomic, copy) NSString *infoStatus;//": null,
@property (nonatomic, copy) NSString *status;//": null
@property (copy , nonatomic) NSString *teaAboutInfoId;//会客ID
@property (copy , nonatomic) NSString *teaStartTime;//会客开始时间
@property (nonatomic , copy) NSString *teaSignUpEndTime;//会客报名截止时间
@property (nonatomic , copy) NSString *teaEndTime;//会客结束时间
@property (nonatomic , copy) NSString *cancelReason;//取消原因
@property (nonatomic , copy) NSString *orderStatusCount;
@property (nonatomic , copy) NSString *peopleInviteId;

@end

NS_ASSUME_NONNULL_END
