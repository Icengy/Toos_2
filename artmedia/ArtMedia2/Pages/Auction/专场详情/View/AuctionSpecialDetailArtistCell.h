//
//  AuctionSpecialDetailArtistCell.h
//  ArtMedia2
//
//  Created by LY on 2020/11/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AuctionModel;
NS_ASSUME_NONNULL_BEGIN

@interface AuctionSpecialDetailArtistCell : UITableViewCell

@property (nonatomic , strong) AuctionModel *model;
@property (nonatomic , copy) void(^focusBlock)(AMButton *sender);
@property (nonatomic , copy) void(^clickToPersonal)(void);
@end

NS_ASSUME_NONNULL_END
