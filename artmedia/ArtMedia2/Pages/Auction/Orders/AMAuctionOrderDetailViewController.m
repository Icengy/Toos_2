//
//  AMAuctionOrderDetailViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/11/13.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMAuctionOrderDetailViewController.h"
#import "AMPayViewController.h"
#import "AuctionItemDetailViewController.h"

#import "AMAuctionShoppingCartTableCell.h"
#import "AMAuctionShoppingCartHeaderTableCell.h"
#import "AMAuctionOrderLogisticsTableCell.h"
#import "AMAuctionOrderInfoTableCell.h"

#import "AMAuctionOrderModel.h"

@interface AMAuctionOrderDetailViewController () <UITableViewDelegate, UITableViewDataSource, AMPayDelegate, AMPayManagerDelagate>

@property (weak, nonatomic) IBOutlet UIView *naviView;

@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UIImageView *statusIconIV;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusTipsLabel;

@property (weak, nonatomic) IBOutlet BaseTableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *botttomView;
@property (weak, nonatomic) IBOutlet UIStackView *bottomStackView;
@property (weak, nonatomic) IBOutlet AMButton *cancelBtn;
@property (weak, nonatomic) IBOutlet AMButton *payBtn;
@property (weak, nonatomic) IBOutlet AMButton *refundBtn;
@property (weak, nonatomic) IBOutlet AMButton *confirmBtn;

@property (nonatomic ,strong) AMAuctionOrderModel *orderModel;

@end

@implementation AMAuctionOrderDetailViewController {
    CGFloat _stateAlpha;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    self.naviView.backgroundColor = [Color_Whiter colorWithAlphaComponent:1.0];
    
    _stateAlpha = 0.0;
    self.tableView.backgroundColor = RGBA(247.0, 247.0, 247.0, _stateAlpha);
    self.naviView.alpha = _stateAlpha;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMAuctionShoppingCartTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMAuctionShoppingCartTableCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMAuctionShoppingCartHeaderTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMAuctionShoppingCartHeaderTableCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMAuctionOrderLogisticsTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMAuctionOrderLogisticsTableCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMAuctionOrderInfoTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMAuctionOrderInfoTableCell class])];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.tableView.backgroundColor = RGBA(247.0, 247.0, 247.0, _stateAlpha);
    self.naviView.alpha = _stateAlpha;
    
    [self loadData:nil];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.orderModel.orderStatus == 0) return 0;
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 && self.orderModel.orderStatus > AMAuctionOrderStyleToBeDelivered)
        return 2;
    if (section == 1)
        return self.orderModel.lotModel.lots.count + 1;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row) {
            /// 物流cell
            AMAuctionOrderLogisticsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMAuctionOrderLogisticsTableCell class]) forIndexPath:indexPath];
            cell.needCorner = YES;
            cell.rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
            cell.cornerRudis = 8.0f;
            cell.insets = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0);
            
            cell.style = AMAuctionOrderLogisticsStyleDefault;
            cell.addressModel = self.orderModel.logisticsInfo;
            
            return cell;
        }
        /// 地址cell
        AMAuctionOrderLogisticsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMAuctionOrderLogisticsTableCell class]) forIndexPath:indexPath];
        cell.insets = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0);
        cell.needCorner = YES;
        cell.cornerRudis = 8.0f;
        if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
            cell.rectCorner = UIRectCornerAllCorners;
        }else
            cell.rectCorner = UIRectCornerTopRight | UIRectCornerTopLeft;
        
        cell.style = AMAuctionOrderLogisticsStyleAddress;
        cell.addressModel = self.orderModel.logisticsInfo;
        
        return cell;
    }else if (indexPath.section == ([tableView numberOfSections] -1)) {
        AMAuctionOrderInfoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMAuctionOrderInfoTableCell class]) forIndexPath:indexPath];
        cell.model = self.orderModel;
        
        return cell;
    }else {
        if (indexPath.row) {
            AMAuctionShoppingCartTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMAuctionShoppingCartTableCell class]) forIndexPath:indexPath];
            
            cell.model = [self.orderModel.lotModel.lots objectAtIndex:(indexPath.row - 1)];
            
            cell.hiddenBottomMargin = indexPath.row == 1;
            cell.insets = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0);
            if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
                cell.needCorner = YES;
                cell.rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
                cell.cornerRudis = 8.0f;
            }else
                cell.needCorner = NO;
            
            return cell;
        }else {
            AMAuctionShoppingCartHeaderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMAuctionShoppingCartHeaderTableCell class]) forIndexPath:indexPath];
            cell.model = self.orderModel.lotModel;
            
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id cell = [tableView cellForRowAtIndexPath:indexPath];
    if (![cell isKindOfClass:[AMAuctionShoppingCartTableCell class]]) return;
    AMAuctionShoppingCartTableCell *cartCell = (AMAuctionShoppingCartTableCell *)cell;
    AuctionItemDetailViewController *detailVC = [[AuctionItemDetailViewController alloc] init];
    detailVC.auctionGoodId = cartCell.model.auctionGoodId;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    _stateAlpha = (offsetY + self.statusView.maxY) / (self.statusView.height - self.statusIconIV.y);
    if (_stateAlpha < 0.0) {
        _stateAlpha = 0.0;
    }else if (_stateAlpha > 1.0) {
        _stateAlpha = 1.0;
    }
    self.tableView.backgroundColor = RGBA(247.0, 247.0, 247.0, _stateAlpha);
    self.naviView.alpha = _stateAlpha;
}

#pragma mark -
- (IBAction)clickToBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/// 付款
- (IBAction)clickToPay:(id)sender {
    AMPayViewController *payVC = [[AMPayViewController alloc] init];
    payVC.delegate = self;
    payVC.priceStr = [NSString stringWithFormat:@"%@",[ToolUtil isEqualToNonNull:self.orderModel.orderPrice replace:@"0"]];
    payVC.payStyle = AMAwakenPayStyleAuction;
    [self.navigationController presentViewController:payVC animated:YES completion:nil];
}
/// 取消订单
- (IBAction)clickToCancel:(id)sender {
    
}
/// 退款
- (IBAction)clickToRefund:(id)sender {
    
}
/// 确认收货
- (IBAction)clickToComfirm:(id)sender {
    AMAlertView *alert = [AMAlertView shareInstanceWithTitle:@"是否确认收货?" buttonArray:@[@"是",@"否"] confirm:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [ApiUtil getWithParent:self url:[ApiUtilHeader confirmReceiptOfAuctionUserByAuctionGoodOrderId:self.orderModel.auctionGoodOrderId] params:nil success:^(NSInteger code, id  _Nullable response) {
                [SVProgressHUD showSuccess:@"确认收货成功!" completion:^{
                    [self loadData:nil];
                }];
            } fail:nil];
        });
    } cancel:nil];
    [alert show];
}


#pragma mark -
- (void)payViewController:(BaseViewController *)payViewController didSelectPayForWay:(AMPayWay)payWay {
    @weakify(self);
    [payViewController dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        if (self.orderModel && self.orderModel.auctionGoodOrderId) {
            switch (payWay) {
                case AMPayWayWX:///微信支付
                    [[AMPayManager shareManager] payCommonWithRelevanceMap:@[self.orderModel.auctionGoodOrderId] withPayType:5 byChannel:2 delegate:self];
                    break;
                case AMPayWayAlipay:///支付宝支付
                    [[AMPayManager shareManager] payCommonWithRelevanceMap:@[self.orderModel.auctionGoodOrderId] withPayType:5 byChannel:1 delegate:self];
                    break;
                case AMPayWayOffline: {/// 线下支付
                    [[AMPayManager shareManager] payCommonWithRelevanceMap:@[self.orderModel.auctionGoodOrderId] withPayType:5 byChannel:4 delegate:self];
                    break;
                }
                default:
                    break;
            }
        }else
            [SVProgressHUD showError:@"下单失败，请重试或联系客服"];
    }];
}

#pragma mark - AMPayManagerDelagate
- (void)getAlipayPayResult:(BOOL)isSuccess {
    if (isSuccess) [self loadData:nil];
}

- (void)getWXPayResult:(BOOL)isSuccess {
    if (isSuccess) [self loadData:nil];
}

- (void)getOfflinePayResult:(BOOL)isSuccess offlineTradeNo:(NSString *)offlineTradeNo {
    if (isSuccess) [self loadData:nil];
}

#pragma mark -
- (void)loadData:(id)sender {
    self.tableView.allowsSelection = NO;
    if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
        [SVProgressHUD show];
    }
    [ApiUtil getWithParent:self url:[ApiUtilHeader selectAuctionGoodOrderDetailOfAuctionUserById:self.orderID] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response) {
        [self.tableView endAllFreshing];
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            self.orderModel = [AMAuctionOrderModel yy_modelWithDictionary:data];
        }
        [self.tableView reloadData];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [self.tableView endAllFreshing];
        @weakify(self);
        [SVProgressHUD showError:errorMsg completion:^{
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

- (void)setOrderModel:(AMAuctionOrderModel *)orderModel {
    _orderModel = orderModel;
    
    self.statusView.hidden = NO;
    self.botttomView.hidden = YES;
    switch (_orderModel.orderStatus) {
        case AMAuctionOrderStyleToBePaid: {/// 待支付
            
            self.botttomView.hidden = NO;
            self.cancelBtn.hidden = YES;
            self.payBtn.hidden = NO;
            self.refundBtn.hidden = YES;
            self.confirmBtn.hidden = YES;
            
            self.statusLabel.text = @"等待支付";
            self.statusTipsLabel.text = @"请买家尽快付款后才可发货，超时后订单自动关闭";
            
            break;
        }
        case AMAuctionOrderStyleToBeDelivered: {/// 待发货
            
            self.statusLabel.text = @"等待发货";
            self.statusTipsLabel.text = @"卖家已在积极准备出库中，请耐心等待";
            
            break;
        }
        case AMAuctionOrderStyleDelivered: {/// 已发货
            
            self.botttomView.hidden = NO;
            self.cancelBtn.hidden = YES;
            self.payBtn.hidden = YES;
            self.refundBtn.hidden = YES;
            self.confirmBtn.hidden = NO;
            
            self.statusLabel.text = @"已发货";
            self.statusTipsLabel.text = @"您的宝贝已发出，快递正向你飞奔而来";
            
            break;
        }
        case AMAuctionOrderStyleReceived: {/// 已收货
            
            self.statusLabel.text = @"已收货";
            self.statusTipsLabel.text = @"您的宝贝已签收";
            
            break;
        }
        case AMAuctionOrderStyleSuccess: {/// 交易成功
            
            self.statusLabel.text = @"交易成功";
            self.statusTipsLabel.text = nil;
            
            break;
        }
        case AMAuctionOrderStyleClose: {/// 交易关闭
            
            self.statusLabel.text = @"交易关闭";
            self.statusTipsLabel.text = @"订单超时关闭";
            
            break;
        }
            
        default: {
            self.statusView.hidden = YES;
            self.statusLabel.text = nil;
            self.statusTipsLabel.text = nil;
            break;
        }
    }
    if (self.botttomView.hidden) {
        [self.bottomStackView.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = YES;
        }];
    }
    NSString *iconStr = [NSString stringWithFormat:@"icon-orderDet-by-%@", @(_orderModel.orderStatus)];
    self.statusIconIV.image = ImageNamed(iconStr);
    
    self.statusTipsLabel.hidden = ![ToolUtil isEqualToNonNull:self.statusTipsLabel.text];
    
    self.tableView.contentInset = UIEdgeInsetsMake(self.statusView.hidden?0.0:self.statusView.maxY, 0.0, 0.0, 0.0);
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
