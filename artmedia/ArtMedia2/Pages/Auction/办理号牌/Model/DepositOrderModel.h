//
//  DepositOrderModel.h
//  ArtMedia2
//
//  Created by LY on 2020/11/23.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DepositOrderModel : NSObject
/*
 auctionFieldId = 14;
 auctionFieldPlateNumber = "<null>";
 auctionFieldTitle = 111;
 createTime = "<null>";
 createUserId = "<null>";
 createUserName = "<null>";
 depositAmount = 2;
 depositForfeitureAmount = 0;
 depositForfeitureTime = "<null>";
 depositOrderId = 3;
 depositOrderNo = MBZJ0debug2011240004;
 depositOrderStatus = 1;
 depositPayStatus = 1;
 depositPayTime = "<null>";
 depositPayUserId = 836;
 depositPayUserMobile = 17557283488;
 depositPayUserName = "游客077396";
 depositRefundAmount = 0;
 depositRefundTime = "<null>";
 hostUserId = 843;
 hostUserName = "西米露";
 isAutoForfeiture = "<null>";
 isAutoRefund = "<null>";
 isDelete = 2;
 isShouldRefund = "<null>";
 offlineTradeNo = "<null>";
 offlineTradingChannel = "<null>";
 payChannel = "<null>";
 payOverdueTime = "2020-11-27 10:13:31";
 payType = "<null>";
 plateNumberLogId = 10;
 remark = "<null>";
 tradeNo = "<null>";
 tradingNumber = "<null>";
 transferTime = "<null>";
 updateTime = "<null>";
 updateUserId = "<null>";
 updateUserName = "<null>";
 */
@property (nonatomic , copy) NSString *depositOrderId;

@end

NS_ASSUME_NONNULL_END
