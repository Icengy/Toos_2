//
//  MyAuctionMoneyNormalView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/11/19.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyAuctionMoneyNormalView : BaseView

/// 0:缴费 1:退回 2:罚没
@property (nonatomic ,assign) NSInteger style;
@property (nonatomic ,copy) NSString *dateStr;
@property (nonatomic ,copy) NSString *priceStr;;

@end

NS_ASSUME_NONNULL_END
