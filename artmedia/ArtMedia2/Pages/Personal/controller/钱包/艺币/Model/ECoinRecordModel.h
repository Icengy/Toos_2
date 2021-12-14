//
//  ECoinRecordModel.h
//  ArtMedia2
//
//  Created by LY on 2020/10/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ECoinRecordModel : NSObject
/*
 "goldId": 1,                                          //艺币消费明细表主键id
 "goldNo": 002,                                        //消费编号
 "virtualGoldTitle": "老王充值100艺币",                //讲师名称
 "virtualGoldPrice": 22,                               // 订单艺币金额（艺币）
 "createUserId": 123,                                  //创建人ID
 "createUserName": "张三",                             //创建人名称
 "consumeType": 1,                                    //消费类型 1:充值(+);2消费(-),
 "tradingChannel": 1,                                 //交易渠道 1:支付宝 2:微信,
 "createTime": "2020-09-18 10:37:53",                  //创建时间
 "updateUserId": 123,                                  //修改人id
 "updateUserName": "张三",                             //修改人名称
 "updateTime": "2020-09-18 10:37:53",                  //修改时间
 

 */
@property (nonatomic , copy) NSString *goldId;
@property (nonatomic , copy) NSString *goldNo;
@property (nonatomic , copy) NSString *virtualGoldTitle;
@property (nonatomic , copy) NSString *virtualGoldPrice;
@property (nonatomic , copy) NSString *createUserId;
@property (nonatomic , copy) NSString *createUserName;
@property (nonatomic , copy) NSString *consumeType;
@property (nonatomic , copy) NSString *tradingChannel;
@property (nonatomic , copy) NSString *createTime;
@property (nonatomic , copy) NSString *updateUserId;
@property (nonatomic , copy) NSString *updateUserName;
@property (nonatomic , copy) NSString *updateTime;



@end

NS_ASSUME_NONNULL_END
