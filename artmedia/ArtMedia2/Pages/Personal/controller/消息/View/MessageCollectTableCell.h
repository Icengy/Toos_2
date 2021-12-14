//
//  MessageCollectTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/5/25.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface MessageCollectTableCell : UITableViewCell

@property (nonatomic ,assign) MessageDetailListStyle listStyle;
@property (nonatomic ,strong) MessageInfoModel *model;

@end

NS_ASSUME_NONNULL_END
