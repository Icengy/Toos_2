//
//  MobileChange_ViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/22.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "MobileChange_ViewController.h"

#import "MD5Tool.h"
#import <AFNetworking.h>

@interface MobileChange_ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIView *contentCarrier;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentCarrierHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *phoneNameLabel;
@property (weak, nonatomic) IBOutlet AMTextField *phoneTF;

@property (weak, nonatomic) IBOutlet UILabel *codeNameLabel;
@property (weak, nonatomic) IBOutlet AMTextField *codeTF;
@property (weak, nonatomic) IBOutlet AMButton *getCodeBtn;

@property (weak, nonatomic) IBOutlet AMButton *finishBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *finishBtnHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *finishBtnBottomConstraint;

@property (nonatomic ,strong) NSTimer              *timer;

@end

@implementation MobileChange_ViewController
{
	int _num;
	NSInteger _verifyCode;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    
    [self.finishBtn setBackgroundImage:[UIImage imageWithColor:Color_Black] forState:UIControlStateNormal];
    [self.finishBtn setBackgroundImage:[UIImage imageWithColor:Color_Grey] forState:UIControlStateDisabled];

	_contentCarrierHeightConstraint.constant = ADRowHeight*2;
	
	_nameLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
	_phoneNameLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
	_phoneTF.font = [UIFont addHanSanSC:15.0f fontType:0];
	_codeNameLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
	_codeTF.font = [UIFont addHanSanSC:15.0f fontType:0];
	_getCodeBtn.titleLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
	_finishBtn.titleLabel.font = [UIFont addHanSanSC:17.0f fontType:1];
	
	_verifyCode = 0;
    
	
	_num = 60;
	_timer=[NSTimer timerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
	[[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
	[_timer setFireDate:[NSDate distantFuture]];
	
	_nameLabel.text = !_type?@"通过短信验证码验证手机号，完成绑定":@"通过短信验证码验证新手机号，完成更换绑定";
	_phoneTF.placeholder = !_type?@"请输入新手机号":@"请输入手机号";
	
	[self.codeTF addTarget:self action:@selector(textChangeAction:)  forControlEvents:UIControlEventEditingChanged];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	self.navigationItem.title = _type?@"更换绑定":@"绑定手机号";
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	if (_timer) {
		[_timer invalidate];
		_timer = nil;
	}
}

#pragma mark -
- (void)textChangeAction:(UITextField *)textField {
	if (textField.text.length)
//		self.finishBtn.backgroundColor = Color_Black;
        self.finishBtn.enabled = YES;
	else
        self.finishBtn.enabled = NO;
//		self.finishBtn.backgroundColor = Color_Grey;
}

#pragma mark -
- (IBAction)clickToGetCode:(id)sender {
	if (!_phoneTF.text.length) {
		[SVProgressHUD  showMsg:@"请输入手机号"];
		return;
	}
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"type"] = @"7";
    dic[@"mobile"] = [ToolUtil isEqualToNonNullKong:_phoneTF.text];
    [ApiUtil postWithParent:self url:[ApiUtilHeader getVerificationCode] params:dic success:^(NSInteger code, id  _Nullable response) {
        [SVProgressHUD showSuccess:response[@"message"]];
        [_timer setFireDate:[NSDate distantPast]];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        if (errorCode == -7) {
            [SVProgressHUD showMsg:errorMsg];
            [_timer setFireDate:[NSDate distantPast]];
        }else{
            [SVProgressHUD showError:errorMsg];
        }
    }];
}

- (IBAction)clickToFinish:(id)sender {
    [self.view endEditing:YES];
//	[self.navigationController popToRootViewControllerAnimated:YES];
	[self sureButtonClick];
}

#pragma mark -
-(void)countDown{
	_num -= 1;
	
	if(_num > 0){
		self.getCodeBtn.userInteractionEnabled = NO;
		[self.getCodeBtn setTitleColor:Color_Grey forState:UIControlStateNormal];
		[self.getCodeBtn setTitle:[NSString stringWithFormat:@"重新获取(%@s)",@(_num)] forState:UIControlStateNormal];
	}else{
		self.getCodeBtn.userInteractionEnabled = YES;
		[self.getCodeBtn setTitleColor:Color_MainBg forState:UIControlStateNormal];
		[self.getCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
		
		[_timer setFireDate:[NSDate distantFuture]];
		_num = 60;
	}
}

- (void)sureButtonClick {
	NSString *phone = _phoneTF.text;
	NSString *code = _codeTF.text;
	if (phone.length == 0) {
		[SVProgressHUD showMsg:@"请输入手机号！"];
		return;
	}
	if (code.length == 0) {
		[SVProgressHUD showMsg:@"请输入验证码！"];
		return;
	}
	NSDictionary *params = @{@"mobile":phone,@"code":code, @"type":@"7"};
	
    [ApiUtil postWithParent:self url:[ApiUtilHeader verifyCode] params:params success:^(NSInteger code, id  _Nullable response) {
        _verifyCode = code;
        [self response:response[@"message"] phone:phone];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        if (errorCode == -3) {
            _verifyCode = errorCode;
            [self response:errorMsg phone:phone];
        }else {
            [SVProgressHUD showError:errorMsg];
        }
    }];
}

- (void)response:(NSString *)responseMsg phone:(NSString *)phone {
    if (_type == 0) {
        NSString *message = [NSString stringWithFormat:@"%@，是否继续?",responseMsg];
        AMAlertView *alertView = [AMAlertView shareInstanceWithTitle:@"提示"
                                                             message:message
                                                         buttonArray:@[ @"继续", @"取消"]
                                                           alertType:AMAlertTypeNormal
                                                             confirm:^{
            if (_afterBindPhoneBlock) _afterBindPhoneBlock(_verifyCode, phone);
            
        } cancel:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertView show];
    }else {
        [self changeMobileWithMobile:phone];
    }
}

- (void)changeMobileWithMobile:(NSString *)moblie {
    NSDictionary *param = @{@"uid" : [UserInfoManager shareManager].uid,
							@"mobile" : moblie
							};
    [ApiUtil postWithParent:self url:[ApiUtilHeader editUserInfo] params:param success:^(NSInteger code, id  _Nullable response) {
        [self saveUserData:moblie];
        AMAlertView *alertView = [AMAlertView shareInstanceWithTitle:(!_type)?@"手机号码绑定成功":@"手机号码修改成功!" buttonArray:@[@"确定"] confirm:^{
            [self.navigationController popViewControllerAnimated:YES];
        } cancel:nil];
        [alertView show];
    } fail:nil];
}

-(void)saveUserData:(NSString *)mobile{
	UserInfoModel *model = [UserInfoManager shareManager].model;
	NSMutableDictionary *inforDic = [model yy_modelToJSONObject];
	[inforDic setObject:mobile  forKey:@"mobile"];
	[[UserInfoManager shareManager] saveUserData:inforDic];
}
@end
