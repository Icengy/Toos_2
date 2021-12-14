//
//  MyOrderListViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/23.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "MyOrderListViewController.h"

#import "AMEmptyView.h"
#import "MyOrderTableViewCell.h"

#import "MyOrderModel.h"

#import "OrderDetailViewController.h"
#import "ReceivableListViewController.h"
#import "FillLogisticsViewController.h"
#import "RefundDetailViewController.h"

#import "AMPayViewController.h"

@interface MyOrderListViewController () <UITableViewDelegate, UITableViewDataSource, MyOrderCellDelegate, AMPayDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSTimer *timer;

@property(nonatomic,strong)NSMutableArray <MyOrderModel *>*dataArray;
@end

@implementation MyOrderListViewController
{
	int _page;
    MyOrderModel *_selectedOrderModel;
}

- (NSTimer *)timer  {
	if (!_timer) {
		_timer=[NSTimer timerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
		[[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
		[_timer setFireDate:[NSDate distantFuture]];
	}return _timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	_dataArray = [NSMutableArray arrayWithCapacity:0];
	
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
	self.tableView.rowHeight = UITableViewAutomaticDimension;

	[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyOrderTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MyOrderTableViewCell class])];
	
	[self.tableView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
	[self.tableView addRefreshFooterWithTarget:self action:@selector(loadData:)];
    self.tableView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadData:)];
	
	if (@available(iOS 11.0, *)) {
		self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWXPayResult:) name:WXPaymentResultForOrderList object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAliPayResult:) name:AliPaymentResultForNormal object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self loadData:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WXPaymentResultForOrderList object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AliPaymentResultForNormal object:nil];
    
	if (self.timer) {
		[self.timer invalidate];
		self.timer = nil;
	}
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return ADAptationMargin/2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyOrderTableViewCell class]) forIndexPath:indexPath];
    cell.delegate = self;
	if (_dataArray.count) cell.orderModel = _dataArray[indexPath.section];
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	

    MyOrderTableViewCell *cell = (MyOrderTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
	OrderDetailViewController *detailVC = [[OrderDetailViewController alloc] init];
	
	detailVC.orderID = cell.orderModel.ID;
    detailVC.wayType = cell.orderModel.wayType;
//    detailVC.orderType = model.state;
//    detailVC.oretapply = model.oretapply;
//    detailVC.is_deliver_goods = model.is_deliver_goods;
	
	[self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - MyOrderCellDelegate
- (void)orderCell:(MyOrderTableViewCell *)orderCell didClickToOpeation:(MyOrderModel *)orderModel {
    
    if (orderModel.wayType) {/// 卖家
        switch (orderModel.state) {
            case MyOrderTypeYiFuKuan: {/// 卖家填写发货物流
                [self fillLogistics:orderModel logType:0];
                break;
            }
            case MyOrderTypeTuiHuoZhong:
            case MyOrderTypeQueRenShouHuo: {
                if (orderModel.oretapply.integerValue == 2 && orderModel.is_deliver_goods.boolValue) {/// 卖家确认收货
                    [self querenshouhuoForSeller:orderModel];
                }else { /// 卖家退货处理
                    [self tuihuochuli:orderModel];
                }
                break;
            }
//            case MyOrderTypeTuiHuoZhong: {/// 退货中，卖家确认收货
//                [self querenshouhuoForSeller:orderModel];
//                break;
//            }
                
            default:
                break;
        }
    }else {/// 买家
        switch (orderModel.state) {
            case MyOrderTypeDaiFuKuan:/// 支付
                [self zhifuForBuyer:orderModel];
                break;
            case MyOrderTypeTuiHuoZhong:
            case MyOrderTypeQueRenShouHuo: /// 确认收货/处理退货
            {
                if (orderModel.oretapply.integerValue == 2) { /// 买家填写退货物流
                    [self tuihuochuli:orderModel];
                }else {
                    [self querenshouhuoForBuyer:orderModel];
                }
                break;
            }
//            case MyOrderTypeTuiHuoZhong: { /// 退货中，买家填写退货物流
//                [self tuihuochuli:orderModel];
//                break;
//            }
                
            default:
                break;
        }
    }
}

- (void)orderCell:(MyOrderTableViewCell *)orderCell didClickToQueRenShouHuo:(MyOrderModel *)orderModel {
    [self querenshouhuoForBuyer:orderModel];
}

/// 买家支付
- (void)zhifuForBuyer:(MyOrderModel *)orderModel {
    _selectedOrderModel = orderModel;
    
    AMPayViewController *payVC = [[AMPayViewController alloc] init];
    payVC.delegate = self;
    payVC.priceStr = orderModel.buyer_amount;
    payVC.payStyle = AMAwakenPayStyleDefalut;
    
    [self.navigationController presentViewController:payVC animated:YES completion:nil];
}

/// 买家确认收货
- (void)querenshouhuoForBuyer:(MyOrderModel *)orderModel {
    AMAlertView *alert = [AMAlertView shareInstanceWithTitle:@"确认收货后无法申请退货服务。\n是否确认收货?" buttonArray:@[@"是",@"否"] confirm:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableDictionary *params = [NSMutableDictionary new];
            
            params[@"order_id"] = [ToolUtil isEqualToNonNullKong:orderModel.ID];
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
- (void)querenshouhuoForSeller:(MyOrderModel *)orderModel {
    AMAlertView *alert = [AMAlertView shareInstanceWithTitle:@"是否确认收货?" buttonArray:@[@"是",@"否"] confirm:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableDictionary *params = [NSMutableDictionary new];
            
            params[@"order_id"] = [ToolUtil isEqualToNonNullKong:orderModel.ID];
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

/// 填写发货/退货订单
- (void)fillLogistics:(MyOrderModel *)orderModel logType:(NSInteger)logType {
    OrderDetailViewController *detailVC = [[OrderDetailViewController alloc] init];
        
    detailVC.orderID = orderModel.ID;
    detailVC.wayType = orderModel.wayType;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

/// 卖家退货处理
- (void)tuihuochuli:(MyOrderModel *)orderModel {
    RefundDetailViewController *detailVC = [[RefundDetailViewController alloc] init];
    detailVC.orderID = orderModel.ID;
    detailVC.wayType = _wayType;
    @weakify(self);
    detailVC.bottomClickBlock = ^{
        @strongify(self);
        [self loadData:nil];
    };
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - AMPayDelegate
- (void)payViewController:(BaseViewController *)payViewController didSelectPayForWay:(AMPayWay)payWay {
    [payViewController dismissViewControllerAnimated:YES completion:^{
        switch (payWay) {
            case AMPayWayApple:///苹果支付
                
                break;
            case AMPayWayWX:///微信支付
                [[WechatManager shareManager] payOrderWithType:@"3" withOrderID:_selectedOrderModel.ID];
                break;
            case AMPayWayAlipay:///支付宝支付
                [[AlipayManager shareManager] payOrderWithType:@"3" withOrderID:_selectedOrderModel.ID];
                break;
                
            default:
                break;
        }
    }];
}

#pragma mark -
- (void)showWXPayResult:(NSNotification *)noti {
	BOOL isSuccess = [noti.object boolValue];
	AMAlertView *alertView = [AMAlertView shareInstanceWithTitle:isSuccess?@"支付成功":@"支付失败" buttonArray:@[@"知道了"] confirm:^{
        if (isSuccess) [self loadData:nil];
	} cancel:nil];
	[alertView show];
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

-(void)countDown {
	NSArray <MyOrderTableViewCell *>*array = self.tableView.visibleCells;
	[array enumerateObjectsUsingBlock:^(MyOrderTableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if (obj.orderModel.state == MyOrderTypeDaiFuKuan) {
			[TimeTool compareCurrentDateTimeWithTime:[[ToolUtil isEqualToNonNull:obj.orderModel.addtime replace:@"0"] integerValue] block:^(BOOL isFinish, NSString * _Nullable compareStr) {
				dispatch_async(dispatch_get_main_queue(), ^{
					NSString *stateStr = nil;
					if (isFinish) {
                        if (obj.orderModel.wayType) {
                            stateStr = [NSString stringWithFormat:@"%@后自动关闭订单",compareStr];
                            [obj updateOrderState:stateStr stateColor:Color_Red orderOperation:nil operationColor:nil descText:@"等待买家付款"];
                        }else {
                            stateStr = [NSString stringWithFormat:@"%@后自动取消订单",compareStr];
                            [obj updateOrderState:stateStr stateColor:Color_Red orderOperation:@"去支付" operationColor:Color_Red descText:nil];
                        }
					}else {
                        [self.timer setFireDate:[NSDate distantFuture]];
						stateStr = @"订单已取消";
                        [obj updateOrderState:stateStr stateColor:Color_Black orderOperation:nil operationColor:nil descText:obj.orderModel.wayType?@"买家付款超时":nil];
					}
				});
			}];
		}
	}];
}

#pragma mark -
- (void)loadData:(id __nullable)sender {
    
    self.tableView.allowsSelection = NO;
	if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
		[SVProgressHUD show];
	}
	if(sender && [sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
		_page ++;
	}else {
		_page = 0;
        if (_dataArray.count) [_dataArray removeAllObjects];
	}
	
	NSString *urlStr = _wayType?[ApiUtilHeader getSellOrderList]:[ApiUtilHeader getBuyOrderList];
	
	NSMutableDictionary*params = [NSMutableDictionary new];
	
    params[@"uid"] = [UserInfoManager shareManager].uid;
	params[@"page"] = StringWithFormat(@(_page));
	params[@"type"] = StringWithFormat(@(_itemType));
	
    [ApiUtil postWithParent:self url:urlStr needHUD:NO params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [self.tableView endAllFreshing];
        NSArray*array = (NSArray *)[response objectForKey:@"data"];
        if (array && array.count) {
            NSMutableArray <MyOrderModel *>*newArray = [NSArray yy_modelArrayWithClass:[MyOrderModel class] json:array].mutableCopy;
            if (newArray.count) {
                [newArray enumerateObjectsUsingBlock:^(MyOrderModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.state += 1;
                    obj.wayType = _wayType;
                    [newArray replaceObjectAtIndex:idx withObject:obj];
                }];
            }
            [_dataArray addObjectsFromArray:newArray];
            [_dataArray enumerateObjectsUsingBlock:^(MyOrderModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.state == MyOrderTypeDaiFuKuan) {
                    [self.timer setFireDate:[NSDate distantPast]];
                    *stop = YES;
                }
            }];
        }
        
        [self.tableView updataFreshFooter:(_dataArray.count && array.count != MaxListCount)];
        [self.tableView ly_updataEmptyView:!_dataArray.count];
        self.tableView.mj_footer.hidden = !_dataArray.count;
        [self.tableView reloadData];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [SVProgressHUD showError:errorMsg];
        [self.tableView endAllFreshing];
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
