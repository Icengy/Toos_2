//
//  MobileBind_ViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/22.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "MobileBind_ViewController.h"
#import "MobileChange_ViewController.h"
#import "Mobile_RemoveBind_ViewController.h"

@interface MobileBind_ViewController ()

@property (weak, nonatomic) IBOutlet UIView *changeBindView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *changeBindViewTopConstraint;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet AMButton *changePhoneBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *changeBtnHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *firstBindView;


@end

@implementation MobileBind_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	_nameLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
	_phoneLabel.font = [UIFont addHanSanSC:30.0f fontType:2];
	
	UserInfoModel *model = [UserInfoManager shareManager].model;
	_phoneLabel.text = [ToolUtil getSecretMobileNumWitMobileNum:[ToolUtil isEqualToNonNullKong:model.mobile]];
	
	_changePhoneBtn.titleLabel.font = [UIFont addHanSanSC:18.0f fontType:1];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self.navigationItem setTitle:@"绑定手机号"];
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	_changeBindViewTopConstraint.constant += ADRowHeight;
	_changeBtnHeightConstraint.constant = ADBottomButtonHeight;
	
	_changePhoneBtn.layer.cornerRadius = ADBottomButtonHeight/2;
	_changePhoneBtn.clipsToBounds = YES;
}

- (IBAction)clickToChangePhone:(id)sender {
	Mobile_RemoveBind_ViewController *vc = [[Mobile_RemoveBind_ViewController alloc] init];
	[self.navigationController pushViewController:vc animated:YES];
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
