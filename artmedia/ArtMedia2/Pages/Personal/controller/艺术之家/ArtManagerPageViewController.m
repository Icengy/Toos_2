//
//  ArtManagerPageViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/9/3.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "ArtManagerPageViewController.h"

#import "PhoneAuthViewController.h"// 实名认证
#import "HK_Tea_ManagerVC.h"// 会客管理
#import "AMMeetingRecordManageViewController.h"// 约见管理
#import "AMMeetingRecordManageViewController.h"// 约见记录
#import "HK_TeaMeetingRecordVC.h"// 会客记录
#import "WalletViewController.h"// 我的收入
#import "ReceivableListViewController.h"
#import "WebViewURLViewController.h"
#import "ArtistClassListController.h"

#import "MySellViewController.h"// 销售订单列表

#import "ArtManagerHeaderView.h"
#import "ArtManagerPendingTableCell.h"
#import "ArtManagerMenuTableCell.h"
#import "ArtManagerClassCell.h"

#import "UIViewController+BackButtonHandler.h"


@interface ArtManagerPageViewController () <ArtManagerHeaderDelegate, ArtManagerMenuItemDelegate, ArtManagerPendingMenuItemDelegate, BackButtonHandlerProtocol>

@property (weak, nonatomic) IBOutlet BaseTableView *tableView;

@property (strong, nonatomic) ArtManagerHeaderView *headerView;

@property (nonatomic , copy) NSString *courseNumber;
@end

@implementation ArtManagerPageViewController {
    UserInfoModel *_userModel;
    NSInteger _wait_deliver_num, _wait_deal_refund_num, _wait_deal_appointment, _wait_deal_meeting;
}

- (ArtManagerHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [ArtManagerHeaderView shareInstance];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setTableFooterView:[UIView new]];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ArtManagerPendingTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ArtManagerPendingTableCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ArtManagerMenuTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ArtManagerMenuTableCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ArtManagerClassCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ArtManagerClassCell class])];
    
    [self.tableView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self selectLiveCourseCountOfCurrentTeacher];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    //禁用右滑返回手势
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
    
    if (_userModel == nil) [self loadData:nil];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ArtManagerMenuTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ArtManagerMenuTableCell class]) forIndexPath:indexPath];
        cell.delegate = self;
        
        return cell;
    }else if(indexPath.section == 1){
        ArtManagerPendingTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ArtManagerPendingTableCell class]) forIndexPath:indexPath];
        cell.delegate = self;
        cell.wait_deliver_num = _wait_deliver_num;
        cell.wait_deal_meeting = _wait_deal_meeting;
        cell.wait_deal_refund_num = _wait_deal_refund_num;
        cell.wait_deal_appointment = _wait_deal_appointment;
        return cell;
    }else{
        ArtManagerClassCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ArtManagerClassCell class]) forIndexPath:indexPath];
        cell.courseNumber= self.courseNumber;
        return cell;
    }
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return self.headerView.contentHeight;
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0){
        ArtManagerHeaderView *headerView = [ArtManagerHeaderView shareInstance];
        headerView.delegate = self;
        headerView.model = _userModel;
        self.headerView = headerView;
        return self.headerView;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {//课程
        ArtistClassListController *vc = [[ArtistClassListController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -
- (BOOL)navigationShouldPopOnBackButton {
    [self.navigationController popToRootViewControllerAnimated:YES];
    return NO;
}

#pragma mark -
- (void)headerView:(ArtManagerHeaderView *)headerView didSelectedToBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)headerView:(ArtManagerHeaderView *)headerView didSelectedToAuthData:(id)sender {
//    [self.navigationController pushViewController:[[PhoneAuthViewController alloc] init] animated:YES];
}

#pragma mark - ArtManagerPendingMenuItemDelegate
- (void)pendingMenuCell:(ArtManagerPendingTableCell *)pendingMenuCell didSelectedMenuItemWithIndex:(ArtManagerPendingMenuItemIndex)index {
    switch (index) {
            // 待发货订单 0:全部", 1:待付款", 2:待发货", 3:待收货", 4:已完成", 5:退货退款
        case ArtManagerPendingMenuItemIndexOrderDaiFaHuo: {
            MySellViewController *sellVC = [[MySellViewController alloc] init];
            sellVC.pageIndex = 2;
            [self.navigationController pushViewController:sellVC animated:YES];
            break;
        }
            //待处理退货
        case ArtManagerPendingMenuItemIndexOrderDaiTuiHuo: {
            MySellViewController *sellVC = [[MySellViewController alloc] init];
            sellVC.pageIndex = 5;
            [self.navigationController pushViewController:sellVC animated:YES];
            break;
        }
            //待处理约见 0全部 1待邀请 2待确认 3已确认 4已取消
        case ArtManagerPendingMenuItemIndexMeetingDaiYueJian: {
            AMMeetingRecordManageViewController *managerVC = [[AMMeetingRecordManageViewController alloc] init];
            managerVC.style = AMMeetingRecordManageStyleManage;
            [self.navigationController pushViewController:managerVC animated:YES];
            
            break;
        }
            //待开始会客 1全部 2待开始 3进行中 4已结束 5已取消
        case ArtManagerPendingMenuItemIndexMeetingDaiHuiKe: {
            HK_Tea_ManagerVC *managerVC = [[HK_Tea_ManagerVC alloc] init];
            [self.navigationController pushViewController:managerVC animated:YES];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - ArtManagerMenuItemDelegate
- (void)menuCell:(ArtManagerMenuTableCell *)menuCell didSelectedMenuItemWithIndex:(ArtManagerMenuItemIndex)index {
    switch (index) {
            //我的收入
        case ArtManagerMenuItemIndexIncome: {
            WalletViewController *itemVC = [[WalletViewController alloc] init];
            itemVC.style = AMWalletItemStyleRevenue;
            [self.navigationController pushViewController:itemVC animated:YES];
            break;
        }
            //经纪人账户
        case ArtManagerMenuItemIndexAgentAccount: {
            ReceivableListViewController *receivablelistVC = [[ReceivableListViewController alloc] init];
            receivablelistVC.receiveType = 0;
            [self.navigationController pushViewController:receivablelistVC animated:YES];
            break;
        }
            //销售订单
        case ArtManagerMenuItemIndexSale: {
            [self.navigationController pushViewController:[[MySellViewController alloc] init] animated:YES];
            break;
        }
            // 约见管理
        case ArtManagerMenuItemIndexMeetingAppointmentManage: {
            AMMeetingRecordManageViewController *managerVC = [[AMMeetingRecordManageViewController alloc] init];
            managerVC.style = AMMeetingRecordManageStyleManage;
            [self.navigationController pushViewController:managerVC animated:YES];
            break;
        }
            //会客管理
        case ArtManagerMenuItemIndexMeetingManage:
            [self.navigationController pushViewController:[[HK_Tea_ManagerVC alloc] init] animated:YES];
            break;
            // 帮助中心
        case ArtManagerMenuItemIndexHelp: {
            WebViewURLViewController *webView = [[WebViewURLViewController alloc] initWithUrlString:[ApiUtil_H5Header h5_helpCenter:0]];
            webView.navigationBarTitle = @"帮助中心";
            [self.navigationController pushViewController:webView animated:YES];
            break;
        }
            
        default:
            break;
    }
}

- (void)loadData:(id _Nullable)sender {
    if (![UserInfoManager shareManager].isLogin) {
        [self jumpToLoginWithBlock:nil];
        return;
    }
    
    self.tableView.allowsSelection = NO;
    if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
        [SVProgressHUD show];
    }
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    param[@"user_id"] = [UserInfoManager shareManager].uid;
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader getArtistUserInfo] needHUD:NO params:param.copy success:^(NSInteger code, id  _Nullable response) {
        [self.tableView endAllFreshing];
        
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            NSDictionary *userinfo = (NSDictionary *)[data objectForKey:@"user_info"];
            _userModel = [UserInfoModel yy_modelWithDictionary:userinfo];
            
            _wait_deal_appointment = [[ToolUtil isEqualToNonNull:[data objectForKey:@"wait_deal_appointment"] replace:@"0"] integerValue];
            _wait_deliver_num = [[ToolUtil isEqualToNonNull:[data objectForKey:@"wait_deliver_num"] replace:@"0"] integerValue];
            _wait_deal_meeting = [[ToolUtil isEqualToNonNull:[data objectForKey:@"wait_deal_meeting"] replace:@"0"] integerValue];
            _wait_deal_refund_num = [[ToolUtil isEqualToNonNull:[data objectForKey:@"wait_deal_refund_num"] replace:@"0"] integerValue];
        }
        
        [self.tableView reloadData];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [self.tableView endAllFreshing];
    }];
}

- (void)selectLiveCourseCountOfCurrentTeacher{
   
    [ApiUtil getWithParent:self url:[ApiUtilHeader selectLiveCourseCountOfCurrentTeacher] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response) {
        if (response) {
            self.courseNumber = response[@"data"];
            [self.tableView reloadData];
        }
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        
    }];
}

@end
