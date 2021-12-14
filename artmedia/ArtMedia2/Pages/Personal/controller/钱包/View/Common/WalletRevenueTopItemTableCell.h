//
//  WalletRevenueTopItemTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "WalletTopItemBasicCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WalletRevenueTopItemDelegate <NSObject>
@optional

/// 点击提现
/// @param sender sender
/// @param index 销售提现=0，收益提现=1
- (void)didClickToCashout:(id)sender forIndex:(NSInteger)index;

@end


@interface WalletRevenueTopItemTableCell : WalletTopItemBasicCell

@property (nonatomic, weak) id <WalletRevenueTopItemDelegate> delegate;
@property (nonatomic ,assign) BOOL isAuthUser;
@property (nonatomic ,strong) NSDictionary *revenueData;

@end

NS_ASSUME_NONNULL_END
