//
//  DiscussInfoTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/7/6.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DiscussItemInfoModel;
@class DiscussInfoTableCell;
NS_ASSUME_NONNULL_BEGIN

@protocol DiscussInfoTableCellDelegate <NSObject>

@optional
- (void)infoCell:(DiscussInfoTableCell *)infoCell clickToShowMenuWithModel:(DiscussItemInfoModel *)model;

@end

@interface DiscussInfoTableCell : UITableViewCell

@property (nonatomic ,weak) id <DiscussInfoTableCellDelegate> delegate;
@property (nonatomic ,strong) DiscussItemInfoModel *model;

@end

NS_ASSUME_NONNULL_END
