//
//  MinePageViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/9/2.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "MinePageViewController.h"

//#import "CustomPersonalViewController.h"
#import "AMBaseUserHomepageViewController.h"
#import "UserListDetailViewController.h"//用户列表
#import "SettingViewController.h"//设置
#import "PersonalDataEditViewController.h"//用户信息编辑
#import "IdentifyViewController.h"//认证主页
#import "ReceivableListViewController.h"//收款账户
#import "PhoneAuthViewController.h"//实名认证
#import "FaceRecognitionViewController.h"// 人脸认证
#import "AdressViewController.h"//地址管理
#import "AMMeetingRecordManageViewController.h"// 约见记录
#import "HK_TeaMeetingRecordVC.h"// 会客记录
#import "ArtManagerPageViewController.h"// 艺术之家
#import "MyBuyViewController.h"// 买家订单
#import "MyShortVideoListViewController.h"// 我的短视频
#import "MyLikeVideoListViewController.h"// 我喜欢的视频
#import "InviteNewViewController.h"// 我的邀请
#import "WalletViewController.h"// 我的收益
#import "WalletEstimateViewController.h"// 预估收益
#import "WebViewURLViewController.h"
#import "AMCertificateBaseViewController.h"// 权属证书

#import "MyECoinViewController.h" //易币
#import "MyStudyListController.h"//我的学习
#import "AMAuctionShoppingCartViewController.h"/// 未结
#import "AMAuctionOrderViewController.h"/// 拍品订单
#import "AMAuctionRecordViewController.h"/// 参拍记录
#import "MyAuctionMoneyController.h"

#import "CustomPersonalModel.h"

#import "MineInfoTableCell.h"
#import "MineOrderItemTableCell.h"
#import "PersonalWalletTableViewCell.h"
#import "MineMeeingItemTableCell.h"
#import "PersonMenuBackCell.h"
#import "MineAuctionItemTableCell.h"

#import "AMDialogView.h"
#import "WechatManager.h"
#import "PublishResultViewController.h"


@interface MinePageViewController () <UITableViewDelegate, UITableViewDataSource ,MineInfoTableCellDelegate, PersonalWalletItemDelegate, MineMeetingItemDelegate, MineOrderItemDelegate, WebViewURLViewControllerDelegate , PersonMenuBackCellDelegate ,MineAuctionItemDelegate>


@property (weak, nonatomic) IBOutlet BaseTableView *tableView;

@property (nonatomic ,strong) CustomPersonalModel *userModel;
@property (nonatomic ,assign) BOOL naviHidden;
@end

@implementation MinePageViewController

- (instancetype) initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        self.naviHidden = YES;
    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    
    self.userModel = [CustomPersonalModel new];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MineInfoTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MineInfoTableCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MineOrderItemTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MineOrderItemTableCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PersonalWalletTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([PersonalWalletTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MineMeeingItemTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MineMeeingItemTableCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MineAuctionItemTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MineAuctionItemTableCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PersonMenuBackCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([PersonMenuBackCell class])];

    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationItem setTitle:@"我的"];
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController setNavigationBarHidden:self.naviHidden animated:NO];
    self.barStyle = self.naviHidden?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
    self.tableView.contentOffset = CGPointZero;
    
    if (![UserInfoManager shareManager].isLogin) {
        [self jumpToLoginWithBlock:nil];
        return;
    }
    [self loadData:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.barStyle = UIStatusBarStyleDefault;
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {/// 订单模块
        MineOrderItemTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MineOrderItemTableCell class]) forIndexPath:indexPath];
        cell.delegate = self;
        cell.unreadModel = _userModel.unreadModel;
        
        return cell;
    }
    if (indexPath.section == 2) {/// 收益模块
        PersonalWalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PersonalWalletTableViewCell class]) forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = _userModel;
        
        return cell;
    }
    if (indexPath.section == 3) {/// 拍卖模块
        MineAuctionItemTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MineAuctionItemTableCell class]) forIndexPath:indexPath];
        cell.delegate = self;
        if ([(NSString *)AMUserDefaultsObjectForKey(@"is_include_auc") isEqualToString:@"1"]) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
        }
        return cell;
    }
    if (indexPath.section == 4) {/// 会客厅模块
        MineMeeingItemTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MineMeeingItemTableCell class]) forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = _userModel;
        
        return cell;
    }
    if (indexPath.section == 5) {/// 菜单模块
        PersonMenuBackCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PersonMenuBackCell class]) forIndexPath:indexPath];
        cell.delegate = self;
        
        return cell;
    }
    /// 用户信息模块
    MineInfoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MineInfoTableCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    cell.model = self.userModel;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        if ([(NSString *)AMUserDefaultsObjectForKey(@"is_include_auc") isEqualToString:@"1"]){
            return 100;
        }else{
            return CGFLOAT_MIN;
        }
    }else{
        return UITableViewAutomaticDimension;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section?10.0f:CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return ([tableView numberOfSections] - 1 == section)?10.0f:CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    ///隐藏导航栏
    self.naviHidden = YES;
    if (offsetY >= StatusNav_Height) {
        self.naviHidden = NO;
    }
    [self.navigationController setNavigationBarHidden:self.naviHidden animated:YES];
    self.barStyle = self.naviHidden?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
}

#pragma mark - PersonMenuBackCellDelegate
- (void)PersonMenuBackCellCollectionDidSelect:(PersonMenuBackCell *)cell collectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:[[AMCertificateBaseViewController alloc] init] animated:YES];
    }else if(indexPath.row == 1){
        [self.navigationController pushViewController:[[MyStudyListController alloc] init] animated:YES];
    }else if(indexPath.row == 2){
        [self.navigationController pushViewController:[[MyECoinViewController alloc] init] animated:YES];
    }else if(indexPath.row == 3){
        [self.navigationController pushViewController:[[InviteNewViewController alloc] init] animated:YES];
    }else if(indexPath.row == 4){
        [self.navigationController pushViewController:[[AdressViewController alloc] init] animated:YES];
    }else if(indexPath.row == 5){
        WebViewURLViewController *webView = [[WebViewURLViewController alloc] initWithUrlString:[ApiUtil_H5Header h5_helpCenter:1]];
        webView.navigationBarTitle = @"帮助中心";
        [self.navigationController pushViewController:webView animated:YES];
    }
}


#pragma mark - MineInfoTableCellDelegate
/// 更换背景图
- (void)infoCell:(MineInfoTableCell *)infoCell selectedForChangeBackgroundImage:(id)sender {
    AMImageSelectDialogView *dialogView = [AMImageSelectDialogView shareInstance];
    dialogView.title = @"设置封面";
    dialogView.itemData = @[@"拍一张", @"从手机相册选择"];
    @weakify(dialogView);
    dialogView.imageSelectedBlock = ^(AMImageSelectedMeidaType meidaType) {
        @strongify(dialogView);
        [dialogView hide];
        [ToolUtil showInController:self photoOfMax:1 withType:meidaType uploadType:5 completion:^(NSArray * _Nullable images) {
            [self updateBackImg:images];
        }];
    };
    [dialogView show];
}

/// 点击用户头像
- (void)infoCell:(MineInfoTableCell *)infoCell selectedForLogo:(id)sender {
    AMBaseUserHomepageViewController * vc = [[AMBaseUserHomepageViewController alloc] init];
    vc.artuid = [UserInfoManager shareManager].uid;
    [self.navigationController pushViewController:vc animated:YES];
    
}
/// 0:视频 1:喜欢 2:关注 3:粉丝
- (void)infoCell:(MineInfoTableCell *)infoCell selectedForItemAtIndex:(NSInteger)index {
    if (index == 0) {
        [self.navigationController pushViewController:[[MyShortVideoListViewController alloc] init] animated:YES];
    }
    if (index == 1) {
        [self.navigationController pushViewController:[[MyLikeVideoListViewController alloc] init] animated:YES];
    }
    if (index > 1) {/// 关注/粉丝
        UserListDetailViewController *userList = [[UserListDetailViewController alloc] init];
        userList.detailType = index%2;
        [self.navigationController pushViewController:userList animated:YES];
    }
}
/// 点击设置
- (void)infoCell:(MineInfoTableCell *)infoCell selectedForSetting:(id)sender {
    [self.navigationController pushViewController:[[SettingViewController alloc]init] animated:YES];
//    SettingViewController *settingVC = [[SettingViewController alloc]init];
////    settingVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:settingVC animated:YES];
}

/// 点击邀请好友
- (void)infoCell:(MineInfoTableCell *)infoCell selectedForInviteFriends:(id)sender {
    WebViewURLViewController *webView = [[WebViewURLViewController alloc] initWithUrlString:[ApiUtil_H5Header h5_inviteFriends]];
//    webView.delegate = self;
    webView.navigationBarTitle = @"邀请好友";
    webView.needSafeAreaBottomHeight = YES;
    webView.isShare = YES;
    [self.navigationController pushViewController:webView animated:YES];
}

/// 点击编辑
- (void)infoCell:(MineInfoTableCell *)infoCell selectedForEdit:(id)sender {
    [self.navigationController pushViewController: [[PersonalDataEditViewController alloc] init] animated:YES];
}

///点击认证
- (void)infoCell:(MineInfoTableCell *)infoCell selectedForAuth:(id)sender {
    [self.navigationController pushViewController:[[IdentifyViewController alloc] init] animated:YES];
}

- (void)infoCell:(MineInfoTableCell *)infoCell selectedForArtManage:(nonnull id)sender {
    [self.navigationController pushViewController:[[ArtManagerPageViewController alloc] init] animated:YES];
}

#pragma mark - MineOrderItemDelegate
/// index 0:待付款 1:待发货 2:待收货 3:已完成 4:退货
- (void)orderCell:(MineOrderItemTableCell *)walletCell didSelectedOrderCellWithIndex:(NSInteger)index {
    MyBuyViewController *buyVC  = [[MyBuyViewController alloc] init];
    buyVC.pageIndex = index + 1;
    [self.navigationController pushViewController:buyVC animated:YES];
}

- (void)orderCell:(MineOrderItemTableCell *)walletCell didSelectedToAll:(id)sender {
    [self.navigationController pushViewController:[[MyBuyViewController alloc] init] animated:YES];
}

#pragma mark - PersonalWalletItemDelegate
- (void)walletCell:(PersonalWalletTableViewCell *)walletCell didSelectedWalletItemWithIndex:(NSInteger)index {
    if (index == 0) {
        /// 我的钱包
        WalletViewController *itemVC = [[WalletViewController alloc] init];
        itemVC.style = AMWalletItemStyleRevenue;
        [self.navigationController pushViewController:itemVC animated:YES];
    }
    if (index == 1) {///预估收益
        WalletEstimateViewController *estimate = [[WalletEstimateViewController alloc] init];
        estimate.style = AMWalletItemStyleEstimateProfit;
        estimate.estimateMoney = self.userModel.pre_reward_money;
        [self.navigationController pushViewController:estimate animated:YES];
    }
    if (index == 2) {
        /// 积分
        SingleAMAlertView * alertView = [SingleAMAlertView shareInstance];
        alertView.title = @"积分商城敬请期待";
        [alertView show];
    }
    
}

- (void)walletCell:(PersonalWalletTableViewCell *)walletCell didSelectedToAccount:(id)sender {
    if ([UserInfoManager shareManager].isAuthed) {
        ReceivableListViewController *receivablelistVC = [[ReceivableListViewController alloc] init];
        receivablelistVC.receiveType = 0;
        [self.navigationController pushViewController:receivablelistVC animated:YES];
    }else {
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
    }
}

#pragma mark - MineMeetingItemDelegate
- (void)meetingCell:(MineMeeingItemTableCell *)meetingCell didSelectedMeetingItemWithIndex:(NSInteger)index {
    if (index == 0) {/// 会客
        [self.navigationController pushViewController:[[HK_TeaMeetingRecordVC alloc] init] animated:YES];
    }
    if (index == 1) {/// 约见
        AMMeetingRecordManageViewController *recordVC = [[AMMeetingRecordManageViewController alloc] init];
        recordVC.style = AMMeetingRecordManageStyleRecord;
        [self.navigationController pushViewController:recordVC animated:YES];
    }
}


#pragma mark - MineAuctionItemDelegate
- (void)auctionCell:(MineAuctionItemTableCell *)auctionCell didSelectedAuctionCellWithIndex:(NSInteger)index {
    if (index == 0) {/// 未结拍品
        [self.navigationController pushViewController:[[AMAuctionShoppingCartViewController alloc] init] animated:YES];
    }
    if (index == 1) {/// pm订单
        [self.navigationController pushViewController:[[AMAuctionOrderViewController alloc] init] animated:YES];
    }
    if (index == 2) {/// 参拍记录
        [self.navigationController pushViewController:[[AMAuctionRecordViewController alloc] init] animated:YES];
    }
    if (index == 3) {/// 保证金
        [self.navigationController pushViewController:[[MyAuctionMoneyController alloc] init] animated:YES];
    }
}

#pragma mark - WebViewURLViewControllerDelegate
- (void)webViewDidSelectedJSForShare:(NSInteger)shareType {
    NSDictionary *params = @{@"title":@"邀请好友",
                             @"des":@"艺术融媒体全新上线来这里，和我们一起“搞艺术",
                             @"img":@"logo",
                             @"url":[ApiUtil_H5Header h5_registerWith:[ToolUtil isEqualToNonNullKong:_userModel.userData.invitation_code]]
    };
    [[WechatManager shareManager] wxSendReqWithScene:shareType?AMShareViewItemStyleWXFriend:AMShareViewItemStyleWX withParams:params];
}

- (void)webViewDidSelectedJSForSaveImage:(id _Nullable)imageData {
    if (imageData) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        UIAlertAction *save = [UIAlertAction actionWithTitle:@"保存" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            NSURL *baseImageUrl = [NSURL URLWithString:imageData];
            NSData *imageData = [NSData dataWithContentsOfURL:baseImageUrl];
            UIImage *image = [UIImage imageWithData:imageData];
//            [self calulateImageFileSize:image];
            if (image) {
                UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinshSavingWithError:contextInfo:), NULL);
            }
        }];
        [alert addAction:cancel];
        [alert addAction:save];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

// 保存图片错误提示方法
- (void)image:(UIImage *)image didFinshSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *mes = nil;
    if (error != nil) {
        mes = @"保存图片失败";
    } else {
        mes = @"保存图片成功";
    }
    SingleAMAlertView *alert = [SingleAMAlertView shareInstance];
    alert.title = mes;
    [alert show];
}

#pragma mark - parvite
/// 更新用户背景图
- (void)updateBackImg:(NSArray *)imageUrls {
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"uid"] = [UserInfoManager shareManager].uid;
    params[@"back_img"] = [ToolUtil isEqualToNonNullKong:imageUrls.lastObject];
    
    @weakify(self);
    [ApiUtil postWithParent:self url:[ApiUtilHeader editUserInfo] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        
        [SVProgressHUD showSuccess:@"修改成功。图片加载可能回延迟，请稍候..." completion:^{
            [[UserInfoManager shareManager] updateUserDataWithKey:@"back_img" value:imageUrls.lastObject complete:^(UserInfoModel * _Nullable model) {
                @strongify(self);
                self.userModel.userData = model;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
                });
            }];
        }];
    } fail:nil];
}


#pragma mark - NetData
- (void)loadData:(id)sender {
    self.tableView.allowsSelection = NO;
    NSMutableDictionary *param = [NSMutableDictionary new];
    param[@"uid"] = [UserInfoManager shareManager].uid;
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader getUserInfo] needHUD:NO params:param.copy success:^(NSInteger code, id  _Nullable response) {
        [self.tableView endAllFreshing];
        
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            _userModel = [CustomPersonalModel yy_modelWithDictionary:data];
            ///更新用户数据
            [[UserInfoManager shareManager] updateUserDataWithModel:_userModel.userData complete:nil];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
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
