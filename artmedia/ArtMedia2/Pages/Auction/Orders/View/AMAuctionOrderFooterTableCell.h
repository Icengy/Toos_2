//
//  AMAuctionOrderFooterTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/11/18.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMAuctionBaseTableCell.h"

@class AMAuctionOrderBusinessModel;
@class AMAuctionOrderFooterTableCell;
NS_ASSUME_NONNULL_BEGIN
@protocol AMAuctionOrderfooterDelegate <NSObject>

@optional
- (void)footerCell:(AMAuctionOrderFooterTableCell *)footerCell clickToCancelOrder:(id)sender;
- (void)footerCell:(AMAuctionOrderFooterTableCell *)footerCell clickToPayOrder:(id)sender;
- (void)footerCell:(AMAuctionOrderFooterTableCell *)footerCell clickToConfirmOrder:(id)sender;

@end

@interface AMAuctionOrderFooterTableCell : AMAuctionBaseTableCell

@property (nonatomic ,weak) id <AMAuctionOrderfooterDelegate> delegate;
@property (nonatomic ,strong) AMAuctionOrderBusinessModel *model;

@end

NS_ASSUME_NONNULL_END
