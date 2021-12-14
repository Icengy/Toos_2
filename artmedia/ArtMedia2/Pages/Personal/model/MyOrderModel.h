//
//  MyOrderModel.h
//  ArtMedia
//
//  Created by 美术传媒 on 2018/11/11.
//  Copyright © 2018 lcy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MyAddressModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ApplyOrderModel : NSObject

///申请状态 0：未申请 1：申请中 2：已通过 3：已到账
@property (nonatomic ,assign) NSInteger apply_state;
///申请审核状态 0：未审核 1：通过 2：拒绝
@property (nonatomic ,assign) NSInteger audit_state;

@property (nonatomic ,copy) NSString *account_number;
@property (nonatomic ,copy) NSString *account_type;
@property (nonatomic ,copy) NSString *account_user_name;
@property (nonatomic ,copy) NSString *apply_amount;
///提现时间
@property (nonatomic ,copy) NSString *apply_date;
@property (nonatomic ,copy) NSString *apply_uid;
@property (nonatomic ,copy) NSString *apply_uname;
@property (nonatomic ,copy) NSString *audit_date;
@property (nonatomic ,copy) NSString *audit_remark;
@property (nonatomic ,copy) NSString *bank_name;
@property (nonatomic ,copy) NSString *commission;
@property (nonatomic ,copy) NSString *ID;
@property (nonatomic ,copy) NSString *obj_name;
@property (nonatomic ,copy) NSString *order_id;
@property (nonatomic ,copy) NSString *order_type;
@property (nonatomic ,copy) NSString *retmsg;
@property (nonatomic ,copy) NSString *trade_nomber;

@end

@interface MyOrderModel : NSObject

///订单添加时间
@property(nonatomic ,copy) NSString *addtime;
///订单支付时间
@property(nonatomic ,copy) NSString *pay_time;
///确认收货时间
@property (nonatomic ,copy) NSString *confirmtime;

///支付金额
@property(nonatomic ,copy) NSString *buyer_amount;
///购买人ID
@property(nonatomic ,copy) NSString *buyer_id;
///购买人姓名
@property(nonatomic ,copy) NSString *buyer_name;
///佣金
@property(nonatomic ,copy) NSString *commission;
///订单ID
@property(nonatomic ,copy) NSString *ID;
///商品ID
@property(nonatomic ,copy) NSString *obj_id;
///商品图片
@property(nonatomic ,copy) NSString *obj_image;
///商品名称
@property(nonatomic ,copy) NSString *obj_name;

///销售金额
@property(nonatomic ,copy) NSString*seller_amount;
///卖家ID
@property(nonatomic ,copy) NSString*seller_id;
///卖家姓名
@property(nonatomic ,copy) NSString*seller_name;
///订单类型 1拍品订单 2商品订单
@property(nonatomic ,copy) NSString*type;
@property(nonatomic ,copy) NSString*seller_headimg;
@property (nonatomic , assign) NSInteger is_invest;
@property (nonatomic ,copy) NSString *is_invest_buyer;

///订单状态 生成订单=0，已付款=1，已发货=2，确认收货=3，退货/退款中=4，退货/退款完成=5，已退款/退款=6，已提现=7，关闭订单=8
@property(nonatomic ,assign) MyOrderType state;
///买卖类型
@property(nonatomic ,assign) MyOrderWayType wayType;

/// 退货 买家是否寄出过商品
@property (nonatomic ,copy) NSString *is_deliver_goods;

///退货状态 0 未申请 1 申请中 2同意退货 3拒绝退货
@property (nonatomic ,copy) NSString *oretapply;
///退货原因
@property (nonatomic ,copy) NSString *apply_reason;
///退货申请时间
@property (nonatomic ,copy) NSString *oretapplydate;
///退货处理时间
@property (nonatomic ,copy) NSString *oret_deal_date;
///退货拒绝说明
@property (nonatomic ,copy) NSString *refuse_remark;
///退款时间
@property (nonatomic ,copy) NSString *return_money_time;

///订单编号
@property (nonatomic ,copy) NSString *ordersn;

@property (nonatomic ,copy) NSString *price;

///地址信息 发货信息
@property (nonatomic ,strong) MyAddressModel *send_delivery;
///地址信息 退货信息
@property (nonatomic ,strong) MyAddressModel *return_delivery;

///提现信息
//@property (nonatomic ,strong) ApplyOrderModel *apply_order;

@end



NS_ASSUME_NONNULL_END
