//
//  WalletItemDetailViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "WalletItemDetailViewController.h"

#import "WalletListDetailHeaderView.h"
#import "WalletListDetailCell.h"

#import "WalletListBaseModel.h"

#import "OrderDetailViewController.h"
#import "AMBaseUserHomepageViewController.h"
#import "AMMeetingDetailViewController.h"
#import "ClassDetailViewController.h"

@interface WalletItemDetailViewController () <UITableViewDelegate ,UITableViewDataSource, WalletListDetailCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

@property (nonatomic ,strong) WalletListDetailHeaderView *headerView;
@end

@implementation WalletItemDetailViewController {
    NSArray *_dataArray;
}

- (WalletListDetailHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WalletListDetailHeaderView class]) owner:nil options:nil].lastObject;
    }return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    
    [self initTitleArray];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = 44.0f;
    self.tableView.sectionFooterHeight = 10.0f;
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WalletListDetailCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WalletListDetailCell class])];
    
    [self.tableView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
    
    if (_detailModel.style < AMWalletItemDetailStyleEstimateSaleValid) {
        [self loadData:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"收入详情";
    if (_detailModel.style == AMWalletItemDetailStyleYBRecharge) {
        self.navigationItem.title = @"艺币消费详情";
    }
    if (_detailModel.style == AMWalletItemDetailStyleYBConsumption ||
        _detailModel.style == AMWalletItemDetailStyleBalanceExpenditure ||
        _detailModel.style == AMWalletItemDetailStyleBalanceRollin ||
        _detailModel.style == AMWalletItemDetailStyleBalanceCashout ||
        _detailModel.style == AMWalletItemDetailStyleBalanceRefund) {
        self.navigationItem.title = @"账单详情";
    }
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WalletListDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WalletListDetailCell class])];
    
    cell.delegate = self;
    cell.showDetailHidden = [self showsDetailHidden:indexPath];
    cell.titleText = _dataArray[indexPath.row];
    cell.detailModel = _detailModel;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 120.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.headerView.detailModel = _detailModel;
    return self.headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//cell即将展示的时候调用
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    self.tableViewHeightConstraint.constant = tableView.contentSize.height;
}

#pragma mark - WalletListDetailCellDelegate
- (void)didClickToDetailBtn:(id)sender {
    if (_detailModel.style == AMWalletItemDetailStyleYBConsumption)  {//艺币-消费
        //查看详情
    }
    
    if (_detailModel.style == AMWalletItemDetailStyleRevenueProfit) {// 收入-收益
        
        // 主页
        WalletRevenueListModel *model = (WalletRevenueListModel *)_detailModel;
        if (![ToolUtil isEqualToNonNull:model.uid]) {
            [SVProgressHUD showError:@"数据错误，请重试或联系客服"];
            return;
        }
        AMBaseUserHomepageViewController * vc = [[AMBaseUserHomepageViewController alloc] init];
        vc.artuid = model.uid;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (_detailModel.style == AMWalletItemDetailStyleRevenueMeetingProfit) {
        WalletRevenueListModel *model = (WalletRevenueListModel *)_detailModel;
        // 查看会客
        if (![ToolUtil isEqualToNonNull:model.tea_info.tea_about_info_id]) {
            [SVProgressHUD showError:@"数据错误，请重试或联系客服"];
            return;
        }
        AMMeetingDetailViewController *meetingDetail = [[AMMeetingDetailViewController alloc] init];
        meetingDetail.meetingid = model.tea_info.tea_about_info_id;
        [self.navigationController pushViewController:meetingDetail animated:YES];
    }
    
    if (_detailModel.style == AMWalletItemDetailStyleRevenueCourseProfit) {
        ///查看直播课详情
        WalletRevenueListModel *model = (WalletRevenueListModel *)_detailModel;
        if (![ToolUtil isEqualToNonNull:model.course_info.course_id]) {
            [SVProgressHUD showError:@"数据错误，请重试或联系客服"];
            return;
        }
        ClassDetailViewController *detailVC = [[ClassDetailViewController alloc] init];
        detailVC.courseId = model.course_info.course_id;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
    if (_detailModel.style == AMWalletItemDetailStyleRevenueSale || //收入-销售
        _detailModel.style == AMWalletItemDetailStyleBalanceRefund || // 余额-退款
        _detailModel.style == AMWalletItemDetailStyleBalanceExpenditure || // 余额-支出
        _detailModel.style == AMWalletItemDetailStyleEstimateSaleValid ||    // 预估销售-有效
        _detailModel.style == AMWalletItemDetailStyleEstimateSaleInvalid)  {// 预估销售-无效
        
        // 查看订单
        NSString *orderID = nil;
        NSInteger orderType = 0;
        if (_detailModel.style == AMWalletItemDetailStyleEstimateSaleValid ||
            _detailModel.style == AMWalletItemDetailStyleEstimateSaleInvalid) { /// 预估销售
            WalletEstimateListModel *model = (WalletEstimateListModel *)_detailModel;
            orderID = model.oid;
            orderType = model.ostate.integerValue;
        }else if (_detailModel.style == AMWalletItemDetailStyleRevenueSale) {/// 收入
            WalletRevenueListModel *model = (WalletRevenueListModel *)_detailModel;
            orderID = model.orderid;
            orderType = model.orderstate.integerValue;
        }
        
        if (![ToolUtil isEqualToNonNull:orderID]) {
            [SVProgressHUD showError:@"数据错误，请重试或联系客服"];
            return;
        }
        
        OrderDetailViewController *orderDetail = [[OrderDetailViewController alloc] init];
        orderDetail.wayType = MyOrderWayTypeSalled;
        orderDetail.orderID = orderID;
//        orderDetail.orderType = orderType;
        
        [self.navigationController pushViewController:orderDetail animated:YES];
    }
}

#pragma mark -
- (void)initTitleArray {
    if (_detailModel.style == AMWalletItemDetailStyleYBRecharge) {//艺币-充值
        _dataArray = @[@"花费金额：", @"账单编号：", @"账单时间："];
    }
    if (_detailModel.style == AMWalletItemDetailStyleYBConsumption) {//艺币-消费
        _dataArray = @[@"账单时间：", @"账单编号：", @"账单时间：", @"账单备注："];
    }
    
    if (_detailModel.style == AMWalletItemDetailStyleRevenueProfit) {// 收入-收益
        _dataArray = @[@"用户名称：", @"收入编号：", @"收入时间："];
    }
    if (_detailModel.style == AMWalletItemDetailStyleRevenueCashout) {// 收入-提现
        _dataArray = @[@"收入编号：", @"账单时间：", @"提现用户："];
    }
    if (_detailModel.style == AMWalletItemDetailStyleRevenueSale) { /// 收入-销售
        _dataArray = @[@"商品名称：", @"收入编号：", @"收入时间："];
    }
    if (_detailModel.style == AMWalletItemDetailStyleRevenueMeetingProfit) {/// 收入-会客收益
        _dataArray = @[@"会客时间：", @"订单编号：", @"收入时间："];
    }
    if (_detailModel.style == AMWalletItemDetailStyleRevenueCourseProfit ||
        _detailModel.style == AMWalletItemDetailStyleEstimateProfitValid) {
        /// 收入-直播课收益
        _dataArray = @[@"课程名称", @"购买人", @"支付艺币", @"订单编号", @"购买时间", @"收入时间"];
    }
    if (_detailModel.style == AMWalletItemDetailStyleEstimateSaleValid || /// 预估销售-有效
        _detailModel.style == AMWalletItemDetailStyleEstimateSaleInvalid) { /// 预估销售-无效
         _dataArray = @[@"商品名称：", @"订单编号：", @"支付时间："];
    }
    
    if (_detailModel.style == AMWalletItemDetailStyleBalanceRollin) {// 余额-转入
        _dataArray = @[@"账单编号：", @"账单时间：", @"账单备注："];
    }
    if (_detailModel.style == AMWalletItemDetailStyleBalanceCashout) {// 余额-提现
        _dataArray = @[@"账单编号：", @"账单时间：", @"提现账户：", @"账单备注："];
    }
    if (_detailModel.style == AMWalletItemDetailStyleBalanceRefund || // 余额-退款
        _detailModel.style == AMWalletItemDetailStyleBalanceExpenditure) {// 余额-支出
        _dataArray = @[@"商品名称：", @"账单编号：", @"账单时间：", @"账单备注："];
    }
}

- (BOOL)showsDetailHidden:(NSIndexPath *)indexPath {
    if (_detailModel.style == AMWalletItemDetailStyleYBRecharge && indexPath.row == 0) return NO;
    if (_detailModel.style == AMWalletItemDetailStyleRevenueCashout && indexPath.row == 0) return YES;
    if (indexPath.row == 0) return NO;
    return YES;
}

#pragma mark -
- (void)loadData:(id)sender {
    if (!(sender && [sender isKindOfClass:[MJRefreshNormalHeader class]])) {
        [SVProgressHUD show];
    }
    
    NSString *urlString = nil;
    NSMutableDictionary *params = [NSMutableDictionary new];

    switch (_detailModel.style) {
        case AMWalletItemDetailStyleYBRecharge:     /// 艺币-充值
        case AMWalletItemDetailStyleYBConsumption: {    /// 艺币-消费
            
            break;
        }
        case AMWalletItemDetailStyleRevenueSale:     /// 收入-销售
        case AMWalletItemDetailStyleRevenueProfit:     /// 收入-收益
        case AMWalletItemDetailStyleRevenueCashout: /// 收入-提现
        case AMWalletItemDetailStyleRevenueMeetingProfit:  /// 收入-会客
        case AMWalletItemDetailStyleRevenueCourseProfit: {    /// 收入-直播课
            
            urlString = [ApiUtilHeader getIncomeDetails];
            params[@"id"] = [ToolUtil isEqualToNonNullKong:_detailModel.id];
            break;
        }
        case AMWalletItemDetailStyleBalanceExpenditure:     /// 余额-支出
        case AMWalletItemDetailStyleBalanceRollin:     /// 余额-转入
        case AMWalletItemDetailStyleBalanceCashout:     /// 余额-提现
        case AMWalletItemDetailStyleBalanceRefund: {    /// 余额-退款
            
            break;
        }
        
        default:
            break;
    }
    
    params[@"uid"] = [UserInfoManager shareManager].uid;
    
    if ([ToolUtil isEqualToNonNull:urlString]) {
        [self loadVideoListData:urlString params:params sender:sender];
    }
}

- (void)loadVideoListData:(NSString *)urlString params:(NSDictionary *)params sender:(id)sender {
    self.tableView.allowsSelection = NO;
    [ApiUtil postWithParent:self url:urlString params:params success:^(NSInteger code, id  _Nullable response) {
        [self.tableView endAllFreshing];
        NSDictionary *newDict = (NSDictionary *)[response objectForKey:@"data"];
        if (newDict && newDict.count) {
            _detailModel = [self distinguishModelStyle:newDict];
        }
        [self.tableView reloadData];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [self.tableView endAllFreshing];
        [SVProgressHUD showError:errorMsg completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

- (WalletListBaseModel *)distinguishModelStyle:(NSDictionary *)modelDict {
    switch (_detailModel.style) {
        case AMWalletItemDetailStyleYBRecharge:     /// 艺币-充值
        case AMWalletItemDetailStyleYBConsumption: {    /// 艺币-消费
            
            WalletYBListModel *yibModel = [WalletYBListModel yy_modelWithDictionary:modelDict];
            yibModel.style = _detailModel.style;
            return yibModel;
            break;
        }
        case AMWalletItemDetailStyleRevenueSale:     /// 收入-销售
        case AMWalletItemDetailStyleRevenueProfit:     /// 收入-收益
        case AMWalletItemDetailStyleRevenueCashout:  /// 收入-提现
        case AMWalletItemDetailStyleRevenueMeetingProfit: /// 收入-茶会收益
        case AMWalletItemDetailStyleRevenueCourseProfit: {/// 收入-直播课收益
            
            WalletRevenueListModel *revenueModel = [WalletRevenueListModel yy_modelWithDictionary:modelDict];
            revenueModel.style = _detailModel.style;
            return revenueModel;
            break;
        }
        case AMWalletItemDetailStyleBalanceExpenditure:     /// 余额-支出
        case AMWalletItemDetailStyleBalanceRollin:     /// 余额-转入
        case AMWalletItemDetailStyleBalanceCashout:     /// 余额-提现
        case AMWalletItemDetailStyleBalanceRefund: {    /// 余额-退款
            
            WalletBalanceListModel *balanceModel = [WalletBalanceListModel yy_modelWithDictionary:modelDict];
            balanceModel.style = _detailModel.style;
            return balanceModel;
            break;
        }
        default:
            break;
    }
    return _detailModel;
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
