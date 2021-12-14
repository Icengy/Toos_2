//
//  MessageListCell.h
//  ArtMedia2
//
//  Created by 名课 on 2020/9/3.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageSubModel;
NS_ASSUME_NONNULL_BEGIN

@interface MessageListCell : UITableViewCell
@property (strong , nonatomic) MessageSubModel *model;
@end

NS_ASSUME_NONNULL_END
