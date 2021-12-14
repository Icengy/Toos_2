//
//  CustomInfoTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "CustomInfoTableCell.h"

#import "CustomPersonalModel.h"

#pragma mark -
@interface CustomInfoTableCell ()
@property (weak, nonatomic) IBOutlet AMButton *backBtn;//返回按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backBtnTopConstraint;

@property (weak, nonatomic) IBOutlet AMButton *moreBtn;//更多按钮

@property (weak, nonatomic) IBOutlet UIImageView *headBgIV;//头视图背景
@property (weak, nonatomic) IBOutlet AMIconImageView *iconIV;//用户头像
@property (weak, nonatomic) IBOutlet AMButton *followBtn;//关注按钮
@property (weak, nonatomic) IBOutlet AMButton *removeBLBtn;//移除黑名单按钮
@property (weak, nonatomic) IBOutlet AMButton *editInfoBtn;// 编辑资料

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//用户名
@property (weak, nonatomic) IBOutlet UILabel *introLabel;

@property (weak, nonatomic) IBOutlet AMButton *identifitionBtn;//认证信息

@property (weak, nonatomic) IBOutlet AMButton *thumbsCountBtn;//获赞数量
@property (weak, nonatomic) IBOutlet AMButton *followCountBtn;//关注数量
@property (weak, nonatomic) IBOutlet AMButton *fansCountBtn;//粉丝数量

@end

@implementation CustomInfoTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _nameLabel.font = [UIFont addHanSanSC:24.0f fontType:1];
    _introLabel.font = [UIFont addHanSanSC:12.f fontType:0];
    _followBtn.titleLabel.font = [UIFont addHanSanSC:16.0f fontType:0];
    _removeBLBtn.titleLabel.font = [UIFont addHanSanSC:16.0f fontType:0];
    _thumbsCountBtn.titleLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
    _followCountBtn.titleLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
    _fansCountBtn.titleLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
    
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
    if ([ToolUtil isEqualToNonNull:_model.userData.signature]) {
        _introLabel.hidden = NO;
        _introLabel.text = _model.userData.signature;
    }else _introLabel.hidden = YES;
    
    self.editInfoBtn.hidden = ![ToolUtil isEqualOwner:_model.userData.id];
    self.followBtn.hidden = [ToolUtil isEqualOwner:_model.userData.id];
    self.moreBtn.hidden = [ToolUtil isEqualOwner:_model.userData.id];
    
    if (!self.followBtn.hidden) {
        [self updateFollowPart];
    }
    if (!self.moreBtn.hidden) {
        [self updateBtnState];
    }
    
    [self.thumbsCountBtn setAttributedTitle:[self getCountLabelAttribute:[NSString stringWithFormat:@"%@ 获赞",[ToolUtil isEqualToNonNull:_model.userData.like_num replace:@"0"]]] forState:UIControlStateNormal];
    [self.followCountBtn setAttributedTitle:[self getCountLabelAttribute:[NSString stringWithFormat:@"%@ 关注",[ToolUtil isEqualToNonNull:_model.userData.followcount replace:@"0"]]] forState:UIControlStateNormal];
    [self.fansCountBtn setAttributedTitle:[self getCountLabelAttribute:[NSString stringWithFormat:@"%@ 粉丝", [ToolUtil isEqualToNonNull:_model.userData.fans_num replace:@"0"]]] forState:UIControlStateNormal];
    [self.thumbsCountBtn sizeToFit];
    [self.followCountBtn sizeToFit];
    [self.fansCountBtn sizeToFit];
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
    [self.followBtn setTitleColor:_model.userData.is_collect?RGB(122,129,153):Color_Black forState:(UIControlStateNormal)];
    self.followBtn.layer.borderColor = _model.userData.is_collect?RGB(122,129,153).CGColor:Color_Black.CGColor;
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


#pragma mark -
- (NSMutableAttributedString *)getCountLabelAttribute:(NSString *)string {
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"([0-9]\\d*\\.?\\d*)" options:0 error:NULL];
    
    NSArray<NSTextCheckingResult *> *ranges = [regular matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:string];
    
    for (int i = 0; i < ranges.count; i++) {
        [attStr setAttributes:@{NSForegroundColorAttributeName : Color_Black, NSFontAttributeName: [UIFont addHanSanSC:16.0f fontType:2]} range:ranges[i].range];
    }
    return attStr;
}

@end
