//
//  WalletListModel.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/17.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletListBaseModel : NSObject

/// 数据类型
@property (nonatomic ,assign) AMWalletItemDetailStyle style;

@property (nonatomic ,copy) NSString *id;
@property (nonatomic ,copy) NSString *addtime;

@end

@interface WalletRevenueListMeetingModel : NSObject

@property (nonatomic ,copy) NSString *artist_id;/// 会主
@property (nonatomic ,copy) NSString *tea_about_info_id;/// 茶会ID
@property (nonatomic ,copy) NSString *tea_start_time;/// 茶会开始时间

@end

@interface WalletRevenueListCourseModel : NSObject

@property (nonatomic ,copy) NSString *course_id;/// 课程id
@property (nonatomic ,copy) NSString *order_price;/// 支付课币价格
@property (nonatomic ,copy) NSString *from_object_name;/// 课程名称
@property (nonatomic ,copy) NSString *buy_time;/// 购买时间

@end

@interface WalletRevenueListModel : WalletListBaseModel

@property (nonatomic ,copy) NSString *bill_amount;
@property (nonatomic ,copy) NSString *bill_title;
/// 副标题：如 分佣奖励
@property (nonatomic ,copy) NSString *bill_category;
/// 流水订单号
@property (nonatomic ,copy) NSString *bill_record_number;
@property (nonatomic ,copy) NSString *bill_state;
///流入/流出 1流入 2流出
@property (nonatomic ,copy) NSString *bill_type;
@property (nonatomic ,copy) NSString *user_id;

@property (nonatomic ,copy) NSString *account_type;
@property (nonatomic ,copy) NSString *price;

/// 1销售 2收益 3提现 4茶会受益
@property (nonatomic ,copy) NSString *state;

/// 提现数据独有
@property (nonatomic ,copy) NSString *bankname;
@property (nonatomic ,copy) NSString *bankno;
/// 收益独有
@property (nonatomic ,copy) NSString *uname;
@property (nonatomic ,copy) NSString *uid;
/// 销售独有
@property (nonatomic ,copy) NSString *good_name;
@property (nonatomic ,copy) NSString *orderid;
@property (nonatomic ,copy) NSString *orderstate;
/// 茶会独有
@property (nonatomic ,strong) WalletRevenueListMeetingModel *tea_info;
/// 课程独有
@property (nonatomic ,strong) WalletRevenueListCourseModel *course_info;

@end

@interface WalletEstimateListModel : WalletListBaseModel

/// 实际金额
@property (nonatomic ,copy) NSString *actual_amount;
@property (nonatomic ,copy) NSString *cancel_reason;
@property (nonatomic ,copy) NSString *from_order_number;
@property (nonatomic ,copy) NSString *from_user_id;
@property (nonatomic ,copy) NSString *from_user_name;
@property (nonatomic ,copy) NSString *gain_user_id;
@property (nonatomic ,copy) NSString *gain_user_name;
@property (nonatomic ,copy) NSString *identify_type;
@property (nonatomic ,copy) NSString *modify_time;
@property (nonatomic ,copy) NSString *official_commission_amount;
@property (nonatomic ,copy) NSString *official_commission_rate;
@property (nonatomic ,copy) NSString *official_net_income;
@property (nonatomic ,copy) NSString *personal_tax_amount;
@property (nonatomic ,copy) NSString *personal_tax_rate;
@property (nonatomic ,copy) NSString *rake_back_amount;
@property (nonatomic ,copy) NSString *rake_back_level;
@property (nonatomic ,copy) NSString *rake_back_ratio;
/// 奖励金额
@property (nonatomic ,copy) NSString *reward_money;
/// 订单状态 0、1:有效 2:无效
@property (nonatomic ,copy) NSString *reward_order_state;
/// 预估收益类型：1销售商品，2销售课程，3商品返佣
@property (nonatomic ,copy) NSString *reward_type;

@property (nonatomic ,copy) NSString *statement_number;
@property (nonatomic ,copy) NSString *statement_remark;
/// 标题/商品名称
@property (nonatomic ,copy) NSString *title;
/// 订单ID
@property (nonatomic ,copy) NSString *oid;
/// 订单编号
@property (nonatomic ,copy) NSString *ordersn;
/// 订单状态
@property (nonatomic ,copy) NSString *ostate;

@end

@interface WalletBalanceListModel : WalletListBaseModel

@end

@interface WalletYBListModel : WalletListBaseModel

@end

NS_ASSUME_NONNULL_END
