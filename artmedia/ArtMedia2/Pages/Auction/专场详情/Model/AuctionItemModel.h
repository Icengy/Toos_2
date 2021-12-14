//
//  AuctionItemModel.h
//  ArtMedia2
//
//  Created by 刘洋 on 2020/11/22.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AuctionItemModel : NSObject
/*
 artistOpusId = 20;
 auctionFieldId = 14;
 auctionGoodId = 7;
 auctionGoodStatus = 2;
 auctionStartPrice = 2000;
 dealPrice = "<null>";
 goodNumber = 1;
 opusCoverImage = "group1/M00/00/05/rBAu0l-2DnWAaQP6AAART9HGs0Y736.jpg";
 opusTitle = 22;
 referenceEndPrice = 3320;
 referenceStartPrice = 1000;
 */

/// 作品主键id
@property (nonatomic , copy) NSString *artistOpusId;
/// pm专场主键id
@property (nonatomic , copy) NSString *auctionFieldId;
/// 专场拍品表主键id
@property (nonatomic , copy) NSString *auctionGoodId;
/// 拍品状态，1：未开拍，2：竞价中，3：已结拍，4：流拍
@property (nonatomic , copy) NSString *auctionGoodStatus;
/// 起拍价
@property (nonatomic , copy) NSString *auctionStartPrice;
/// 成交价
@property (nonatomic , copy) NSString *dealPrice;
/// 拍品编号（图录号）
@property (nonatomic , copy) NSString *goodNumber;
/// 作品封面图片
@property (nonatomic , copy) NSString *opusCoverImage;
/// 作品标题
@property (nonatomic , copy) NSString *opusTitle;
@property (nonatomic , copy) NSString *composeTitle;

/// 参考结束价
@property (nonatomic , copy) NSString *referenceEndPrice;
/// 参考起始价
@property (nonatomic , copy) NSString *referenceStartPrice;

@property (nonatomic , copy) NSString *currentMaxPrice;

@property (nonatomic , copy) NSString *increasePriceNumber;
@end

NS_ASSUME_NONNULL_END
