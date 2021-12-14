//
//  AuctionItemBidRecordHeadView.h
//  ArtMedia2
//
//  Created by 刘洋 on 2020/11/23.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface AuctionItemBidRecordHeadView : BaseView

@property (nonatomic ,assign) NSInteger bidTotalTimes;
@property (nonatomic , copy) void(^clickToRulersBlock)(void);

@end

NS_ASSUME_NONNULL_END
