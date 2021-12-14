//
//  AMAuctionPayResultViewController.h
//  ArtMedia2
//
//  Created by icnengy on 2020/11/13.
//  Copyright © 2020 翁磊. All rights reserved.
//
// 支付结果页(成功)
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AMAuctionPayResultViewController : BaseViewController

@property (nonatomic ,copy) NSString *priceStr;
@property (nonatomic ,assign) AMPayWay payWay;

@end

NS_ASSUME_NONNULL_END
