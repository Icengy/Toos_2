//
//  PersonalHomepageViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/5.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "PersonalHomepageViewController.h"

#import "TYTabButtonPagerController.h"
#import "PersonalListViewController.h"
#import "MessageViewController.h"
#import "SettingViewController.h"
#import "AdressViewController.h"
#import "GiftRecordViewController.h"
#import "ReceivableListViewController.h"
#import "MyOrderViewController.h"
//#import "CustomPersonalViewController.h"
#import "AMBaseUserHomepageViewController.h"
#import "AMPayViewController.h"
#import "PhoneAuthViewController.h"
#import "FaceRecognitionViewController.h"
//#import "AMMeetingDetailViewController.h"
#import "AMMeetingCreateViewController.h"
#import "HK_Tea_ManagerVC.h"

#import "InviteNewViewController.h"

#import "WalletViewController.h"

#import "PersonalDataEditViewController.h"
#import "UserListViewController.h"
#import "IdentifyViewController.h"

#import "PersonalInfoTableViewCell.h"
#import "PersonalWalletTableViewCell.h"
#import "PersonalMenuTableViewCell.h"
#import "EmptyTableViewCell.h"

#import "PersonalListTitleView.h"

#import "AMDialogView.h"
#import "AMShareView.h"

#import "CustomPersonalModel.h"

#import "WechatManager.h"

#import "HK_TeaMeetingRecordVC.h"
#define PersonalItemContentSectionHeight  (K_Height - TabBar_Height- StatusNav_Height - SafeAreaBottomHeight - 44.0f)

@interface PersonalHomepageViewController () <UIScrollViewDelegate ,
            PersonalInfoItemDelegate,
            PersonalMenuItemDelegate>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (nonatomic ,strong) NSArray *dataArray;
@property (nonatomic ,strong) PersonalListTitleView *headerView;

@property (nonatomic ,strong) CustomPersonalModel *userModel;

@end

@implementation PersonalHomepageViewController {
    BOOL _barHidden;
}

- (PersonalListTitleView *)headerView {
    if (_headerView) return _headerView;
    _headerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PersonalListTitleView class]) owner:self options:nil].lastObject;
    _headerView.insets = UIEdgeInsetsMake(0.0f, 10.0f, 0.0, 10.0f);
    _headerView.frame = CGRectMake(0, 0, self.view.width, 44.0f);
    _headerView.dataArray = self.contentTitleArray.mutableCopy;
    @weakify(self);
    _headerView.clickIndexBlock = ^(NSInteger index) {
        @strongify(self);
        self.currentIndex = index;
        [self.contentCarrier moveToControllerAtIndex:self.currentIndex animated:YES];
    };
    return _headerView;
}

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    
    self.currentIndex = 0;
    self.canScroll = YES;
    _barHidden = YES;
    
    _dataArray = [NSMutableArray new];
    self.contentChildArray = [self getContentChildArray].mutableCopy;
    
    self.contentCarrier.delegate = self;
    self.contentCarrier.dataSource = self;
    [self addChildViewController:self.contentCarrier];
    
    self.tableView.multipleGestureEnable = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, SafeAreaBottomHeight + TabBar_Height, 0);
    
    [self.tableView registerClass:[EmptyTableViewCell class] forCellReuseIdentifier:NSStringFromClass([EmptyTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PersonalInfoTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([PersonalInfoTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PersonalWalletTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([PersonalWalletTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PersonalMenuTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([PersonalMenuTableViewCell class])];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self.tableView addRefreshHeaderWithTarget:self action:@selector(getPersonalPageInfo:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:_barHidden animated:NO];
    [self.navigationItem setTitle:@"我的"];
    self.navigationItem.hidesBackButton = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPersonalPageInfo:) name:ReloadDataAfterDelete object:nil];
    
    if (![UserInfoManager shareManager].isLogin) {
        [self jumpToLoginWithBlock:nil];
    }else {
        [self getPersonalPageInfo:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ReloadDataAfterDelete object:nil];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return UITableViewAutomaticDimension;
    }
    if (indexPath.section == 1) {
        return 44.0f*3;
    }
    if (indexPath.section == 2) {
        return 44.0f*2;
    }
    if (indexPath.section == 3) {
        return PersonalItemContentSectionHeight;
    }
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        PersonalInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PersonalInfoTableViewCell class]) forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = _userModel;
        
        return cell;
    }
    if (indexPath.section == 1) {
        PersonalWalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PersonalWalletTableViewCell class]) forIndexPath:indexPath];
//        cell.delegate = self;
        cell.model = _userModel;
        
        return cell;
    }
    if (indexPath.section == 2) {
        PersonalMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PersonalMenuTableViewCell class]) forIndexPath:indexPath];
        cell.delegate = self;
//        cell.model = _userModel;
        
        return cell;
    }
    EmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EmptyTableViewCell class]) forIndexPath:indexPath];
    
    cell.insets = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f);
    cell.corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
    cell.cornersRadii = AMCellcornersRadiusDefault;
    cell.contentCarrier = self.contentCarrier.view;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1 || section == 2) {
        return 10.0f;
    }
    if (section == 3) {
        return 44.0f;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        self.headerView.dataArray = self.contentTitleArray.copy;
        return self.headerView;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 10.0f;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    ///隐藏导航栏
    _barHidden = YES;
    if (offsetY >= StatusNav_Height) {
        _barHidden = NO;
    }
    [self.navigationController setNavigationBarHidden:_barHidden animated:YES];
    
    CGFloat bottomCellOffset = [self.tableView rectForSection:self.tableView.numberOfSections - 1].origin.y - StatusNav_Height;
    [self tableViewDidScroll:scrollView bottomCellOffset:bottomCellOffset];
}

#pragma mark - BaseItemViewController
- (void)itemListController:(BaseItemViewController *)listVC scrollToTopOffset:(BOOL)scrollTop {
    [self tableViewScrollToTopOffset];
}

#pragma mark - TYPagerController
- (NSArray *)getContentChildArray {
    self.contentTitleArray = [self getContentTitleArray].mutableCopy;
    
    NSMutableArray *customArray = [NSMutableArray new];
    for (int i = 0; i < self.contentTitleArray.count; i ++) {
        PersonalListViewController *listVC = [[PersonalListViewController alloc] init];
        listVC.delegate = self;
        switch (i) {
            case 0:
                listVC.listType = PersonalControllerListTypeMineVideo;
                break;
            case 1:
                listVC.listType = PersonalControllerListTypeMineCollection;
                break;
            case 2:
                listVC.listType = PersonalControllerListTypeMineDraft;
                break;
            default:
                break;
        }
        listVC.userID = [UserInfoManager shareManager].uid;
        [customArray insertObject:listVC atIndex:customArray.count];
    }
    return customArray;
}

- (NSArray *)getContentTitleArray {
    return @[@"视频", @"喜欢", @"草稿"];
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
    NSLog(@"didScrollToTabPageIndex - %@",@(index));
    self.currentIndex = index;
    _headerView.currentIndex = self.currentIndex;
}

#pragma mark - PersonalItemDelegate
#pragma mark ----
//- (void)didSelectedMenuItemWithIndex:(PersonalMenuItemIndex)index {
//    NSLog(@"didSelectedMenuItemWithIndex = %@",@(index));
//    switch (index) {
//        case PersonalMenuItemIndexOrder://我的订单
//            [self.navigationController pushViewController:[[MyOrderViewController alloc] init] animated:YES];
//            break;
//        case PersonalMenuItemIndexAccount: {//收款账户
//            if ([UserInfoManager shareManager].isAuthed) {
//                ReceivableListViewController *receivablelistVC = [[ReceivableListViewController alloc] init];
//                receivablelistVC.receiveType = 0;
//                [self.navigationController pushViewController:receivablelistVC animated:YES];
//            }else {
//                AMAuthDialogView *dialogView = [AMAuthDialogView shareInstance];
//                @weakify(dialogView);
//                dialogView.imageSelectedBlock = ^(AMImageSelectedMeidaType meidaType) {
//                    @strongify(dialogView);
//                    [dialogView hide];
//                    if (meidaType) {
//                        [self.navigationController pushViewController:[[PhoneAuthViewController alloc] init] animated:YES];
//                    }else {
//                        [self.navigationController pushViewController:[[FaceRecognitionViewController alloc] init] animated:YES];
//                    }
//                };
//                [dialogView show];
//            }
//            break;
//        }
//        case PersonalMenuItemIndexGift: {//礼物记录
////            [self.navigationController pushViewController:[[GiftRecordViewController alloc] init] animated:YES];
//        }
//        case PersonalMenuItemIndexAuth: {//邀请认证
//            AMShareView *shareView = [AMShareView shareInstanceWithStyle:AMShareViewStyleInvite];
//            NSDictionary *params = @{@"title":@"邀请好友",
//                                     @"des":@"艺术融媒体全新上线来这里，和我们一起“搞艺术",
//                                     @"img":@"logo",
//                                     @"url":[NSString stringWithFormat:@"http://wechat.ysrmt.cn/official/#/register?uid=%@&invitation_code=%@",[UserInfoManager shareManager].uid, [UserInfoManager shareManager].invitation_code]
//            };
//            shareView.params = params;
//            [shareView show];
//            break;
//        }
//        case PersonalMenuItemIndexAddress: {//地址管理
//            [self.navigationController pushViewController:[[AdressViewController alloc] init] animated:YES];
//            break;
//        }
//
//        default:
//            break;
//    }
//}

#pragma mark ----
- (void)didSelectedWalletItemWithIndex:(AMWalletItemStyle)index {
    NSLog(@"didSelectedWalletItemWithIndex = %@",@(index));
    switch (index) {
        case AMWalletItemStyleBalance: //余额
        case AMWalletItemStyleRevenue: //收入
        case AMWalletItemStyleYiB:  {//艺币
            WalletViewController *itemVC = [[WalletViewController alloc] init];
            itemVC.style = index;
            [self.navigationController pushViewController:itemVC animated:YES];
            break;
            break;
        }
        case AMWalletItemStyleIntegral: {//积分
            SingleAMAlertView * alertView = [SingleAMAlertView shareInstance];
            alertView.title = @"积分商城敬请期待";
            [alertView show];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark ----
/// 更换个人首页背景
- (void)didSelectedInfoItemForChangeBg:(id)sender {
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
- (void)didSelectedInfoItemForLogo:(id)sender {
//    CustomPersonalViewController *personalVC = [CustomPersonalViewController shareInstance];
//    personalVC.artuid = [UserInfoManager shareManager].uid;
//    [self.navigationController pushViewController:personalVC animated:YES];
    
    AMBaseUserHomepageViewController * vc = [[AMBaseUserHomepageViewController alloc] init];
    vc.artuid = [UserInfoManager shareManager].uid;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 编辑信息
- (void)didSelectedInfoItemForEditInfo:(id)sender {
    [self.navigationController pushViewController: [[PersonalDataEditViewController alloc] init] animated:YES];
}

/// 设置
- (void)didSelectedInfoItemForSetting:(id)sender {
    [self.navigationController pushViewController:[[SettingViewController alloc]init] animated:YES];
}

/// 消息中心
- (void)didSelectedInfoItemForMessage:(id)sender {
    [self.navigationController pushViewController: [[MessageViewController alloc] init] animated:YES];
}

/// 邀新
- (void)didSelectedInfoItemForInvite:(id)sender {
    [self.navigationController pushViewController:[[InviteNewViewController alloc] init] animated:YES];
}

/// 认证
- (void)didSelectedInfoItemForIdentify:(id)sender {
    [self.navigationController pushViewController:[[IdentifyViewController alloc] init] animated:YES];
}

/// 保证金
- (void)didSelectedInfoItemForBond:(id)sender  {
    
}

/// 查看点赞数量
- (void)didSelectedInfoItemForThumbs:(id)sender {
    AMThumbsDialogView *dialogView = [AMThumbsDialogView shareInstance];
    dialogView.thumbsCount = _userModel.userData.like_num.integerValue;
    [dialogView show];
}

/// 关注列表
- (void)didSelectedInfoItemForFollow:(id)sender {
    UserListViewController *userList = [[UserListViewController alloc] init];
    userList.detailType = 0;
    [self.navigationController pushViewController:userList animated:YES];
}

/// 粉丝列表
- (void)didSelectedInfoItemForFans:(id)sender {
    UserListViewController *userList = [[UserListViewController alloc] init];
    userList.detailType = 1;
    [self.navigationController pushViewController:userList animated:YES];
}

#pragma mark--------会客跳转
- (void)jumpTea_Meetting_Record {
    HK_TeaMeetingRecordVC *vc=[[HK_TeaMeetingRecordVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpTea_Meetting_Create {
    [self.navigationController pushViewController:[[AMMeetingCreateViewController alloc] init] animated:YES];
}

- (void)jumpTea_Meetting_Detail {
    [self.navigationController pushViewController:[[HK_Tea_ManagerVC alloc] init] animated:YES];
}

#pragma mark - parvite
/// 更新用户背景图
- (void)updateBackImg:(NSArray *)imageUrls {
//    NSMutableDictionary *params = [NSMutableDictionary new];
//    UserInfoModel *model = [UserInfoManager shareManager].model;
//    params[@"uid"] = [ToolUtil isEqualToNonNullKong:model.id];
//    params[@"back_img"] = [ToolUtil isEqualToNonNullKong:imageUrls.lastObject];
//
//    [ApiUtil postWithParent:self url:[ApiUtilHeader editUserInfo] params:params.copy success:^(NSInteger code, id  _Nullable response) {
//        model.back_img = imageUrls.lastObject;
//        [[UserInfoManager shareManager] updateUserDataWithModel:model];
//        self.userModel.userData.back_img = imageUrls.lastObject;
//        [SVProgressHUD showSuccess:@"修改成功。图片加载可能回延迟，请稍候..." completion:^{
//            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
//        }];
//    } fail:nil];
}

#pragma mark - NetData
- (void)getPersonalPageInfo:(id)sender {
    self.tableView.allowsSelection = NO;
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    param[@"uid"] = [UserInfoManager shareManager].uid;
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader getUserInfo] needHUD:NO params:param.copy success:^(NSInteger code, id  _Nullable response) {
        [self.tableView endAllFreshing];
        
//        if (!_userModel) _userModel = [CustomPersonalModel new];
//        _userModel = [CustomPersonalModel yy_modelWithJSON:response[@"data"]];
//        ///更新用户数据
//        [[UserInfoManager shareManager] updateUserDataWithModel:_userModel.userData];
//
//        NSString *videoTitle = [NSString stringWithFormat:@"视频%@",[ToolUtil isEqualToNonNull:_userModel.videoDataCount replace:@"0"]];
//        NSString *collectionTitle = [NSString stringWithFormat:@"喜欢%@",[ToolUtil isEqualToNonNull:_userModel.collectDataCount replace:@"0"]];
//        NSString *draftsTitle = [NSString stringWithFormat:@"草稿%@",[ToolUtil isEqualToNonNull:_userModel.draftsDataCount replace:@"0"]];
//        self.contentTitleArray = @[videoTitle, collectionTitle, draftsTitle].mutableCopy;
//
//        [self.tableView reloadData];
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
