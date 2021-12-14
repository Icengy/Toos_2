//
//  AMMeetingDetailViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/8/17.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMMeetingDetailViewController.h"

#import "AMMeetingDetailHeaderView.h"
#import "AMMeetingDetailMeetingInfoView.h"
#import "AMMeetingListHeader.h"
#import "AMMeetingMasterManageView.h"
#import "AMMeetingMemberTableCell.h"
#import "EmptyTableViewCell.h"
#import "AMDialogView.h"
#import "AMEmptyView.h"

#import "HK_tea_managerModel.h"
#import "AMMeetingMemberModel.h"

#import "AMMeetingMainViewController.h"
#import "AMBaseUserHomepageViewController.h"
#import "HK_invitationList.h"

#import "UIImage+Extend.h"

@interface AMMeetingDetailViewController () <UITableViewDelegate, UITableViewDataSource, AMMeetingDetailHeaderDelegate, AMMeetingMasterManageViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bgIV;
@property (weak, nonatomic) IBOutlet UIImageView *bgCoverIV;

@property (weak, nonatomic) IBOutlet AMMeetingDetailHeaderView *headerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerView_height_constraint;

@property (weak, nonatomic) IBOutlet AMMeetingDetailMeetingInfoView *infoView;

@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableView_top_constraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableView_bottom_constraint;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

/// 底部栏
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
/// 底部标题
@property (weak, nonatomic) IBOutlet UILabel *stack_titleLabel;
/// 底部按钮
@property (weak, nonatomic) IBOutlet AMButton *stack_mainBtn;

/// 约见报名未截止且未报名
@property (weak, nonatomic) IBOutlet UIView *stack_joinView;
/// 暂不参加
@property (weak, nonatomic) IBOutlet AMButton *stack_nonjoinBtn;
/// 确认参加
@property (weak, nonatomic) IBOutlet AMButton *stack_joinBtn;

@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) AMMeetingMasterManageView *manageView;

@property (nonatomic , strong) HK_tea_managerModel *model;

@property (nonatomic , strong) UIVisualEffectView *blurView;

@end

@implementation AMMeetingDetailViewController {
    CGFloat _alpha, _itemContentSectionHeight;
    /// 倒计时 "开始前1小时～开始前10分钟～开始后2小时"
    double _time_num;
//    HK_tea_managerModel *_model;
    NSArray <AMMeetingMemberModel *>*_memberArray;
    
    /// 参加状态 1:已参加 2:不参加 3:待确认
//    NSInteger _joinedStatus;
    /// 是否满员
    BOOL _hadFull;
    /// 报名是否截止
    BOOL _hadRegisterDeadline;
}

- (AMMeetingMasterManageView *)manageView {
    if (!_manageView) {
        _manageView = [AMMeetingMasterManageView shareInstance];
        _manageView.delegate = self;
        _manageView.model = self.model;
    }return _manageView;
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerCountDown:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }return _timer;
}

- (instancetype) init {
    if (self = [super init]) {
        _alpha = 1.0f;
        _time_num = 0;
        _model = [HK_tea_managerModel new];
        _memberArray = @[];
        _hadFull = NO;
        _hadRegisterDeadline = NO;
    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self setTableView];
    [self setHeaderView];
}

- (void)setUpUI {
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    self.barStyle = UIStatusBarStyleLightContent;
    [self.timer setFireDate:[NSDate distantFuture]];
    
    [self.stack_mainBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xE29220)] forState:UIControlStateNormal];
    [self.stack_mainBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xCCCCCC)] forState:UIControlStateDisabled];
    
    self.bgCoverIV.image = [UIImage boxblurImage:[UIImage imageWithColor:[RGB(247, 247, 247) colorWithAlphaComponent:1.0]] withBlurNumber:0.1];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (void)setTableView{
    self.tableView_bottom_constraint.constant = -SafeAreaBottomHeight;
    self.tableView.bgColorStyle = AMBaseTableViewBackgroundColorStyleWhite;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setTableFooterView:[UIView new]];
    [self.tableView registerClass:[EmptyTableViewCell class] forCellReuseIdentifier:NSStringFromClass([EmptyTableViewCell class])];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMMeetingMemberTableCell class])  bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMMeetingMemberTableCell class])];
    
    [self.tableView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
    self.tableView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadData:)];
}
- (void)setHeaderView {
    self.headerView.delegate = self;
    self.headerView.model = _model;
    self.headerView_height_constraint.constant = StatusNav_Height;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    [self loadData:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.barStyle = UIStatusBarStyleDefault;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _memberArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AMMeetingMemberTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMMeetingMemberTableCell class]) forIndexPath:indexPath];
    cell.style = AMMeetingMemberStyleDefault;
    if (_memberArray.count) cell.model = _memberArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [AMMeetingListHeader shareInstance];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

#pragma mark - UITavleViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    CustomPersonalViewController *personalVC = [CustomPersonalViewController shareInstance];
//    personalVC.artuid = _memberArray[indexPath.row].id;
//    [self.navigationController pushViewController:personalVC animated:YES];
    
    AMBaseUserHomepageViewController * vc = [[AMBaseUserHomepageViewController alloc] init];
    vc.artuid = _memberArray[indexPath.row].id;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    
    _tableView_top_constraint.constant -= offsetY;
    if (_tableView_top_constraint.constant > 10.0f) {/// 最低点
        _tableView_top_constraint.constant = 10.0f;
    }
    if ((_tableView_top_constraint.constant + self.infoView.height) < 0) {///最高点
        _tableView_top_constraint.constant = -self.infoView.height;
    }
    CGFloat constant = _tableView_top_constraint.constant; //(-self.infoView.height ~ 10.0f)->(0.0~1.0)
    _alpha = 1.0f;
    if (constant == -self.infoView.height) {
        _alpha = 0.0f;
    }else if (constant == 10.0f) {
        _alpha = 1.0f;
    }else {
        _alpha = 1.0f - ((10.0f - constant)/self.infoView.height);
    }
    [self updateHeaderUIs];
}

#pragma mark - AMMeetingDetailHeaderDelegate
- (void)headerView:(AMMeetingDetailHeaderView *)header didSelectedBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)headerView:(AMMeetingDetailHeaderView *)header didSelectedFollow:(AMButton *)sender {
    sender.selected = !sender.selected;
    if (header.showDarkStyle) {
        sender.layer.borderColor = sender.selected?UIColorFromRGB(0x999999).CGColor:UIColorFromRGB(0xE22020).CGColor;
    }else {
        sender.layer.borderColor = sender.selected?UIColorFromRGB(0x999999).CGColor:Color_Whiter.CGColor;
    }
}

- (void)headerView:(AMMeetingDetailHeaderView *)header didSelectedUserLogo:(id)sender {
    AMBaseUserHomepageViewController * vc = [[AMBaseUserHomepageViewController alloc] init];
    vc.artuid = self.model.ID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)headerView:(AMMeetingDetailHeaderView *)header didSelectedManage:(nonnull id)sender {
    if ([TimeTool getDifferenceSinceDateStr:_model.teaStartTime] > 0) {
        self.manageView.style = AMMeetingMasterManageStyleDetault;
    }else
        self.manageView.style = AMMeetingMasterManageStyleHadBegin;
    self.manageView.model = self.model;
    [self.manageView show];
}

#pragma mark - AMMeetingMasterManageViewDelegate
- (void)manageView:(AMMeetingMasterManageView *)manageView didSelectedItemForInviteList:(id)sender {
    @weakify(self);
    [manageView hide:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            NSLog(@"%@",_model.ID);
            HK_invitationList *inviteList = [[HK_invitationList alloc] init];
            inviteList.meetingid = _model.teaAboutInfoId;
            [self.navigationController pushViewController:inviteList animated:YES];
        });
    }];
}

- (void)manageView:(AMMeetingMasterManageView *)manageView didSelectedItemForMeetingCancel:(id)sender {
    @weakify(self);
    [manageView hide:^{
        @strongify(self);
        [self showDialogView:AMMeetingEditCancelDialogCancel];
    }];
}

- (void)manageView:(AMMeetingMasterManageView *)manageView didSelectedItemForEdit:(id)sender {
    @weakify(self);
    [manageView hide:^{
        @strongify(self);
        [self showDialogView:AMMeetingEditCancelDialogEdit];
    }];
}

- (void)showDialogView:(AMMeetingEditCancelDialogStyle)style {
    AMMeetingEditCancelDialogView *dialogView = [AMMeetingEditCancelDialogView shareInstance];
    dialogView.style = style;
    @weakify(self);
    dialogView.meetingInfoBlock = ^(NSString * _Nullable reason) {
        @strongify(self);
        if ([ToolUtil isEqualToNonNull:reason]) {
            if (style) {
                [self clickToCancel:reason];
            }else {
                [self clickToEdit:reason];
            }
        }else [SVProgressHUD showMsg:style?@"取消原因不能为空":@"会客说明不能为空"];
    };
    [dialogView show];
}

#pragma mark - 网络请求
- (void)clickToCancel:(NSString *)reason {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"teaAboutInfoId"] = _model.teaAboutInfoId;
    params[@"cancelReason"] = reason;
    params[@"infoStatus"] = StringWithFormat(@(_model.infoStatus));
    
    @weakify(self);
    [ApiUtil putWithParent:self url:[ApiUtilHeader cancelMeetingParty] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [SVProgressHUD showSuccess:[response objectForKey:@"msg"] completion:^{
            @strongify(self);
            [self loadData:nil];
        }];
    } fail:nil];
}

- (void)clickToEdit:(NSString *)reason {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"teaAboutInfoId"] = _model.teaAboutInfoId;
    params[@"teaDesc"] = reason;
    
    @weakify(self);
    [ApiUtil putWithParent:self url:[ApiUtilHeader updateMeetingExplain] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [SVProgressHUD showSuccess:[response objectForKey:@"msg"] completion:^{
            @strongify(self);
            [self loadData:nil];
        }];
    } fail:nil];
}

- (IBAction)clickToOption:(id)sender {
    
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"uid"] = [UserInfoManager shareManager].uid;
    params[@"timespan"] = [AMMeetingMainViewController getNowTimeStamp];
    params[@"token"] = [AMMeetingMainViewController md5StringWith:[params copy]];
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader enterMeetingRoom] params:params success:^(NSInteger code, id  _Nullable response) {
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            // TRTC相关参数设置
            LS_TRTCParams *param = [[LS_TRTCParams alloc] init];
            param.sdkAppId = [[data objectForKey:@"SDKAppID"] intValue];
            param.userId = [UserInfoManager shareManager].uid;
            param.roomId = _model.teaAboutInfoId.intValue;
            param.userSig = [data objectForKey:@"sig"];
            param.role = TRTCRoleAnchor;
            
            param.ownerID = StringWithFormat(@(_model.artistId));
            param.ownerName = [ToolUtil isEqualToNonNullKong:_model.createUserName];
            param.teaEndTime = _model.teaEndTime;
            param.currentTime = [TimeTool timestampForTeaToTime:[[ToolUtil isEqualToNonNull:[data objectForKey:@"now_time"]  replace:@"0"] doubleValue]];
            
            [self.navigationController pushViewController:[AMMeetingMainViewController shareInstance:param] animated:YES];
        }else {
            [SVProgressHUD showError:@"数据错误，请重试"];
        }

    } fail:nil];
}
- (void)uploadPartState:(BOOL)joined {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"teaAboutOrderId"] = [ToolUtil isEqualToNonNullKong:_model.teaAboutOrderId];
    params[@"orderStatus"] = @(_model.infoStatus);
    params[@"peopleInviteStatus"] = joined?@"1":@"2";
    params[@"createUserId"] = @(_model.createUserId);
    params[@"createUserName"] = [ToolUtil isEqualToNonNullKong:_model.createUserName];
    
    [ApiUtil putWithParent:self url:[ApiUtilHeader updateOrderStatus] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [SVProgressHUD showMsg:[response objectForKey:@"msg"] completion:^{
            [self loadData:nil];
        }];
    } fail:nil];
}

#pragma mark -
- (void)loadData:(id _Nullable)sender {
    
    self.tableView.allowsSelection = NO;
    if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || ![sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
        [SVProgressHUD show];
    }
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_t group = dispatch_group_create();
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"teaAboutInfoId"] = [ToolUtil isEqualToNonNullKong:self.meetingid];
    params[@"id"] = [UserInfoManager shareManager].uid;
    
    ///查询会客信息
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        [ApiUtil postWithParent:self url:[ApiUtilHeader getMeetingDetail] needHUD:NO params:params.copy success:^(NSInteger code, id  _Nullable response) {
            NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
            if (data && data.count) {
                
                self.model = [HK_tea_managerModel yy_modelWithDictionary:data];
            }
            dispatch_group_leave(group);
        } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
            dispatch_group_leave(group);
        }];
    });
    ///查询参会名单
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        [ApiUtil postWithParent:self url:[ApiUtilHeader getTeaInviteList] needHUD:NO params:params.copy success:^(NSInteger code, id  _Nullable response) {
            NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
            if (data && data.count) {
                NSArray *records = (NSArray *)[data objectForKey:@"records"];
                if (records && records.count) {
                    _memberArray = [NSArray yy_modelArrayWithClass:[AMMeetingMemberModel class] json:records];
                }
            }
            dispatch_group_leave(group);
        } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.bgIV am_setImageWithURL:self.model.headimg placeholderImage:nil contentMode:UIViewContentModeScaleToFill];
            
            [self.tableView reloadData];
            [self.tableView endAllFreshing];
            [self.tableView ly_updataEmptyView: !_memberArray.count];
        });
    });
}

#pragma mark - 重写Set
- (void)setModel:(HK_tea_managerModel *)model{
    _model = model;
    /// 是否满员
    _hadFull = [self hadFull];
    /// 参加状态
//    _joinedStatus = model.status;
    /// 报名截止
    _hadRegisterDeadline = model.deadlineType;
    
//    _time_num = [TimeTool getDifferenceSinceDateStr:model.teaStartTime cloudTime:model.currentTime];
    
    self.headerView.model = model;
    self.infoView.model = model;
    
    [self setUpTimer:model];
    
    [self updateHeaderUIs];
    [self updateUIs];
}

- (void)setUpTimer:(HK_tea_managerModel *)model{
    
    if (model.infoStatus == 1) {//待开始,分为：1.报名截止前，2.报名截止后开始前一小时前，3.报名截止后开始前一小时内
        _time_num = [TimeTool getDifferenceSinceDate:model.teaStartTime toDate:model.currentTime];
        [self.timer setFireDate:[NSDate distantPast]];/// 开启定时器

    }else if(model.infoStatus == 2){//进行中
        _time_num = [TimeTool getDifferenceSinceDate:model.currentTime toDate:model.teaStartTime];
        [self.timer setFireDate:[NSDate distantPast]];/// 开启定时器
    }else if(model.infoStatus == 3){//已结束
        [self.timer setFireDate:[NSDate distantFuture]];/// 关闭定时器
    }else if(model.infoStatus == 4){//已取消
        [self.timer setFireDate:[NSDate distantFuture]];/// 关闭定时器
    }
}

#pragma mark - 计时器方法
//1:待开始 2:进行中 3:已结束 4:已取消
- (void)timerCountDown:(NSTimer *)timer {
    NSLog(@"timerCountDown = %@",@(_time_num));
    
    if (self.model.infoStatus == 1){//未开始
        if (_time_num <= 0) { //会客结束后关闭定时器
            [self.timer setFireDate:[NSDate distantFuture]];//关闭定时器
            [self loadData:nil];
            
            return;
        }
        if (_time_num == TeaBeginCountDown) {
            [self updateUIs];
        }
        _time_num --;
        self.infoView.time_num = _time_num;
        
    }else if(self.model.infoStatus == 2){//进行中
        if (_time_num >= [TimeTool getDifferenceSinceDate:self.model.teaEndTime toDate:self.model.teaStartTime]) { //会客结束后关闭定时器
            [self.timer setFireDate:[NSDate distantFuture]];//关闭定时器
            [self loadData:nil];
            
            return;
        }
        _time_num ++;
        self.infoView.time_num = _time_num;
    }
}

#pragma mark - Click

/// 不参加
- (IBAction)clickToNoPart:(id)sender {
    
    SingleAMAlertView *alertView = [SingleAMAlertView shareInstance];
    alertView.title = [NSString stringWithFormat:@"确定不参加%@本次的会客吗？",_model.createUserName];
    alertView.subTitle = [NSString stringWithFormat:@"会客时间：%@\n\n确定不参加，即取消本次会客邀请，您可以等待下次会客的开启。",_model.teaStartTime];
    alertView.needCancelShow = YES;
    @weakify(self);
    alertView.confirmBlock = ^{
        @strongify(self);
        [self uploadPartState:NO];
    };
    [alertView show];
}

/// 参加
- (IBAction)clickToPart:(id)sender {
    SingleAMAlertView *alertView = [SingleAMAlertView shareInstance];
    alertView.title = [NSString stringWithFormat:@"确认参加%@本次的会客吗？",_model.createUserName];
    alertView.subTitle = [NSString stringWithFormat:@"会客时间：%@\n\n由于名额有限，为保证其他用户的利益，参加后，将无法主动取消。同时，会客预约保证金将自动转为会客费。如果艺术家因故取消会客，本次会客视为无效，并退还预约保证金。",_model.teaStartTime];
    alertView.needCancelShow = YES;
    @weakify(self);
    alertView.confirmBlock = ^{
        @strongify(self);
        [self uploadPartState:YES];
    };
    [alertView show];
}

#pragma mark - 更新页面
- (void)updateHeaderUIs {
    self.bgIV.alpha = _alpha;
    self.bgCoverIV.alpha = _alpha;
    self.headerView.showDarkStyle = (_alpha < 0.3)?YES:NO;
    self.barStyle = (_alpha < 0.3)?UIStatusBarStyleDefault:UIStatusBarStyleLightContent;
    
    self.infoView.alpha = _alpha;
}

- (BOOL)hadFull {
    if (self.model.count == self.model.peopleMax) return YES;
    return NO;
}

- (void)updateUIs {
    self.bottomView.hidden = NO;
    self.stack_joinView.hidden = YES;
    self.stack_titleLabel.hidden = YES;
    self.stack_mainBtn.hidden = NO;
    
    switch (_model.infoStatus)
    {
        case 1: {
            if (_model.deadlineType == 1) {//已截止
                switch (self.model.status) {
                    case 1:  {/// 已参加
                        if ([TimeTool getDifferenceSinceDate:_model.teaStartTime toDate:_model.currentTime] <= TeaBeginCountDown ) {/// 开始前10分钟
                            self.stack_mainBtn.enabled = YES;
                            [self.stack_mainBtn setTitle:@"进入房间" forState:UIControlStateNormal];
                        }else {
                            self.stack_mainBtn.enabled = NO;
                            [self.stack_mainBtn setTitle:@"等待开始" forState:UIControlStateDisabled];
                        }
                        break;
                    }
                    case 2: {/// 不参加
                        self.stack_mainBtn.enabled = NO;
                        [self.stack_mainBtn setTitle:@"未参加本次会客" forState:UIControlStateDisabled];
                        break;
                    }
                    case 3: {/// 待确认
                        self.stack_mainBtn.enabled = NO;
                        [self.stack_mainBtn setTitle:@"截止报名" forState:UIControlStateDisabled];
                        break;
                    }
                        
                    default:
                        break;
                }
            }else {/// 未截止
                self.stack_mainBtn.enabled = NO;
                switch (self.model.status) {
                    case 1:  {/// 已参加
                        [self.stack_mainBtn setTitle:@"等待开始" forState:UIControlStateDisabled];
                        break;
                    }
                    case 2:  {/// 不参加
                        [self.stack_mainBtn setTitle:@"未参加本次会客" forState:UIControlStateDisabled];
                        break;
                    }
                    case 3:  {/// 待确认
                        if (_hadFull) { /// 已满员
                            [self.stack_mainBtn setTitle:@"已满员" forState:UIControlStateDisabled];
                        }else {
                            self.stack_mainBtn.hidden = YES;
                            self.stack_joinView.hidden = NO;
                        }
                        break;
                    }
                        
                    default:
                        break;
                }
            }
            break;
        }
        case 2:// 进行中
        {
            if (self.model.status == 1) {/// 已参加
                self.stack_mainBtn.enabled = YES;
                [self.stack_mainBtn setTitle:@"进入房间" forState:UIControlStateNormal];
            }else {
                self.stack_mainBtn.enabled = NO;
                [self.stack_mainBtn setTitle:@"未参加本次会客" forState:UIControlStateDisabled];
            }
            break;
        }
        case 3://已结束
        {
            [self.timer setFireDate:[NSDate distantFuture]];/// 关闭定时器
            self.bottomView.hidden = YES;
            self.stack_mainBtn.hidden = YES;
            break;
        }
            
        case 4:// 已取消
        {
            [self.timer setFireDate:[NSDate distantFuture]];/// 关闭定时器
            self.stack_titleLabel.text = [ToolUtil isEqualToNonNull:_model.cancelReason replace:@"人数不足，系统自动取消会客"];
            self.stack_titleLabel.hidden = NO;
            self.stack_mainBtn.hidden = YES;
            break;
        }
            
        default: {
            self.bottomView.hidden = YES;
            self.stack_joinView.hidden = YES;
            self.stack_titleLabel.hidden = YES;
            self.stack_mainBtn.hidden = YES;
            break;
        }
    }
    
    CGFloat bottomMargin = 10.0f;
    NSLog(@"self.stack_mainBtn.height - %.2f", self.stack_mainBtn.height);
    if (self.bottomView.hidden) {
        self.tableView_bottom_constraint.constant = 0.0f;
    }else {
        self.tableView_bottom_constraint.constant = (40.0f + 20.0f + bottomMargin);
    }
}

@end
