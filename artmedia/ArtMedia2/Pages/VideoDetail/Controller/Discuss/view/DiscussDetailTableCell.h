//
//  DiscussDetailTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/7/7.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DiscussDetailTableCell;
@class DiscussItemInfoModel;

@protocol DiscussDetailTableCellDelegate <NSObject>

@optional
- (void)detailCell:(DiscussDetailTableCell *)cell didSelectedLogo:(id)sender withModel:(DiscussItemInfoModel *)model;
- (void)detailCell:(DiscussDetailTableCell *)cell clickToShowMenuWithModel:(DiscussItemInfoModel *)model;

@end

@interface DiscussDetailTableCell : UITableViewCell

@property (weak ,nonatomic) id <DiscussDetailTableCellDelegate> delegate;
@property (strong ,nonatomic) DiscussItemInfoModel *itemModel;

@end

NS_ASSUME_NONNULL_END
