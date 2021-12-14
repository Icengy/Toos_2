//
//  MessageNewListController.m
//  ArtMedia2
//
//  Created by 名课 on 2020/9/3.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "MessageNewListController.h"

/// 课程详情
#import "ClassDetailViewController.h"

#import "MessageListCell.h"
#import "MessageInfoModel.h"

/// 茶会详情
#import "AMMeetingDetailViewController.h"
/// 茶会订单详情
#import "HK_appointmentDetailVC.h"

/// 认证海报页
#import "IdentifyViewController.h"
///填写认证资料页
#import "ImproveDataViewController.h"

/// 钱包
#import "WalletViewController.h"

#import "WalletItemDetailViewController.h"
#import "WalletListBaseModel.h"

/// 商品订单详情页面
#import "OrderDetailViewController.h"
/// 退款退货详情页面
#import "RefundDetailViewController.h"

#import "AuctionSpecialDetailViewController.h"
#import "AuctionItemDetailViewController.h"
#import "AMAuctionShoppingCartViewController.h"
#import "AMAuctionOrderDetailViewController.h"


@interface MessageNewListController ()<UITableViewDelegate , UITableViewDataSource>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (strong, nonatomic)NSMutableArray <MessageSubModel *>*data;

@end

@implementation MessageNewListController

- (NSMutableArray *)data{
    if (!_data) {
        _data = [[NSMutableArray alloc] init];
    }
    return _data;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTableView];
    
    [self updateMessageStatus];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (self.model.mtype.integerValue == 1) {
        self.navigationItem.title = @"系统消息";
    }else if(self.model.mtype.integerValue == 3) {
        self.navigationItem.title = @"交易通知";
    }else if(self.model.mtype.integerValue == 2) {
        self.navigationItem.title = @"会客通知";
    }else if(self.model.mtype.integerValue == 4) {
        self.navigationItem.title = @"课程通知";
    }else if (self.model.mtype.integerValue == 5) {
        self.navigationItem.title = @"拍卖通知";
    }
    
    if (!self.data.count) [self loadData:nil];
}

- (void)setTableView{
    self.tableView.bgColorStyle = AMBaseTableViewBackgroundColorStyleGray;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MessageListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MessageListCell class])];
    
    [self.tableView addRefreshFooterWithTarget:self action:@selector(loadData:)];
    [self.tableView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
    self.tableView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self imageStr:@"message_list_null_img" action:@selector(loadData:)];
}

#pragma mark -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageListCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MessageListCell class]) forIndexPath:indexPath];
    if(self.data.count) cell.model = self.data[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MessageSubModel *model = [self.data objectAtIndex:indexPath.row];
    switch (model.mtype.integerValue) {
        case 1: /// 系统消息
            [self systemMessageHandle:model];
            break;
        case 2:/// 会客通知
            [self meetingMessageHandle:model];
            break;
        case 3:/// 交易通知
            [self transactionMessageHandle:model];
            break;
        case 4:/// 课程通知
            [self courseMessageHandle:model];
            break;
        case 5:/// pm通知
            [self auctionMessageHandle:model];
            break;
            
        default:
            break;
    }
    
    
}

- (void)systemMessageHandle:(MessageSubModel *)model {
    switch (model.jumpType.integerValue) {
        case 6: {///用户填写认证资料页
            [self.navigationController pushViewController:[[ImproveDataViewController alloc] init] animated:YES];
            break;
        }
        case 7: {///认证海报页
            [self.navigationController pushViewController:[[IdentifyViewController alloc] init] animated:YES];
            break;
        }
        case 9:   ///我的收入
        case 10: { ///我的收益
            WalletViewController *wallatVC = [[WalletViewController alloc] init];
            wallatVC.style = AMWalletItemStyleRevenue;
            [self.navigationController pushViewController:wallatVC animated:YES];
            break;
        }
            
        default:
            break;
    }
}

- (void)meetingMessageHandle:(MessageSubModel *)model {
    switch (model.jumpType.integerValue) {
        case 1: { /// 茶会详情
            if (![ToolUtil isEqualToNonNull:model.jumpId]) {
                [SVProgressHUD showMsg:@"数据错误，请重试或联系后台"];
                return;
            }
            AMMeetingDetailViewController *detailVC = [[AMMeetingDetailViewController alloc] init];
            detailVC.meetingid = model.jumpId;
            [self.navigationController pushViewController:detailVC animated:YES];
            break;
        }
        case 2: { /// 约茶订单详情
            if (![ToolUtil isEqualToNonNull:model.jumpId]) {
                [SVProgressHUD showMsg:@"数据错误，请重试或联系后台"];
                return;
            }
            HK_appointmentDetailVC *detailVC = [[HK_appointmentDetailVC alloc] init];
            detailVC.teaAboutOrderId = model.jumpId;
            [self.navigationController pushViewController:detailVC animated:YES];
            break;
        }
            
        default:
            break;
    }
}

- (void)transactionMessageHandle:(MessageSubModel *)model {
    
    switch (model.jumpType.integerValue) {
        case 3: { /// 退货详情页
            if (![ToolUtil isEqualToNonNull:model.jumpId]) {
                [SVProgressHUD showMsg:@"数据错误，请重试或联系后台"];
                return;
            }
            RefundDetailViewController *detailVC = [[RefundDetailViewController alloc] init];
            detailVC.wayType = (model.userType.integerValue == 1)?MyOrderWayTypeBuyed:MyOrderWayTypeSalled;
            detailVC.orderID = model.jumpId;
            [self.navigationController pushViewController:detailVC animated:YES];
            break;
        }
        case 4: {/// 收入详情页
//            WalletViewController *wallatVC = [[WalletViewController alloc] init];
//            wallatVC.style = AMWalletItemStyleRevenue;
//            [self.navigationController pushViewController:wallatVC animated:YES];
            
            WalletRevenueListModel *wModel = [[WalletRevenueListModel alloc] init];
            wModel.id = model.jumpId;
            wModel.style = AMWalletItemDetailStyleRevenueSale;
            WalletItemDetailViewController *vc = [[WalletItemDetailViewController alloc] init];
            vc.detailModel = wModel;
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case 5: {/// 订单详情页
            if (![ToolUtil isEqualToNonNull:model.jumpId]) {
                [SVProgressHUD showMsg:@"数据错误，请重试或联系后台"];
                return;
            }
            OrderDetailViewController *detailVC = [[OrderDetailViewController alloc] init];
            detailVC.wayType = (model.userType.integerValue == 1)?MyOrderWayTypeBuyed:MyOrderWayTypeSalled;
            detailVC.orderID = model.jumpId;
            [self.navigationController pushViewController:detailVC animated:YES];
            break;
        }
        case 14: {/// 拍品订单详情
            if (![ToolUtil isEqualToNonNull:model.jumpId]) {
                [SVProgressHUD showMsg:@"数据错误，请重试或联系后台"];
                return;
            }
            AMAuctionOrderDetailViewController *detailVC = [[AMAuctionOrderDetailViewController alloc] init];
            detailVC.orderID = model.jumpId;
            [self.navigationController pushViewController:detailVC animated:YES];
            break;
        }
            
            
        default:
            break;
    }
}
- (void)courseMessageHandle:(MessageSubModel *)model {
    
    switch (model.jumpType.integerValue) {
        case 8: { /// 课程详情
            ClassDetailViewController *vc = [[ClassDetailViewController alloc] init];
            vc.courseId = model.jumpId;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        default:
            break;
    }
}

- (void)auctionMessageHandle:(MessageSubModel *)model {
    switch (model.jumpType.integerValue) {
        case 11: {/// 专场详情
            if (![ToolUtil isEqualToNonNull:model.jumpId]) {
                [SVProgressHUD showMsg:@"数据错误，请重试或联系后台"];
                return;
            }
            AuctionSpecialDetailViewController *detailVC = [[AuctionSpecialDetailViewController alloc] init];
            detailVC.auctionFieldId = model.jumpId;
            [self.navigationController pushViewController:detailVC animated:YES];
            break;
        }
        case 12: {/// 拍品详情
            if (![ToolUtil isEqualToNonNull:model.jumpId]) {
                [SVProgressHUD showMsg:@"数据错误，请重试或联系后台"];
                return;
            }
            AuctionItemDetailViewController *detailVC = [[AuctionItemDetailViewController alloc] init];
            detailVC.auctionGoodId = model.jumpId;
            [self.navigationController pushViewController:detailVC animated:YES];
            break;
        }
        case 13: {/// 未结拍品
            [self.navigationController pushViewController:[[AMAuctionShoppingCartViewController alloc] init] animated:YES];
            break;
        }
        case 14: {/// 拍品订单详情
            if (![ToolUtil isEqualToNonNull:model.jumpId]) {
                [SVProgressHUD showMsg:@"数据错误，请重试或联系后台"];
                return;
            }
            AMAuctionOrderDetailViewController *detailVC = [[AMAuctionOrderDetailViewController alloc] init];
            detailVC.orderID = model.jumpId;
            [self.navigationController pushViewController:detailVC animated:YES];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - 删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        SHOWERROR(@"删除该行");
        [self deleteIndexPath:indexPath];
    }
}

- ( UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(11.0)) {
    //删除
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
//        SHOWERROR(@"删除该行");
        [self deleteIndexPath:indexPath];
        completionHandler (YES);
    }];
    deleteRowAction.backgroundColor = [UIColor redColor];
    
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
    return config;
}

- (void)deleteIndexPath:(NSIndexPath *)indexPath {
//    NSMutableDictionary *params = @{}.mutableCopy;
//
//    params[@"uid"] = [UserInfoManager shareManager].uid;
//    params[@"msgid"] = [_dataArray[indexPath.row] ID];
//
//    [ApiUtil postWithParent:self url:[ApiUtilHeader deleteSystemMsg] params:params.copy success:^(NSInteger code, id  _Nullable response) {
//        [_dataArray removeObjectAtIndex:indexPath.row];
//         _totalMsgNum --;
//         [SVProgressHUD showSuccess:@"删除成功" completion:^{
//             if (_dataArray.count) {
//                 [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
//             }else {
//                 [self loadData:nil];
//             }
//         }];
//    } fail:nil];
}

#pragma mark -
- (void)loadData:(id)sender{
    self.tableView.allowsSelection = NO;
    if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
        [SVProgressHUD show];
    }
    if (sender && [sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        self.pageIndex ++;
    }else {
        self.pageIndex = 1;
        if (self.data.count) [self.data removeAllObjects];
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[UserInfoManager shareManager].uid forKey:@"uid"];
    [dic setValue:self.model.userType forKey:@"userType"];
    [dic setValue:self.model.mtype forKey:@"mtype"];
    [dic setValue:@(self.pageIndex) forKey:@"current"];
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader selectNewsByPage] needHUD:YES params:dic success:^(NSInteger code, id  _Nullable response) {
        [self.tableView endAllFreshing];
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            NSArray *records = (NSArray *)[data objectForKey:@"records"];
            if (records && records.count) {
                [self.data addObjectsFromArray:[NSArray yy_modelArrayWithClass:[MessageSubModel class] json:records]];
            }
            [self.tableView updataFreshFooter:(self.data.count && records.count != MaxListCount)];
        }
        [self.tableView ly_updataEmptyView:!self.data.count];
        self.tableView.mj_footer.hidden = !self.data.count;
        [self.tableView reloadData];
        
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [self.tableView endAllFreshing];
        [SVProgressHUD showError:errorMsg];
    }];
}

- (void)updateMessageStatus {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"mtype"] = _model.mtype;
    dic[@"userType"] = _model.userType;
    dic[@"uid"] = [UserInfoManager shareManager].uid;
    [ApiUtil postWithParent:self url:[ApiUtilHeader updateMessageStatus] needHUD:YES params:dic success:^(NSInteger code, id  _Nullable response) {
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
    }];
}

@end
