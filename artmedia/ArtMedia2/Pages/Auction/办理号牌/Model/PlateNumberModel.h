//
//  PlateNumberModel.h
//  ArtMedia2
//
//  Created by LY on 2020/11/20.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlateNumberModel : NSObject
/*
 auctionFieldId = 15;
 auctionFieldPlateNumber = 1001;
 auctionFieldTitle = 11;
 auctionUserId = 836;
 auctionUserMobile = 17557283488;
 auctionUserName = "游客077396";
 createTime = "<null>";
 createUserId = 836;
 createUserName = "游客077396";
 depositAmount = 2;
 depositOrderNo = "<null>";
 hostUserId = 843;
 hostUserName = "西米露";
 isDelete = "<null>";
 isValid = "<null>";
 plateNumberLogId = 8;
 plateNumberOnlineFlag = "<null>";
 remark = "数据库手动改数据";
 updateTime = "2020-11-20 15:32:39";
 updateUserId = 836;
 updateUserName = "游客077396";
 */
/// 专场主键id
@property (nonatomic , copy) NSString *auctionFieldId;
/// 拍客专场牌号，号牌取值范围 （1001 - 9999），线下号牌范围（1-1000）
@property (nonatomic , copy) NSString *auctionFieldPlateNumber;
/// 专场标题
@property (nonatomic , copy) NSString *auctionFieldTitle;
/// 拍客用户id
@property (nonatomic , copy) NSString *auctionUserId;
/// 未知
@property (nonatomic , copy) NSString *auctionUserMobile;
/// 拍客用户名称
@property (nonatomic , copy) NSString *auctionUserName;
/// 创建时间
@property (nonatomic , copy) NSString *createTime;
/// 创建人id
@property (nonatomic , copy) NSString *createUserId;
/// 创建人名称
@property (nonatomic , copy) NSString *createUserName;
/// 专场保证金数额
@property (nonatomic , copy) NSString *depositAmount;
/// 保证金订单号
@property (nonatomic , copy) NSString *depositOrderNo;
/// 主办方用户id（商户id）
@property (nonatomic , copy) NSString *hostUserId;
/// 主办方用户名称（商户名称）
@property (nonatomic , copy) NSString *hostUserName;
/// 逻辑删除，1：是；2：否
@property (nonatomic , copy) NSString *isDelete;
/// 是否有效；1:未生效；2已生效；
@property (nonatomic , copy) NSString *isValid;
/// 牌号记录主键id
@property (nonatomic , copy) NSString *plateNumberLogId;
/// 线下线上标志：1 线上；2 线下
@property (nonatomic , copy) NSString *plateNumberOnlineFlag;
/// 备注
@property (nonatomic , copy) NSString *remark;
/// 修改时间
@property (nonatomic , copy) NSString *updateTime;
/// 修改人id
@property (nonatomic , copy) NSString *updateUserId;
/// 修改人名称
@property (nonatomic , copy) NSString *updateUserName;
@end

NS_ASSUME_NONNULL_END
