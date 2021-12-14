//
//  MyAuctionMoneyModel.h
//  ArtMedia2
//
//  Created by LY on 2020/11/13.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMAuctionOrderBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyAuctionMoneyModel : AMAuctionOrderBaseModel

/// 保证金订单id
@property (nonatomic ,copy) NSString *depositOrderId;
/// 牌号记录主键id
@property (nonatomic ,copy) NSString *plateNumberLogId;
/// 保证金订单号
@property (nonatomic ,copy) NSString *depositOrderNo;
/// pm专场主键id
@property (nonatomic ,copy) NSString *auctionFieldId;
/// pm专场名称
@property (nonatomic ,copy) NSString *auctionFieldTitle;
/// 主办方用户id（艺术家id）
@property (nonatomic ,copy) NSString *hostUserId;
/// 主办方用户名称（艺术家名称）
@property (nonatomic ,copy) NSString *hostUserName;
/// 保证金金额
@property (nonatomic ,copy) NSString *depositAmount;
/// 保证金缴纳人id
@property (nonatomic ,copy) NSString *depositPayUserId;
/// 保证金缴纳人名称
@property (nonatomic ,copy) NSString *depositPayUserName;
/// 保证金缴纳人手机号码
@property (nonatomic ,copy) NSString *depositPayUserMobile;
/// 支付渠道 1:线上支付宝；2 线上微信，3 线下支付宝扫码，4 线下支付宝扫码，5 线下银行卡转账，6 线下pos机刷卡，7 线下现金支付
@property (nonatomic ,copy) NSString *payChannel;
/// 支付类型：1:线上支付；2线下打款
@property (nonatomic ,copy) NSString *payType;
/// 交易流水号
@property (nonatomic ,copy) NSString *tradingNumber;
/// 专场保证金支付状态；1:未支付；2 支付过期取消，3已支付；
@property (nonatomic ,copy) NSString *depositPayStatus;
/// 保证金支付时间
@property (nonatomic ,copy) NSString *depositPayTime;
/// 保证金支付过期时间
@property (nonatomic ,copy) NSString *payOverdueTime;
/// 是否可退款。1 可退款（可以自动退款），2 不可退款（不可自动退款）
@property (nonatomic ,copy) NSString *isAutoRefund;
/// 应不应该退：1 应该退（满足退款条件，已拍全买，没拍到拍品）; 2 不应该退（不满足退款条件，已拍未全买）
@property (nonatomic ,copy) NSString *isShouldRefund;
/// 保证金状态：1 初始状态，2 待退款（满足退款条件，已拍到拍品全买或者未拍到拍品），3 待处理（不满足退款条件，拍到拍品未全买），4 已退款（全退），5 已罚没（全罚没），6 已完成（部分退和部分罚没之和 = 订单金额）
@property (nonatomic ,copy) NSString *depositOrderStatus;
/// 保证金退款时间
@property (nonatomic ,copy) NSString *depositRefundTime;
/// 保证金退款金额
@property (nonatomic ,copy) NSString *depositRefundAmount;
/// 是否可罚没。1 可罚没（可以自动全额罚没），2 不可罚没（不可自动罚没）
@property (nonatomic ,copy) NSString *isAutoForfeiture;
/// 保证金罚没金额
@property (nonatomic ,copy) NSString *depositForfeitureAmount;
/// 保证金罚没时间
@property (nonatomic ,copy) NSString *depositForfeitureTime;

@end

NS_ASSUME_NONNULL_END
