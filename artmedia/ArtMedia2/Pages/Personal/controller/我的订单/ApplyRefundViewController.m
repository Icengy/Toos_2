//
//  ApplyRefundViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/12.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "ApplyRefundViewController.h"

#import "MyOrderModel.h"

@interface ApplyRefundViewController () <AMTextViewDelegate>

@property (weak, nonatomic) IBOutlet AMButton *confirmButton;
@property (weak, nonatomic) IBOutlet AMTextView *contentTV;

@property (weak, nonatomic) IBOutlet UIView *receiveView;
@property (weak, nonatomic) IBOutlet UILabel *receiveGoodsLabel;
@property (weak, nonatomic) IBOutlet AMButton *isReceiveGoodsBtn;

@end

@implementation ApplyRefundViewController {
	BOOL _isReceiveGoods;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	_isReceiveGoods = YES;
	
	_contentTV.font = [UIFont addHanSanSC:15.0f fontType:0];
	_contentTV.placeholder = _type?@"请填写拒绝退货原因":@"请填写退货原因";
	_contentTV.ownerDelegate = self;
	
	if (_type) {
		_receiveView.hidden = YES;
	}else {
		_receiveView.hidden = YES;
		_receiveGoodsLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
		_isReceiveGoodsBtn.selected = _isReceiveGoods;
	}
	
	[self.confirmButton setTitle:_type?@"拒绝退货":@"提交申请" forState:UIControlStateNormal];
    [self.confirmButton setTitle:_type?@"拒绝退货":@"提交申请" forState:UIControlStateDisabled];
    [self.confirmButton setBackgroundImage:[UIImage imageWithColor:Color_Black] forState:UIControlStateNormal];
    [self.confirmButton setBackgroundImage:[UIImage imageWithColor:Color_Grey] forState:UIControlStateDisabled];
    self.confirmButton.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	self.navigationItem.title = _type?@"填写拒绝原因":@"申请退货";
}

#pragma mark -
- (void)amTextViewDidChange:(AMTextView *)textView {
    self.confirmButton.enabled = textView.text.length;
}

#pragma mark -
- (IBAction)clickToReceive:(AMButton *)sender {
	sender.selected = !sender.selected;
	_isReceiveGoods = sender.selected;
}

- (IBAction)bottomClick:(id)sender {
	if (_type) {
		///卖家拒绝退货
		if (_bottomClick2Block) _bottomClick2Block(_contentTV.text);
		[self.navigationController popViewControllerAnimated:YES];
	}else {
		///买家申请退货
		NSString *urlString = [ApiUtilHeader applyRefund];
		/* {"type":"1","order_id":"79","is_received_goods":"2","apply_reason":"申请退货的原因。"}type为订单类型：1拍品订单，2商品订单。is_received_goods:1未收到货物，2已收到货物。
		 */
		NSMutableDictionary *params = [NSMutableDictionary new];
		
		params[@"order_id"] = [ToolUtil isEqualToNonNullKong:_orderModel.ID];
		params[@"type"] = @"2";
		
		params[@"apply_reason"] = _contentTV.text;
		params[@"is_received_goods"] = _isReceiveGoods?@"2":@"1";
		
        [ApiUtil postWithParent:self url:urlString params:params.copy success:^(NSInteger code, id  _Nullable response) {
            [SVProgressHUD showSuccess:@"申请退货成功" completion:^{
                if (_bottomClick1Block) _bottomClick1Block();
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } fail:nil];
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
