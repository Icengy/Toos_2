//
//  OrderDetailViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/8.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "OrderDetailViewController.h"

#import "MyOrderModel.h"

#import "OrderAddressSelectCell.h"
#import "OrderGoodsIntroCell.h"
#import "MyOrderDetailTableCell.h"

#import "AdressViewController.h"
#import "ApplyRefundViewController.h"
#import "RefundDetailViewController.h"
#import "FillLogisticsViewController.h"
#import "ReceivableListViewController.h"
#import "GoodsPartViewController.h"

//#import "AMPaySelectView.h"
#import "AMPayViewController.h"

@interface OrderDetailViewController () <UITableViewDelegate ,UITableViewDataSource, AMPayDelegate>
@property (nonatomic ,weak) IBOutlet BaseTableView *tableView;

@property (nonatomic ,weak) IBOutlet AMButton *confirmButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmBtnBottomConstraint;
@property (nonatomic ,strong) AMButton *navRightBtn;
@property (nonatomic ,strong) UILabel *countDownLabel;

@property (nonatomic ,strong) NSTimer *timer;

@end

@implementation OrderDetailViewController {
	MyOrderModel *_orderModel;
    NSMutableArray <NSArray *>*_titleArray;
}

- (NSTimer *)timer {
	if (!_timer) {
		_timer=[NSTimer timerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
		[[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
		[_timer setFireDate:[NSDate distantFuture]];
	}return _timer;
}

- (UILabel *)countDownLabel {
    if (!_countDownLabel) {
        _countDownLabel = [[UILabel alloc] init];
        _countDownLabel.textColor = RGB(251, 108, 30);
        _countDownLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    }return _countDownLabel;
}

#pragma mark -
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
    self.confirmButton.titleLabel.font = [UIFont addHanSanSC:17.0f fontType:1];
    [self.confirmButton setBackgroundImage:[UIImage imageWithColor:Color_Black] forState:UIControlStateNormal];
    [self.confirmButton setBackgroundImage:[UIImage imageWithColor:Color_Whiter] forState:UIControlStateDisabled];
    [self.confirmButton setTitleColor:Color_Whiter forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:Color_Red forState:UIControlStateDisabled];
    
    _titleArray = @[].mutableCopy;
    
    self.tableView.bgColorStyle = AMBaseTableViewBackgroundColorStyleGray;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderGoodsIntroCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([OrderGoodsIntroCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderAddressSelectCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([OrderAddressSelectCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyOrderDetailTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MyOrderDetailTableCell class])];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell_UILabel"];
    
	if (@available(iOS 11.0, *)) {
		self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}
    
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	self.navigationItem.title = @"订单详情";
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWXPayResult:) name:WXPaymentResultForOrderDetail object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAliPayResult:) name:AliPaymentResultForNormal object:nil];
    
    [self loadData:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:WXPaymentResultForOrderDetail object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AliPaymentResultForNormal object:nil];
	if (self.timer) {
		[self.timer invalidate];
		self.timer = nil;
	}
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titleArray.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_titleArray.count) {
        NSArray *titArray = _titleArray[section];
        if (titArray.count) {
            if ([titArray.firstObject isEqualToString:@""]) {
                return titArray.count - 1;
            }
            return titArray.count;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section) {
        if (_orderModel.state == MyOrderTypeCancel || _orderModel.state == MyOrderTypeDaiFuKuan) {
            return CGFLOAT_MIN;
        }
        return ADAptationMargin/2;
    }
	return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [tableView numberOfSections] - 1) {
        if (_orderModel.state == MyOrderTypeDaiFuKuan && !_wayType) {
            return ADBottomButtonHeight;
        }
        return ADAptationMargin/2;
    }
	return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	UIView *wrapView = [[UIView alloc] init];
    if (_orderModel.state == MyOrderTypeDaiFuKuan && !_wayType && section == [tableView numberOfSections] - 1) {
        ///为确保交易顺利，请于24小时内付款，逾期将自动取消订单。
        wrapView.frame = CGRectMake(0, 0, K_Width, ADBottomButtonHeight);
        
        UILabel *label = [[UILabel alloc] init];
        [wrapView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.height.equalTo(wrapView);
            make.width.offset(K_Width - ADAptationMargin*2);
        }];
        label.font = [UIFont addHanSanSC:14.0f fontType:0];
        label.textColor = Color_GreyLight;
        label.text = @"为确保交易顺利，请于15分钟内付款，逾期将自动取消订单。";
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
    }
    return wrapView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	MyOrderDetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyOrderDetailTableCell class]) forIndexPath:indexPath];
    
    NSArray *titArray = _titleArray[indexPath.section];
    
    if ([titArray.firstObject isEqualToString:@""]) {
        if ([titArray.lastObject isEqualToString:NSStringFromClass([UILabel class])]) {
            UITableViewCell *timeCell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell_UILabel"];
            if (!timeCell) {
                timeCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell_UILabel"];
            }
            timeCell.backgroundColor = RGB(254, 252, 237);
            timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            timeCell.textLabel.textColor =  RGB(251, 108, 30);
            timeCell.textLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
            timeCell.textLabel.textAlignment = NSTextAlignmentCenter;
            timeCell.textLabel.text = _wayType?@"买家支付已超时":@"支付已超时";
            
            return timeCell;
        }
        if ([titArray.lastObject isEqualToString:NSStringFromClass([OrderGoodsIntroCell class])]) {
            ///OrderGoodsIntroCell
            OrderGoodsIntroCell *goodsCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderGoodsIntroCell class]) forIndexPath:indexPath];
            goodsCell.orderModel = _orderModel;
            @weakify(self);
            goodsCell.clickToRefundBlock = ^{
                @strongify(self);
                [self goodCellBtn];
            };
            
            return goodsCell;
        }
        if ([titArray.lastObject isEqualToString:NSStringFromClass([OrderAddressSelectCell class])]) {
            ///OrderAddressSelectCell
            OrderAddressSelectCell *addressCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderAddressSelectCell class]) forIndexPath:indexPath];
            addressCell.addressModel = _orderModel.send_delivery;
            
            return addressCell;
        }else {
            cell.titleLabel.text = titArray[indexPath.row + 1];
            cell.subTitleLabel.text = [self detailText:cell.titleLabel.text];
        }
    }else {
        cell.titleLabel.text = titArray[indexPath.row];
        cell.subTitleLabel.text = indexPath.row?[self detailText:cell.titleLabel.text]:nil;
    }
    
    if ([cell.titleLabel.text isEqualToString:@"商品金额"] ||
        [cell.titleLabel.text isEqualToString:@"应付金额（不含运费）"] ||
        [cell.titleLabel.text isEqualToString:@"买家实付金额（不含运费）"] ||
        [cell.titleLabel.text isEqualToString:@"平台佣金"] ||
        [cell.titleLabel.text isEqualToString:@"实际到账"]) {
        cell.subTitleLabel.textColor = Color_Red;
    }else
        cell.subTitleLabel.textColor = Color_Black;
    
    if ([cell.subTitleLabel.text isEqualToString:@"包邮"]) {
        cell.subTitleLabel.font = [UIFont addHanSanSC:16.0f fontType:2];
    }else {
        cell.subTitleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    }
    
    if ([cell.titleLabel.text isEqualToString:@"物流信息"] ||
        [cell.titleLabel.text isEqualToString:@"买家信息"] ||
        [cell.titleLabel.text isEqualToString:@"收款信息"]) {
        
        cell.titleLabel.textColor = RGB(122, 129, 153);
        cell.titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    }else {
        cell.titleLabel.textColor = Color_Black;
        cell.titleLabel.font = [UIFont addHanSanSC:16.0f fontType:0];
    }
	
	return cell;
}

- (NSString *_Nullable)detailText:(NSString *)title {
    if ([title isEqualToString:@"运费"]) {
        return @"包邮";
    }
    if ([title isEqualToString:@"商品金额"]) {
        return [NSString stringWithFormat:@"¥ %.2f",[[ToolUtil isEqualToNonNull:_orderModel.buyer_amount replace:@"0"] floatValue]];
    }
    if ([title isEqualToString:@"创建时间"]) {
        return [TimeTool getDateStringWithTimeStr:_orderModel.addtime];
    }
    if ([title isEqualToString:@"付款时间"]) {
        return [TimeTool getDateStringWithTimeStr:_orderModel.pay_time];
    }
    if ([title isEqualToString:@"发货时间"]) {
        return [TimeTool getDateStringWithTimeStr:_orderModel.send_delivery.delivery_time];
    }
    if ([title isEqualToString:@"收货时间"]) {
        return [TimeTool getDateStringWithTimeStr:_orderModel.confirmtime];
    }
    if ([title isEqualToString:@"关闭时间"]) {
        return [TimeTool getDateStringWithTimeStr:_orderModel.return_money_time];
    }
    if ([title isEqualToString:@"买家实付金额（不含运费）"]) {
        return [NSString stringWithFormat:@"¥ %.2f",[[ToolUtil isEqualToNonNull:_orderModel.buyer_amount replace:@"0"] floatValue]];
    }
    if ([title isEqualToString:@"平台佣金"]) {
        return [NSString stringWithFormat:@"¥ %.2f",[[ToolUtil isEqualToNonNull:_orderModel.commission replace:@"0"] floatValue]];
    }
    if ([title isEqualToString:@"实际到账"]) {
        return [NSString stringWithFormat:@"¥ %.2f",[[ToolUtil isEqualToNonNull:_orderModel.seller_amount  replace:@"0"] floatValue]];
    }
    if ([title isEqualToString:@"物流公司"]) {
        return[ToolUtil isEqualToNonNullKong:_orderModel.send_delivery.devlivery_comp];
    }
    if ([title isEqualToString:@"物流单号"]) {
        return [ToolUtil isEqualToNonNullKong:_orderModel.send_delivery.devlivery_no];
    }
    if ([title isEqualToString:@"订单编号"]) {
        return [ToolUtil isEqualToNonNullKong:_orderModel.ordersn];
    }
    if ([title isEqualToString:@"支付用户"]) {
        return [ToolUtil isEqualToNonNullKong:_orderModel.buyer_name];
    }
    if ([title isEqualToString:@"应付金额（不含运费）"]) {
        return [NSString stringWithFormat:@"¥ %.2f",[[ToolUtil isEqualToNonNull:_orderModel.buyer_amount  replace:@"0"] floatValue]];
    }
    if ([title isEqualToString:@"支付状态"]) {
        if (_orderModel.state == MyOrderTypeDaiFuKuan ||
            _orderModel.state == MyOrderTypeCancel) {
            return @"未支付";
        }
        return @"已支付";
    }
    if ([title isEqualToString:@"收货人"]) {
        return [ToolUtil isEqualToNonNullKong:_orderModel.send_delivery.reciver];
    }
    if ([title isEqualToString:@"联系电话"]) {
        return [ToolUtil isEqualToNonNullKong:_orderModel.send_delivery.phone];
    }
    if ([title isEqualToString:@"收货地址"]) {
        NSString *valueStr =  [NSString stringWithFormat:@"%@\n%@",[ToolUtil isEqualToNonNullKong:_orderModel.send_delivery.addrregion], [ToolUtil isEqualToNonNullKong:_orderModel.send_delivery.address]];
        if ([valueStr hasPrefix:@"\n"])
            valueStr = [valueStr substringFromIndex:1];
        if ([valueStr hasSuffix:@"\n"])
            valueStr = [valueStr substringToIndex:valueStr.length - 1];
        return [ToolUtil isEqualToNonNullKong:valueStr];
    }
    
    return [NSString stringWithFormat:@"测试待修改：%@",@(arc4random()%2000)];
}

- (void)goodCellBtn {
    switch (_orderModel.state) {
        case MyOrderTypeYiFuKuan: {
            if (!_orderModel.wayType)/// 申请退货
                [self clickToRefund:nil];
            break;
        }
        case MyOrderTypeQueRenShouHuo: {
            if (_orderModel.wayType) {
                if (_orderModel.oretapply.integerValue) {
                    [self clickToShowRefundDetail:nil];
                }
            }else {
                if (_orderModel.oretapply.integerValue) {
                    [self clickToShowRefundDetail:nil];
                }else {
                    [self clickToRefund:nil];
                }
            }
            break;
        }
        case MyOrderTypeTuiHuoZhong:/// 处理退货
        case MyOrderTypeTuiHuoWanCheng: /// 退货详情
        case MyOrderTypeYiTuiKuan: {
            
            [self clickToShowRefundDetail:nil];
            break;
        }
            
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        GoodsPartViewController * vc = [[GoodsPartViewController alloc] init];
        vc.goodsID = _orderModel.obj_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
	switch (_orderModel.state) {
		case MyOrderTypeDaiFuKuan:
			if (_orderModel.wayType == 0 && indexPath.section == 1) {
				AdressViewController *addressVC = [[AdressViewController alloc]init];
                addressVC.style = 1;
				addressVC.chooseAdress = ^(MyAddressModel * _Nonnull adressModel) {
					if (adressModel) {
						NSMutableDictionary *params = [NSMutableDictionary new];
						
						params[@"order_id"] = _orderID;
						params[@"address_id"] = [ToolUtil isEqualToNonNullKong:adressModel.ID];
                        
                        [ApiUtil postWithParent:self url:[ApiUtilHeader resetGoodOrderAddress] params:params.copy success:^(NSInteger code, id  _Nullable response) {
                            _orderModel.send_delivery = adressModel;
                            [self.tableView reloadData];
                        } fail:nil];
					}
				};
				[self.navigationController pushViewController:addressVC animated:YES];
			}
			break;
		default:
			break;
	}
}

#pragma mark -
- (void)payViewController:(BaseViewController *)payViewController didSelectPayForWay:(AMPayWay)payWay {
    [payViewController dismissViewControllerAnimated:YES completion:^{
        switch (payWay) {
            case AMPayWayApple:///苹果支付
                
                break;
            case AMPayWayWX:///微信支付
                [[WechatManager shareManager] payOrderWithType:@"3" withOrderID:_orderID];
                break;
            case AMPayWayAlipay:///支付宝支付
                [[AlipayManager shareManager] payOrderWithType:@"3" withOrderID:_orderID];
                break;
                
            default:
                break;
        }
    }];
}

- (void)showWXPayResult:(NSNotification *)noti {
    BOOL isSuccess = [noti.object boolValue];
    [[AMAlertView shareInstanceWithTitle:isSuccess?@"支付成功！":@"支付失败，请重试！" buttonArray:@[@"确定"] confirm:^{
//        [self.navigationController popToRootViewControllerAnimated:YES];
        if (isSuccess) [self loadData:nil];
    } cancel:nil] show];
}

- (void)showAliPayResult:(NSNotification *)noti {
    NSInteger code = [noti.object integerValue];
    NSString *titleStr = nil;
    if (code == 0) {
        titleStr = @"支付成功！";
    }else if (code == 1) {
        titleStr = @"已取消支付";
    }else {
        titleStr = @"支付失败，请重试！";
    }
    [[AMAlertView shareInstanceWithTitle:titleStr buttonArray:@[@"确定"] confirm:^{
        if (code == 0) [self loadData:nil];
    } cancel:nil] show];
}

#pragma mark -
-(void)countDown {
	[TimeTool compareCurrentDateTimeWithTime:[[ToolUtil isEqualToNonNull:_orderModel.addtime replace:@"0"] integerValue] block:^(BOOL isFinish, NSString * _Nullable compareStr) {
		dispatch_async(dispatch_get_main_queue(), ^{
                if (isFinish) {
                    UITableViewCell *timeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                    if (timeCell && [timeCell.reuseIdentifier isEqualToString:@"UITableViewCell_UILabel"]) {
                         if (_wayType) {
                             timeCell.textLabel.text = [NSString stringWithFormat:@"%@后自动关闭订单",compareStr];
                         }else {
                             timeCell.textLabel.text = [NSString stringWithFormat:@"剩余支付时间：%@", compareStr];
                        }
                    }
                }else {
                    [self.timer setFireDate:[NSDate distantFuture]];
                    _orderModel.state = MyOrderTypeCancel;
                    [self updateContentUI];
                }
		});
	}];
}

- (IBAction)bottomLeftClick:(AMButton *)sender {
	switch (_orderModel.state) {
		case MyOrderTypeDaiFuKuan: {///立即支付
            AMPayViewController *payVC = [[AMPayViewController alloc] init];
            payVC.delegate = self;
            payVC.priceStr = _orderModel.buyer_amount;
            payVC.payStyle = AMAwakenPayStyleDefalut;
            [self.navigationController presentViewController:payVC animated:YES completion:nil];
			
			break;
		}
		case MyOrderTypeYiFuKuan: {///填写物流
			FillLogisticsViewController *fillLogVC = [[FillLogisticsViewController alloc] init];
			fillLogVC.model = _orderModel;
			fillLogVC.logType = 0;
			fillLogVC.bottomClickBlock = ^{
				[self loadData:nil];
			};
			[self.navigationController pushViewController:fillLogVC animated:YES];
			
			break;
		}
		case MyOrderTypeQueRenShouHuo: {
			if (!_wayType) {///确认收货
                [self querenshouhuoForBuyer];
			}else {///退货处理
				[self clickToShowRefundDetail:sender];
			}
			break;
		}
		case MyOrderTypeTuiHuoZhong: {
            if (_wayType) {
                if (_orderModel.oretapply.integerValue) {
                    [self clickToShowRefundDetail:sender];
                }else
                    [self querenshouhuoForSeller];
            }else {
                [self querenshouhuoForBuyer];
            }
			break;
		}
		default:
			break;
	}
}

/// 买家确认收货
- (void)querenshouhuoForBuyer {
    AMAlertView *alert = [AMAlertView shareInstanceWithTitle:@"确认收货后无法申请退货服务。\n是否确认收货?" buttonArray:@[@"是",@"否"] confirm:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableDictionary *params = [NSMutableDictionary new];
            
            params[@"order_id"] = [ToolUtil isEqualToNonNullKong:_orderModel.ID];
            params[@"type"] = @"2";
            [ApiUtil postWithParent:self url:[ApiUtilHeader confirmReceiptForBuyer] params:params.copy success:^(NSInteger code, id  _Nullable response) {
                [SVProgressHUD showSuccess:@"确认收货成功" completion:^{
                    [self loadData:nil];
                }];
            } fail:nil];
        });
    } cancel:nil];
    [alert show];
}

/// 卖家确认收货
- (void)querenshouhuoForSeller {
    AMAlertView *alert = [AMAlertView shareInstanceWithTitle:@"是否确认收货?" buttonArray:@[@"是",@"否"] confirm:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableDictionary *params = [NSMutableDictionary new];
            
            params[@"order_id"] = [ToolUtil isEqualToNonNullKong:_orderModel.ID];
            params[@"type"] = @"2";
            
            [ApiUtil postWithParent:self url:[ApiUtilHeader confirmReceiptForSeller] params:params.copy success:^(NSInteger code, id  _Nullable response) {
                [SVProgressHUD showSuccess:@"确认收货成功" completion:^{
                    [self loadData:nil];
                }];
            } fail:nil];
        });
    } cancel:nil];
    [alert show];
}

- (void)clickToRefund:(id)sender {
	NSLog(@"申请退货");
	ApplyRefundViewController *refundVC = [[ApplyRefundViewController alloc] init];
	refundVC.orderModel = _orderModel;
	refundVC.type = 0;
	refundVC.bottomClick1Block = ^{
		[self loadData:nil];
	};
	[self.navigationController pushViewController:refundVC animated:YES];
}

- (void)clickToShowRefundDetail:(id)sender {
	NSLog(@"clickToShowRefundDetail");
	RefundDetailViewController *detailVC = [[RefundDetailViewController alloc] init];
	detailVC.orderID = _orderModel.ID;
    detailVC.wayType = _orderModel.wayType;
	detailVC.bottomClickBlock = ^{
		[self loadData:nil];
	};
	[self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark -
- (void)loadData:(id)sender {
//    _orderModel = [MyOrderModel new];
//    _orderModel.state = _orderType;
//    _orderModel.wayType = _wayType;
//    _orderModel.oretapply = _oretapply;
//    _orderModel.is_deliver_goods = _is_deliver_goods;
//
//    [self updateContentUI];
//    return;
	NSString *urlStr = _wayType?[ApiUtilHeader getSellOrderDetail]:[ApiUtilHeader getBuyOrderDetail];
	
	NSMutableDictionary *params = [NSMutableDictionary new];
	
    params[@"uid"] = [UserInfoManager shareManager].uid;
	params[@"order_id"] = [ToolUtil isEqualToNonNullKong:_orderID];
	
    [ApiUtil postWithParent:self url:urlStr params:params.copy success:^(NSInteger code, id  _Nullable response) {
        _orderModel = [MyOrderModel yy_modelWithJSON:[response objectForKey:@"data"]];
        _orderModel.state += 1;
        _orderModel.wayType = _wayType;
        
        [self updateContentUI];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [SVProgressHUD showError:showNetworkError completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

#pragma mark -
- (void)updateContentUI {
	AMButton *navBtn = [AMButton buttonWithType:UIButtonTypeCustom];
//	navBtn.frame = CGRectMake(0, 0, NavBar_Height*2.5, NavBar_Height);
	navBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
	
	[navBtn setTitle:[[self navRightTitle] objectForKey:@"title"] forState:UIControlStateNormal];
	[navBtn setTitleColor:[[self navRightTitle] objectForKey:@"color"] forState:UIControlStateNormal];
//	navBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, ADAptationMargin);
	
	navBtn.titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
	[navBtn.titleLabel sizeToFit];
	
	_navRightBtn = navBtn;
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_navRightBtn];
	
	[self layoutSubviews];
}

- (void)layoutSubviews {
	BOOL needBottom = NO;
    self.confirmButton.enabled = YES;
	switch (_orderModel.state) {
		case MyOrderTypeDaiFuKuan: {
			needBottom = YES;
            [self.timer setFireDate:[NSDate distantPast]];
			if (!_wayType) {
				NSString *priceStr = [NSString stringWithFormat:@"¥ %.2f", [[ToolUtil isEqualToNonNullKong:_orderModel.buyer_amount] floatValue]];
				[self.confirmButton setTitle:[NSString stringWithFormat:@"立即支付 %@",priceStr] forState:UIControlStateNormal];
			}else
				self.confirmButton.enabled = NO;
			
			break;
		}
		case MyOrderTypeYiFuKuan: {
			if (_wayType) {
				needBottom = YES;
				[self.confirmButton setTitle:@"填写物流信息" forState:UIControlStateNormal];
			}
			
			break;
		}
		case MyOrderTypeQueRenShouHuo: {
			if (!_wayType) {
				needBottom = YES;
				[self.confirmButton setTitle:@"确认收货" forState:UIControlStateNormal];
			}else {
				if (_orderModel.oretapply.integerValue == 1) {
					needBottom = YES;
					[self.confirmButton setTitle:@"退货处理" forState:UIControlStateNormal];
                }else if (_orderModel.oretapply.integerValue == 2 ||
                          _orderModel.oretapply.integerValue == 3) {
                    needBottom = YES;
                    [self.confirmButton setTitle:@"退货信息" forState:UIControlStateNormal];
                }
			}
			break;
		}
        case MyOrderTypeTuiHuoZhong: {
            if (_wayType) {
                if (_orderModel.oretapply.integerValue == 1) {
                    needBottom = YES;
                    [self.confirmButton setTitle:@"退货处理" forState:UIControlStateNormal];
                }else if (_orderModel.oretapply.integerValue == 2 ||
                          _orderModel.oretapply.integerValue == 3) {
                    needBottom = YES;
                    [self.confirmButton setTitle:@"退货信息" forState:UIControlStateNormal];
                }
            }else {
                if (_orderModel.is_deliver_goods.integerValue != 1) {/// 未寄出
                    needBottom = YES;
                    [self.confirmButton setTitle:@"确认收货" forState:UIControlStateNormal];
                }
            }
            break;
        }
			
		default:
			break;
	}
    [self confirmBtnNeedHidden:!needBottom];
    
    [self _titleArray];
    
	[self.tableView reloadData];
}

- (void)confirmBtnNeedHidden:(BOOL)hidden {
    self.confirmButton.hidden = hidden;
    self.confirmBtnBottomConstraint.constant = hidden?(-(60.0f + SafeAreaBottomHeight)):10.0f;
    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, hidden?SafeAreaBottomHeight:0.0f, 0.0f);
}

- (NSDictionary *)navRightTitle {
	NSString *title = @"";
	UIColor *textColor = Color_Black;
	switch (_orderModel.state) {
		case MyOrderTypeDaiFuKuan: {///待支付/等待买家付款
			title = _wayType?@"等待买家付款":@"待付款";
			textColor = Color_Red;
			break;
		}
		case MyOrderTypeYiFuKuan: {
			title = @"待发货";
			textColor = Color_Red;
			break;
		}
		case MyOrderTypeQueRenShouHuo: {
			title = @"待收货";
			textColor = Color_Red;
            if (_orderModel.oretapply.integerValue == 2) {
                if (!_orderModel.is_deliver_goods.boolValue) {
                    title = @"待退货";
                }
            }
			break;
		}
		case MyOrderTypeSuccess: {
			title = @"已完成";
			textColor = _wayType?Color_Black:Color_Red;
			break;
		}
		case MyOrderTypeTuiHuoZhong: {
            title = _wayType?@"待收货":@"退货中";
			textColor = Color_Red;
			break;
		}
		case MyOrderTypeTuiHuoWanCheng: {
            if (_wayType) {
                title = @"退款中";
            }else
                title = @"待退款";
			textColor = Color_Red;
			break;
		}
		case MyOrderTypeYiTuiKuan: {
			title = @"已退货退款";
			textColor = Color_Black;
			break;
		}
        case MyOrderTypeCancel: {
            title = @"订单已取消";
            textColor = Color_Black;
            break;
        }
		default:
			break;
	}
	return @{@"title":title, @"color":textColor};
}

- (void)_titleArray {
    if (_titleArray.count) [_titleArray removeAllObjects];
    if (_orderModel.wayType) {
        switch (_orderModel.state) {
            case MyOrderTypeDaiFuKuan: {/// 等待买家付款
                [_titleArray addObjectsFromArray:@[
                             @[@"", NSStringFromClass([OrderGoodsIntroCell class])],
                             @[@"支付信息", @"支付用户", @"应付金额（不含运费）", @"支付状态", @"运费"],
                             @[@"", @"订单编号", @"创建时间"]]];
                break;
            }
            case MyOrderTypeYiFuKuan: {/// 待发货
                [_titleArray addObjectsFromArray:@[
                             @[@"", NSStringFromClass([OrderGoodsIntroCell class])],
                             @[@"买家信息", @"收货人", @"联系电话", @"收货地址"],
                             @[@"收款信息", @"买家实付金额（不含运费）", @"支付状态", @"运费"],
                             @[@"", @"订单编号", @"创建时间", @"付款时间"]]];
                break;
            }
            case MyOrderTypeTuiHuoZhong:
            case MyOrderTypeTuiHuoWanCheng:
            case MyOrderTypeQueRenShouHuo: {/// 等待买家收货
                [_titleArray addObjectsFromArray:@[
                             @[@"", NSStringFromClass([OrderGoodsIntroCell class])],
                             @[@"买家信息", @"收货人", @"联系电话", @"收货地址"],
                             @[@"收款信息", @"买家实付金额（不含运费）", @"支付状态", @"运费"],
                             @[@"物流信息", @"物流公司" ,@"物流单号"],
                             @[@"", @"订单编号", @"创建时间", @"付款时间", @"发货时间"]]];
                break;
            }
            case MyOrderTypeSuccess: {/// 交易完成
                [_titleArray addObjectsFromArray:@[
                             @[@"", NSStringFromClass([OrderGoodsIntroCell class])],
                             @[@"买家信息", @"收货人", @"联系电话", @"收货地址"],
                             @[@"收款信息", @"买家实付金额（不含运费）", @"支付状态", @"运费"],
                             @[@"物流信息", @"物流公司" ,@"物流单号"],
                             @[@"", @"订单编号", @"创建时间", @"付款时间", @"发货时间", @"收货时间"]]];
                break;
            }
            case MyOrderTypeYiTuiKuan:/// 已退货退款
            {
                [_titleArray addObjectsFromArray:@[
                             @[@"", NSStringFromClass([OrderGoodsIntroCell class])],
                             @[@"买家信息", @"收货人", @"联系电话", @"收货地址"],
                             @[@"收款信息", @"买家实付金额（不含运费）", @"支付状态", @"运费"],
                             @[@"物流信息", @"物流公司" ,@"物流单号"],
                             @[@"", @"订单编号", @"创建时间", @"付款时间", @"发货时间", @"收货时间", @"关闭时间"]]];
                break;
            }
            case MyOrderTypeCancel: { /// 超时取消
                [_titleArray addObjectsFromArray:@[
                             @[@"", NSStringFromClass([OrderGoodsIntroCell class])],
                             @[@"支付信息", @"支付用户", @"应付金额（不含运费）", @"支付状态", @"运费"],
                             @[@"", @"订单编号", @"创建时间", @"取消时间"]]];
                break;
            }
                
            default:
                break;
        }
    }else {
        switch (_orderModel.state) {
            case MyOrderTypeDaiFuKuan: {/// 待付款
                [_titleArray addObjectsFromArray:@[
                             @[@"", NSStringFromClass([UILabel class])],
                             @[@"", NSStringFromClass([OrderAddressSelectCell class])],
                             @[@"", NSStringFromClass([OrderGoodsIntroCell class])],
                             @[@"", @"商品金额", @"运费"],
                             @[@"", @"订单编号", @"创建时间"]]];
                break;
            }
            case MyOrderTypeYiFuKuan: {///待发货
                [_titleArray addObjectsFromArray:@[
                             @[@"", NSStringFromClass([OrderGoodsIntroCell class])],
                             @[@"物流信息", @"收货人", @"联系电话", @"收货地址"],
                             @[@"", @"商品金额", @"运费"],
                             @[@"", @"订单编号", @"创建时间", @"付款时间"]]];
                break;
            }
            case MyOrderTypeTuiHuoWanCheng:/// 退货完成，待退款
            case MyOrderTypeTuiHuoZhong: /// 退货中
            case MyOrderTypeQueRenShouHuo: {///待收货，确认收货
                [_titleArray addObjectsFromArray:@[
                             @[@"", NSStringFromClass([OrderGoodsIntroCell class])],
                             @[@"物流信息", @"收货人", @"联系电话", @"收货地址" ,@"物流公司", @"物流单号"],
                             @[@"", @"商品金额", @"运费"],
                             @[@"", @"订单编号", @"创建时间", @"付款时间", @"发货时间"]]];
                break;
            }
            case MyOrderTypeSuccess: {///交易完成
                [_titleArray addObjectsFromArray:@[
                             @[@"", NSStringFromClass([OrderGoodsIntroCell class])],
                             @[@"物流信息", @"收货人", @"联系电话", @"收货地址" ,@"物流公司", @"物流单号"],
                             @[@"", @"商品金额", @"运费"],
                             @[@"", @"订单编号", @"创建时间", @"付款时间", @"发货时间", @"收货时间"]]];
                break;
            }
            case MyOrderTypeYiTuiKuan:/// 已退货退款
            {
                [_titleArray addObjectsFromArray:@[
                             @[@"", NSStringFromClass([OrderGoodsIntroCell class])],
                             @[@"物流信息", @"收货人", @"联系电话", @"收货地址" ,@"物流公司", @"物流单号"],
                             @[@"", @"商品金额", @"运费"],
                             @[@"", @"订单编号", @"创建时间", @"付款时间", @"发货时间", @"收货时间", @"关闭时间"]]];
                break;
            }
            case MyOrderTypeCancel:  { /// 超时取消
                [_titleArray addObjectsFromArray:@[
                        @[@"", NSStringFromClass([UILabel class])],
                        @[@"", NSStringFromClass([OrderAddressSelectCell class])],
                        @[@"", NSStringFromClass([OrderGoodsIntroCell class])],
                        @[@"", @"商品金额", @"运费"],
                        @[@"", @"订单编号", @"创建时间", @"取消时间"]]];
                break;
            }
                
            default:
                break;
        }
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
