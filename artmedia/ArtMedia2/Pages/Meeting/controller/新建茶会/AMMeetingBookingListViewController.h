//
//  AMMeetingBookingListViewController.h
//  ArtMedia2
//
//  Created by icnengy on 2020/8/13.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AMMeetingBookingListViewController : BaseViewController
/// isEditMeeting = NO:新建会客 isEditMeeting = YES:继续邀请
@property (nonatomic, assign) BOOL isEditMeeting;
/// 会客ID
@property (nonatomic, copy, nullable) NSString *teaAboutInfoId;
@end

NS_ASSUME_NONNULL_END
