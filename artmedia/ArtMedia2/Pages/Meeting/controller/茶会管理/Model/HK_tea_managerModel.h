//
//  HK_tea_managerModel.h
//  ArtMedia2
//
//  Created by guohongkai on 2020/8/24.
//  Copyright © 2020 翁磊. All rights reserved.
//
/*
 artistId = 1;
 cancelReason = "家中有事3";
 count = "<null>";
 createTime = "2020-08-13 18:57:20";
 createUserId = 1;
 createUserName = "融媒体官方";
 headimg = "<null>";
 id = "<null>";
 infoStatus = 1;
 peopleMax = 20;
 peopleMin = 2;
 realname = "<null>";
 teaAboutInfoId = 3;
 teaDesc = "山高水长，江湖再见";
 teaSignUpEndTime = "2020-08-13 17:28:53";
 teaStartTime = "2020-08-13 17:10:53";
 teaSystemStatus = "<null>";
 uname = "<null>";
 updateTime = "2020-08-17 11:04:50";
 updateUserId = "<null>";
 updateUserName = "<null>";
 utype = "<null>";
 -----------------
 
 */
#import "HK_baseModel.h"


/// 会客开始前1小时
#define TeaBeforeBeginOneHour   (60*60)
/// 会客开始前10分钟
#define TeaBeginCountDown   (60*10)
/// 会客2小时持续时间
#define TeaLastCountDown   (60*60*2)


NS_ASSUME_NONNULL_BEGIN

@interface HK_tea_managerModel : HK_baseModel

@property (nonatomic,copy)NSString *ID;

@property (nonatomic, copy) NSString *updateTime;//更新时间
@property (nonatomic, assign) NSInteger updateUserId;//更新人id
@property (nonatomic, copy) NSString *updateUserName;//更新人姓名
@property (nonatomic, assign) NSInteger peopleMin;//会客最小人数
@property (nonatomic, copy) NSString *createUserName;//创建人姓名
@property (nonatomic, assign) NSInteger peopleMax;//会客最大人数
@property (nonatomic, copy) NSString *teaDesc;//会客说明
@property (nonatomic, assign) NSInteger infoStatus;//会客状态 1待开始 2进行中 3已结束 4已取消
@property (nonatomic, copy) NSString *teaSystemStatus;//约见状态 1开始 2关闭
@property (nonatomic, copy) NSString *createTime;//创建时间
@property (nonatomic, assign) NSInteger createUserId;//创建人id
@property (nonatomic, assign) NSInteger artistId;// (会员id)
@property (nonatomic, copy) NSString *artistTitle;//头衔
@property (nonatomic, copy) NSString *cancelReason;//取消会客原因
@property (nonatomic, copy) NSString *teaStartTime;//会客开始时间
@property (nonatomic , copy) NSString *teaEndTime;//会客结束时间
@property (nonatomic, copy) NSString *teaSignUpEndTime;//会客报名截止时间
@property (nonatomic,copy)NSString *uname;//用户昵称
@property (nonatomic,copy)NSString *headimg;//用户头像
@property (nonatomic,assign)NSInteger count;//预约见会总人数
@property (nonatomic,assign)NSInteger utype;//角色类型 1普通用户 2经纪人 3艺术家
@property (nonatomic,copy)NSString *realname;//真实姓名
@property (nonatomic,copy)NSString *peopleInviteId;//邀请人员主键
@property (nonatomic,copy)NSString *teaAboutOrderId;//约见预约订单id
@property (nonatomic,copy)NSString *teaAboutInfoId;//约见会客信息ID
@property (nonatomic,copy)NSString *memberId;//会员id
@property (nonatomic,assign)NSInteger status;//邀请状态 1已参加 2不参加 3待确认
@property (nonatomic , assign) NSInteger deadlineType;//1 已经截止，-1未截止
@property (nonatomic , copy) NSString *currentTime;//服务器当前时间

@property (nonatomic , assign) NSInteger presentCount;// 确认参会总人数

@end

NS_ASSUME_NONNULL_END
