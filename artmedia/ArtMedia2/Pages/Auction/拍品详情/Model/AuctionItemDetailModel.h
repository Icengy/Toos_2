//
//  AuctionItemDetailModel.h
//  ArtMedia2
//
//  Created by 刘洋 on 2020/11/23.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class OpusImageModel;
@interface AuctionItemDetailModel : NSObject
/*
 artistOpusId = 20;
 auctionFieldId = 14;
 auctionGoodId = 7;
 auctionGoodPopularity = 0;
 auctionGoodStatus = 2;
 auctionStartPrice = 2000;
 createTime = "2020-11-19 15:34:25";
 createUserId = "<null>";
 createUserName = "<null>";
 currentMaxPrice = "<null>";
 currentMaxPriceUserId = "<null>";
 currentMaxPriceUserName = "<null>";
 currentMaxPriceUserPlateNumber = "<null>";
 dealPrice = "<null>";
 goodNumber = 1;
 hostUserId = 843;
 hostUserName = "西米露";
 increasePriceNumber = 0;
 isDelete = 2;
 isMySelf = 2;
 opusAuthor = 22;
 opusClassId = 7;
 opusCoverImage = "group1/M00/00/05/rBAu0l-2DnWAaQP6AAART9HGs0Y736.jpg";
 opusImagesList =         (
                 {
         artistOpusId = 20;
         createTime = "2020-11-19 15:14:45";
         createUserId = 843;
         createUserName = "西米露";
         image = "group1/M00/00/05/rBAu0l-16DSAJ_eEAACRglFn0AM561.jpg";
         isDelete = 2;
         opusImagesId = 27;
         sort = 1;
         updateTime = "<null>";
         updateUserId = "<null>";
         updateUserName = "<null>";
     }
 );
 opusParentClassId = 2;
 opusPrice = 22;
 opusRemark = "<null>";
 opusTitle = 22;
 referenceEndPrice = 3320;
 referenceStartPrice = 1000;
 remark = "<null>";
 retainPrice = 45500;
 updateTime = "2020-11-20 10:19:00";
 updateUserId = 843;
 updateUserName = "西米露";
 userId = "<null>";
 verifyStatus = 3;
 */

@property (nonatomic , copy) NSString *artistOpusId;
@property (nonatomic , copy) NSString *auctionFieldId;
@property (nonatomic , copy) NSString *auctionGoodId;
@property (nonatomic , copy) NSString *auctionGoodPopularity;
@property (nonatomic , copy) NSString *auctionGoodStatus;
@property (nonatomic , copy) NSString *auctionStartPrice;
@property (nonatomic , copy) NSString *createTime;
@property (nonatomic , copy) NSString *createUserId;
@property (nonatomic , copy) NSString *createUserName;
@property (nonatomic , copy) NSString *currentMaxPrice;
@property (nonatomic , copy) NSString *currentMaxPriceUserId;
@property (nonatomic , copy) NSString *currentMaxPriceUserName;
@property (nonatomic , copy) NSString *currentMaxPriceUserPlateNumber;
@property (nonatomic , copy) NSString *dealPrice;
@property (nonatomic , copy) NSString *goodNumber;
@property (nonatomic , copy) NSString *hostUserId;
@property (nonatomic , copy) NSString *hostUserName;
@property (nonatomic , copy) NSString *increasePriceNumber;
@property (nonatomic , copy) NSString *isDelete;
@property (nonatomic , copy) NSString *isMySelf;
@property (nonatomic , copy) NSString *opusAuthor;
@property (nonatomic , copy) NSString *opusClassId;
@property (nonatomic , copy) NSString *opusCoverImage;
@property (nonatomic , strong) NSArray <OpusImageModel *>*opusImagesList;
@property (nonatomic , copy) NSString *opusParentClassId;
@property (nonatomic , copy) NSString *opusPrice;
@property (nonatomic , copy) NSString *opusRemark;
@property (nonatomic , copy) NSString *opusTitle;
@property (nonatomic , copy) NSString *referenceEndPrice;
@property (nonatomic , copy) NSString *referenceStartPrice;
@property (nonatomic , copy) NSString *remark;
@property (nonatomic , copy) NSString *retainPrice;
@property (nonatomic , copy) NSString *updateTime;
@property (nonatomic , copy) NSString *updateUserId;
@property (nonatomic , copy) NSString *updateUserName;
@property (nonatomic , copy) NSString *verifyStatus;

@property (nonatomic , copy) NSString *composeTitle;
@property (nonatomic , copy) NSString *opusSpecs;
@end


/*
 artistOpusId = 20;
 createTime = "2020-11-19 15:14:45";
 createUserId = 843;
 createUserName = "西米露";
 image = "group1/M00/00/05/rBAu0l-16DSAJ_eEAACRglFn0AM561.jpg";
 isDelete = 2;
 opusImagesId = 27;
 sort = 1;
 updateTime = "<null>";
 updateUserId = "<null>";
 updateUserName = "<null>";
 */
@interface OpusImageModel : NSObject
@property (nonatomic , copy) NSString *image;
@end
NS_ASSUME_NONNULL_END
