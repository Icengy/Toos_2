//
//  AMAuctionOrderFillViewController.h
//  ArtMedia2
//
//  Created by icnengy on 2020/11/13.
//  Copyright © 2020 翁磊. All rights reserved.
//
// 拍品下单页
//

#import "BaseViewController.h"

@class AMAuctionOrderBusinessModel;
NS_ASSUME_NONNULL_BEGIN

@interface AMAuctionOrderFillViewController : BaseViewController

/// 总价
@property (nonatomic ,copy) NSString *totalPrice;
/// 选中商户-商品
@property (nonatomic ,strong) NSArray<AMAuctionOrderBusinessModel *> *lots;

@end

NS_ASSUME_NONNULL_END
