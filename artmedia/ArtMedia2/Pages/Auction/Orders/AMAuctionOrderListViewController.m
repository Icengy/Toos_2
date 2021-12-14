//
//  AMAuctionOrderListViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/11/13.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMAuctionOrderListViewController.h"
#import "AMAuctionOrderDetailViewController.h"
#import "AMPayViewController.h"

#import "AMAuctionShoppingCartTableCell.h"
#import "AMAuctionShoppingCartHeaderTableCell.h"
#import "AMAuctionOrderFooterTableCell.h"

#import "AMAuctionOrderModel.h"
#import "AMPayManager.h"

@interface AMAuctionOrderListViewController () <UITableViewDelegate, UITableViewDataSource, AMAuctionOrderfooterDelegate, AMPayDelegate, AMPayManagerDelagate>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;

@end

@implementation AMAuctionOrderListViewController {
    NSMutableArray <AMAuctionOrderBusinessModel *>*_dataArray;
    AMAuctionOrderBusinessModel *_selectPayModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    
    _dataArray = @[].mutableCopy;
    self.pageIndex = 1;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMAuctionShoppingCartTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMAuctionShoppingCartTableCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMAuctionShoppingCartHeaderTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMAuctionShoppingCartHeaderTableCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMAuctionOrderFooterTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMAuctionOrderFooterTableCell class])];
    
    [self.tableView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
    [self.tableView addRefreshFooterWithTarget:self action:@selector(loadData:)];
    self.tableView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self imageStr:@"icon-hummer-current" titleStr:nil detailStr:@"暂无拍品订单" btnTitleStr:nil action:@selector(loadData:)];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData:nil];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    AMAuctionOrderBusinessModel *orderModel = [_dataArray objectAtIndex:section];
//    if (orderModel.orderStatus == AMAuctionOrderStyleToBePaid || orderModel.orderStatus == AMAuctionOrderStyleDelivered) {
    if (orderModel.orderStatus == AMAuctionOrderStyleToBePaid) {
        return orderModel.lots.count + 2;
    }
    return orderModel.lots.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AMAuctionOrderBusinessModel *orderModel = [[AMAuctionOrderBusinessModel alloc] init];
    if (_dataArray && _dataArray.count) {
        orderModel = [_dataArray objectAtIndex:indexPath.section];
    }
    
    if (indexPath.row) {
        /// 未支付状态
//        if ((orderModel.orderStatus == AMAuctionOrderStyleToBePaid || orderModel.orderStatus == AMAuctionOrderStyleDelivered) &&
//            (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1)) {
        if (orderModel.orderStatus == AMAuctionOrderStyleToBePaid &&
            (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1)) {
            AMAuctionOrderFooterTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMAuctionOrderFooterTableCell class]) forIndexPath:indexPath];
            cell.delegate = self;
            cell.model = orderModel;
            
            return cell;
        }else {
            /// 其他
            AMAuctionShoppingCartTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMAuctionShoppingCartTableCell class]) forIndexPath:indexPath];
            
            [cell fillData:orderModel atIndexPath:indexPath];
            
            cell.hiddenBottomMargin = indexPath.row == 1;
            cell.insets = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0);
            if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
                cell.needCorner = YES;
                cell.rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
                cell.cornerRudis = 8.0f;
            }else {
                cell.needCorner = NO;
            }
            
            return cell;
        }
    }else {
        AMAuctionShoppingCartHeaderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMAuctionShoppingCartHeaderTableCell class]) forIndexPath:indexPath];
        cell.showStatus = YES;
        
        cell.model = orderModel;
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section?CGFLOAT_MIN:20.0f;
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
    if (!_dataArray.count) return;
    
    AMAuctionOrderDetailViewController *detailVC = [[AMAuctionOrderDetailViewController alloc] init];
    detailVC.orderID = [_dataArray objectAtIndex:indexPath.section].auctionGoodOrderId;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - AMAuctionOrderfooterDelegate
- (void)footerCell:(AMAuctionOrderFooterTableCell *)footerCell clickToCancelOrder:(id)sender {
    
}

- (void)footerCell:(AMAuctionOrderFooterTableCell *)footerCell clickToPayOrder:(id)sender {
    _selectPayModel = footerCell.model;
    AMPayViewController *payVC = [[AMPayViewController alloc] init];
    payVC.delegate = self;
    payVC.priceStr = [NSString stringWithFormat:@"%@",[ToolUtil isEqualToNonNull:_selectPayModel.orderPrice replace:@"0"]];
    payVC.payStyle = AMAwakenPayStyleAuction;
    [self.navigationController presentViewController:payVC animated:YES completion:nil];
}

- (void)footerCell:(AMAuctionOrderFooterTableCell *)footerCell clickToConfirmOrder:(id)sender {
    AMAlertView *alert = [AMAlertView shareInstanceWithTitle:@"是否确认收货?" buttonArray:@[@"是",@"否"] confirm:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [ApiUtil getWithParent:self url:[ApiUtilHeader confirmReceiptOfAuctionUserByAuctionGoodOrderId:footerCell.model.auctionGoodOrderId] params:nil success:^(NSInteger code, id  _Nullable response) {
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
        if (_selectPayModel && _selectPayModel.auctionGoodOrderId) {
            switch (payWay) {
                case AMPayWayWX:///微信支付
                    [[AMPayManager shareManager] payCommonWithRelevanceMap:@[_selectPayModel.auctionGoodOrderId] withPayType:5 byChannel:2 delegate:self];
                    break;
                case AMPayWayAlipay:///支付宝支付
                    [[AMPayManager shareManager] payCommonWithRelevanceMap:@[_selectPayModel.auctionGoodOrderId] withPayType:5 byChannel:1 delegate:self];
                    break;
                case AMPayWayOffline: {/// 线下支付
                    [[AMPayManager shareManager] payCommonWithRelevanceMap:@[_selectPayModel.auctionGoodOrderId] withPayType:5 byChannel:4 delegate:self];
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
    if (sender && [sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        self.pageIndex ++;
    }else {
        self.pageIndex = 1;
        if (_dataArray.count) [_dataArray removeAllObjects];
    }
    if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
        [SVProgressHUD show];
    }
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"current"] = StringWithFormat(@(self.pageIndex));
    params[@"size"] = StringWithFormat(@(MaxListCount));
    if (self.style) params[@"orderStatus"] = @(self.style);
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader selectAuctionGoodOrderListByAuctionUseId] needHUD:NO params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [self.tableView endAllFreshing];
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            NSArray *records = (NSArray *)[data objectForKey:@"records"];
            if (records && records.count) {
                [_dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[AMAuctionOrderBusinessModel class] json:records]];
            }
            [self.tableView updataFreshFooter:(_dataArray.count && records.count != MaxListCount)];
        }
        
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
