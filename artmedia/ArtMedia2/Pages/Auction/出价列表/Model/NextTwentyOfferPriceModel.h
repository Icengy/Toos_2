//
//  NextTwentyOfferPriceModel.h
//  ArtMedia2
//
//  Created by LY on 2020/12/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NextTwentyOfferPriceModel : NSObject
@property (nonatomic , copy) NSString *auctionGoodId;
@property (nonatomic , strong) NSArray <NSNumber *>*nextOfferPriceList;
@end

NS_ASSUME_NONNULL_END
