//
//  ReceivableBlankTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/28.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ReceivableModel;
@class ReceivableBlankTableCell;
@protocol ReceivableBlankDelegate <NSObject>

@optional
- (void)tableCell:(ReceivableBlankTableCell *)cell didClickToAddNewWithModel:(ReceivableModel *)model;

@end

@interface ReceivableBlankTableCell : UITableViewCell

@property (nonatomic ,weak) id <ReceivableBlankDelegate> delegate;
@property (nonatomic ,assign) NSInteger receiveType;
@property (nullable ,nonatomic ,strong) ReceivableModel *model;

@end

NS_ASSUME_NONNULL_END
