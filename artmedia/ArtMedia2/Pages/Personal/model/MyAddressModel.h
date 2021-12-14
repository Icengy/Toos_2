//
//  MyAddressModel.h
//  ArtMedia
//
//  Created by 美术传媒 on 2018/11/15.
//  Copyright © 2018 lcy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyAddressModel : NSObject

//{"id":"1","uid":"160","reciver":"秦翔","phone":"18758129692","addrregion":"浙江省杭州市下城区","address":"西湖铭楼401","is_default":"1"}
@property (nonatomic ,copy) NSString *addtime;

@property(nonatomic,copy) NSString *ID;
/// 邮编
@property (nonatomic ,copy) NSString *postalcode;
///接收者
@property(nonatomic,copy) NSString *reciver;
///手机号
@property(nonatomic,copy) NSString *phone;
///地区
@property(nonatomic,copy) NSString *addrregion;
///详细地址
@property(nonatomic,copy) NSString *address;
///是否默认地址
@property(nonatomic,assign) BOOL is_default;

///物流公司
@property (nonatomic ,copy) NSString *devlivery_comp;
///物流单号
@property (nonatomic ,copy) NSString *devlivery_no;
/// 1发货物流 2退货物流
@property (nonatomic ,copy) NSString *type;
/// type = 1:发货时间 type = 2:退货时间
@property (nonatomic ,copy) NSString *delivery_time;
/// 备注
@property (nonatomic ,copy) NSString *remark;
/// 1 拍品订单 2商品订单
@property (nonatomic ,copy) NSString *order_type;
/// 订单ID
@property (nonatomic ,copy) NSString *order_id;
/// 邮费
@property (nonatomic ,copy) NSString *freight;

@end

NS_ASSUME_NONNULL_END
