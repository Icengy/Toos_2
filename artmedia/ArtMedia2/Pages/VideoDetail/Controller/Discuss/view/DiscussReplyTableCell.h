//
//  DiscussReplyTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/7/6.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DiscussItemInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface DiscussReplyTableCell : UITableViewCell

@property (nonatomic ,strong) DiscussItemInfoModel *replyModel;

@property(nonatomic,strong) void(^ layoutBlock)(void);

@end

NS_ASSUME_NONNULL_END
