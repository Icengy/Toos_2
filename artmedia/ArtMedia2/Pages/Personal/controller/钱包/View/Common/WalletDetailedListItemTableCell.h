//
//  WalletDetailedListItemTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/11.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WalletListBaseModel;
NS_ASSUME_NONNULL_BEGIN

@interface WalletDetailedListItemTableCell : UITableViewCell

@property (nonatomic, strong) WalletListBaseModel *detailModel;

@end

NS_ASSUME_NONNULL_END
