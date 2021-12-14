//
//  HK_teaDetailPeopleCell.h
//  ArtMedia2
//
//  Created by guohongkai on 2020/8/18.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "HK_baseCell.h"

@class AMMeetingOrderManagerListModel;
NS_ASSUME_NONNULL_BEGIN

@interface HK_teaDetailPeopleCell : HK_baseCell
@property (nonatomic,strong) AMMeetingOrderManagerListModel *model;
@property (copy , nonatomic) void(^gotArtistBlock)(NSString *artistId);
@end

NS_ASSUME_NONNULL_END
