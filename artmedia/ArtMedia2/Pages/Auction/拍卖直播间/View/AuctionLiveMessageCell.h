//
//  AuctionLiveMessageCell.h
//  ArtMedia2
//
//  Created by LY on 2020/11/13.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMLiveMsgModel.h"
#import "PlateNumberModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AuctionLiveMessageCell : UITableViewCell
@property (nonatomic , strong) AMLiveMsgModel *model;
@property (nonatomic , strong) PlateNumberModel *plateModel;
@end

NS_ASSUME_NONNULL_END
