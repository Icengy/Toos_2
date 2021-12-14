//
//  IdentifyViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/23.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "IdentifyViewController.h"

#import "IdentityResultViewController.h"
#import "ImproveDataViewController.h"
#import "FaceRecognitionViewController.h"
#import "PhoneAuthViewController.h"
#import "AMPayViewController.h"

#import "AMDialogView.h"
#import "IMYWebView.h"

#import "AMPayManager.h"

@interface IdentifyViewController () <AMPayDelegate, AMPayManagerDelagate>

@property (weak, nonatomic) IBOutlet UIStackView *contentView;

@property (weak, nonatomic) IBOutlet AMButton *statusBtn;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;

@property (weak, nonatomic) IBOutlet IMYWebView *webView;

@end

@implementation IdentifyViewController {
	NSInteger _state;
    NSString *_paymoney;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"艺术家认证";
    
    _reasonLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    _statusBtn.titleLabel.font = [UIFont addHanSanSC:18.0f fontType:1];
    
	_state = 0;
    
    NSURL *url = [NSURL URLWithString:[ApiUtil_H5Header h5_identityPost]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWXPayResult:) name:WXPaymentResultForNormal object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAliPayResult:) name:AliPaymentResultForNormal object:nil];
    
    [self loadData:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WXPaymentResultForNormal object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AliPaymentResultForNormal object:nil];
}

#pragma mark -
- (void)payViewController:(BaseViewController *)payViewController didSelectPayForWay:(AMPayWay)payWay {
    [payViewController dismissViewControllerAnimated:YES completion:^{
        switch (payWay) {
            case AMPayWayApple:///苹果支付

                break;
            case AMPayWayWX:///微信支付
                [[WechatManager shareManager] payIdentifyFeeWithType:@"9" roleType:@"2"];
                break;
            case AMPayWayAlipay:///支付宝支付
                [[AlipayManager shareManager] payIdentifyFeeWithType:@"9" roleType:@"2"];
                break;

            default:
                break;
        }
    }];
}

#pragma mark -
- (void)showWXPayResult:(NSNotification *)noti {
    BOOL isSuccess = [noti.object boolValue];
    SingleAMAlertView *alert = [SingleAMAlertView shareInstance];
    alert.title = isSuccess?@"支付成功！":@"支付失败，请重试！";
    alert.canTouchBlank = NO;
    @weakify(self);
    alert.confirmBlock = ^{
        if (isSuccess)  {
            @strongify(self);
            [self.navigationController pushViewController:[[IdentityResultViewController alloc] init] animated:YES];
        }
    };
    [alert show];
}

- (void)showAliPayResult:(NSNotification *)noti {
    NSInteger code = [noti.object integerValue];
    SingleAMAlertView *alert = [SingleAMAlertView shareInstance];
    
    if (code == 0) {
        alert.title = @"支付成功！";
    }else if (code == 1) {
        alert.title = @"已取消支付";
    }else {
        alert.title = @"支付失败，请重试！";
    }
    alert.canTouchBlank = NO;
    alert.confirmBlock = ^{
        @weakify(self);
        if (code == 0) {
            @strongify(self);
            [self.navigationController pushViewController:[[IdentityResultViewController alloc] init] animated:YES];
        }
    };
    [alert show];
}

#pragma mark -
- (IBAction)clickToIdentify:(id)sender {
	/// 0未实名 1未提交认证资料（可以点击认证） 2申请中 3申请未通过 4申请通过，未缴费 5认证通过
    switch (_state) {
        case 0: {
            AMAuthDialogView *dialogView = [AMAuthDialogView shareInstance];
            @weakify(dialogView);
            dialogView.imageSelectedBlock = ^(AMImageSelectedMeidaType meidaType) {
                @strongify(dialogView);
                [dialogView hide];
                if (meidaType) {
                    PhoneAuthViewController *authVC = [[PhoneAuthViewController alloc] init];
                    authVC.isFromArtistAuth = YES;
                    [self.navigationController pushViewController:authVC animated:YES];
                }else {
                    FaceRecognitionViewController *faceVC = [[FaceRecognitionViewController alloc] init];
                    faceVC.isFromArtistAuth = YES;
                    [self.navigationController pushViewController:faceVC animated:YES];
                }
            };
            [dialogView show];
            break;
        }
        case 1:
        case 3: {
            [self.navigationController pushViewController:[[ImproveDataViewController alloc] init] animated:YES];
            break;
        }
        case 2:
            break;
        case 4: {
            if (![ToolUtil isEqualToNonNullKong:_paymoney]) {
                [SVProgressHUD showMsg:@"数据错误，请联系客服"];
                return;
            }
            AMPayViewController *payVC = [[AMPayViewController alloc] init];
            payVC.delegate = self;
            payVC.priceStr = _paymoney;
            payVC.payStyle = AMAwakenPayStyleDefalut;
            [self.navigationController presentViewController:payVC animated:YES completion:nil];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark -
- (void)loadData:(id)sender {
    [ApiUtil postWithParent:self url:[ApiUtilHeader artistIdentifyIndex] params:@{@"uid":[UserInfoManager shareManager].uid} success:^(NSInteger code, id  _Nullable response) {
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            NSString *state = [ToolUtil isEqualToNonNull:[data objectForKey:@"state"] replace:@"0"];
            _state = state.integerValue;
            _paymoney = [data objectForKey:@"paymoney"];
            /// 0未实名 1未提交认证资料（可以点击认证） 2申请中 3申请未通过 4申请通过，未缴费 5认证通过
            switch (_state) {
                case 0:
                case 1: {/// 按钮黑底白字无tip
                    _statusBtn.hidden = NO;
                    [_statusBtn setTitle:@"立即认证" forState:UIControlStateNormal];
                    _reasonLabel.hidden = YES;
                    break;
                }
                case 2: {///
                    _statusBtn.hidden = YES;
                    [_statusBtn setTitle:nil forState:UIControlStateNormal];
                    _reasonLabel.hidden = NO;
                    _reasonLabel.text = @"认证待审核，客服电话：45645645";
                    break;
                }
                case 3: {
                    _statusBtn.hidden = NO;
                    [_statusBtn setTitle:@"修改认证资料" forState:UIControlStateNormal];
                    _reasonLabel.hidden = NO;
                    _reasonLabel.text = @"认证未通过，您可以重新修改资料";
                    break;
                }
                case 4: {
                    _statusBtn.hidden = NO;
                    [_statusBtn setTitle:[NSString stringWithFormat:@"立即缴纳¥%.2f", [[ToolUtil isEqualToNonNull:_paymoney replace:@"0"] floatValue]] forState:UIControlStateNormal];
                    _reasonLabel.hidden = NO;
                    _reasonLabel.text = @"您尚未缴纳认证费，缴纳成功后，完成艺术家认证";
                    break;
                }
                case 5: {
                    _statusBtn.hidden = YES;
                    [_statusBtn setTitle:nil forState:UIControlStateNormal];
                    _reasonLabel.hidden = NO;
                    _reasonLabel.text = @"您已经是认证艺术家！";
                    _reasonLabel.textColor = RGB(17,103,219);
                    _reasonLabel.font = [UIFont addHanSanSC:18.0f fontType:1];
                    break;
                }
                    
                default:
                    break;
            }
        }
        
    } fail:nil];
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
