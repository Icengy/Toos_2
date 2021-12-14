//
//  WXPayModel.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/8/29.
//  Copyright © 2019 lcy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXPayModel : NSObject


/** 请求类型 */
@property (nonatomic, assign) int type;
/** 由用户微信号和AppID组成的唯一标识，发送请求时第三方程序必须填写，用于校验微信用户是否换号登录*/
@property (nonatomic, copy) NSString *openid;
/** 商家向财付通申请的商家id */
@property (nonatomic, copy) NSString *partnerid;
/** 预支付订单 */
@property (nonatomic, copy) NSString *prepayid;
/** 随机串，防重发 */
@property (nonatomic, copy) NSString *noncestr;
/** 时间戳，防重发 */
@property (nonatomic, assign) UInt32 timestamp;
/** 商家根据财付通文档填写的数据和签名 */
@property (nonatomic, copy) NSString *package;
/** 商家根据微信开放平台文档对数据做的签名 */
@property (nonatomic, copy) NSString *sign;

@end

NS_ASSUME_NONNULL_END
