//
//  GiftListModel.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/12/2.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GiftListModel : NSObject

@property (nonatomic ,strong) NSString *addtime;
///赠礼总金额
@property (nonatomic ,strong) NSString *all_price;
///平台收取佣金
@property (nonatomic ,strong) NSString *commission;
///礼物数量
@property (nonatomic ,strong) NSString *gift_num;
///礼物单价
@property (nonatomic ,strong) NSString *gift_price;
///赠礼人实际付款金额
@property (nonatomic ,strong) NSString *giver_amount;
///赠送人id
@property (nonatomic ,strong) NSString *giver_uid;
///赠送人名称
@property (nonatomic ,strong) NSString *giver_uname;
@property (nonatomic ,copy) NSString *ID;
///视频id
@property (nonatomic ,strong) NSString *obj_id;
///视频图片
@property (nonatomic ,strong) NSString *obj_image;
///赠送对象类型:1短视频
@property (nonatomic ,strong) NSString *obj_type;
///视频名称
@property (nonatomic ,strong) NSString *obj_name;
///被赠送人uid
@property (nonatomic ,strong) NSString *obj_uid;
///被赠送人用户名称
@property (nonatomic ,strong) NSString *obj_uname;
///订单编号
@property (nonatomic ,strong) NSString *ordersn;
///收礼人收款金额
@property (nonatomic ,strong) NSString *payee_amount;
///
@property (nonatomic ,strong) NSString *paytime;
///ios
@property (nonatomic ,strong) NSString *paytype;
///退款时间
@property (nonatomic ,strong) NSString *return_money_time;
///生成订单=0，已付款=1，已退款=2，已提现=3，关闭订单=4
@property (nonatomic ,strong) NSString *state;
///支付流水号
@property (nonatomic ,strong) NSString *wxpay_ordersn;

@end

NS_ASSUME_NONNULL_END
