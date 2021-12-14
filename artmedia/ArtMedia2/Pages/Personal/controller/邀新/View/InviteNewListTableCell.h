//
//  InviteNewListTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/15.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InviteInfoModel;

NS_ASSUME_NONNULL_BEGIN

@interface InviteNewListTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet AMIconImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *authMark;
@property (weak, nonatomic) IBOutlet AMButton *inviteBtn;

@property (weak, nonatomic) IBOutlet UILabel *inviteLabel;

@property (nonatomic ,strong) InviteInfoModel *model;

@property (nonatomic ,copy) void(^ inviteBlock)(InviteInfoModel *model);

/// 是否为二级页面
@property (nonatomic ,assign) BOOL isSecondary;
@end

NS_ASSUME_NONNULL_END
