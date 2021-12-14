//
//  AMMeetingDetailHeaderView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/8/17.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMMeetingDetailHeaderView.h"

#import "HK_tea_managerModel.h"

@interface AMMeetingDetailHeaderView ()
@property (weak, nonatomic) IBOutlet AMButton *backBtn;
@property (weak, nonatomic) IBOutlet AMIconImageView *logoIV;
@property (weak, nonatomic) IBOutlet UILabel *unameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet AMButton *followBtn;
@property (weak, nonatomic) IBOutlet AMButton *manageBtn;

@property (weak, nonatomic) IBOutlet UILabel *masterTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *normalView;

@end

@implementation AMMeetingDetailHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }return self;
}

- (void)setup {
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [self addSubview:self.view];
    self.view.frame = self.bounds;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.unameLabel.font = [UIFont addHanSanSC:14.0f fontType:1];
    self.titleLabel.font = [UIFont addHanSanSC:11.0f fontType:0];
    self.followBtn.titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    self.manageBtn.titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    self.masterTitleLabel.font = [UIFont addHanSanSC:18.0f fontType:0];
    
    self.showDarkStyle = NO;
}

- (void)setShowDarkStyle:(BOOL)showDarkStyle {
    _showDarkStyle = showDarkStyle;
    if (_showDarkStyle) {
        self.backgroundColor = Color_Whiter;
        [self.backBtn setImage:ImageNamed(@"back_black") forState:UIControlStateNormal];
        self.unameLabel.textColor = Color_Black;
        self.masterTitleLabel.textColor = Color_Black;
        self.titleLabel.textColor = UIColorFromRGB(0x999999);
        [self.followBtn setTitleColor:UIColorFromRGB(0xE22020) forState:UIControlStateNormal];
        [self.followBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateSelected];
        self.followBtn.layer.borderColor = self.followBtn.selected?UIColorFromRGB(0x999999).CGColor:UIColorFromRGB(0xE22020).CGColor;
        
        [self.manageBtn setTitleColor:Color_Black forState:UIControlStateNormal];
        self.manageBtn.layer.borderColor = self.manageBtn.selected?UIColorFromRGB(0x999999).CGColor:Color_Black.CGColor;
        
    }else {
        self.backgroundColor = UIColor.clearColor;
        [self.backBtn setImage:ImageNamed(@"backwhite") forState:UIControlStateNormal];
        self.unameLabel.textColor = Color_Whiter;
        self.masterTitleLabel.textColor = Color_Whiter;
        self.titleLabel.textColor = Color_Whiter;
        [self.followBtn setTitleColor:Color_Whiter forState:UIControlStateNormal];
        [self.followBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateSelected];
        self.followBtn.layer.borderColor = self.followBtn.selected?UIColorFromRGB(0x999999).CGColor:Color_Whiter.CGColor;
        [self.manageBtn setTitleColor:Color_Whiter forState:UIControlStateNormal];
        self.manageBtn.layer.borderColor = self.manageBtn.selected?UIColorFromRGB(0x999999).CGColor:Color_Whiter.CGColor;
    }
}

- (void)setModel:(HK_tea_managerModel *)model {
    _model = model;
    [_logoIV am_setImageWithURL:_model.headimg placeholderImage:ImageNamed(@"logo") contentMode:(UIViewContentModeScaleAspectFill)];
    _unameLabel.text = [ToolUtil isEqualToNonNullKong:_model.uname];
    _titleLabel.hidden = ![ToolUtil isEqualToNonNull:_model.artistTitle];
    _titleLabel.text = [ToolUtil isEqualToNonNullKong:_model.artistTitle];
    
    if ([ToolUtil isEqualOwner:StringWithFormat(@(_model.artistId))]) {
        /// 本人访问
        self.masterTitleLabel.hidden = NO;
        self.normalView.hidden = YES;
        self.followBtn.hidden = YES;
        self.manageBtn.hidden = NO;
    }else {
        /// 他人访问
        self.masterTitleLabel.hidden = YES;
        self.normalView.hidden = NO;
        self.followBtn.hidden = YES;
        self.manageBtn.hidden = YES;
    }
}

#pragma mark -
- (IBAction)clickToBack:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerView:didSelectedBack:)]) {
        [self.delegate headerView:self didSelectedBack:sender];
    }
}

- (IBAction)clickToFollow:(AMButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerView:didSelectedFollow:)]) {
        [self.delegate headerView:self didSelectedFollow:sender];
    }
}

- (IBAction)clickToLogo:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerView:didSelectedUserLogo:)]) {
        [self.delegate headerView:self didSelectedUserLogo:sender];
    }
}

- (IBAction)clickToManage:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerView:didSelectedManage:)]) {
        [self.delegate headerView:self didSelectedManage:sender];
    }
}


@end
