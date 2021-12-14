//
//  WalletTopItemTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "WalletTopItemBasicCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WalletTopItemTableCellDelegate <NSObject>
@required
- (void)didClickToQuestion:(id)sender;
@optional
- (void)didClickToRecharge:(id)sender;
- (void)didClickToCashout:(id)sender;

@end

@interface WalletTopItemTableCell : WalletTopItemBasicCell

@property (nonatomic, weak) id <WalletTopItemTableCellDelegate> delegate;
@property (nonatomic ,assign) AMWalletItemStyle style;

@end

NS_ASSUME_NONNULL_END
