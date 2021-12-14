//
//  AMMeetingEditTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/8/13.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AMMeetingEditTableCellStyle) {
    /// 会客开始时间
    AMMeetingEditTableCellStyleBeginDate = 0,
    /// 会客说明
    AMMeetingEditTableCellStyleExplain,
    /// 会客截止报名时间
    AMMeetingEditTableCellStyleEndDate,
    /// 人数范围
    AMMeetingEditTableCellStyleNumber
};

@class AMMeetingEditTableCell;
NS_ASSUME_NONNULL_BEGIN

@protocol AMMeetingEditCellDelegate <NSObject>

@optional
- (BOOL)editCell:(AMMeetingEditTableCell *)editCell didBeginEditContent:(AMTextView *)textView;
- (void)editCell:(AMMeetingEditTableCell *)editCell didFillInContent:(NSString *)contentStr style:(AMMeetingEditTableCellStyle)style;

@end

@interface AMMeetingEditTableCell : UITableViewCell

@property (nonatomic ,weak) id <AMMeetingEditCellDelegate> delegate;
@property (nonatomic ,assign) AMMeetingEditTableCellStyle style;
@property (nonatomic ,copy, nullable) NSString *contentStr;

@end

NS_ASSUME_NONNULL_END
