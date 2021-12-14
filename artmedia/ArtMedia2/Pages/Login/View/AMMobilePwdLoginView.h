//
//  AMMobilePwdLoginView.h
//  ArtMedia2
//
//  Created by 美术拍卖 on 2020/12/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AgreementTextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface AMMobilePwdLoginView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;//logo
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UILabel *topLabel;//手机号
@property (weak, nonatomic) IBOutlet UILabel *botoomLabel;//密码/验证码
@property (weak, nonatomic) IBOutlet AMTextField *topTextFilrd;//账号输入
@property (weak, nonatomic) IBOutlet AMTextField *bottomTextField;//密码/验证码输入

@property (weak, nonatomic) IBOutlet UIView *lineTwoView;//验证码按钮与输入框之前的分割线
@property (weak, nonatomic) IBOutlet AMButton *codeBtn;//获取验证码


@property (weak, nonatomic) IBOutlet AMButton *loginBtn;//登录按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBtnTopConstraint;

@property (weak, nonatomic) IBOutlet AMButton *forgetBtn;//忘记密码

@property (weak, nonatomic) IBOutlet AgreementTextView *xieYiTV;//用户协议

@property(nonatomic,strong)void(^loginBlock)(void);
@property(nonatomic,strong)void(^forgotBlock)(void);
@property(nonatomic,strong)void(^getCodeBlock)(void);
@property(nonatomic,strong)void(^xyBlock)(void);
@property(nonatomic,strong)void(^backBlock)(void);
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordRigthConstraint;

@end

NS_ASSUME_NONNULL_END
