//
//  AuctionModel.h
//  ArtMedia2
//
//  Created by LY on 2020/11/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AuctionModel : NSObject
/*
 auctionFieldDesc = addTest;
 auctionFieldId = 11;
 auctionFieldImage = "null-tu";
 auctionFieldPopularity = "<null>";
 auctionFieldTitle = addTestTitle;
 auctionGoodTotalAmount = 0;
 createTime = "2020-11-06 16:46:14";
 createUserId = 827;
 createUserName = string;
 depositAmount = "0.01";
 fieldOrderNo = "<null>";
 fieldServiceFee = 0;
 fieldServiceFeePayStatus = 2;
 fieldStatus = 7;
 hostUserId = 827;
 hostUserName = string;
 isDelete = 2;
 isNeedDeposit = 2;
 payOverdueTime = "<null>";
 remark = "<null>";
 roomId = 78974701;
 startLiveTime = "2020-12-01 00:00:00";
 streamName = MSCMLIVE000dev201106000004;
 updateTime = "2020-11-13 15:26:11";
 updateUserId = 827;
 updateUserName = "少年金城武";
 verifyStatus = 1;
 */

/// pm专场介绍
@property (nonatomic , copy) NSString *auctionFieldDesc;
/// pm专场主键id
@property (nonatomic , copy) NSString *auctionFieldId;
/// 专场图片
@property (nonatomic , copy) NSString *auctionFieldImage;

/// 艺术家头像
@property (nonatomic , copy) NSString *headimg;
/// 专场人气值（浏览数量）
@property (nonatomic , copy) NSString *auctionFieldPopularity;
/// 专场名称
@property (nonatomic , copy) NSString *auctionFieldTitle;
/// 专场拍品总数
@property (nonatomic , copy) NSString *auctionGoodTotalAmount;
/// 创建时间
@property (nonatomic , copy) NSString *createTime;
/// 创建人ID
@property (nonatomic , copy) NSString *createUserId;
/// 创建人名称
@property (nonatomic , copy) NSString *createUserName;
/// 保证金数额（拍客需要缴纳的保证金）
@property (nonatomic , copy) NSString *depositAmount;
/// 专场订单号
@property (nonatomic , copy) NSString *fieldOrderNo;
/// 专场服务费
@property (nonatomic , copy) NSString *fieldServiceFee;
/// 专场服务费支付状态 1: 未支付;2: 已支付
@property (nonatomic , copy) NSString *fieldServiceFeePayStatus;
/// 专场状态 1: 草稿状态 2:未审核=审核中；3:审核失败；4:审核通过=专场服务费未支付，5:专场服务费已支付=未开拍; 6:直播中; 7:拍卖结束 8 专场取消（已失效）
@property (nonatomic , copy) NSString *fieldStatus;
/// 主办方用户id（商户d）
@property (nonatomic , copy) NSString *hostUserId;
/// 主办方名称(商户名称)
@property (nonatomic , copy) NSString *hostUserName;
/// 逻辑删除，1：是；2：否
@property (nonatomic , copy) NSString *isDelete;
/// 是否需要保证金 1:不需要;2:需要
@property (nonatomic , copy) NSString *isNeedDeposit;

/// 未知
@property (nonatomic , copy) NSString *payOverdueTime;

/// 备注
@property (nonatomic , copy) NSString *remark;
@property (nonatomic , copy) NSString *roomId;
/// 直播时间
@property (nonatomic , copy) NSString *startLiveTime;
@property (nonatomic , copy) NSString *streamName;
/// 修改时间
@property (nonatomic , copy) NSString *updateTime;
/// 修改人ID
@property (nonatomic , copy) NSString *updateUserId;
/// 修改人名称
@property (nonatomic , copy) NSString *updateUserName;
/// 审核状态 1 草稿状态，2:未审核=审核中; 3:审核失败; 4:审核通过
@property (nonatomic , copy) NSString *verifyStatus;


@property (nonatomic , copy) NSString *is_collect;
@property (nonatomic , copy) NSString *artist_title;
@property (nonatomic , copy) NSString *utype;
@end

NS_ASSUME_NONNULL_END
