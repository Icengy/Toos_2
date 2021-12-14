//
//  WalletClassifiedItemViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/11.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "WalletClassifiedItemViewController.h"

#import "WalletDetailedListItemTableCell.h"
#import "WalletItemDetailViewController.h"

#import "AMEmptyView.h"

#import "WalletListBaseModel.h"

@interface WalletClassifiedItemViewController () <UITableViewDelegate,
                UITableViewDataSource>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@end

@implementation WalletClassifiedItemViewController {
    NSInteger _page;
    NSMutableArray <WalletListBaseModel *>*_dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    
    _dataArray = @[].mutableCopy;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 80.0f;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, SafeAreaBottomHeight, 0);
    
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WalletDetailedListItemTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WalletDetailedListItemTableCell class])];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self.tableView addRefreshFooterWithTarget:self action:@selector(loadData:)];
    self.tableView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadData:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadData:nil];
}

- (UIScrollView *)scrollView {
    return self.tableView;
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WalletDetailedListItemTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WalletDetailedListItemTableCell class])];
    
    cell.detailModel = _dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WalletDetailedListItemTableCell *cell = (WalletDetailedListItemTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.detailModel.style >= AMWalletItemDetailStyleEstimateSaleValid && cell.accessoryType == UITableViewCellAccessoryNone) return;
    
    WalletItemDetailViewController *detailView = [[WalletItemDetailViewController alloc] init];
    detailView.detailModel = _dataArray[indexPath.row];
    [self.navigationController pushViewController:detailView animated:YES];
}

//cell即将展示的时候调用
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
        UIImageView *arror = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow-right_cell"]];//arrow-right_cell
        arror.contentMode = UIViewContentModeScaleAspectFit;
        arror.frame = CGRectMake(0, 0, 15.0f, 15.0f);
        cell.accessoryView = arror;
    }
   if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
       [cell setSeparatorInset:UIEdgeInsetsMake(0, 15.0f, 0, cell.accessoryView.x+15.0f)];
   }
   if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
       [cell setLayoutMargins:UIEdgeInsetsMake(0, 15.0f, 0, cell.accessoryView.x+15.0f)];
   }
    //  隐藏每个分区最后一个cell的分割线
    if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
        // 1.系统分割线,移到屏幕外
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
        [cell addRoundedCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) withRadii:CGSizeMake(8.0f, 8.0f)];
    }
}

#pragma mark -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.vcCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y <= 0) {
        self.vcCanScroll = NO;
        scrollView.contentOffset = CGPointZero;
        if (self.delegate && [self.delegate respondsToSelector:@selector(itemListController:scrollToTopOffset:)])
            [self.delegate itemListController:self scrollToTopOffset:YES];
    }
    self.scrollView.showsVerticalScrollIndicator = self.vcCanScroll;
}

#pragma mark -
- (void)loadData:(id)sender {
    if (sender && [sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        _page ++;
    }else {
        _page = 0;
        if (_dataArray.count) [_dataArray removeAllObjects];
    }
    NSString *urlString = nil;
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    params[@"page"] = [NSString stringWithFormat:@"%@",@(_page)];
    params[@"uid"] = [UserInfoManager shareManager].uid;
    
    switch (_style) {
        case AMWalletItemDetailStyleYBDefault: {    ///艺币-全部
            
            break;
        }
        case AMWalletItemDetailStyleYBRecharge: {    /// 艺币-充值
            
            break;
        }
        case AMWalletItemDetailStyleYBConsumption: {    /// 艺币-消费
            
            break;
        }
        case AMWalletItemDetailStyleRevenueDefault: {    /// 收入-全部
            urlString = [ApiUtilHeader getBillList];
            params[@"account_type"] = @"23";
            params[@"state"] = @"0";
            break;
        }
        case AMWalletItemDetailStyleRevenueSale: {    /// 收入-销售
            urlString = [ApiUtilHeader getBillList];
            params[@"account_type"] = @"23";
            params[@"state"] = @"1";
            break;
        }
        case AMWalletItemDetailStyleRevenueProfit: {    /// 收入-收益
            urlString = [ApiUtilHeader getBillList];
            params[@"account_type"] = @"23";
            params[@"state"] = @"2";
            break;
        }
        case AMWalletItemDetailStyleRevenueCashout: {    /// 收入-提现
            urlString = [ApiUtilHeader getBillList];
            params[@"account_type"] = @"23";
            params[@"state"] = @"3";
            break;
        }
        case AMWalletItemDetailStyleBalanceDefault: {    /// 余额-全部
            
            break;
        }
        case AMWalletItemDetailStyleBalanceExpenditure: {    /// 余额-支出
            
            break;
        }
        case AMWalletItemDetailStyleBalanceRollin: {    /// 余额-转入
            
            break;
        }
        case AMWalletItemDetailStyleBalanceCashout: {    /// 余额-提现
            
            break;
        }
        case AMWalletItemDetailStyleBalanceRefund: {    /// 余额-退款
            
            break;
        }
        case AMWalletItemDetailStyleEstimateSaleValid: {    /// 预估销售-有效
            urlString = [ApiUtilHeader getSaleProfitList];
            params[@"orderstate"] = @"0";
            params[@"state"] = @"1";
            break;
        }
        case AMWalletItemDetailStyleEstimateSaleInvalid: {    /// 预估销售-无效
            urlString = [ApiUtilHeader getSaleProfitList];
            params[@"orderstate"] = @"2";
            params[@"state"] = @"1";
            break;
        }
        case AMWalletItemDetailStyleEstimateProfitValid: {    /// 预估收益-有效
            urlString = [ApiUtilHeader getSaleProfitList];
            params[@"orderstate"] = @"0";
            params[@"state"] = @"2";
            break;
        }
        case AMWalletItemDetailStyleEstimateProfitInvalid: {    /// 预估收益-无效
            urlString = [ApiUtilHeader getSaleProfitList];
            params[@"orderstate"] = @"2";
            params[@"state"] = @"2";
            break;
        }
        default:
            [SVProgressHUD dismiss];
            break;
    }
    
    if ([ToolUtil isEqualToNonNull:urlString]) {
        [self loadVideoListData:urlString params:params sender:sender];
    }
}

- (void)loadVideoListData:(NSString *)urlString params:(NSDictionary *)params sender:(id)sender {
    self.tableView.allowsSelection = NO;
    [ApiUtil postWithParent:self url:urlString needHUD:NO params:params success:^(NSInteger code, id  _Nullable response) {
        [self.tableView endAllFreshing];
        NSArray*array = (NSArray *)[response objectForKey:@"data"];
        if (array && array.count) {
            [self perfectDataArray:array];
            [_dataArray enumerateObjectsUsingBlock:^(WalletListBaseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [_dataArray replaceObjectAtIndex:idx withObject:[self distinguishModelStyle:obj]];
            }];
        }
        
        [self.tableView updataFreshFooter:(_dataArray.count && array.count != MaxListCount)];
        [self.tableView ly_updataEmptyView:!_dataArray.count];
        self.tableView.mj_footer.hidden = !_dataArray.count;
        [self.tableView reloadData];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [self.tableView endAllFreshing];
    }];
}

/// 将源数据转换成对应的Model
/// @param responseArray 源数据
- (void)perfectDataArray:(NSArray *)responseArray {
    switch (_style) {
        case AMWalletItemDetailStyleYBDefault:    ///艺币-全部
        case AMWalletItemDetailStyleYBRecharge:    /// 艺币-充值
        case AMWalletItemDetailStyleYBConsumption: {    /// 艺币-消费
            
//                                [_dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[WalletListModel class] json:array]];
            break;
        }
        case AMWalletItemDetailStyleRevenueDefault:     /// 收入-全部
        case AMWalletItemDetailStyleRevenueSale:     /// 收入-销售
        case AMWalletItemDetailStyleRevenueProfit:     /// 收入-收益
        case AMWalletItemDetailStyleRevenueCashout: {    /// 收入-提现
            
            [_dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[WalletRevenueListModel class] json:responseArray]];
            break;
        }
        case AMWalletItemDetailStyleBalanceDefault:     /// 余额-全部
        case AMWalletItemDetailStyleBalanceExpenditure:    /// 余额-支出
        case AMWalletItemDetailStyleBalanceRollin:     /// 余额-转入
        case AMWalletItemDetailStyleBalanceCashout:    /// 余额-提现
        case AMWalletItemDetailStyleBalanceRefund: {    /// 余额-退款
            
//                    [_dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[WalletListModel class] json:array]];
            break;
        }
        case AMWalletItemDetailStyleEstimateSaleValid:     /// 预估销售-有效
        case AMWalletItemDetailStyleEstimateSaleInvalid:    /// 预估销售-无效
        case AMWalletItemDetailStyleEstimateProfitValid:     /// 预估收益-有效
        case AMWalletItemDetailStyleEstimateProfitInvalid: {    /// 预估收益-无效
            
            [_dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[WalletEstimateListModel class] json:responseArray]];
            break;
        }
        default:
            break;
    }
}

/// 区分_dataArray.model的style
/// @param listModel WalletListModel
- (WalletListBaseModel *)distinguishModelStyle:(WalletListBaseModel *)listModel {
    AMWalletItemDetailStyle style = _style;
    switch (_style) {
        case AMWalletItemDetailStyleYBDefault: {    ///艺币-全部
            
            break;
        }
        case AMWalletItemDetailStyleRevenueDefault: {    /// 收入-全部
            ///"state":"", 1销售 2收益 3提现
            NSString *state = [(WalletRevenueListModel *)listModel state];
            if (state.integerValue == 1) {
                style = AMWalletItemDetailStyleRevenueSale;
            }
            if (state.integerValue == 2) {
                style = AMWalletItemDetailStyleRevenueProfit;
            }
            if (state.integerValue == 3) {
                style = AMWalletItemDetailStyleRevenueCashout;
            }
            if (state.integerValue == 4) {
                style = AMWalletItemDetailStyleRevenueMeetingProfit;
            }
            if (state.integerValue == 5) {
                style = AMWalletItemDetailStyleRevenueCourseProfit;
            }
            break;
        }
        case AMWalletItemDetailStyleRevenueProfit: {
            NSString *state = [(WalletRevenueListModel *)listModel state];
            if (state.integerValue == 2) {
                style = AMWalletItemDetailStyleRevenueProfit;
            }
            if (state.integerValue == 4) {
                style = AMWalletItemDetailStyleRevenueMeetingProfit;
            }
            if (state.integerValue == 5) {
                style = AMWalletItemDetailStyleRevenueCourseProfit;
            }
            break;
        }
        case AMWalletItemDetailStyleBalanceDefault: {    /// 余额-全部
            
            break;
        }
        default:
            [SVProgressHUD dismiss];
            break;
    }
    listModel.style = style;
    return listModel;
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
