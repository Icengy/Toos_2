//
//  AMMeetingRecordManageListViewController.h
//  ArtMedia2
//
//  Created by icnengy on 2020/8/17.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AMMeetingRecordManageListViewController : BaseViewController

@property (nonatomic ,assign) AMMeetingRecordManageStyle style;
@property (nonatomic ,assign) AMMeetingRecordManageListStyle listStyle;
@property (nonatomic ,copy) void(^ updateTotalBlock)(AMMeetingRecordManageListStyle style, NSInteger total);

@end

NS_ASSUME_NONNULL_END
