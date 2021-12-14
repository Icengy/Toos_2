//
//  Mobile_RemoveBind_ViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/22.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "Mobile_RemoveBind_ViewController.h"

#import "MobileChange_ViewController.h"

@interface Mobile_RemoveBind_ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIView *contentCarrier;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentCarrierHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *codeNameLabel;
@property (weak, nonatomic) IBOutlet AMTextField *codeTF;
@property (weak, nonatomic) IBOutlet AMButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet AMButton *nextBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextBtnHegihtConstranit;

@property (weak, nonatomic) IBOutlet UILabel *wraningLabel;

@property (nonatomic ,strong) NSTimer *timer;
@end

@implementation Mobile_RemoveBind_ViewController {
	int _num;
	UserInfoModel *_model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.bgColorStyle = AMBaseBackgroundColorStyleGray;
	
	_model = [UserInfoManager shareManager].model;
	
	_contentCarrierHeightConstraint.constant = ADRowHeight;
	_contentCarrier.backgroundColor = Color_Whiter;
//	_contentCarrier.layer.cornerRadius = 4.0f;
//	_contentCarrier.layer.borderColor = Color_Grey.CGColor;
//	_contentCarrier.layer.borderWidth = 0.5f;
//	_contentCarrier.clipsToBounds = YES;
	
	_nextBtnHegihtConstranit.constant = ADBottomButtonHeight;
	_nextBtn.layer.cornerRadius = ADBottomButtonHeight/2;
	_nextBtn.clipsToBounds = YES;
	
	_nameLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
	_nameLabel.text = [NSString stringWithFormat:@"为保护您的账户安全，需要对现绑定的手机号（%@）进行短信验证", [ToolUtil getSecretMobileNumWitMobileNum:_model.mobile]];
	
	_codeNameLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
	_codeTF.font = [UIFont addHanSanSC:15.0f fontType:0];
	[_codeTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
	
//	_getCodeBtn.layer.cornerRadius = 4.0f;
//	_getCodeBtn.layer.borderWidth = 0.5f;
//	_getCodeBtn.layer.borderColor = Color_Grey.CGColor;
//	_getCodeBtn.clipsToBounds = YES;
	
	_getCodeBtn.titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
	
	_nextBtn.titleLabel.font = [UIFont addHanSanSC:18.0f fontType:1];
	_wraningLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
	

	
	_num = 60;
	_timer=[NSTimer timerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
	[[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
	[_timer setFireDate:[NSDate distantFuture]];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self.navigationItem setTitle:@"更换绑定"];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	if (_timer) {
		[_timer invalidate];
		_timer = nil;
	}
}

#pragma mark -
- (void)textFieldDidChange:(UITextField *)sender {
	_nextBtn.backgroundColor = (sender.text.length == 4)?Color_Black:Color_Grey;
}

#pragma mark -
- (IBAction)clickToGetCode:(id)sender {
	
	NSDictionary *params = @{@"type":@"6", @"mobile":[ToolUtil isEqualToNonNullKong:_model.mobile]};
    [ApiUtil postWithParent:self url:[ApiUtilHeader getVerificationCode] params:params success:^(NSInteger code, id  _Nullable response) {
        [SVProgressHUD showSuccess:response[@"message"]];
        [_timer setFireDate:[NSDate distantPast]];
    } fail:nil];
}

- (IBAction)clickToNext:(id)sender {
	if (!_codeTF.text || _codeTF.text.length != 4) {
		[SVProgressHUD showError:@"短信验证码不正确"];
		return;
	}
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"type"] = @"6";
    dic[@"code"] = [ToolUtil isEqualToNonNullKong:_codeTF.text];
    dic[@"mobile"] = [ToolUtil isEqualToNonNullKong:_model.mobile];
    [ApiUtil postWithParent:self url:[ApiUtilHeader verifyCode] params:dic success:^(NSInteger code, id  _Nullable response) {
        MobileChange_ViewController *mobileVC = [[MobileChange_ViewController alloc] init];
        mobileVC.type = 1;
        [self.navigationController pushViewController:mobileVC animated:YES];
    } fail:nil];
}

-(void)countDown {
	_num -= 1;
	if(_num > 0){
		[self.getCodeBtn setTitleColor:Color_Grey forState:UIControlStateNormal];
		self.getCodeBtn.userInteractionEnabled = NO;
		[self.getCodeBtn setTitle:[NSString stringWithFormat:@"重新获取(%@s)",@(_num)] forState:UIControlStateNormal];
	}else{
		self.getCodeBtn.userInteractionEnabled = YES;
		[self.getCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
		[self.getCodeBtn setTitleColor:Color_MainBg forState:UIControlStateNormal];
		
		[_timer setFireDate:[NSDate distantFuture]];
		_num = 60;
	}
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
