//
//  LoginView.m
//  ArtMedia
//
//  Created by 美术传媒 on 2018/10/23.
//  Copyright © 2018 lcy. All rights reserved.
//

#import "LoginMarkView.h"
#import <WXApi.h>
//#import <AuthenticationServices/AuthenticationServices.h>


@interface LoginMarkView ()

@property (weak, nonatomic) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conetntTopConstraint;

//@property (strong, nonatomic) ASAuthorizationAppleIDButton *appleBtn API_AVAILABLE(ios(13));

@end

@implementation LoginMarkView

//- (ASAuthorizationAppleIDButton *)appleBtn {
//    if (!_appleBtn) {
//        _appleBtn = [[ASAuthorizationAppleIDButton alloc] initWithAuthorizationButtonType:(ASAuthorizationAppleIDButtonTypeSignIn) authorizationButtonStyle:(ASAuthorizationAppleIDButtonStyleWhite)];
//        [_appleBtn addTarget:self action:@selector(logoWithAppleID:) forControlEvents:UIControlEventTouchUpInside];
//    }return _appleBtn;
//}

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

-(void)awakeFromNib {
    [super awakeFromNib];
	
	_topLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
	_botoomLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
	
	_topTextFilrd.font = [UIFont addHanSanSC:15.0f fontType:1];
    _topTextFilrd.text = AMUserDefaultsObjectForKey(AMPhoneDefaults);
	_bottomTextField.font = [UIFont addHanSanSC:15.0f fontType:1];
	_topTextFilrd.tintColor = RGB(135, 138, 153);
	_bottomTextField.tintColor = RGB(135, 138, 153);
    _topTextFilrd.placeholder = @"请输入账号";
    _bottomTextField.placeholder = @"请输入验证码";
	
	_codeBtn.titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
	
	_forgetBtn.titleLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
	
	_loginBtn.titleLabel.font = [UIFont addHanSanSC:18.0f fontType:1];
	
	NSString *agreement = @"《用户协议》";
    NSString *str = [NSString stringWithFormat:@"未注册用户登录时将自动注册,登录视作同意%@",agreement];
	
	[_xieYiTV setAllText:str allFont:[UIFont addHanSanSC:12.0f fontType:0] allTextColor:RGB(157, 161, 179) linkText:agreement linkKey:nil linkFont:nil linkTextColor:nil block:^(NSString * _Nullable linkKey) {
		if (_xyBlock) _xyBlock();
	}];
	
	_otherWayLabel.font = [UIFont addHanSanSC:14.0f fontType:0];

    _leftBtn.hidden = ![WXApi isWXAppInstalled];
}

#pragma mark -
- (IBAction)loginBtnClick:(id)sender {
    if(_loginBlock) {
        _loginBlock();
    }
}

- (IBAction)leftBtnClick:(id)sender {
    if(_wechatBlock) {
        _wechatBlock();
    }
}

- (IBAction)codeBtnClick:(id)sender {
    if(_getCodeBlock) {
        _getCodeBlock();
    }
}

- (IBAction)rightBtnClick:(id)sender {
    if(_rightBlock)
    {
        _rightBlock();
    }
}

-(IBAction)forgotBtnClick:(id)sender
{
    if(_forgotBlock)
    {
        _forgotBlock();
    }
}

- (IBAction)clickToBack:(AMButton *)sender {
	if (_backBlock) _backBlock();
}

//- (void)logoWithAppleID:(ASAuthorizationAppleIDButton *)sender API_AVAILABLE(ios(13.0)){
//
//}

//#pragma mark -
//- (UITextView *)xieYiTV {
//	if (!_xieYiTV) {
//		_xieYiTV = [[UITextView alloc] init];
//		_xieYiTV.delegate = self;
//
//		_xieYiTV.editable = NO;
//		_xieYiTV.scrollEnabled = NO;
//		_xieYiTV.textContainer.lineFragmentPadding = 0;
//		_xieYiTV.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
//
//	}return _xieYiTV;
//}


@end
