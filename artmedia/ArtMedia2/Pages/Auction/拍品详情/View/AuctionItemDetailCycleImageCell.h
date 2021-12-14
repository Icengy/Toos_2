//
//  AuctionItemDetailCycleImageCell.h
//  ArtMedia2
//
//  Created by 刘洋 on 2020/11/23.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuctionItemDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AuctionItemDetailCycleImageCell : UITableViewCell
@property (nonatomic , strong) AuctionItemDetailModel *model;
@property (nonatomic , copy) void(^backBlock)(void);
@property (nonatomic , copy) void(^shareBlock)(void);
@end

NS_ASSUME_NONNULL_END
