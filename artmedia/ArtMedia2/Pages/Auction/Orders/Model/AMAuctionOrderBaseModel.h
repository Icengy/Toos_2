//
//  AMAuctionLotModel.h
//  ArtMedia2
//
//  Created by icnengy on 2020/11/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 基类model
@interface AMAuctionOrderBaseModel : BaseModel
@property (nonatomic ,assign) BOOL isSelect;
@end


#pragma mark - 订单拍品model
@interface AMAuctionLotModel : AMAuctionOrderBaseModel

/// 未结算拍品表主键id
@property (nonatomic ,copy) NSString *unsettledAuctionGoodsId;
/// 拍客用户id（买家id）
@property (nonatomic ,copy) NSString *auctionUserId;
/// 拍客用户名称id（买家用户名称）
@property (nonatomic ,copy) NSString *auctionUserName;
/// 线下线上标志：1 线上；2 线下
@property (nonatomic ,copy) NSString *plateNumberOnlineFlag;
/// 拍客的号牌
@property (nonatomic ,copy) NSString *auctionFieldPlateNumber;
/// 大厅号牌（线下大厅实际号牌）
@property (nonatomic ,copy) NSString *hallPlateNumber;
/// 主办方id（卖家ID）
@property (nonatomic ,copy) NSString *hostUserId;
/// 主办方名称（卖家用户名称）
@property (nonatomic ,copy) NSString *hostUserName;
/// pm专场主键id
@property (nonatomic ,copy) NSString *auctionFieldId;
/// 专场拍品表主键id
@property (nonatomic ,copy) NSString *auctionGoodId;
/// 艺术家作品主键id
@property (nonatomic ,copy) NSString *artistOpusId;
/// 艺术家作品标题
@property (nonatomic ,copy) NSString *opusTitle;
///后台合成的title
@property (nonatomic ,copy) NSString *composeTitle;
///规格描述
@property (nonatomic ,copy) NSString *opusSpecs;
/// 艺术家作品封面图片（拍品图片）
@property (nonatomic ,copy) NSString *opusCoverImage;
/// 拍品编号（图录号）
@property (nonatomic ,copy) NSString *goodNumber;
/// 成交价
@property (nonatomic ,copy) NSString *dealPrice;
/// 成交价 x 抽成比例（10%），后台计算
@property (nonatomic ,copy) NSString *serviceFeePrice;
/// 实际付款价格
@property (nonatomic ,copy) NSString *actualPrice;
/// 结算状态：1 已结算（已生成结算订单），2 未结算（未生成结算订单）3，结算过期
@property (nonatomic ,copy) NSString *settledStatus;
/// 结算订单号（拍品订单号）
@property (nonatomic ,copy) NSString *auctionGoodOrderNo;
/// 结算时间
@property (nonatomic ,copy) NSString *settledTime;
/// 结算过期时间
@property (nonatomic ,copy) NSString *settledOverdueTime;
/// 备注
@property (nonatomic ,copy) NSString *remark;

@end

#pragma mark - 订单商户Model
@interface AMAuctionOrderBusinessModel : AMAuctionOrderBaseModel

/// 卖家名称
@property (nonatomic ,copy) NSString *hostUserName;
/// 卖家ID
@property (nonatomic ,copy) NSString *hostUserId;
/// 包含的商品列表
@property (nonatomic ,strong) NSArray <AMAuctionLotModel *> *lots;


/// 订单状态：1 下单待支付；2 下单已支付=卖家待发货；3 买家待收货（填写物流信息）；4 买家签收；5 订单完结；6 订单关闭
@property (nonatomic ,assign) AMAuctionOrderStyle orderStatus;
/// 订单ID
@property (nonatomic ,copy) NSString *auctionGoodOrderId;
/// 实际应付款金额
@property (nonatomic ,copy) NSString *orderPrice;

@end



NS_ASSUME_NONNULL_END
