//
//  FillLogisticsViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/12.
//  Copyright © 2019年 lcy. All rights reserved.
//
// 填写物流信息
//

#import "FillLogisticsViewController.h"
#import "ZFScanViewController.h"

#import "MyOrderModel.h"


@interface FillLogisticsViewController ()

@property (weak, nonatomic) IBOutlet AMTextField *logOfferTF;
@property (weak, nonatomic) IBOutlet AMTextField *logNoTF;
@property (weak, nonatomic) IBOutlet AMButton *comfirmBtn;

@end

@implementation FillLogisticsViewController {
	NSString *_logNoStr, *_logOfferStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.bgColorStyle = AMBaseBackgroundColorStyleGray;
	
	_logOfferTF.font = [UIFont addHanSanSC:15.0f fontType:0];
	_logNoTF.font = [UIFont addHanSanSC:15.0f fontType:0];
    
    [_comfirmBtn setBackgroundImage:[UIImage imageWithColor:Color_Black] forState:UIControlStateNormal];
    [_comfirmBtn setBackgroundImage:[UIImage imageWithColor:Color_Grey] forState:UIControlStateDisabled];
	
	AMButton *rightView = [AMButton buttonWithType:UIButtonTypeCustom];
	rightView.frame = CGRectMake(0, 0, _logNoTF.height, _logNoTF.height);
	[rightView setImage:ImageNamed(@"log_no_pick") forState:UIControlStateNormal];
	[rightView addTarget:self action:@selector(clickToPickNo:) forControlEvents:UIControlEventTouchUpInside];
	_logNoTF.rightView = rightView;
	_logNoTF.rightViewMode = UITextFieldViewModeAlways;
	
	[_logOfferTF addTarget:self action:@selector(offerTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
	[_logNoTF addTarget:self action:@selector(noTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
	
	[self judgeConfirmBtn];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	self.navigationItem.title = @"填写物流";
}

#pragma mark -
- (void)offerTextFieldDidChange:(UITextField *)textField {
	_logOfferStr = textField.text;
	[self judgeConfirmBtn];
}

- (void)noTextFieldDidChange:(UITextField *)textField {
	_logNoStr = textField.text;
	[self judgeConfirmBtn];
}

- (void)judgeConfirmBtn {
	if (_logOfferTF.text.length && _logNoTF.text.length) {
        _comfirmBtn.enabled = YES;
	}else {
        _comfirmBtn.enabled = NO;
	}
}

#pragma mark -
- (IBAction)clickToConfirm:(id)sender {
    [self.view endEditing:YES];
	//0:发货物流 1 退货物流
    SingleAMAlertView *alertView = [SingleAMAlertView shareInstance];
    alertView.title = @"请确认物流信息";
    alertView.subTitle = [NSString stringWithFormat:@"物流公司：%@ \n 物流单号：%@",_logOfferTF.text,_logNoTF.text];
    alertView.needCancelShow = YES;
    //    @weakify(self);
    alertView.confirmBlock = ^{
        NSString *urlString = _logType?[ApiUtilHeader addDeliveryForBuyer]:[ApiUtilHeader addDeliveryForSeller];
        
        NSMutableDictionary *params = [NSMutableDictionary new];
        params[@"order_id"] = [ToolUtil isEqualToNonNullKong:_model.ID];
        params[@"type"] = @"2";
        params[@"delivery_comp"] = _logOfferTF.text;
        params[@"delivery_no"] = _logNoTF.text;
        params[@"delivery_id"] = [ToolUtil isEqualToNonNullKong:_logType?_model.return_delivery.ID:_model.send_delivery.ID];
        
        [ApiUtil postWithParent:self url:urlString params:params.copy success:^(NSInteger code, id  _Nullable response) {
            if (_bottomClickBlock) _bottomClickBlock();
            [self.navigationController popViewControllerAnimated:YES];
        } fail:nil];
    };
    [alertView show];
}

- (void)clickToPickNo:(id)sende {
	ZFScanViewController * vc = [[ZFScanViewController alloc] init];
	vc.returnScanBarCodeValue = ^(NSString * barCodeString){
		NSLog(@"扫描结果的字符串======%@",barCodeString);
		self.logNoTF.text = barCodeString;
        [self judgeConfirmBtn];
	};

	[self presentViewController:vc animated:YES completion:nil];
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
