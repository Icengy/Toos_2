//
//  AMAuctionBaseTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/11/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AMAuctionBaseTableCell : UITableViewCell

@property (nonatomic, assign) BOOL isShoppingCart;
@property (nonatomic ,assign) BOOL needCorner;
@property (nonatomic ,assign) UIRectCorner rectCorner;
@property (nonatomic ,assign) CGFloat cornerRudis;
@property (nonatomic ,assign) UIEdgeInsets insets;

@end

NS_ASSUME_NONNULL_END
