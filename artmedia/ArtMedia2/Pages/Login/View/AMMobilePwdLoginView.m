//
//  AMMobilePwdLoginView.m
//  ArtMedia2
//
//  Created by 美术拍卖 on 2020/12/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMMobilePwdLoginView.h"

@interface AMMobilePwdLoginView ()
@property (strong, nonatomic) IBOutlet UIView *view;

@end
@implementation AMMobilePwdLoginView

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
}

#pragma mark -
- (IBAction)loginBtnClick:(id)sender {
    if(_loginBlock) {
        _loginBlock();
    }
}

- (IBAction)codeBtnClick:(id)sender {
    if(_getCodeBlock) {
        _getCodeBlock();
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

@end
