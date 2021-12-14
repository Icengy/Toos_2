//
//  SearchBarView.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/15.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "SearchBarView.h"

@interface SearchBarView () <UITextFieldDelegate>
@property (nonatomic ,strong) AMButton *cancelBtn;
@property (nonatomic ,strong) AMTextField *searchTF;
@end

@implementation SearchBarView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
#pragma mark -
+ (SearchBarView *)shareInstance {
	return [[SearchBarView alloc] initWithFrame:CGRectMake(0, 0, K_Width, ADAPTATIONRATIOVALUE(100.0f))];
}

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self initSubViews];
	}return self;
}

- (void)enterFirstResponse {
	[self.searchTF becomeFirstResponder];
}

- (void)endFirstResponse {
	[self.searchTF resignFirstResponder];
}

#pragma mark -
- (void)initSubViews {
	[self addSubview:self.cancelBtn];
	[self addSubview:self.searchTF];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self.mas_right).offset(-ADAPTATIONRATIOVALUE(15.0f));
		make.top.bottom.equalTo(self);
		make.width.offset(ADAPTATIONRATIOVALUE(100.0f));
	}];
	[self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.offset(ADDefaultButtonHeight);
		make.centerY.equalTo(self);
		make.left.equalTo(self.mas_left).offset(15.0f);
		make.right.equalTo(self.cancelBtn.mas_left).offset(0);
	}];
}

#pragma mark -
- (void)setPlaceholder:(NSString *)placeholder {
	_placeholder = placeholder;
	self.searchTF.placeholder = _placeholder;
}

- (void)setSearchText:(NSString *)searchText {
	_searchText = searchText;
	self.searchTF.text = _searchText;
}

#pragma mark -
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField.text.length) {
		if ([self.delegate respondsToSelector:@selector(searchView:didClickToSearch:)]) {
			[self.delegate searchView:self didClickToSearch:textField.text];
		}
	}
	[textField resignFirstResponder];
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	NSLog(@"shouldChangeCharactersInRange :%@--%@",textField.text, string);
	BOOL hidden = YES;
	if (textField.text.length == 1 && !string.length) {
		hidden = NO;
	}
	if ([self.delegate respondsToSelector:@selector(searchView:didClickToHideTag:)]) {
		[self.delegate searchView:self didClickToHideTag:hidden];
	}
	return YES;
}

#pragma mark -
- (void)clickToCancel:(id)sender {
	[self.searchTF resignFirstResponder];
	if ([self.delegate respondsToSelector:@selector(searchView:didClickToCancel:)]) {
		[self.delegate searchView:self didClickToCancel:sender];
	}
}

#pragma mark -
- (AMTextField *)searchTF {
	if (!_searchTF) {
		
		_searchTF = [[AMTextField alloc] init];
		_searchTF.backgroundColor = RGB(245, 245, 245);
		_searchTF.textColor = Color_Black;
		_searchTF.font = [UIFont addHanSanSC:15.0f fontType:0];
		_searchTF.textAlignment = NSTextAlignmentLeft;
		_searchTF.borderStyle = UITextBorderStyleNone;
		_searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
		_searchTF.minimumFontSize = 12.0f;
		_searchTF.returnKeyType = UIReturnKeySearch;
		
		_searchTF.layer.cornerRadius = ADAPTATIONRATIOVALUE(36.0f);
		_searchTF.layer.borderWidth = 1.0f;
		_searchTF.layer.borderColor = RGB(229, 229, 229).CGColor;
		
		_searchTF.leftViewMode = UITextFieldViewModeAlways;
		UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ADDefaultButtonHeight/2.5+ADAptationMargin*2, ADDefaultButtonHeight/2.5)];
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((leftView.width-leftView.height)/2+3.0f, 0, leftView.height, leftView.height)];
		imageView.image = ImageNamed(@"search_black");
		[leftView addSubview:imageView];
		_searchTF.leftView = leftView;
		
		_searchTF.delegate = self;
		
	}return _searchTF;
}

- (AMButton *)cancelBtn {
	if (!_cancelBtn) {
		_cancelBtn = [AMButton buttonWithType:UIButtonTypeCustom];
		
		[_cancelBtn setTitleColor:Color_Black forState:UIControlStateNormal];
		[_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
		_cancelBtn.titleLabel.font = [UIFont addHanSanSC:16.0f fontType:0];
		
		[_cancelBtn addTarget:self action:@selector(clickToCancel:) forControlEvents:UIControlEventTouchUpInside];
	}return _cancelBtn;
}

@end
