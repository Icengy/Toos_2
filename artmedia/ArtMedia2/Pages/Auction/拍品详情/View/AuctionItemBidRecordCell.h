//
//  AuctionItemBidRecordCell.h
//  ArtMedia2
//
//  Created by 刘洋 on 2020/11/23.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuctionOfferPriceRecordModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AuctionItemBidRecordCell : UITableViewCell
@property (nonatomic , strong) AuctionOfferPriceRecordModel *model;
@end

NS_ASSUME_NONNULL_END
