//
//  TeaMeetingRecordCell.h
//  ArtMedia2
//
//  Created by 名课 on 2020/9/8.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HK_tea_managerModel;
NS_ASSUME_NONNULL_BEGIN

@interface TeaMeetingRecordCell : UITableViewCell
@property (strong , nonatomic) HK_tea_managerModel *model;

@property (copy , nonatomic) void(^gotoDetailBlock)(NSString *meetingid);
@property (copy , nonatomic) void(^gotoMeetingRoomBlock)(HK_tea_managerModel *model);

@end

NS_ASSUME_NONNULL_END

