//
//  AMOfferPriceListViewController.h
//  ArtMedia2
//
//  Created by LY on 2020/12/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@protocol AMOfferPriceListDelegate <NSObject>
@optional
- (void)priceListOfferPrice:(NSString *)price;
@end
@interface AMOfferPriceListViewController : BaseViewController
@property (nonatomic , copy) NSString *auctionGoodId;
@property (nonatomic , weak) id <AMOfferPriceListDelegate> delegate;
- (void)showWithController:(UIViewController *)controller;

@end

NS_ASSUME_NONNULL_END
