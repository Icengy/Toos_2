//
//  LoginViewController.m
//  ArtMedia
//
//  Created by 美术传媒 on 2018/10/23.
//  Copyright © 2018 lcy. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginMarkView.h"
#import <WXApi.h>
#import "MD5Tool.h"

#import "AppDelegate.h"
#import "PasswordChange_ViewController.h"
#import "MobileChange_ViewController.h"
#import "MainNavigationController.h"

#import "HomeNormalViewController.h"
#import "MainTabBarController.h"
#import "MinePageViewController.h"

#import "SystemArticleViewController.h"

#import "AMAuthLoginFailView.h"
#import "AMMobilePwdLoginController.h"
@interface LoginViewController ()


@property(nonatomic,strong) AMAuthLoginFailView* authLoginFailV;

@property(nonatomic,strong) NSTimer*timer;
@property(nonatomic,copy) NSString *headimgurl;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *openid;
@property(nonatomic,copy) NSString *unionid;

@property (nonatomic ,strong) MainNavigationController *mainNavi;

@end

@implementation LoginViewController

- (void)dealloc {
	[[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(weChatLogin:) name:WXAuthResult object:nil];
	self.tabBarController.tabBar.hidden = YES;
	self.view.backgroundColor = RGBA(0, 0, 0, 0);
    [self eventLogin];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:NO];

	//禁用右滑返回手势
	id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
	UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
	[self.view addGestureRecognizer:pan];
    
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

#pragma mark - Event
- (void)eventLogin
{
    @weakify(self);
    [[AMATAuthTool sharedATAuthTool] authLoginBtn:self style:PNSBuildModelStylePortrait resultBlock:^(AMATAuthToolType authToolType, id  _Nullable response) {
        @strongify(self);

        if (authToolType == AMATAuthToolTypeAuthFail) {
            self.authLoginFailV.hidden = NO;
        } else {
            self.authLoginFailV.hidden = YES;
            if (authToolType == AMATAuthToolTypeClose) {
                [self backManual];
            } else if (authToolType == AMATAuthToolTypeLoginSuc) {
                [self login:[response objectForKey:@"data"] forCode:YES];
            } else {
                
            }
        }
        
    } loginStyleBlock:^(AMLoginStyleType loginStyleType) {
        @strongify(self);
        [self eventLoginStyle:loginStyleType];
    }];
}

#pragma mark - LoginType
- (void)eventLoginStyle:(AMLoginStyleType)loginStyleType
{
    if (loginStyleType == AMLoginStyleTypeWechat) {
        //微信登录
        if ([WXApi isWXAppInstalled]) {
            SendAuthReq *req = [[SendAuthReq alloc] init];
            req.scope = @"snsapi_userinfo";
            req.state = @"App";
            [WXApi sendReq:req completion:nil];
        }else {
            [self setupAlertController];
        }
    } else if (loginStyleType == AMLoginStyleTypeMobile) {
        //手机密码
        [self eventJumpMobile:0];

    } else if (loginStyleType == AMLoginStyleTypeCode) {
        //验证码
        [self eventJumpMobile:1];
    }
}

- (void)eventJumpMobile:(int)type
{
    AMMobilePwdLoginController *mobilePwdVC = [[AMMobilePwdLoginController alloc] init];
    mobilePwdVC.type = type;
    mobilePwdVC.loginBlock = ^(id  _Nonnull data) {
        [self back];
    };
    [self jumpPushController:mobilePwdVC];
}

- (void)jumpPushController:(UIViewController *)vc
{
    MainNavigationController *navigationController = (MainNavigationController *)self.navigationController;
    if (self.presentedViewController) {
        //如果授权页成功拉起，这个时候则需要使用授权页的导航控制器进行跳转
        navigationController = (MainNavigationController *)self.presentedViewController;
    }
    [navigationController pushViewController:vc animated:YES];
}
#pragma mark -
- (void)backManual {
    
    MainTabBarController *tabVC = (MainTabBarController *)[(AppDelegate *)[UIApplication sharedApplication].delegate window].rootViewController;
    [tabVC setSelectedIndex:0];
    if (self.viewControllers.count) {
        BaseViewController *lastVC = self.viewControllers.lastObject;
        [lastVC.navigationController popToRootViewControllerAnimated:NO];
    }
    [self back];
}

- (void)back {
    
    [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.loginBlock) self.loginBlock(@(YES));
    }];
    
}

#pragma mark -
#pragma mark -Network

- (void)login:(NSDictionary *)dict forCode:(BOOL)forCode {
    if (!(dict && dict.count)) {
		[SVProgressHUD showError:@"数据错误，登录失败！"];
		return;
	}
    @weakify(self);
    [[UserInfoManager shareManager] updateUserDataWithInfo:dict complete:^(UserInfoModel * _Nullable model) {
        @strongify(self);
        [self uploadClientId];
        [[NSNotificationCenter defaultCenter] postNotificationName:AMLoginSuccess object:nil];
    }];
}

#pragma mark - 设置弹出提示语
- (void)setupAlertController {
	AMAlertView *alert = [AMAlertView shareInstanceWithTitle:@"未检测到微信应用或版本过低" buttonArray:@[@"确定"] confirm:nil cancel:nil];
	[alert show];
}

#pragma mark - wechat
- (void)weChatLogin:(NSNotification*)notification {
    NSDictionary*dic = notification.userInfo;
    [self judgeWechatWhetherRegiestWithDic:dic];
}

//判断微信是否注册过
- (void)judgeWechatWhetherRegiestWithDic:(NSDictionary*)dic {
	if(dic.allKeys.count==2) return;
	
	@weakify(self);
    [ApiUtil postWithParent:self url:[ApiUtilHeader thirdLogin] params:@{@"openid":[ToolUtil isEqualToNonNullKong:dic[@"unionid"]]} success:^(NSInteger code, id  _Nullable response) {
        @strongify(self);
        //注册过就直接登录
        NSDictionary *dict = (NSDictionary *)[response objectForKey:@"data"];
        if (dict && dict.count) {
            @weakify(self);
            [[UserInfoManager shareManager] updateUserDataWithInfo:dict complete:^(UserInfoModel * _Nullable model) {
                @strongify(self);
                [self uploadClientId];
            }];
        }
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        @strongify(self);
        if (errorCode == -2) {
            // 未注册
            [self getWechatUserInfoWithDic:dic];
        }else {
            [SVProgressHUD showError:errorMsg];
        }
    }];
}

//未注册时，跳转至新绑手机号页面
- (void)getWechatUserInfoWithDic:(NSDictionary*)dic {
    _headimgurl = dic[@"headimgurl"];
    _name = dic[@"nickname"];
    _openid = dic[@"openid"];
    _unionid = dic[@"unionid"];
        
    MobileChange_ViewController *mobileVC = [[MobileChange_ViewController alloc] init];
    mobileVC.type = 0;
    mobileVC.afterBindPhoneBlock = ^(NSInteger wayType, NSString * _Nonnull phone) {
        if (wayType) {
            [self wechatBind:phone];
        }else {
            [self wechatRegister:phone];
        }
    };
    [self jumpPushController:mobileVC];
}

//微信注册
- (void)wechatRegister:(NSString *)phone {
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithCapacity:0];
	[params setObject:phone forKey:@"mobile"];
    [params setObject:_name forKey:@"name"];
    [params setObject:_headimgurl forKey:@"headimg"];
    [params setObject:_openid forKey:@"wechatid"];
    [params setObject:_unionid forKey:@"openid"];
	@weakify(self);
    [ApiUtil postWithParent:self url:[ApiUtilHeader registerWithWechat] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)[response objectForKey:@"data"];
        if (dic && dic.count) {
            @weakify(self);
            [[UserInfoManager shareManager] updateUserDataWithInfo:dic complete:^(UserInfoModel * _Nullable model) {
                @strongify(self);
                [self uploadClientId];
            }];
        }
    } fail:nil];
}

//微信绑定已有账号
- (void)wechatBind:(NSString *)phone {
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:phone forKey:@"mobile"];
    [params setObject:_openid forKey:@"wechatid"];
    [params setObject:_unionid forKey:@"openid"];
	
    @weakify(self);
    [ApiUtil postWithParent:self url:[ApiUtilHeader bindWithWechat] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [SVProgressHUD showSuccess:@"绑定成功！" completion:^{
            @strongify(self);
            NSDictionary *dic = (NSDictionary *)[response objectForKey:@"data"];
            if (dic && dic.count) {
                @weakify(self);
                [[UserInfoManager shareManager] updateUserDataWithInfo:dic complete:^(UserInfoModel * _Nullable model) {
                    @strongify(self);
                    [self uploadClientId];
                }];
            }
            
        }];
    } fail:nil];
}

#pragma mark - 获取协议
- (void)getXieYi {
	SystemArticleViewController *agreementVC = [[SystemArticleViewController alloc] init];
	agreementVC.needBottom = YES;
    /// 用户协议
	agreementVC.articleID = @"YSRMTYHXY";
    [self jumpPushController:agreementVC];
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

- (AMAuthLoginFailView *) authLoginFailV
{
    if (!_authLoginFailV) {
        _authLoginFailV = [AMAuthLoginFailView am_loadFirstViewFromXib];
        _authLoginFailV.frame = self.view.bounds;
        _authLoginFailV.hidden = YES;
        [self.view addSubview:_authLoginFailV];
        @weakify(self);
        _authLoginFailV.loginStyleV.loginStyleBlock = ^(AMLoginStyleType loginStyleType) {
            @strongify(self);
            [self eventLoginStyle:loginStyleType];
        };
        
        _authLoginFailV.btnBlock = ^{
            @strongify(self);
            [self backManual];
        };
    }
    return _authLoginFailV;
}

@end
