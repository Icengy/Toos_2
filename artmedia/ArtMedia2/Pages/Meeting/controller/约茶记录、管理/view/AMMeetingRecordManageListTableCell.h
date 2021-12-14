//
//  AMMeetingRecordManageListTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/8/17.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMMeetingOrderManagerListModel;
NS_ASSUME_NONNULL_BEGIN

@interface AMMeetingRecordManageListTableCell : UITableViewCell

@property (nonatomic ,assign) AMMeetingRecordManageStyle style;
@property (nonatomic ,strong) AMMeetingOrderManagerListModel *model;

@end

NS_ASSUME_NONNULL_END
