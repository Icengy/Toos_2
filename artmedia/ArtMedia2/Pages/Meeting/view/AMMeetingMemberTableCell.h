//
//  AMMeetingMemberTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/8/19.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMMeetingMemberModel;
@class AMMeetingRoomMemberModel;
NS_ASSUME_NONNULL_BEGIN

@class AMMeetingMemberTableCell;
@protocol AMMeetingMemberTableCellDelegate <NSObject>

@optional
- (void)memberCell:(AMMeetingMemberTableCell *)memberCell didSelected:(AMButton *)sender onVideoWithUserID:(NSString *)userID;
- (void)memberCell:(AMMeetingMemberTableCell *)memberCell didSelected:(AMButton *)sender onAudioWithUserID:(NSString *)userID;

@end

@interface AMMeetingMemberTableCell : UITableViewCell

@property (weak, nonatomic)  id <AMMeetingMemberTableCellDelegate> delegate;
@property (assign, nonatomic) AMMeetingMemberStyle style;
@property (strong, nonatomic) AMMeetingMemberModel *model;
@property (strong, nonatomic) AMMeetingRoomMemberModel *roomModel;

@end

NS_ASSUME_NONNULL_END
