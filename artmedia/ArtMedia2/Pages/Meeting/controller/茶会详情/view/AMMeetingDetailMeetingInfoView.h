//
//  AMMeetingDetailMeetingInfoView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/9/2.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HK_tea_managerModel;
NS_ASSUME_NONNULL_BEGIN

@interface AMMeetingDetailMeetingInfoView : UIView

@property (nonatomic ,strong) HK_tea_managerModel *model;

@property (nonatomic ,assign) double time_num;

@end

NS_ASSUME_NONNULL_END
