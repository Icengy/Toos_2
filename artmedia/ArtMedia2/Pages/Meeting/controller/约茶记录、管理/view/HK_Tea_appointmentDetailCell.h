//
//  HK_Tea_appointmentDetailCell.h
//  ArtMedia2
//
//  Created by guohongkai on 2020/8/18.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "HK_baseCell.h"

@class AMMeetingOrderManagerListModel;
NS_ASSUME_NONNULL_BEGIN
@protocol HK_Tea_appointmentDetailCellDelegate <NSObject>
//延期
- (void)delayAction;

@end
@interface HK_Tea_appointmentDetailCell : HK_baseCell
@property (strong , nonatomic) AMMeetingOrderManagerListModel *model;
@property (nonatomic,strong)NSString *leftStr;
@property (nonatomic,strong)NSString *rightStr;
@property (nonatomic,assign)NSInteger time_Status;
//@property (nonatomic,copy)NSString *status;
@property (nonatomic,weak)id<HK_Tea_appointmentDetailCellDelegate>delegate;
@property (copy , nonatomic) void(^gotoDetailBlock)(void);
@end

NS_ASSUME_NONNULL_END
