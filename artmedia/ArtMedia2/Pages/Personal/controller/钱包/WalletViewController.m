//
//  WalletViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "WalletViewController.h"

#import "TYTabButtonPagerController.h"
#import "WalletClassifiedItemViewController.h"

#import "YiBRechargeViewController.h"//艺币充值页面
#import "WalletEstimateViewController.h"//预估列表页
#import "ReceivableListViewController.h"//提现页面

#import "WalletTopItemTableCell.h"
#import "WalletRevenueTopItemTableCell.h"
#import "WalletRevenueEstimateTableCell.h"
#import "EmptyTableViewCell.h"

#import "WalletListHeaderView.h"

#import "AMDialogView.h"
#import "PhoneAuthViewController.h"
#import "FaceRecognitionViewController.h"


#define WalletTopSectionHeight  K_Width *(160.0f/K_Width)
#define WalletRevenueTopSectionHeight K_Width *(200.0f/375.0f)
#define WalletHeaderViewHeight (44.0f *2 + 10.0f)
#define WalletListItemSectionHeight  (K_Height - StatusNav_Height - WalletHeaderViewHeight)

@interface WalletViewController () <WalletTopItemTableCellDelegate, WalletRevenueTopItemDelegate>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;

@property (nonatomic ,strong) WalletListHeaderView *headerView;

@end

@implementation WalletViewController {
    NSMutableDictionary *_revenueData;
}

#pragma mark -
- (WalletListHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WalletListHeaderView class]) owner:nil options:nil].lastObject;
        _headerView.currentIndex = self.currentIndex;
        _headerView.dataArray = self.contentTitleArray.copy;
        _headerView.style = _style;
        _headerView.frame = CGRectMake(0, 0, self.view.width, WalletHeaderViewHeight);
        @weakify(self);
        _headerView.clickIndexBlock = ^(NSInteger index) {
            @strongify(self);
            self.currentIndex = index;
            [self.contentCarrier moveToControllerAtIndex:self.currentIndex animated:YES];
        };
    }return _headerView;
}

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    
    self.currentIndex = 0;
    self.canScroll = YES;
    self.contentChildArray = [self getContentChildArray].mutableCopy;
    
    self.contentCarrier.delegate = self;
    self.contentCarrier.dataSource = self;
    self.contentCarrier.customShadowColor = UIColor.clearColor;
    [self addChildViewController:self.contentCarrier];
    
    _revenueData = @{}.mutableCopy;
    
    self.tableView.multipleGestureEnable = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerClass:[EmptyTableViewCell class] forCellReuseIdentifier:NSStringFromClass([EmptyTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WalletTopItemTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WalletTopItemTableCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WalletRevenueTopItemTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WalletRevenueTopItemTableCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WalletRevenueEstimateTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WalletRevenueEstimateTableCell class])];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self.tableView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (_style == AMWalletItemStyleBalance) {
        self.navigationItem.title = @"我的余额";
    }
    if (_style == AMWalletItemStyleRevenue) {
        self.navigationItem.title = @"我的钱包";
    }
    if (_style == AMWalletItemStyleYiB) {
        self.navigationItem.title = @"我的艺币";
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadData:nil];
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_style == AMWalletItemStyleRevenue) return 3;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_style == AMWalletItemStyleRevenue && section == 1 && [UserInfoManager shareManager].isArtist) return 2;
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return (_style == AMWalletItemStyleRevenue)?WalletRevenueTopSectionHeight:WalletTopSectionHeight;
    }
    if (_style == AMWalletItemStyleRevenue && indexPath.section == 1) return 44.0f;
    return WalletListItemSectionHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (_style == AMWalletItemStyleRevenue) {/// 我的收入
            WalletRevenueTopItemTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WalletRevenueTopItemTableCell class]) forIndexPath:indexPath];
            cell.isAuthUser = [UserInfoManager shareManager].isArtist;
            cell.delegate = self;
            cell.revenueData = _revenueData.copy;
            
            return cell;
        }
        WalletTopItemTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WalletTopItemTableCell class]) forIndexPath:indexPath];
        cell.style = _style;
        cell.delegate = self;
        
        return cell;
    }
    if (indexPath.section == 1 && _style == AMWalletItemStyleRevenue) {/// 我的预估
        WalletRevenueEstimateTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WalletRevenueEstimateTableCell class]) forIndexPath:indexPath];
        cell.cornersRadii = CGSizeMake(8.0, 8.0);
        cell.insets = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0);
        
        if (indexPath.row == 0) {
            if ([UserInfoManager shareManager].isArtist) {
                cell.style = AMWalletItemStyleEstimateSale;
                cell.corners = UIRectCornerTopLeft | UIRectCornerTopRight;
            }else {
                cell.corners = UIRectCornerAllCorners;
                cell.style = AMWalletItemStyleEstimateProfit;
            }
        }else {
            cell.corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
            cell.style = AMWalletItemStyleEstimateProfit;
        }
        
        cell.estimateData = _revenueData.copy;
        
        return cell;
    }
    EmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EmptyTableViewCell class]) forIndexPath:indexPath];
    
    cell.insets = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f);
    cell.corners = UIRectCornerAllCorners;
    cell.contentCarrier = self.contentCarrier.view;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ((section == 1 && _style != AMWalletItemStyleRevenue) || (section == 2)) return WalletHeaderViewHeight;
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ((section == 1 && _style != AMWalletItemStyleRevenue) || (section == 2)) {
        return self.headerView;
    }
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && _style == AMWalletItemStyleRevenue) {
        WalletEstimateViewController *estimate = [[WalletEstimateViewController alloc] init];
        
        WalletRevenueEstimateTableCell *cell = (WalletRevenueEstimateTableCell *)[tableView cellForRowAtIndexPath:indexPath];
        estimate.style = cell.style;
        
        NSString *pre_money;
        if (cell.style == AMWalletItemStyleEstimateSale) {
            pre_money = [ToolUtil isEqualToNonNull:[_revenueData objectForKey:@"pre_sale_money"] replace:@"0"];
        }else
            pre_money = [ToolUtil isEqualToNonNull:[_revenueData objectForKey:@"pre_reward_money"] replace:@"0"];
        
        estimate.estimateMoney = pre_money;
        [self.navigationController pushViewController:estimate animated:YES];
    }
}

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
}

#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat bottomCellOffset = [self.tableView rectForSection:self.tableView.numberOfSections - 1].origin.y;
    [self tableViewDidScroll:scrollView bottomCellOffset:bottomCellOffset];
}

#pragma mark - BaseItemViewControllerDelegate
- (void)itemListController:(BaseItemViewController *)listVC scrollToTopOffset:(BOOL)scrollTop {
    [self tableViewScrollToTopOffset];
}

#pragma mark - TYPagerController
- (NSArray *)getContentChildArray {
    self.contentTitleArray = [self getContentTitleArray].mutableCopy;
    NSMutableArray *customArray = [NSMutableArray new];
    for (int i = 0; i < self.contentTitleArray.count; i ++) {
        WalletClassifiedItemViewController *listVC = [[WalletClassifiedItemViewController alloc] init];
        listVC.delegate = self;
        listVC.style = [self itemStyle:i];
        [customArray insertObject:listVC atIndex:customArray.count];
    }
    return customArray;
}

- (NSArray *)getContentTitleArray {
    if (_style == AMWalletItemStyleYiB) {
        return @[@"全部", @"支出", @"充值"];
    }
    if (_style == AMWalletItemStyleRevenue) {
        if ([UserInfoManager shareManager].isArtist) return @[@"全部", @"销售", @"收益", @"提现"];
         return @[@"全部", @"收益", @"提现"];
    }
    if (_style == AMWalletItemStyleBalance) {
         return @[@"全部", @"支出", @"转入", @"提现", @"退款"];
    }
    return @[];
}

- (NSInteger)numberOfControllersInPagerController {
    return self.contentChildArray.count;
}

- (NSString *)pagerController:(TYPagerController *)pagerController titleForIndex:(NSInteger)index {
    return self.contentTitleArray[index];
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index {
    return self.contentChildArray[index];
}

- (void)pagerController:(TYTabPagerController *)pagerController didScrollToTabPageIndex:(NSInteger)index {
    self.currentIndex = index;
    _headerView.currentIndex = self.currentIndex;
}

#pragma mark - WalletTopItemTableCellDelegate
- (void)didClickToQuestion:(id)sender {
    NSString *title;
    if (_style == AMWalletItemStyleYiB) {
        title = @"其它（非苹果）平台上充值的艺币不能在苹果的设备上使用。";
    }else if (_style == AMWalletItemStyleBalance) {
        title = @"这里是冻结原因这里是冻结原因";
    }
    SingleAMAlertView *alertView = [SingleAMAlertView shareInstance];
    alertView.title = title;
    alertView.titleFont = [UIFont addHanSanSC:15.0f fontType:0];
    [alertView show];
    
}

- (void)didClickToRecharge:(id)sender {
    if (_style == AMWalletItemStyleYiB) {
        [self.navigationController pushViewController:[[YiBRechargeViewController alloc] init] animated:YES];
    }
}

- (void)didClickToCashout:(id)sender {
    ReceivableListViewController *receivablelistVC = [[ReceivableListViewController alloc] init];
    receivablelistVC.receiveType = 2;
    [self.navigationController pushViewController:receivablelistVC animated:YES];
}

#pragma mark - WalletRevenueTopItemDelegate
- (void)didClickToCashout:(id)sender forIndex:(NSInteger)index {
    
    if (index && ![UserInfoManager shareManager].isAuthed) {
        AMAuthDialogView *dialogView = [AMAuthDialogView shareInstance];
        @weakify(dialogView);
        dialogView.imageSelectedBlock = ^(AMImageSelectedMeidaType meidaType) {
            @strongify(dialogView);
            [dialogView hide];
            if (meidaType) {
                [self.navigationController pushViewController:[[PhoneAuthViewController alloc] init] animated:YES];
            }else {
                [self.navigationController pushViewController:[[FaceRecognitionViewController alloc] init] animated:YES];
            }
        };
        [dialogView show];
        return;
    }
    
    CGFloat cashoutValue = 0.0f;
    if (index) {// 收益提现
//        cashoutValue = [_revenueData[@"now_reward_money"] floatValue];
        cashoutValue = [[ToolUtil isEqualToNonNull:[_revenueData objectForKey:@"now_reward_money"] replace:@"0"] floatValue];
    }else {// 销售提现
        cashoutValue = [[ToolUtil isEqualToNonNull:[_revenueData objectForKey:@"now_sale_money"] replace:@"0"] floatValue];
//        cashoutValue = [_revenueData[@"now_sale_money"] floatValue];
    }
    if (cashoutValue < 10.00) {
        SingleAMAlertView *alert = [SingleAMAlertView shareInstance];
        alert.title = @"当前金额不足最低提现额度";
        alert.subTitle = @"最低提现额度为10元";
        [alert show];
        return;
    }
    ReceivableListViewController *receivablelistVC = [[ReceivableListViewController alloc] init];
    receivablelistVC.receiveType = index + 1;
    receivablelistVC.cashoutCount = [NSString stringWithFormat:@"%.2f",cashoutValue];
    [self.navigationController pushViewController:receivablelistVC animated:YES];
}

#pragma mark - prvite
- (AMWalletItemDetailStyle)itemStyle:(int)index {
    if (_style == AMWalletItemStyleRevenue) {/// 收入
        switch (index) {
            case 0: /// 收入-全部
                return AMWalletItemDetailStyleRevenueDefault;
                break;
            case 1: /// 收入-销售
                return [UserInfoManager shareManager].isArtist?AMWalletItemDetailStyleRevenueSale:AMWalletItemDetailStyleRevenueProfit;
                break;
            case 2: /// 收入-收益
                return [UserInfoManager shareManager].isArtist?AMWalletItemDetailStyleRevenueProfit:AMWalletItemDetailStyleRevenueCashout;
                break;
            case 3: /// 收入-提现
                return AMWalletItemDetailStyleRevenueCashout;
                break;
                
            default:
                break;
        }
    }
    
    if (_style == AMWalletItemStyleYiB) {/// 艺币
        switch (index) {
            case 0: /// 艺币-全部
                return AMWalletItemDetailStyleYBDefault;
                break;
            case 1: /// 艺币-充值
                return AMWalletItemDetailStyleYBRecharge;
                break;
            case 2: /// 艺币-消费
                return AMWalletItemDetailStyleYBConsumption;
                break;
                
            default:
                break;
        }
    }
    
    if (_style == AMWalletItemStyleBalance) {/// 余额
        switch (index) {
            case 0: /// 余额-全部
                return AMWalletItemDetailStyleBalanceDefault;
                break;
            case 1: /// 余额-支出
                return AMWalletItemDetailStyleBalanceExpenditure;
                break;
            case 2: /// 余额-转入
                return AMWalletItemDetailStyleBalanceRollin;
                break;
            case 3: /// 余额-提现
                return AMWalletItemDetailStyleBalanceCashout;
                break;
            case 4: /// 余额-退款
                return AMWalletItemDetailStyleBalanceRefund;
                break;

            default:
                break;
        }
    }
    
    return AMWalletItemDetailStyleNone;
}

#pragma mark -
- (void)loadData:(id)sender {
    NSString *url = nil;
    if (_style == AMWalletItemStyleBalance) {//我的余额
        url = [ApiUtilHeader getMyWalletBalance];
    }
    if (_style == AMWalletItemStyleRevenue) {//我的收入
        url = [ApiUtilHeader myIncomeIndex];
    }
    if (_style == AMWalletItemStyleYiB) {//我的艺币
        
    }
    if (![ToolUtil isEqualToNonNull:url]) return;
    
    self.tableView.allowsSelection = NO;
    [ApiUtil postWithParent:self url:url needHUD:NO params:@{@"uid":[UserInfoManager shareManager].uid} success:^(NSInteger code, id  _Nullable response) {
        [self.tableView endAllFreshing];
        /*
         now_sale_money //当前销售收入
         now_reward_money //当前收益收入
         history_sale_money //历史销售总收入
         history_reward_money //历史收益总收入
         pre_sale_money //预估销售
         pre_reward_money //预估收益
         */
        if (_style == AMWalletItemStyleBalance) {//我的余额
            
        }
        if (_style == AMWalletItemStyleRevenue) {//我的收入
            _revenueData = [response[@"data"] mutableCopy];
        }
        if (_style == AMWalletItemStyleYiB) {//我的艺币
        }
        [self.tableView reloadData];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
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
