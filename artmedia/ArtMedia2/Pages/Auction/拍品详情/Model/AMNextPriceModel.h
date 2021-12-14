//
//  AMNextPriceModel.h
//  ArtMedia2
//
//  Created by LY on 2020/12/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AMNextPriceModel : NSObject
/*
 auctionGoodId = 405;
 nextOfferPrice = 400;
 */
@property (nonatomic , copy) NSString *auctionGoodId;
@property (nonatomic , copy) NSString *nextOfferPrice;
@end

NS_ASSUME_NONNULL_END
