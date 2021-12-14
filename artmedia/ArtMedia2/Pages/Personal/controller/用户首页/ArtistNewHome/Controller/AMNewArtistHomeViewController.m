//
//  AMNewArtistHomeViewController.m
//  ArtMedia2
//
//  Created by 刘洋 on 2020/9/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMNewArtistHomeViewController.h"

#import "AMNewArtistMainSubViewController.h"
#import "AMNewArtistReceptionSubViewController.h"
#import "AMNewArtistVideoSubViewController.h"
#import "AMMeetingSettingViewController.h"
#import "PersonalDataEditViewController.h"
#import "HK_appointmentDetailVC.h"
#import "AMMeetingOrderViewController.h"
#import "AMNewArtistCourseViewController.h"

#import "ArtistHeadCell.h"
#import "ArtistSubTableViewCell.h"
#import "AMDialogView.h"
#import "PersonalListTitleView.h"

#import "CustomPersonalModel.h"
#import "AMNewArtistTimeLineModel.h"

@interface AMNewArtistHomeViewController ()<UITableViewDelegate , UITableViewDataSource , ArtistHeadCellDelegate > {
    NSString *_orderBtnStatus , *_teaAboutOrderId;
    CGFloat _naviAlpha;
    NSMutableArray <AMNewArtistTimeLineModel *>*_meetingData;
}
@property (weak, nonatomic) IBOutlet UIView *customNavigationBar;
@property (weak, nonatomic) IBOutlet AMButton *moreButton;

@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (nonatomic , strong) PersonalListTitleView *headerView;

@property (nonatomic , strong) CustomPersonalModel *userModel;

@property (nonatomic , strong) AMNewArtistMainSubViewController *mainVC;
@property (nonatomic , strong) AMNewArtistReceptionSubViewController *meetingVC;
@property (nonatomic , strong) AMNewArtistVideoSubViewController *videosVC;
@property (nonatomic , strong) AMNewArtistCourseViewController *courseVC;
@property (weak, nonatomic) IBOutlet UILabel *navTitleLabel;

@end

@implementation AMNewArtistHomeViewController

- (PersonalListTitleView *)headerView {
    if (_headerView) return _headerView;
    _headerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PersonalListTitleView class]) owner:self options:nil].lastObject;
    _headerView.insets = UIEdgeInsetsZero;
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
- (CustomPersonalModel *)userModel{
    if (!_userModel) {
        _userModel = [[CustomPersonalModel alloc] init];
    }
    return _userModel;
}

- (AMNewArtistMainSubViewController *)mainVC {
    if (!_mainVC) {
        _mainVC = [[AMNewArtistMainSubViewController alloc] init];
        _mainVC.delegate = self;
        @weakify(self);
        _mainVC.clickForMoreVideosBlock = ^{
            @strongify(self);
            [self.contentCarrier moveToControllerAtIndex:2 animated:YES];
        };
    }return _mainVC;
}

- (AMNewArtistReceptionSubViewController *)meetingVC {
    if (!_meetingVC) {
        _meetingVC = [[AMNewArtistReceptionSubViewController alloc] init];
        _meetingVC.delegate = self;
        _meetingVC.artistID = self.artuid;
    }return _meetingVC;
}

- (AMNewArtistVideoSubViewController *)videosVC {
    if (!_videosVC) {
        _videosVC = [[AMNewArtistVideoSubViewController alloc] init];
        _videosVC.delegate = self;
        _videosVC.artistID = self.artuid;
    }return _videosVC;
}
- (AMNewArtistCourseViewController *)courseVC{
    if (!_courseVC) {
        _courseVC = [[AMNewArtistCourseViewController alloc] init];
        _courseVC.delegate = self;
        _courseVC.artistID = self.artuid;
    }
    return _courseVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.canScroll = YES;
    _naviAlpha = 0.0f;
    _meetingData = @[].mutableCopy;
    
    self.contentTitleArray = @[@"主页",@"会客",@"视频",@"课程"].mutableCopy;
    self.contentChildArray = @[self.mainVC, self.meetingVC, self.videosVC, self.courseVC].mutableCopy;
    
    self.contentCarrier.barStyle = TYPagerBarStyleProgressView;
    self.contentCarrier.contentTopEdging = 0;
    self.contentCarrier.collectionLayoutEdging = ADAptationMargin;
    self.contentCarrier.cellWidth = (K_Width - ADAptationMargin*(self.contentChildArray.count + 1))/self.contentChildArray.count;
    self.contentCarrier.cellSpacing = ADAptationMargin;
    
    self.contentCarrier.progressHeight = 3;
    self.contentCarrier.normalTextFont = [UIFont addHanSanSC:14.0f fontType:0];
    self.contentCarrier.selectedTextFont = [UIFont addHanSanSC:14.0f fontType:0];
    self.contentCarrier.progressColor = Color_MainBg;
    self.contentCarrier.normalTextColor = UIColorFromRGB(0x999999);
    self.contentCarrier.selectedTextColor = Color_Black;
    
    self.contentCarrier.delegate = self;
    self.contentCarrier.dataSource = self;
    [self addChildViewController:self.contentCarrier];
    
    [self setTableView];
}

- (void)setTableView{
    
    self.tableView.multipleGestureEnable = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ArtistHeadCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ArtistHeadCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ArtistSubTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ArtistSubTableViewCell class])];
    if ([ToolUtil isEqualOwner:self.artuid]) {
        [self.moreButton setImage:[UIImage imageNamed:@"artist_home_image"] forState:UIControlStateNormal];
    }else{
        [self.moreButton setImage:[UIImage imageNamed:@"artist_home_more"] forState:UIControlStateNormal];
    }
    [self.tableView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.barStyle = UIStatusBarStyleLightContent;
    
    [self loadData:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.barStyle = UIStatusBarStyleDefault;
}

#pragma mark - BaseItemViewController
- (void)itemListController:(BaseItemViewController *)listVC scrollToTopOffset:(BOOL)scrollTop {
    [self tableViewScrollToTopOffset];
}

#pragma mark - TYPagerControllerDataSource
- (NSInteger)numberOfControllersInPagerController {
    return self.contentChildArray.count;
}

- (NSString *)pagerController:(TYPagerController *)pagerController titleForIndex:(NSInteger)index{
    return self.contentTitleArray[index];
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index {
    return self.contentChildArray[index];
}

- (void)pagerController:(TYTabPagerController *)pagerController didScrollToTabPageIndex:(NSInteger)index {
    NSLog(@"didScrollToTabPageIndex - %@",@(index));
    
    self.currentIndex = index;
    self.headerView.currentIndex = self.currentIndex;
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ArtistHeadCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ArtistHeadCell class]) forIndexPath:indexPath];
        
        cell.model = self.userModel;
        cell.delegate = self;
        cell.orderStatus = [_orderBtnStatus integerValue];
        cell.coverView.backgroundColor = [Color_Black colorWithAlphaComponent:_naviAlpha];
        return cell;
    }else{
        ArtistSubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ArtistSubTableViewCell class]) forIndexPath:indexPath];
        cell.contentCarrier = self.contentCarrier.view;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0)
        return UITableViewAutomaticDimension;
    return K_Height - StatusNav_Height - SafeAreaBottomHeight - 15.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) return 44.0f;
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section ==1) return self.headerView;
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"%f",offsetY);
    ArtistHeadCell *cell = (ArtistHeadCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    _naviAlpha = offsetY/cell.height;
    cell.coverView.backgroundColor = [Color_Black colorWithAlphaComponent:_naviAlpha];
 
    CGFloat bottomCellOffset = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]].origin.y - 44.0f - 15.0f - StatusNav_Height;
    [self tableViewDidScroll:scrollView bottomCellOffset:bottomCellOffset];
    NSLog(@"%f",bottomCellOffset);
    
    self.navTitleLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:_naviAlpha];
    self.navTitleLabel.text = self.userModel.userData.username;
//    if (offsetY == bottomCellOffset) {
//
//    }else{
//        self.navTitleLabel.text = @"";
//    }
}

#pragma mark - ArtistHeadCellDelegate
- (void)headButtonClick:(ArtistHeadCell *)cell buttonTitle:(NSString *)title{
    if ([title isEqualToString:@"约见设置"]) {
        [self.navigationController pushViewController:[[AMMeetingSettingViewController alloc] init] animated:YES];
    }else if([title isEqualToString:@"编辑资料"]){
        [self.navigationController pushViewController: [[PersonalDataEditViewController alloc] init] animated:YES];
    }else if([title isEqualToString:@"+关注"]){
        if (![UserInfoManager shareManager].isLogin) {
            [self jumpToLoginWithBlock:nil];
            return;
        }
        [self clickToFollow:nil];
    }else if([title isEqualToString:@"约见"]) {
        if (![UserInfoManager shareManager].isLogin) {
            [self jumpToLoginWithBlock:nil];
            return;
        }
        
        AMMeetingOrderViewController *orderVC = [[AMMeetingOrderViewController alloc] init];
        orderVC.artuid = self.artuid;
        [self.navigationController pushViewController:orderVC animated:YES];
    }else if([title isEqualToString:@"待约见"]){
        if (![UserInfoManager shareManager].isLogin) {
            [self jumpToLoginWithBlock:nil];
            return;
        }
        if ([_orderBtnStatus integerValue] == 4) {
            HK_appointmentDetailVC * vc = [[HK_appointmentDetailVC alloc] init];
            vc.teaAboutOrderId = _teaAboutOrderId;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if([title isEqualToString:@"已关注"]){
        if (![UserInfoManager shareManager].isLogin) {
            [self jumpToLoginWithBlock:nil];
            return;
        }
        [self clickToFollow:nil];
    }
}


- (void)clickToFollow:(AMButton *)sender {
    if ([ToolUtil isEqualOwner:_userModel.userData.id]) {
        AMAlertView *alertView = [AMAlertView shareInstanceWithTitle:@"无法关注自己" buttonArray:@[@"确定"] confirm:nil cancel:nil];
        [alertView show];
        return;
    }
    if (_userModel.userData.is_collect) {
        AMAlertView *alert = [AMAlertView shareInstanceWithTitle:@"是否取消关注？" buttonArray:@[ @"是", @"否"] confirm:^{
            [self clickToCollect:nil];
        } cancel:nil];
        [alert show];
    }else {
        [self clickToCollect:nil];
    }
}

static void extracted(AMNewArtistHomeViewController *object, NSMutableDictionary *params) {
    [ApiUtil postWithParent:object url:[ApiUtilHeader collectUser] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        NSString *keyword = nil;
        if (!object->_userModel.userData.is_collect) {
            keyword = @"关注成功";
        }else {
            keyword = @"取消关注成功";
        }
        [SVProgressHUD showSuccess:keyword];
        object->_userModel.userData.is_collect = !object->_userModel.userData.is_collect;
        [object.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:(UITableViewRowAnimationAutomatic)];
        //        [self updateNaviData];
        [object loadData:nil];
    } fail:nil];
}

- (void)clickToCollect:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"uid"] = [UserInfoManager shareManager].uid;
    params[@"collect_uid"] = [ToolUtil isEqualToNonNullKong:self.artuid];
    
    extracted(self, params);
}

#pragma mark -
- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)moreClick:(UIButton *)sender {
    //YES就是本人，否则不是本人
    if ([ToolUtil isEqualOwner:self.artuid]) {
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
    }else{
        NSString *title = @"拉入黑名单";
        if (_userModel.userData.is_blacklist) title = @"移除黑名单";
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        UIAlertAction *opeationAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self clickToMore:nil];
        }];
        
        [alert addAction:cancelAction];
        [alert addAction:opeationAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

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

- (void)clickToMore:(id _Nullable)sender {
    if ([ToolUtil isEqualOwner:_userModel.userData.id]) {
        AMAlertView *alertView = [AMAlertView shareInstanceWithTitle:@"无法拉黑自己" buttonArray:@[@"确定"] confirm:nil cancel:nil];
        [alertView show];
        return;
    }
    if (!_userModel.userData.is_blacklist) {
        AMAlertView *alert = [AMAlertView shareInstanceWithTitle:@"确认拉黑该用户" message:@"拉黑该用户后，将自动取消对他的关注，并且不再收到他的相关视频推荐。" buttonArray:@[@"确定", @"取消"] alertType:AMAlertTypeNormal confirm:^{
            [self clickToBlacklist:nil];
        } cancel:nil];
        [alert show];
    }else {
        [self clickToBlacklist:nil];
    }
}
- (void)clickToBlacklist:(id _Nullable)sender {
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    params[@"uid"] = [UserInfoManager shareManager].uid;
    params[@"type"] = @"3";
    params[@"objtype"] = @"6";
    params[@"objid"] = [ToolUtil isEqualToNonNullKong:self.artuid];
 
    [ApiUtil postWithParent:self url:[ApiUtilHeader collectObject] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        NSString *keyword = nil;
        if (_userModel.userData.is_blacklist) {
            keyword = @"已移除黑名单";
        }else {
            keyword = @"已拉入黑名单";
        }
        [SVProgressHUD showSuccess:keyword];
        _userModel.userData.is_blacklist = !_userModel.userData.is_blacklist;
        _userModel.userData.is_collect = NO;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:(UITableViewRowAnimationAutomatic)];
        [self updateNaviData];
    } fail:nil];
}

- (void)updateNaviData {
    if (!self.navigationItem.title) {
        [self.navigationItem setTitle:[ToolUtil isEqualToNonNullKong:_userModel.userData.username]];
    }
    self.navigationItem.rightBarButtonItem = nil;
    if (![ToolUtil isEqualOwner:_userModel.userData.id] && !_userModel.userData.is_blacklist) {
//        self.navigationItem.rightBarButtonItem = [self rightItemBtn];
    }
}

#pragma mark -
- (void)loadData:(id)sender {
    self.tableView.allowsSelection = NO;
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("mine", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        
        NSMutableDictionary *param = [NSMutableDictionary new];
        param[@"uid"] = [UserInfoManager shareManager].uid;
        param[@"artuid"] = self.artuid;
        [ApiUtil postWithParent:self url:[ApiUtilHeader getOtherUserInfo] needHUD:NO params:param.copy success:^(NSInteger code, id  _Nullable response) {
            
            NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
            if (data && data.count) {
                self.userModel = [CustomPersonalModel yy_modelWithDictionary:data];
//                self.navTitleLabel.text = self.userModel.userData.username;
            }
            
            dispatch_group_leave(group);
        } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        NSMutableDictionary *param = [NSMutableDictionary new];
        param[@"optUserId"] = self.artuid;
        [ApiUtil postWithParent:self url:[ApiUtilHeader selectInfoLogByArtId] needHUD:NO params:param.copy success:^(NSInteger code, id  _Nullable response) {
            
            NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
            if (data && data.count) {
                NSArray *records = (NSArray *)[data objectForKey:@"records"];
                if (records && records.count) {
                    if (![sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
                        if (_meetingData.count) [_meetingData removeAllObjects];
                    }
                    [_meetingData addObjectsFromArray:[NSArray yy_modelArrayWithClass:[AMNewArtistTimeLineModel class] json:records]];
                }
            }
            dispatch_group_leave(group);
        } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        NSMutableDictionary *param = [NSMutableDictionary new];
        param[@"memberId"] = [UserInfoManager shareManager].uid;
        param[@"artistId"] = self.artuid;
        [ApiUtil postWithParent:self url:[ApiUtilHeader getArtTeaStatus] needHUD:NO params:param success:^(NSInteger code, id  _Nullable response) {
            NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
            if (data && data.count) {
                _orderBtnStatus = StringWithFormat([ToolUtil isEqualToNonNull:[data objectForKey:@"showStatus"] replace:@"3"]);
                _teaAboutOrderId = StringWithFormat([data objectForKey:@"teaAboutOrderId"]);
            }
            dispatch_group_leave(group);
        } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            self.userModel.meetingData = _meetingData.copy;
            
            [self.tableView endAllFreshing];
            [self.tableView reloadData];
            
            self.mainVC.userModel = self.userModel;
            
            if ([sender isKindOfClass:[MJRefreshNormalHeader class]]) {
                [self.meetingVC reloadData];
                [self.videosVC reloadData];
                [self.courseVC reloadData];
            }
    });
}

@end
