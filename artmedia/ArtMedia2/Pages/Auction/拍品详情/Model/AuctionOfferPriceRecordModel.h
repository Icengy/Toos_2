//
//  AuctionOfferPriceRecordModel.h
//  ArtMedia2
//
//  Created by 刘洋 on 2020/11/23.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AuctionOfferPriceRecordModel : NSObject
/// 线下线上标志：1 线上；2 线下
@property(nonatomic,copy) NSString *plateNumberOnlineFlag;
/// 作废标识: 1 作废；2 不作废
@property(nonatomic,copy) NSString *cancelFlag;
@property(nonatomic,copy) NSString *auctionUserName;
@property(nonatomic,copy) NSString *auctionUserId;
/// 创建人名称
@property(nonatomic,copy) NSString *createUserName;
/// 拍品图录号（商品编号）
@property(nonatomic,copy) NSString *goodNumber;
@property(nonatomic,copy) NSString *isDelete;
/// 创建时间
@property(nonatomic,copy) NSString *createTime;
/// 拍品出价记录表主键id
@property(nonatomic,copy) NSString *goodsOfferLogId;
/// 创建人ID
@property(nonatomic,copy) NSString *createUserId;
/// 当前出价
@property(nonatomic,copy) NSString *auctionUserOfferPrice;
/// 拍品表主键id
@property(nonatomic,copy) NSString *auctionGoodId;
@property(nonatomic,copy) NSString *remark;
/// 拍客专场牌号
@property(nonatomic,copy) NSString *auctionFieldPlateNumber;
@property(nonatomic,copy) NSString *userHeadImg;
@end

NS_ASSUME_NONNULL_END
