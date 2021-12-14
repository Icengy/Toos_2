//
//  ImproveConfirmedViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/23.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "ImproveConfirmedViewController.h"

#import "UIViewController+BackButtonHandler.h"

#import "IdentifyViewController.h"

@interface ImproveConfirmedViewController ()

@property (weak, nonatomic) IBOutlet UILabel *ALabel;
@property (weak, nonatomic) IBOutlet UILabel *bLabel;
@property (weak, nonatomic) IBOutlet UILabel *cLabel;

@property (weak, nonatomic) IBOutlet AMButton *sureBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sureBtnHeightConstraint;

@end

@implementation ImproveConfirmedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	_ALabel.font = [UIFont addHanSanSC:18.0f fontType:1];
	_bLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
	_cLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
	
	_sureBtn.titleLabel.font = [UIFont addHanSanSC:16.0f fontType:0];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self.navigationItem setTitle:@"提交结果"];
	
    //禁用右滑返回手势
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
}

- (IBAction)clickToSure:(id)sender {
	[self exit];
}

#pragma mark -
- (BOOL)navigationShouldPopOnBackButton {
	[self exit];
	return NO;
}

- (void)exit {
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[IdentifyViewController class]]) {
            [self.navigationController popToViewController:obj animated:YES];
            *stop = YES;
        }
    }];
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
