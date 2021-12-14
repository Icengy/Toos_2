//
//  MessageReplyTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/7/8.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageReplyInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface MessageReplyTableCell : UITableViewCell

@property (nonatomic ,strong) MessageReplyInfoModel *model;

@end

NS_ASSUME_NONNULL_END
