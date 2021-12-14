//
//  CustomArtInfoTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/7/8.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "CustomArtInfoTableCell.h"

#import "CustomPersonalModel.h"

#import "UILabel+Extension.h"

@interface CustomArtInfoTableCell ()
@property (weak, nonatomic) IBOutlet AMButton *backBtn;//返回按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backBtnTopConstraint;

@property (weak, nonatomic) IBOutlet AMButton *moreBtn;//更多按钮

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIImageView *headBgIV;//头视图背景
@property (weak, nonatomic) IBOutlet AMIconImageView *iconIV;//用户头像
@property (weak, nonatomic) IBOutlet AMButton *followBtn;//关注按钮
@property (weak, nonatomic) IBOutlet AMButton *removeBLBtn;//移除黑名单按钮
@property (weak, nonatomic) IBOutlet AMButton *editInfoBtn;// 编辑资料
@property (weak, nonatomic) IBOutlet AMButton *orderSettringBtn;/// 约见设置

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//用户名
@property (weak, nonatomic) IBOutlet AMButton *identifitionBtn;//认证信息

@property (weak, nonatomic) IBOutlet UILabel *artTitleLabel;//艺术家头衔

@property (weak, nonatomic) IBOutlet UILabel *activeStatusLabel;

@property (weak, nonatomic) IBOutlet UILabel *artIntroLabel;//艺术家简介

@property (weak, nonatomic) IBOutlet UILabel *fansTitleLabel;//粉丝数
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;//粉丝数量

@property (weak, nonatomic) IBOutlet AMButton *orderBtn;//预约按钮

@end

@implementation CustomArtInfoTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _nameLabel.font = [UIFont addHanSanSC:24.0f fontType:1];
    _followBtn.titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
    _removeBLBtn.titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
    _orderSettringBtn.titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
    _artTitleLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
    _artIntroLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
    _fansTitleLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
    _fansCountLabel.font = [UIFont addHanSanSC:18.0f fontType:2];
    _orderBtn.titleLabel.font = [UIFont addHanSanSC:18.0f fontType:0];
    
    [_orderBtn setBackgroundImage:[UIImage imageWithColor:Color_Black] forState:UIControlStateNormal];
    [_orderBtn setTitle:@"约见" forState:UIControlStateNormal];
    [_orderBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xCCCCCC)] forState:UIControlStateDisabled];
    [_orderBtn setTitle:@"已约见" forState:UIControlStateDisabled];
    
    _backBtnTopConstraint.constant = StatusBar_Height;
    
    [_iconIV addBorderWidth:2.0f borderColor:UIColor.whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    frame.size.height -= 10.0f;
    [super setFrame:frame];
}

- (void)setModel:(CustomPersonalModel *)model {
    _model = model;
    
    [self.headBgIV am_setImageWithURL:_model.userData.back_img placeholderImage:[UIImage imageWithColor:RGB(51, 51, 51)] contentMode:UIViewContentModeScaleAspectFill];
    [self.iconIV am_setImageWithURL:_model.userData.headimg placeholderImage:ImageNamed(@"logo") contentMode:UIViewContentModeScaleAspectFill];
    
    self.nameLabel.text = [ToolUtil isEqualToNonNullKong:_model.userData.username];
    
    if ([ToolUtil isEqualToNonNull:_model.userData.artist_title]) {
        self.artTitleLabel.hidden = NO;
        self.artTitleLabel.text = _model.userData.artist_title;
    }else {
        self.artTitleLabel.hidden = YES;
    }
    
    NSString *activeStatusStr = [TimeTool getTimeFromPassTimeIntervalToNowTimeInterval:_model.userData.last_sync_date.integerValue];
    if (activeStatusStr && activeStatusStr.length) {
        self.activeStatusLabel.hidden = NO;
        if ([activeStatusStr containsString:@"秒"]) {
            self.activeStatusLabel.text = @"刚刚";
        }else
            self.activeStatusLabel.text = [NSString stringWithFormat:@"%@前活跃",activeStatusStr];
    }else
        self.activeStatusLabel.hidden = YES;
    
    if ([ToolUtil isEqualToNonNull:_model.userData.signature]) {
        self.artIntroLabel.hidden = NO;
        self.artIntroLabel.text = [ToolUtil isEqualToNonNullKong:_model.userData.signature];
    }else
        self.artIntroLabel.hidden = YES;
    
    self.editInfoBtn.hidden = ![ToolUtil isEqualOwner:_model.userData.id];
    self.followBtn.hidden = [ToolUtil isEqualOwner:_model.userData.id];
    self.moreBtn.hidden = [ToolUtil isEqualOwner:_model.userData.id];
    self.orderSettringBtn.hidden = ![ToolUtil isEqualOwner:_model.userData.id];
    
    BOOL hiddenOrder = YES, enableOrder = YES;
    if (![ToolUtil isEqualOwner:_model.userData.id] && _model.userData.orderBtnStatus != 3) {
        hiddenOrder = NO;
        enableOrder = _model.userData.orderBtnStatus % 2;
    }
    self.orderBtn.hidden = hiddenOrder;
    self.orderBtn.enabled = enableOrder;
    
    if (!self.followBtn.hidden) {
        [self updateFollowPart];
    }
    if (!self.moreBtn.hidden) {
        [self updateBtnState];
    }
    NSInteger fansCount = [ToolUtil isEqualToNonNull:_model.userData.fans_num replace:@"0"].integerValue;
    if (fansCount > 9999) {
        CGFloat fansCountf = fansCount/10000.0;
        self.fansCountLabel.text = [NSString stringWithFormat:@"%.1fW", fansCountf];
    }else
        self.fansCountLabel.text = [NSString stringWithFormat:@"%@", @(fansCount)];
}

- (void)updateBtnState {
    self.removeBLBtn.hidden = !_model.userData.is_blacklist;
    self.followBtn.hidden = _model.userData.is_blacklist;
    if (!_model.userData.is_blacklist) {
        [self updateFollowPart];
    }
}

- (void)updateFollowPart {
    [self.followBtn setTitle:_model.userData.is_collect ? @"已关注":@"+关注" forState:(UIControlStateNormal)];
    [self.followBtn setTitleColor:_model.userData.is_collect?RGB(122,129,153):RGB(255, 84, 84) forState:(UIControlStateNormal)];
    self.followBtn.layer.borderColor = _model.userData.is_collect?RGB(122,129,153).CGColor:RGB(255, 84, 84).CGColor;
}

#pragma mark -
- (IBAction)clickToBack:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerView:didClickToBack:)]) {
        [self.delegate headerView:self didClickToBack:sender];
    }
}

- (IBAction)clickToMore:(AMButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerView:didClickToMore:)]) {
        [self.delegate headerView:self didClickToMore:sender];
    }
}

- (IBAction)clickToFollow:(AMButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerView:didClickToFollow:)]) {
        [self.delegate headerView:self didClickToFollow:sender];
    }
}

- (IBAction)clickToRemoveBlack:(AMButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerView:didClickToRemoveBlack:)]) {
        [self.delegate headerView:self didClickToRemoveBlack:sender];
    }
}

- (IBAction)clickToEditInfo:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerView:didClickToEditInfo:)]) {
        [self.delegate headerView:self didClickToEditInfo:sender];
    }
}

- (IBAction)clickToOrder:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerView:didClickToMeeting:)]) {
        [self.delegate headerView:self didClickToMeeting:sender];
    }
}

- (IBAction)clickToOrderSettring:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerView:didClickToMeetingSetting:)]) {
        [self.delegate headerView:self didClickToMeetingSetting:sender];
    }
}

@end
