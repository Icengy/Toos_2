//
//  AuctionItemDetailInfoCell.h
//  ArtMedia2
//
//  Created by 刘洋 on 2020/11/23.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuctionItemDetailModel.h"
#import "AuctionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AuctionItemDetailInfoCell : UITableViewCell
@property (nonatomic , strong) AuctionItemDetailModel *model;
@property (nonatomic , strong) AuctionModel *auctionModel;
@property (nonatomic , copy) void(^refreshPriceBlock)(void);
@property (nonatomic , copy) void(^gotoLiveRoomBlock)(void);
@end

NS_ASSUME_NONNULL_END
