//
//  PersonalInfoTableViewCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/9.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "PersonalInfoTableViewCell.h"

#import "CustomPersonalModel.h"
#import "HK_Label.h"
@interface PersonalInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *topCarrier;

@property (weak, nonatomic) IBOutlet AMButton *editInfoBtn;
@property (weak, nonatomic) IBOutlet AMButton *settingBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headIV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *settingTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *contentCarrier;

@property (weak, nonatomic) IBOutlet AMIconImageView *logoIV;
@property (weak, nonatomic) IBOutlet AMButton *messageBtn;
@property (weak, nonatomic) IBOutlet UILabel *messageBadgeLabel;
@property (weak, nonatomic) IBOutlet AMButton *inviteBtn;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet AMButton *userIdentifyBtn;
@property (weak, nonatomic) IBOutlet AMButton *bondBtn;

@property (weak, nonatomic) IBOutlet AMBadgePointButton *thumbsBtn;
@property (weak, nonatomic) IBOutlet AMBadgePointButton *followBtn;
@property (weak, nonatomic) IBOutlet AMBadgePointButton *fansBtn;

@property (nonatomic,strong)HK_Label *TeaLabel;

@property (nonatomic, assign) BOOL hasNewFans;
@end

@implementation PersonalInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _inviteBtn.titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    [_inviteBtn.titleLabel adjustsFontSizeToFitWidth];
    
    [_logoIV addBorderWidth:2.0f borderColor:UIColor.whiteColor];
    
    _messageBadgeLabel.font = [UIFont addHanSanSC:11.0f fontType:0];
    
    _userNameLabel.font = [UIFont addHanSanSC:24.0f fontType:0];
    
    _thumbsBtn.titleLabel.font = [UIFont addHanSanSC:13.0 fontType:0];
    _followBtn.titleLabel.font = [UIFont addHanSanSC:13.0 fontType:0];
    _fansBtn.titleLabel.font = [UIFont addHanSanSC:13.0 fontType:0];
    
    _settingTopConstraint.constant = StatusBar_Height;
    
    UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToChangeHeaderImage:)];
    headTap.delegate = self;
    [self.headIV addGestureRecognizer:headTap];
    
    UITapGestureRecognizer *logoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToLogo:)];
    logoTap.delegate = self;
    [self.logoIV addGestureRecognizer:logoTap];
    [self.headIV addSubview:self.TeaLabel];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.TeaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-200));
        make.centerY.equalTo(self.settingBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (HK_Label *)TeaLabel{
    if (!_TeaLabel) {
        _TeaLabel=[[HK_Label alloc]init];
        _TeaLabel.backgroundColor=[UIColor redColor];
        WeakSelf(self);
        _TeaLabel.block = ^(NSString * _Nonnull labeltext, NSInteger index) {
            if ([weakself.delegate respondsToSelector:@selector(jumpTea_Meetting_Record)]) {
                [weakself.delegate jumpTea_Meetting_Record];
            }
        };
    }
    return _TeaLabel;
}
- (void)setModel:(CustomPersonalModel *)model {
    _model = model;
    
    [_headIV am_setImageWithURL:_model.userData.back_img placeholderImage:ImageNamed(@"mine_默认背景") contentMode:(UIViewContentModeScaleAspectFill)];
    [_logoIV am_setImageWithURL:_model.userData.headimg placeholderImage:ImageNamed(@"logo") contentMode:(UIViewContentModeScaleAspectFill)];
    
    if (_model && _model.msgData) {
        _messageBadgeLabel.hidden = YES;
        NSInteger count = [ToolUtil isEqualToNonNull:[_model.msgData objectForKey:@"unreadmsgcount"] replace:@"0"].integerValue;
        if (count != 0) {
            _messageBadgeLabel.hidden = NO;
            _messageBadgeLabel.text = StringWithFormat(@(count));
        }
    }
    
    _userNameLabel.text = [ToolUtil isEqualToNonNullKong:_model.userData.username];
    
    //0未实名 1未提交认证资料（可以点击认证） 2申请中 3申请未通过 4申请通过，未缴费 5认证通过
    switch (_model.userData.ident_state.integerValue) {
        case 0:
        case 1:
        case 2:
        case 3: {//未认证
            [_userIdentifyBtn setImage:ImageNamed(@"Per_尚未认证") forState:UIControlStateNormal];
            _bondBtn.hidden = YES;
            break;
        }
        case 4: {//未认证
            [_userIdentifyBtn setImage:ImageNamed(@"Per_尚未认证") forState:UIControlStateNormal];
            _bondBtn.hidden = NO;
            break;
        }
        case 5: {//商家
            [_userIdentifyBtn setImage:ImageNamed(@"Per_艺术家认证") forState:UIControlStateNormal];
            _bondBtn.hidden = YES;
            [self setUserBond];
            break;
        }
        default:
            break;
    }
    
    [_thumbsBtn setAttributedTitle:[self getCountLabelAttribute:[NSString stringWithFormat:@"%@ 获赞",[ToolUtil isEqualToNonNull:_model.userData.like_num replace:@"0"]]] forState:UIControlStateNormal];
    [_followBtn setAttributedTitle:[self getCountLabelAttribute:[NSString stringWithFormat:@"%@ 关注",[ToolUtil isEqualToNonNull:_model.userData.followcount replace:@"0"]]] forState:UIControlStateNormal];
    [_fansBtn setAttributedTitle:[self getCountLabelAttribute:[NSString stringWithFormat:@"%@ 粉丝", [ToolUtil isEqualToNonNull:_model.userData.fans_num replace:@"0"]]] forState:UIControlStateNormal];
    [_thumbsBtn.titleLabel sizeToFit];
    [_followBtn.titleLabel sizeToFit];
    [_fansBtn.titleLabel sizeToFit];
    
    self.hasNewFans = _model.userData.newfanscount.integerValue;
}

- (void)setUserBond {
    switch (_model.userData.utype.integerValue) {
        case 0:
        case 1:{//未认证
            [_userIdentifyBtn setImage:ImageNamed(@"Per_尚未认证") forState:UIControlStateNormal];
            break;
        }
        case 2: {//商家
            [_userIdentifyBtn setImage:ImageNamed(@"Per_商家认证") forState:UIControlStateNormal];
            break;
        }
        case 3: {//艺术家
            [_userIdentifyBtn setImage:ImageNamed(@"Per_艺术家认证") forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
}

- (void)setHasNewFans:(BOOL)hasNewFans {
    _hasNewFans = hasNewFans;
    _fansBtn.badgeView.hidden = !_hasNewFans;
}

#pragma mark -
- (void)clickToChangeHeaderImage:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectedInfoItemForChangeBg:)]) {
        [self.delegate didSelectedInfoItemForChangeBg:sender];
    }
}

- (void)clickToLogo:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectedInfoItemForLogo:)]) {
        [self.delegate didSelectedInfoItemForLogo:sender];
    }
}

- (IBAction)clickToEditInfo:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedInfoItemForEditInfo:)]) {
        [self.delegate didSelectedInfoItemForEditInfo:sender];
    }
}

- (IBAction)clickToSetting:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedInfoItemForSetting:)]) {
        [self.delegate didSelectedInfoItemForSetting:sender];
    }
}

- (IBAction)clickToMessage:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedInfoItemForMessage:)]) {
        [self.delegate didSelectedInfoItemForMessage:sender];
    }
}

- (IBAction)clickToInvite:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedInfoItemForInvite:)]) {
        [self.delegate didSelectedInfoItemForInvite:sender];
    }
}

- (IBAction)clickToidentify:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedInfoItemForIdentify:)]) {
        [self.delegate didSelectedInfoItemForIdentify:sender];
    }
}

- (IBAction)clickToBond:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedInfoItemForBond:)]) {
        [self.delegate didSelectedInfoItemForBond:sender];
    }
}

- (IBAction)clickToThumbs:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedInfoItemForThumbs:)]) {
        [self.delegate didSelectedInfoItemForThumbs:sender];
    }
}

- (IBAction)clickToFollow:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedInfoItemForFollow:)]) {
        [self.delegate didSelectedInfoItemForFollow:sender];
    }
}

- (IBAction)clickToFans:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedInfoItemForFans:)]) {
        [self.delegate didSelectedInfoItemForFans:sender];
    }
}

- (IBAction)clickToCreateMeeting:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpTea_Meetting_Create)]) {
        [self.delegate jumpTea_Meetting_Create];
    }
}

- (IBAction)clickToMeetingDetail:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpTea_Meetting_Detail)]) {
        [self.delegate jumpTea_Meetting_Detail];
    }
}

- (IBAction)clickToMeetingRecord:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpTea_Meetting_Record)]) {
        [self.delegate jumpTea_Meetting_Record];
    }
}

#pragma mark - private
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
