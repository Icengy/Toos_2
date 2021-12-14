//
//  AMNewArtistMainVideoCell.h
//  ArtMedia2
//
//  Created by 刘洋 on 2020/9/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AMNewArtistMainVideoCell : UITableViewCell
@property (nonatomic , strong) NSMutableArray *data;
@property (nonatomic , copy) void(^videoPlayBlock)(VideoListModel *model);
@end

NS_ASSUME_NONNULL_END
