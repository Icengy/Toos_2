//
//  AMAuctionOrderModel.h
//  ArtMedia2
//
//  Created by icnengy on 2020/11/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AMAuctionOrderBaseModel.h"
#import "MyAddressModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AMAuctionOrderModel : NSObject

/// 订单ID
@property (nonatomic ,copy) NSString *auctionGoodOrderId;
/// 拍品订单号
@property (nonatomic ,copy) NSString *auctionGoodOrderNo;
/// 拍客用户id（买家id）
@property (nonatomic ,copy) NSString *auctionUserId;
/// 拍客用户名称 （买家名称）
@property (nonatomic ,copy) NSString *auctionUserName;
/// 主办方id（卖家id）
@property (nonatomic ,copy) NSString *hostUserId;
/// 主办方名称 （卖家名称）
@property (nonatomic ,copy) NSString *hostUserName;
/// pm专场主键id
@property (nonatomic ,copy) NSString *auctionFieldId;
/// 拍品数量
@property (nonatomic ,copy) NSString *auctionGoodAmount;

/// 订单成交价
@property (nonatomic ,copy) NSString *dealPrice;
/// 订单服务费
@property (nonatomic ,copy) NSString *serviceFeePrice;
/// 商品金额
@property (nonatomic ,copy) NSString *allAuctionGoodPrice;
/// 实际应付款金额
@property (nonatomic ,copy) NSString *orderPrice;

/// 下单时间
@property (nonatomic ,copy) NSString *createOrderTime;
/// 支付类型，1 线上支付，2 线下打款
@property (nonatomic ,copy) NSString *payType;
/// 支付状态；1 未支付，2 支付过期取消，3 已支付
@property (nonatomic ,copy) NSString *payStatus;
/// 支付订单号
@property (nonatomic ,copy) NSString *payOrderNo;
/// 支付时间
@property (nonatomic ,copy) NSString *payTime;
/// 支付过期时间
@property (nonatomic ,copy) NSString *payOverdueTime;
/// 商户订单单号
@property (nonatomic ,copy) NSString *tradeNo;
/// 支付渠道 1:线上支付宝；2 线上微信，3 applePay 4：线下支付
@property (nonatomic ,copy) NSString *payChannel;
/// 1 线下支付宝扫码，2 线下微信扫码，3 线下银行卡转账，4 线下pos机刷卡，5 线下现金支付
@property (nonatomic ,copy) NSString *offlineTradingChannel;
/// 支付流水号
@property (nonatomic ,copy) NSString *tradingNumber;
/// 订单状态：1 下单待支付；2 下单已支付=卖家待发货；3 买家待收货（填写物流信息）；4 买家签收；5 订单完结；6 订单关闭
@property (nonatomic ,assign) AMAuctionOrderStyle orderStatus;
/// 退货状态：1 无售后；2 售后中
@property (nonatomic ,copy) NSString *afterSalesStatus;
/// 发货时间
@property (nonatomic ,copy) NSString *sendGoodsTime;
/// 订单完成时间
@property (nonatomic ,copy) NSString *finishTime;
/// 备注
@property (nonatomic ,copy) NSString *remark;

/// 发货信息
@property (nonatomic ,strong) MyAddressModel *logisticsInfo;
/// 拍品列表
@property (nonatomic ,strong) AMAuctionOrderBusinessModel *lotModel;

@end

NS_ASSUME_NONNULL_END
