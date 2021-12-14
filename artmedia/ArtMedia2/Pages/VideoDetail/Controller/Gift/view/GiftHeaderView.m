//
//  GiftHeaderView.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2020/1/9.
//  Copyright © 2020 lcy. All rights reserved.
//

#import "GiftHeaderView.h"

#import "VideoListModel.h"

@interface GiftHeaderView ()

@property (nonatomic ,strong) UILabel *topLabel;
@property (nonatomic ,strong) UIImageView *userIconIV;
@property (nonatomic ,strong) UILabel *userNameLabel;
@property (nonatomic ,strong) UILabel *userIntroLabel;

@property (nonatomic ,strong) AMButton *identifyBtn;

@property (nonatomic ,strong) UIView *line;

@end

@implementation GiftHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UILabel *)topLabel {
	if (!_topLabel) {
		_topLabel = [[UILabel alloc] init];
		_topLabel.text = @"送TA鲜花，为创作加油";
		_topLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
		_topLabel.textColor = RGB(255,193,45);
		[_topLabel sizeToFit];
		
	}return _topLabel;
}

- (UIImageView *)userIconIV {
	if (!_userIconIV) {
		_userIconIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ADRowHeight*2, ADRowHeight*2)];
		_userIconIV.userInteractionEnabled = NO;
		_userIconIV.contentMode = UIViewContentModeScaleAspectFill;

		_userIconIV.layer.cornerRadius = _userIconIV.width/2;
		_userIconIV.layer.borderWidth = 2.0f;
		_userIconIV.layer.borderColor = RGB(255, 255, 255).CGColor;
		_userIconIV.clipsToBounds = YES;
	}return _userIconIV;
}

- (UILabel *)userNameLabel {
	if (!_userNameLabel) {
		_userNameLabel = [[UILabel alloc] init];
		_userNameLabel.textColor = Color_Whiter;
		_userNameLabel.font = [UIFont addHanSanSC:24.0f fontType:1];
		[_userNameLabel sizeToFit];
		
	}return _userNameLabel;
}

- (UILabel *)userIntroLabel {
	if (!_userIntroLabel) {
		_userIntroLabel = [[UILabel alloc] init];
		_userIntroLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
		_userIntroLabel.textColor = Color_GreyLight;
		_userIntroLabel.text = @"TA还不想介绍自己";
		_userIntroLabel.numberOfLines = 0;
		
	}return _userIntroLabel;
}

- (AMButton *)identifyBtn {
	if (!_identifyBtn) {
		_identifyBtn = [AMButton buttonWithType:UIButtonTypeCustom];
		_identifyBtn.hidden = YES;
		_identifyBtn.frame = CGRectMake(0, 0, self.userNameLabel.height*(71/18) , self.userNameLabel.height);
		
		_identifyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		[_identifyBtn setImage:ImageNamed(@"Per_艺术家认证") forState:UIControlStateNormal];
		
	}return _identifyBtn;
}

- (UIView *)line {
	if (!_line) {
		_line = [[UIView alloc] init];
		_line.backgroundColor = RGB(77,77,77);
	}return _line;
}

#pragma mark -
+ (GiftHeaderView *)shareInstance {
	return [[GiftHeaderView alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self initSubViews];
	}return self;
}

- (void)initSubViews {
	self.backgroundColor = [RGB(0, 0, 0) colorWithAlphaComponent:0.9];
	self.frame = CGRectMake(0, 0, K_Width, ADRowHeight*2+ADDefaultButtonHeight+ADAptationMargin*2);
	
	[self addSubview:self.topLabel];
	[self addSubview:self.userIconIV];
	[self addSubview:self.userNameLabel];
	[self addSubview:self.identifyBtn];
	[self addSubview:self.userIntroLabel];
	
	[self addSubview:self.line];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[self.topLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.mas_left).offset(ADAptationMargin *1.5);
		make.top.equalTo(self.mas_top).offset(ADAptationMargin);
		make.size.sizeOffset(self.topLabel.size);
	}];
	[self.userIconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.mas_left).offset(ADAptationMargin *1.5);
		make.centerY.equalTo(self).offset((self.topLabel.height+ADAptationMargin)/2);
		make.size.sizeOffset(CGSizeMake(ADRowHeight *2, ADRowHeight *2));
	}];
	[self.userNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.userIconIV.mas_right).offset(ADAptationMargin);
		make.bottom.equalTo(self.userIconIV.mas_centerY).offset(-ADAptationMargin/4);
		make.size.sizeOffset(self.userNameLabel.size);
	}];
	[self.identifyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.userNameLabel.mas_right).offset(4.0f);
		make.centerY.equalTo(self.userNameLabel.mas_centerY);
		make.size.sizeOffset(CGSizeMake(self.userNameLabel.height *(71/18), self.userNameLabel.height));
	}];
	[self.userIntroLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.userIconIV.mas_right).offset(ADAptationMargin);
		make.top.equalTo(self.userIconIV.mas_centerY).offset(ADAptationMargin/4);
//		make.size.sizeOffset(self.userIntroLabel.size);
		make.right.equalTo(self.mas_right).offset(-ADAptationMargin);
		make.bottom.equalTo(self.userIconIV.mas_bottom);
	}];
	[self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.left.right.bottom.equalTo(self);
		make.height.offset(0.5f);
	}];
}

#pragma mark -
- (void)setModel:(VideoListModel *)model {
	_model = model;
	
	[_userIconIV am_setImageWithURL:_model.artModel.headimg placeholderImage:ImageNamed(@"logo") contentMode:UIViewContentModeScaleAspectFill];
	
	_userNameLabel.text = [ToolUtil isEqualToNonNullKong:_model.artModel.art_name];
	[_userNameLabel sizeToFit];
	
	CGFloat maxWidth = 0.0f;
	if (_model.artModel.utype.integerValue == 3) {
		_identifyBtn.hidden = NO;
		maxWidth = K_Width - ADAptationMargin - self.userNameLabel.x - self.identifyBtn.width;
	}else {
		_identifyBtn.hidden = YES;
		maxWidth = K_Width - ADAptationMargin - self.userNameLabel.x;
	}
	if (_userNameLabel.width > maxWidth) {
		_userNameLabel.width = maxWidth;
	}
	
	if ([ToolUtil isEqualToNonNull:_model.artModel.signature ]) {
		_userIntroLabel.text = _model.artModel.signature;
	}
}

@end
