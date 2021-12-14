//
//  PasswordChange_ViewController.m
//  ArtMedia
//
//  Created by 美术传媒 on 2018/11/16.
//  Copyright © 2018 lcy. All rights reserved.
//

#import "PasswordChange_ViewController.h"

#import "PasswordSetting_TableViewCell.h"
#import "PasswordReset_TableViewCell.h"

#import "MD5Tool.h"

@interface PasswordChange_ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView         * tableView;
@property (nonatomic ,strong) NSArray             * dataArray;

@property (nonatomic ,assign) BOOL                  havePsw;
@property (nonatomic ,assign) BOOL                  nextStep;//针对重置密码

@property (nonatomic ,assign) NSInteger  num;//验证码倒计时
@property (nonatomic ,strong) NSTimer  *timer;
@property (nonatomic ,strong) AMButton *codeBtn;

@property (nonatomic ,copy) NSString *code;
@property (nonatomic ,copy) NSString *phone;
@end

@implementation PasswordChange_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	_nextStep = NO;
	_code = [NSString new];
	_phone = [NSString new];
	_num = 60;
	_timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
	[[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
	[_timer setFireDate:[NSDate distantFuture]];
	
    [self.view addSubview:self.tableView];
	[self creatData];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	if([_timer isValid]) {
		[self.timer invalidate];
		self.timer = nil;
	}
}

- (void)creatData {
	if (_type) {
		self.navigationItem.title = @"重置密码";
		if (self.nextStep) {//找回密码-验证手机号
			self.dataArray = @[@[@"设置密码",@"请输入密码"],
							   @[@"确认密码",@"请再次输入密码"]];
		}else {//找回密码
			self.dataArray = @[@[@"手机号", @"请输入手机号"],
							   @[@"验证码", @"请输入验证码"]];
		}
	}else {
		UserInfoModel * model = [UserInfoManager shareManager].model;
		self.havePsw = model.password.length;
		if (!self.havePsw) {///首次设置密码
			self.navigationItem.title = @"设置密码";
			self.dataArray = @[@[@"设置密码",@"请输入密码"],
							   @[@"确认密码",@"请再次输入密码"]];
		}else{///修改密码
			self.navigationItem.title = @"修改密码";
			self.dataArray = @[@[@"原密码",@"请输入原密码"],
							   @[@"新密码",@"请输入新密码"],
							   @[@"确认密码",@"请再次输入密码"]];
		}
	}
	[self.tableView reloadData];
}

#pragma mark -
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return _type?ADRowHeight:ADAptationMargin;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return _type?[self creatTableHeaderView]: [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_Width, ADAptationMargin)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return ADBottomButtonHeight*3/2;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return [self creatTableFooterView];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (_type && !_nextStep && indexPath.row) {
		PasswordReset_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PasswordReset_TableViewCell class]) forIndexPath:indexPath];
		
		cell.selectionStyle = UITableViewCellStyleDefault;
		cell.codeNameLabel.text = self.dataArray[indexPath.row][0];
		cell.codeTF.placeholder = self.dataArray[indexPath.row][1];
		
		cell.codeStrBlock = ^(NSString * _Nonnull codeStr) {
			_code = codeStr;
		};
		cell.codeClickBlock = ^(AMButton * _Nonnull sender) {
			_codeBtn = sender;
			if (_phone.length == 0) {
				[SVProgressHUD showMsg:@"请先填写手机号"];
				return;
			}
			[self getCode];
		};
		
		return cell;
	}else {
		PasswordSetting_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PasswordSetting_TableViewCell class]) forIndexPath:indexPath];

		cell.selectionStyle = UITableViewCellSelectionStyleDefault;
		cell.titleLab.text = self.dataArray[indexPath.row][0];
		
		cell.contentTF.text = nil;
		cell.contentTF.placeholder = self.dataArray[indexPath.row][1];

		if ((_type && !_nextStep && !indexPath.row) || (!_type && _havePsw && !indexPath.row)) {
			cell.contentTF.secureTextEntry = NO;
		}else {
			cell.contentTF.secureTextEntry = YES;
		}
		
		cell.contentStrBlock = ^(NSString * _Nonnull conetentStr) {
			if (_type && !_nextStep && !indexPath.row) {
				_phone = conetentStr;
			}
		};
		
		return cell;
	}
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
-(UITableView*)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
		
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
		
        _tableView.separatorStyle = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = ADRowHeight;
		
		[_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PasswordSetting_TableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([PasswordSetting_TableViewCell class])];
		[_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PasswordReset_TableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([PasswordReset_TableViewCell class])];
    }
    return _tableView;
}
#pragma mark -
- (UIView *)creatTableFooterView {
    UIView *wrapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, K_Width, ADBottomButtonHeight*3/2)];
	
    AMButton *button = [AMButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(ADAptationMargin, wrapView.height/3, K_Width- ADAptationMargin*2, wrapView.height*2/3);
	
    button.clipsToBounds = YES;
    button.layer.cornerRadius = button.height/2;
    button.backgroundColor = Color_Black;
	
    [button addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
	[button setTitle:@"确 认" forState:UIControlStateNormal];
	if (_type && !_nextStep) {
		[button setTitle:@"下一步" forState:UIControlStateNormal];
	}
	
	button.titleLabel.font = [UIFont addHanSanSC:17.0f fontType:1];
    [wrapView addSubview:button];
    return wrapView;
}

- (UIView *)creatTableHeaderView {
	UIView *wrapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScrW, ADBottomButtonHeight)];
	
	UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(ADAptationMargin,0 , K_Width- ADAptationMargin*2, wrapView.height)];
	textLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
	textLabel.textColor = RGB(122,129,153);
	textLabel.text = @"您可以通过绑定的手机重置密码";
	[wrapView addSubview:textLabel];
	return wrapView;
}

#pragma mark -
- (void)sureButtonClick{
	[self.view endEditing:YES];
	if (_type) {
		if (!_nextStep) {//找回密码-验证手机
			_nextStep = YES;
			[self verifyCode];
		}else {//找回密码
			NSString *yuan_a;
			NSString *yuan_b;
			for (int i = 0; i < self.dataArray.count; i++) {
				NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
				PasswordSetting_TableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
				switch (i) {
					case 0:
						yuan_a = cell.contentTF.text;
						break;
					case 1:
						yuan_b = cell.contentTF.text;
						break;
					default:
						break;
				}
			}
			if (![ToolUtil isEqualToNonNull:yuan_a ]) {
				[SVProgressHUD showError:@"请输入新密码"];
				return;
			}
			if (![ToolUtil isEqualToNonNull:yuan_b ]) {
				[SVProgressHUD showMsg:@"请再次输入新密码"];
				return;
			}
			if (![yuan_a isEqualToString:yuan_b]) {
				[SVProgressHUD showMsg:@"两次密码输入不一致"];
				return;
			}

			[self changePasswordWithPassword:yuan_b];
		}
	}else {
		if (self.havePsw) {
			NSString *yuan;
			NSString *xin_a;
			NSString *xin_b;
			for (int i = 0; i < self.dataArray.count; i++) {
				NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
				PasswordSetting_TableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
				switch (i) {
					case 0:
						yuan = cell.contentTF.text;
						break;
					case 1:
						xin_a = cell.contentTF.text;
						break;
					case 2:
						xin_b = cell.contentTF.text;
						break;
					default:
						break;
				}
			}
			if (![ToolUtil isEqualToNonNull:yuan ]) {
				[SVProgressHUD showMsg:@"请输入原密码"];
				return;
			}
			if (![ToolUtil isEqualToNonNull:xin_a ]) {
				[SVProgressHUD showMsg:@"请输入新密码"];
				return;
			}
			if (![ToolUtil isEqualToNonNull:xin_b ]) {
				[SVProgressHUD showMsg:@"请再次输入新密码"];
				return;
			}
			if ([xin_a isEqualToString:yuan]) {
				[SVProgressHUD showMsg:@"新密码不能和旧密码相同"];
				return;
			}
			if (![xin_a isEqualToString:xin_b]) {
				[SVProgressHUD showMsg:@"两次密码输入不一致"];
				return;
			}
			[self changePasswordWithOldPassword:yuan withNewPassword:xin_b];
		}else{
			NSString *yuan_a;
			NSString *yuan_b;
			for (int i = 0; i < self.dataArray.count; i++) {
				NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
				PasswordSetting_TableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
				switch (i) {
					case 0:
						yuan_a = cell.contentTF.text;
						break;
					case 1:
						yuan_b = cell.contentTF.text;
						break;
					default:
						break;
				}
			}
			if (![ToolUtil isEqualToNonNull:yuan_a ]) {
				[SVProgressHUD showMsg:@"请输入新密码"];
				return;
			}
			if (![ToolUtil isEqualToNonNull:yuan_b ]) {
				[SVProgressHUD showMsg:@"请再次输入新密码"];
				return;
			}
			if (![yuan_a isEqualToString:yuan_b]) {
				[SVProgressHUD showMsg:@"两次密码输入不一致"];
				return;
			}
			[self first_setPasswordWithPassword:yuan_b];
		}
	}
}


/**
 首次设置密码

 @param psw 密码
 */
- (void)first_setPasswordWithPassword:(NSString *)psw {

    NSDictionary *param = @{@"uid" : [UserInfoManager shareManager].uid,
                            @"password" : [ToolUtil isEqualToNonNullKong:psw]
							};
	
    [ApiUtil postWithParent:self url:[ApiUtilHeader firstSetPassword] params:param success:^(NSInteger code, id  _Nullable response) {
        if (!_type) {
            [self saveUserData:psw];
        }
        AMAlertView *alertView = [AMAlertView shareInstanceWithTitle:@"密码设置成功！" buttonArray:@[@"确定"] confirm:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        } cancel:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        [alertView show];
        
    } fail:nil];
}


/**
 修改密码

 @param oldPsw 旧密码
 @param newPsw 新密码
 */
- (void)changePasswordWithOldPassword:(NSString *)oldPsw withNewPassword:(NSString *)newPsw{
    
    NSDictionary *param = @{@"uid" : [UserInfoManager shareManager].uid,
                            @"oldpass" : [ToolUtil isEqualToNonNullKong:oldPsw],
                            @"newpass" : [ToolUtil isEqualToNonNullKong:newPsw]
                            };
	
    [ApiUtil postWithParent:self url:[ApiUtilHeader changePassword] params:param success:^(NSInteger code, id  _Nullable response) {
        [self saveUserData:newPsw];
        AMAlertView *alertView = [AMAlertView shareInstanceWithTitle:@"密码修改成功！" buttonArray:@[@"确定"] confirm:^{
            [self.navigationController popViewControllerAnimated:YES];
        } cancel:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertView show];
    } fail:nil];
}

-(void)saveUserData:(NSString *)psw{
    UserInfoModel *model = [UserInfoManager shareManager].model;
    NSMutableDictionary *inforDic = [model yy_modelToJSONObject];
    [inforDic setObject:[MD5Tool md5WithString:psw]  forKey:@"password"];
    [[UserInfoManager shareManager] saveUserData:inforDic];
}

#pragma mark - 找回密码操作相关
/**
 获取验证码
 */
- (void)getCode {
	if (![ToolUtil valifyMobile:_phone]) {
        [SVProgressHUD showError:@"请输入正确的手机号"];
		return;
	}
	[self.view endEditing:YES];
	
	NSMutableDictionary *params = [NSMutableDictionary new];
	
	params[@"type"] = @"2";///找回密码
	params[@"mobile"] = [ToolUtil isEqualToNonNullKong:_phone];
	
    [ApiUtil postWithParent:self url:[ApiUtilHeader getVerificationCode] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [SVProgressHUD showSuccess:@"验证码发送成功"];
        [self.timer setFireDate:[NSDate distantPast]];
    } fail:nil];
}

/**
 验证验证码
 */
- (void)verifyCode {
	if (![ToolUtil isEqualToNonNull:_code ]) {
		[SVProgressHUD showSuccess:@"请输入验证码"];
		return;
	}
	
	NSMutableDictionary *params = [NSMutableDictionary new];
	//{"type":"1","mobile":"18758129692","code":"3888"}
	params[@"type"] = @"2";///找回密码
	params[@"mobile"] = [ToolUtil isEqualToNonNullKong:_phone];
	params[@"code"] = [ToolUtil isEqualToNonNullKong:_code];
	
    [ApiUtil postWithParent:self url:[ApiUtilHeader verifyCode] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [self creatData];
    } fail:nil];
}

-(void)countDown
{
	_num -= 1;
	if(_num > 0)
	{
		_codeBtn.enabled = NO;
		[_codeBtn setTitleColor:Color_Grey forState:UIControlStateNormal];
		[_codeBtn setTitle:[NSString stringWithFormat:@"重新获取(%@s)",@(_num)] forState:UIControlStateNormal];
	}else{
		_codeBtn.enabled = YES;
		[_codeBtn setTitleColor:Color_MainBg forState:UIControlStateNormal];
		[_codeBtn setTitle:[NSString stringWithFormat:@"重新获取"] forState:UIControlStateNormal];
		
		[self.timer setFireDate:[NSDate distantFuture]];
		_num = 60;
	}
}


/**
 重置密码

 @param newPasw 新密码
 */
- (void)changePasswordWithPassword:(NSString *)newPasw {
	
	NSMutableDictionary *params = [NSMutableDictionary new];
	params[@"mobile"] = [ToolUtil isEqualToNonNullKong:_phone];
	params[@"newpass"] = [ToolUtil isEqualToNonNullKong:newPasw];
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader resetPassword] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        AMAlertView *alert = [AMAlertView shareInstanceWithTitle:response[@"message"] buttonArray:@[@"确定"] confirm:^{
            [self.navigationController popViewControllerAnimated:YES];
        } cancel:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert show];
    } fail:nil];
}

@end
