//
//  AuctionApplyNumberPlateSuccessController.h
//  ArtMedia2
//
//  Created by LY on 2020/11/13.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BaseViewController.h"
#import "AuctionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AuctionApplyNumberPlateSuccessController : BaseViewController
@property (nonatomic , strong) AuctionModel *auctionModel;
@property (nonatomic , assign) AMPayWay payWay;
@end

NS_ASSUME_NONNULL_END
