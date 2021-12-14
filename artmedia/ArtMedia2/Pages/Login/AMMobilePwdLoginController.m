//
//  AMMobilePwdLoginController.m
//  ArtMedia2
//
//  Created by 美术拍卖 on 2020/12/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMMobilePwdLoginController.h"
#import "AMMobilePwdLoginView.h"

#import "MD5Tool.h"

#import "PasswordChange_ViewController.h"
#import "MobileChange_ViewController.h"
//#import "MainNavigationController.h"

//#import "HomeNormalViewController.h"
//#import "MainTabBarController.h"
//#import "PersonalHomepageViewController.h"
//#import "MinePageViewController.h"

#import "SystemArticleViewController.h"

@interface AMMobilePwdLoginController ()

//@property(nonatomic,weak) IBOutlet LoginMarkView *loginMarkView;
@property (weak, nonatomic) IBOutlet AMMobilePwdLoginView *loginMarkView;

@property(nonatomic,strong) NSTimer*timer;
@property(nonatomic,copy) NSString *headimgurl;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *openid;
@property(nonatomic,copy) NSString *unionid;

//@property (nonatomic ,strong) MainNavigationController *mainNavi;

@end

@implementation AMMobilePwdLoginController {
    int _num;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = RGB(245, 245, 245);
    
    @weakify(self);
    self.loginMarkView.xyBlock = ^{
        @strongify(self);
        [self getXieYi];
    };
    self.loginMarkView.loginBlock = ^{
        @strongify(self);
        if(self.type==0) {
            [self login];
        }else if (self.type==1) {
            [self loginByCode];
        }
    };
    self.loginMarkView.getCodeBlock = ^{
        @strongify(self);
        if (self.loginMarkView.topTextFilrd.text.length==0) {
            [SVProgressHUD showMsg:@"请先填写手机号"];
            return;
        }
        [self sendPhoneCode:self.loginMarkView.topTextFilrd.text];
    };

    self.loginMarkView.forgotBlock = ^{
        @strongify(self);
        PasswordChange_ViewController *vc = [[PasswordChange_ViewController alloc] init];
        vc.type = 1;
        
        [self.navigationController pushViewController:vc animated:YES];
    };

    self.loginMarkView.backBlock = ^{
        @strongify(self);
        [self backManual];
    };
    
    [self loadUIWithType:_type];
    _num = 60;
    self.timer=[NSTimer timerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];

    //禁用右滑返回手势
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if([_timer isValid]) {
        [_timer invalidate];
        _timer=nil;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark -
- (void)backManual {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)back {
    if (self.loginBlock) self.loginBlock(@(YES));
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark -
- (void)loadUIWithType:(int)type {
    _type = type;
    if(type == 0) {
        self.loginMarkView.botoomLabel.text=@"密    码";
        self.loginMarkView.bottomTextField.placeholder=@"请输入密码";
        self.loginMarkView.bottomTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.loginMarkView.bottomTextField.text = @"";
        self.loginMarkView.xieYiTV.hidden = NO;
        self.loginMarkView.forgetBtn.hidden = NO;
        self.loginMarkView.loginBtnTopConstraint.constant = 44.0f;
                
        self.loginMarkView.codeBtn.hidden = YES;
        self.loginMarkView.lineTwoView.hidden = YES;
        self.loginMarkView.passwordRigthConstraint.constant = 15.0f;
        
        self.loginMarkView.bottomTextField.secureTextEntry = YES;
        self.loginMarkView.bottomTextField.keyboardType = UIKeyboardTypeDefault;
    }else if (type == 1) {
        self.loginMarkView.botoomLabel.text=@"验证码";
        self.loginMarkView.bottomTextField.placeholder=@"请输入短信验证码";
        self.loginMarkView.bottomTextField.clearButtonMode = UITextFieldViewModeNever;
        self.loginMarkView.bottomTextField.text = @"";
        self.loginMarkView.xieYiTV.hidden = NO;
        self.loginMarkView.forgetBtn.hidden = YES;
        self.loginMarkView.loginBtnTopConstraint.constant = 15.0f;
        
        
        self.loginMarkView.codeBtn.hidden = NO;
        self.loginMarkView.lineTwoView.hidden = NO;
        self.loginMarkView.passwordRigthConstraint.constant = 130.0f;
        
        if (@available(iOS 12.0, *)) {
            self.loginMarkView.bottomTextField.textContentType = UITextContentTypeOneTimeCode;
        }
        self.loginMarkView.bottomTextField.secureTextEntry = NO;
        self.loginMarkView.bottomTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
}

- (void)countDown {
    _num=_num-1;
    if(_num>0) {
        self.loginMarkView.codeBtn.enabled = NO;
        [self.loginMarkView.codeBtn setTitle:[NSString stringWithFormat:@"重新获取(%d)",_num] forState:UIControlStateNormal];
        
    }else{
        [self.loginMarkView.codeBtn setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
        [_timer setFireDate:[NSDate distantFuture]];
        _num = 60;
        self.loginMarkView.codeBtn.enabled=YES;
    }
}

#pragma mark -
#pragma mark -Network

//微信登录
//记得写上[CoreArchive setStr:open_id key:WEIXIN_OPEN_ID];
//自动登录需要

//账号密码登录
- (void)login {
    [self.view endEditing:YES];
    
    if(self.loginMarkView.topTextFilrd.text.length==0) {
        [SVProgressHUD showMsg:@"请先填写手机号码"];
        return;
    }
    if(self.loginMarkView.bottomTextField.text.length==0) {
        [SVProgressHUD showMsg:@"请先填写密码"];
        return;
    }
    
    NSMutableDictionary*dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:self.loginMarkView.topTextFilrd.text forKey:@"account"];
    [dic setObject:[MD5Tool MD5ForLower32Bate:self.loginMarkView.bottomTextField.text ] forKey:@"password"];
    @weakify(self);
    [ApiUtil postWithParent:self url:[ApiUtilHeader accountLoginOrRegister] params:dic.copy success:^(NSInteger code, id  _Nullable response) {
        [SVProgressHUD showSuccess:response[@"message"] completion:^{
            @strongify(self);
            [self login:[response objectForKey:@"data"] forCode:NO];
        }];
    } fail:nil];
}

//短信验证--登录或注册
- (void)loginByCode {
    [self.view endEditing:YES];
    if(self.loginMarkView.topTextFilrd.text.length == 0) {
        [SVProgressHUD showMsg:@"请先填写手机号码"];
        return;
    }
    if(self.loginMarkView.bottomTextField.text.length == 0) {
        [SVProgressHUD showMsg:@"请先填写验证码"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:@"3" forKey:@"type"];
    [params setObject:self.loginMarkView.topTextFilrd.text forKey:@"mobile"];
    [params setObject:self.loginMarkView.bottomTextField.text forKey:@"code"];
    
    @weakify(self);
    [ApiUtil postWithParent:self url:[ApiUtilHeader smsLoginOrRegister] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [SVProgressHUD showSuccess:response[@"message"] completion:^{
            @strongify(self);
            [self login:[response objectForKey:@"data"] forCode:YES];
        }];
    } fail:nil];
}

- (void)login:(NSDictionary *)dict forCode:(BOOL)forCode {
    if (!(dict && dict.count)) {
        [SVProgressHUD showError:@"数据错误，登录失败！"];
        return;
    }
    @weakify(self);
    [[UserInfoManager shareManager] updateUserDataWithInfo:dict complete:^(UserInfoModel * _Nullable model) {
        @strongify(self);
        [self uploadClientId];
    }];
}

#pragma mark - 设置弹出提示语
- (void)setupAlertController {
    AMAlertView *alert = [AMAlertView shareInstanceWithTitle:@"未检测到微信应用或版本过低" buttonArray:@[@"确定"] confirm:nil cancel:nil];
    [alert show];
}


#pragma mark - 获取协议
- (void)getXieYi {
    SystemArticleViewController *agreementVC = [[SystemArticleViewController alloc] init];
    agreementVC.needBottom = YES;
    /// 用户协议
    agreementVC.articleID = @"YSRMTYHXY";
    [self.navigationController pushViewController:agreementVC animated:YES];
}

#pragma mark - 获取验证码
- (void)sendPhoneCode:(NSString *)phone {
    if (![ToolUtil valifyMobile:phone]) return;
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader getVerificationCode] params:@{@"type":@"3", @"mobile":phone} success:^(NSInteger code, id  _Nullable response) {
        [SVProgressHUD showSuccess:response[@"message"]];
        [self.timer setFireDate:[NSDate distantPast]];
    } fail:nil];
}

- (void)uploadClientId {
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    params[@"uid"] = [UserInfoManager shareManager].uid;
    params[@"clientid"] = AMUserDefaultsObjectForKey(@"AMDeviceToken");
    params[@"device_type"] = StringWithFormat(@(2));
    
    [ApiUtil postWithParent:nil url:[ApiUtilHeader editUserInfo] needHUD:NO params:params.copy success:^(NSInteger code, id  _Nullable response) {
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
    }];
    
    [self back];
}
@end
