//
//  AMMeetingOrderViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/8/17.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMMeetingOrderViewController.h"

#import "AMMeetingPayResultViewController.h"
#import "AMPayViewController.h"

#import "IMYWebView.h"

#import <CoreGraphics/CoreGraphics.h>

@interface AMMeetingOrderViewController () <IMYWebViewDelegate, AMPayDelegate>

@property (weak, nonatomic) IBOutlet UIView *artInfoView;
@property (weak, nonatomic) IBOutlet UILabel *artViewTitleLabel;

@property (weak, nonatomic) IBOutlet AMIconImageView *artHeadIV;
@property (weak, nonatomic) IBOutlet UILabel *artNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artActiveLabel;

@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (weak, nonatomic) IBOutlet UILabel *priceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIView *tipsView;
@property (weak, nonatomic) IBOutlet UILabel *tipsTitleLabel;
@property (weak, nonatomic) IBOutlet IMYWebView *tipsContentWebView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webView_hegiht_constraint;


@property (weak, nonatomic) IBOutlet AMButton *confirmBtn;

@end

@implementation AMMeetingOrderViewController {
    NSDictionary *_artistData;
    NSString *_securityDeposit, *_orderID, *_tipsStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"约见订单";
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    
    _artViewTitleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    _artNameLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
    _artTitleLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
    _artActiveLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
    
    _priceTitleLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
    _priceLabel.font = [UIFont addHanSanSC:18.0f fontType:0];
    
    _tipsTitleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
    
    _confirmBtn.titleLabel.font = [UIFont addHanSanSC:18.0f fontType:0];
    
    self.tipsContentWebView.delegate = self;
    self.tipsContentWebView.scrollView.showsVerticalScrollIndicator = NO;
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWXPayResult:) name:WXPaymentResultForNormal object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAliPayResult:) name:AliPaymentResultForNormal object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WXPaymentResultForNormal object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AliPaymentResultForNormal object:nil];
}

#pragma mark -
- (void)showWXPayResult:(NSNotification *)noti {
    BOOL isSuccess = [noti.object boolValue];
    if (isSuccess) {
        [self showResultSuccess];
    }else
        [[AMAlertView shareInstanceWithTitle:@"支付失败，请重试！"
                                 buttonArray:@[@"确定"]
                                     confirm:nil
                                      cancel:nil] show];
}

- (void)showAliPayResult:(NSNotification *)noti {
    NSInteger code = [noti.object integerValue];
    if (code == 0) {
        [self showResultSuccess];
    }else if (code == 1) {
        [[AMAlertView shareInstanceWithTitle:@"已取消支付" buttonArray:@[@"确定"] confirm:nil cancel:nil] show];
    }else {
        [[AMAlertView shareInstanceWithTitle:@"支付失败，请重试！" buttonArray:@[@"确定"] confirm:nil cancel:nil] show];
    }
}

- (void)showResultSuccess {
    AMMeetingPayResultViewController *payResultVC = [[AMMeetingPayResultViewController alloc] init];
    payResultVC.artist_name = [ToolUtil isEqualToNonNullKong:[_artistData objectForKey:@"uname"]];
    [self.navigationController pushViewController:payResultVC animated:YES];
}

#pragma mark - IMYWebViewDelegate
- (void)webViewDidFinishLoad:(IMYWebView *)webView {
    //获取网页的高度
    [webView evaluateJavaScript:@"document.body.scrollHeight"completionHandler:^(id _Nullable result,NSError * _Nullable error){
        NSLog(@"result = %.2f", [result floatValue]);
        _webView_hegiht_constraint.constant = [result floatValue];
    }];
}

- (void)payViewController:(BaseViewController *)payViewController didSelectPayForWay:(AMPayWay)payWay {
    [payViewController dismissViewControllerAnimated:YES completion:^{
        switch (payWay) {
            case AMPayWayWX:
                [[WechatManager shareManager] payMeetingOrderWithID:_orderID type:@"1"];
                break;
            case AMPayWayAlipay:
                [[AlipayManager shareManager] payMeetingOrderWithID:_orderID type:@"1"];
                break;
                
            default:
                break;
        }
    }];
}

#pragma mark -
- (IBAction)clickToConfirm:(id)sender {
    if ([ToolUtil isEqualToNonNull:_orderID]) {
        AMPayViewController *payVC = [[AMPayViewController alloc] init];
        payVC.delegate = self;
        payVC.priceStr = _securityDeposit;
        payVC.payStyle = AMAwakenPayStyleDefalut;
        [self.navigationController presentViewController:payVC animated:YES completion:nil];
    }else{
        NSMutableDictionary *params = @{}.mutableCopy;
        params[@"artistId"] = [ToolUtil isEqualToNonNullKong:self.artuid];
        params[@"memberId"] = [UserInfoManager shareManager].uid;
        params[@"securityDeposit"] = [NSString stringWithFormat:@"%.2f",_securityDeposit.doubleValue];
        params[@"createUserName"] = [ToolUtil isEqualToNonNullKong:[UserInfoManager shareManager].model.username];
        
        [ApiUtil postWithParent:self url:[ApiUtilHeader addTeaOrder] params:params.copy success:^(NSInteger code, id  _Nullable response) {
            NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
            if (data && data.count) {
                _orderID = StringWithFormat([data objectForKey:@"teaAboutOrderId"]);
            }
            if ([ToolUtil isEqualToNonNull:_orderID]) {
                AMPayViewController *payVC = [[AMPayViewController alloc] init];
                payVC.delegate = self;
                payVC.priceStr = _securityDeposit;
                payVC.payStyle = AMAwakenPayStyleDefalut;
                [self.navigationController presentViewController:payVC animated:YES completion:nil];
            }else
                [SVProgressHUD showError:@"下单失败，请重试或联系后台"];
            
        } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
            @weakify(self);
            [SVProgressHUD showError:errorMsg completion:^{
                @strongify(self);
                [self loadData];
            }];
        }];
    }
}

#pragma mark -
- (void)loadData {
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_t group = dispatch_group_create();
    /// 获取下单所需的信息
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        NSMutableDictionary *params = @{}.mutableCopy;
        params[@"artistId"] = [ToolUtil isEqualToNonNullKong:self.artuid];
        
        [ApiUtil postWithParent:self url:[ApiUtilHeader getArtInfoBeforeCreatOrder] params:params.copy success:^(NSInteger code, id  _Nullable response) {
            NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
            if (data && data.count) {
                _artistData = data;
                _securityDeposit = [ToolUtil isEqualToNonNull:[_artistData objectForKey:@"securityDeposit"] replace:@"0"];
            }
            dispatch_group_leave(group);
        } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
            dispatch_group_leave(group);
        }];
    });
    
    /// 获取约见须知
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        [ApiUtil postWithParent:self url:[ApiUtilHeader getOrderInfoText] needHUD:NO params:@{@"articleCode":@"YJXZ"} success:^(NSInteger code, id  _Nullable response) {
            NSDictionary *data = (NSDictionary *)[(NSArray *)[response objectForKey:@"data"] lastObject];
            if (data && data.count) {
                _tipsStr = [ToolUtil isEqualToNonNullKong:[data objectForKey:@"articleContent"]];
            }
            dispatch_group_leave(group);
        } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUIsWithData];
        });
    });
}

- (void)updateUIsWithData {
    self.confirmBtn.hidden = NO;
    
    [self.artHeadIV am_setImageWithURL:[_artistData objectForKey:@"headimg"] contentMode:UIViewContentModeScaleAspectFill];
    
    self.artNameLabel.text = [ToolUtil isEqualToNonNullKong:[_artistData objectForKey:@"uname"]];
    
    self.artTitleLabel.hidden = ![ToolUtil isEqualToNonNull:[_artistData objectForKey:@"artistTitle"]];
    self.artTitleLabel.text = [ToolUtil isEqualToNonNullKong:[_artistData objectForKey:@"artistTitle"]];
    if ([[ToolUtil isEqualToNonNull:[_artistData objectForKey:@"updateTime"] replace:@"0"] doubleValue]) {
        self.artActiveLabel.hidden = NO;
        NSString *activeStatusStr = [TimeTool getTimeFromPassTimeIntervalToNowTimeInterval:[[_artistData objectForKey:@"lastSyncDate"] integerValue]];
        if ([activeStatusStr containsString:@"秒"]) {
            self.artActiveLabel.text = @"刚刚";
        }else
            self.artActiveLabel.text = [NSString stringWithFormat:@"%@前活跃",activeStatusStr];
    }
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",_securityDeposit.doubleValue];
    [self.confirmBtn setTitle:[NSString stringWithFormat:@"立即支付 %@",self.priceLabel.text] forState:UIControlStateNormal];
    
    [self.tipsContentWebView loadHTMLString:[ToolUtil html5StringWithContent:_tipsStr withTitle:nil] baseURL:nil];
    [self.tipsContentWebView.realWebView setNeedsLayout];
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
