//
//  MineMeeingItemTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/9/2.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomPersonalModel;
@class MineMeeingItemTableCell;
NS_ASSUME_NONNULL_BEGIN

@protocol MineMeetingItemDelegate <NSObject>

@required

/// 点击会客厅模块
/// 0: 会客(会客记录) 1：约见(约见记录)
- (void)meetingCell:(MineMeeingItemTableCell *)meetingCell didSelectedMeetingItemWithIndex:(NSInteger)index;

@end

@interface MineMeeingItemTableCell : UITableViewCell

@property (weak, nonatomic) id <MineMeetingItemDelegate> delegate;
@property (strong, nonatomic) CustomPersonalModel *model;
@end

NS_ASSUME_NONNULL_END
