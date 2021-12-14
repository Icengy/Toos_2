//
//  MineInfoTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/9/2.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "MineInfoTableCell.h"

#import "CustomPersonalModel.h"

#import "PersonalWalletItemView.h"

@interface MineInfoTableCell () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bgIV;
@property (weak, nonatomic) IBOutlet AMButton *inviteBtn;
@property (weak, nonatomic) IBOutlet AMButton *settingBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *setting_top_constraint;

@property (weak, nonatomic) IBOutlet AMIconView *logoIV;
@property (weak, nonatomic) IBOutlet UILabel *unameLabel;

@property (weak, nonatomic) IBOutlet AMReverseButton *editBtn;

@property (weak, nonatomic) IBOutlet UIStackView *itemStackView;
@property (weak, nonatomic) IBOutlet PersonalWalletItemView *videoItemView;
@property (weak, nonatomic) IBOutlet PersonalWalletItemView *likesItemView;
@property (weak, nonatomic) IBOutlet PersonalWalletItemView *followsItemView;
@property (weak, nonatomic) IBOutlet PersonalWalletItemView *fansItemView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomStack_bottomConstraint;

@property (weak, nonatomic) IBOutlet UIView *authCarrier;
@property (weak, nonatomic) IBOutlet UILabel *authLabel;
@property (weak, nonatomic) IBOutlet AMButton *authBtn;

@property (weak, nonatomic) IBOutlet UIView *artManageCarrier;
@property (weak, nonatomic) IBOutlet UILabel *artLabel;
@property (weak, nonatomic) IBOutlet AMButton *artBtn;

@end

@implementation MineInfoTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _inviteBtn.titleLabel.font = [UIFont addHanSanSC:12.0 fontType:0];
    _unameLabel.font = [UIFont addHanSanSC:16.0 fontType:2];
    _editBtn.titleLabel.font = [UIFont addHanSanSC:11.0 fontType:0];
    _authLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
    _artLabel.font = [UIFont addHanSanSC:15.0 fontType:2];
    
    [self.bgIV mas_updateConstraints:^(MASConstraintMaker *make) {
        //设置背景图的宽高比！使用下面方法.
        make.width.equalTo(self.bgIV.mas_height).multipliedBy(375.0/(255.0+StatusBar_Height));
    }];
    
    _setting_top_constraint.constant = StatusBar_Height + 10.0f;
    
    [_itemStackView.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PersonalWalletItemView *itemView = (PersonalWalletItemView *)obj;
        itemView.topTitleLabel.textColor = Color_Whiter;
        itemView.topTitleLabel.font = [UIFont addHanSanSC:18.0f fontType:3];
        itemView.bottomTitleLabel.textColor = Color_Whiter;
        itemView.bottomTitleLabel.font = [UIFont addHanSanSC:11.0 fontType:0];
    }];
    _videoItemView.bottomTitleLabel.text = @"视频";
    _videoItemView.topTitleLabel.text = @"0";
    _videoItemView.personalWalletItemBlock = ^{
        [self clickToItemAtIndex:0];
    };
    _likesItemView.bottomTitleLabel.text = @"喜欢";
    _likesItemView.topTitleLabel.text = @"0";
    _likesItemView.personalWalletItemBlock = ^{
        [self clickToItemAtIndex:1];
    };
    _followsItemView.bottomTitleLabel.text = @"关注";
    _followsItemView.topTitleLabel.text = @"0";
    _followsItemView.personalWalletItemBlock = ^{
        [self clickToItemAtIndex:2];
    };
    _fansItemView.bottomTitleLabel.text = @"粉丝";
    _fansItemView.topTitleLabel.text = @"0";
    _fansItemView.personalWalletItemBlock = ^{
        [self clickToItemAtIndex:3];
    };
    
//    UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToChangeHeaderImage:)];
//    headTap.delegate = self;
//    [self.bgIV addGestureRecognizer:headTap];
    
    UITapGestureRecognizer *logoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToLogo:)];
    logoTap.delegate = self;
    [self.logoIV addGestureRecognizer:logoTap];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(CustomPersonalModel *)model {
    _model = model;
    
//    [_bgIV am_setImageWithURL:_model.userData.back_img placeholderImage:ImageNamed(@"mine_默认背景") contentMode:(UIViewContentModeScaleAspectFill)];
    [_logoIV.imageView am_setImageWithURL:_model.userData.headimg placeholderImage:ImageNamed(@"logo") contentMode:(UIViewContentModeScaleAspectFill)];
    
    _unameLabel.text = [ToolUtil isEqualToNonNull:_model.userData.username replace:@"潮流艺术家"];
    
    _videoItemView.topTitleLabel.text = [ToolUtil isEqualToNonNull:_model.videoDataCount replace:@"0"];
    _likesItemView.topTitleLabel.text = [ToolUtil isEqualToNonNull:_model.collectDataCount replace:@"0"];
    _followsItemView.topTitleLabel.text = [ToolUtil isEqualToNonNull:_model.userData.followcount replace:@"0"];
    _fansItemView.topTitleLabel.text = [ToolUtil isEqualToNonNull:_model.userData.fans_num replace:@"0"];
    
    [self dealAuthBlock];
}

- (void)dealAuthBlock {
    _logoIV.artMark.hidden = (_model.userData.utype.integerValue < 3);
    
    if (_model.userData.utype.integerValue >= 3) {/// 认证艺术家
        _authCarrier.hidden = YES;
        _artManageCarrier.hidden = NO;
        _bottomStack_bottomConstraint.constant = 20.0f;
    }else {
        _authCarrier.hidden = NO;
        _artManageCarrier.hidden = YES;
        _bottomStack_bottomConstraint.constant = 0.0f;
        
        //0未实名 1未提交认证资料（可以点击认证） 2申请中 3申请未通过 4申请通过，未缴费 5认证通过
        NSString *authImageStr = nil;
        switch (_model.userData.ident_state.integerValue) {
            case 2: // 申请中
                authImageStr = @"mine_认证待审核";
                break;
            case 3:
                authImageStr = @"mine_认证未通过";
                break;
            case 4: //申请通过，未缴费
                authImageStr = @"mine_认证待缴费";
                break;
            case 5: //认证通过
                authImageStr = @"mine_艺术家管理";
                break;
                
            default:
                authImageStr = @"mine_未认证";
                break;
        }
        [_authBtn setBackgroundImage:ImageNamed(authImageStr) forState:UIControlStateNormal];
        NSLog(@"_authCarrier.bounds - %@", NSStringFromCGRect(_authCarrier.bounds));
        NSLog(@"k_Bounds - %@", NSStringFromCGRect(k_Bounds));
    }
}

#pragma mark -
- (void)clickToChangeHeaderImage:(id)sender {
    if ([self.delegate respondsToSelector:@selector(infoCell:selectedForChangeBackgroundImage:)]) {
        [self.delegate infoCell:self selectedForChangeBackgroundImage:sender];
    }
}

- (void)clickToLogo:(id)sender {
    if ([self.delegate respondsToSelector:@selector(infoCell:selectedForLogo:)]) {
        [self.delegate infoCell:self selectedForLogo:sender];
    }
}

/// 点击item
/// @param index 0：视频 1：喜欢 2：关注 3：粉丝
- (void)clickToItemAtIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(infoCell:selectedForItemAtIndex:)]) {
        [self.delegate infoCell:self selectedForItemAtIndex:index];
    }
}

- (IBAction)clickToSetting:(id)sender {
    if ([self.delegate respondsToSelector:@selector(infoCell:selectedForSetting:)]) {
        [self.delegate infoCell:self selectedForSetting:sender];
    }
}

- (IBAction)clickToInviteFriends:(id)sender {
    if ([self.delegate respondsToSelector:@selector(infoCell:selectedForInviteFriends:)]) {
        [self.delegate infoCell:self selectedForInviteFriends:sender];
    }
}

- (IBAction)clickToEdit:(id)sender {
    if ([self.delegate respondsToSelector:@selector(infoCell:selectedForEdit:)]) {
        [self.delegate infoCell:self selectedForEdit:sender];
    }
}

- (IBAction)clickToAuth:(id)sender {
    if ([self.delegate respondsToSelector:@selector(infoCell:selectedForAuth:)]) {
        [self.delegate infoCell:self selectedForAuth:sender];
    }
}

- (IBAction)clickToArtManage:(id)sender {
    if ([self.delegate respondsToSelector:@selector(infoCell:selectedForArtManage:)]) {
        [self.delegate infoCell:self selectedForArtManage:sender];
    }
}


@end
