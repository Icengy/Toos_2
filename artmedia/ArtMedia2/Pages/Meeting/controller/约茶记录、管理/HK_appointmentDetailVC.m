//
//  HK_appointmentDetailVC.m
//  ArtMedia2
//
//  Created by guohongkai on 2020/8/18.
//  Copyright © 2020 翁磊. All rights reserved.
//  约见详情

#import "HK_appointmentDetailVC.h"
#import "AMMeetingDetailViewController.h"
//#import "CustomPersonalViewController.h"
#import "AMBaseUserHomepageViewController.h"
#import "AMPayViewController.h"
#import "AMMeetingPayResultViewController.h"

#import "HK_Tea_appointmentDetailCell.h"
#import "HK_teaDetailPeopleCell.h"
#import "HK_bottomView.h"
#import "HK_appointmentFootView.h"

#import "AMMeetingOrderManagerListModel.h"
#import "AMPayManager.h"

@interface HK_appointmentDetailVC ()<UITableViewDelegate,UITableViewDataSource,HK_Tea_appointmentDetailCellDelegate , AMPayDelegate, HK_appointmentFootViewDelegate>
@property (nonatomic,weak) IBOutlet BaseTableView *teaDetailTab;
@property (nonatomic,copy) NSArray *sectionArr;
@property (nonatomic,copy) NSArray *rowHeight;
@property (nonatomic,weak) IBOutlet UILabel *topLabel;
@property (nonatomic,strong) HK_appointmentFootView *footView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic,weak) IBOutlet HK_bottomView *bottomV;

@property (nonatomic,strong) AMMeetingOrderManagerListModel *model;
@end

@implementation HK_appointmentDetailVC {
    NSString *_tipsStr;
    CGFloat _footerHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationItem.title = @"约见详情";
    
    [self loadData];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWXPayResult:) name:WXPaymentResultForNormal object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAliPayResult:) name:AliPaymentResultForNormal object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WXPaymentResultForNormal object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AliPaymentResultForNormal object:nil];
}

- (void)configUI {
    _footerHeight = 200.0f;
    
    self.bgColorStyle=AMBaseBackgroundColorStyleGray;
    self.teaDetailTab.delegate = self;
    self.teaDetailTab.dataSource = self;
    
    [self.teaDetailTab registerClass:[HK_Tea_appointmentDetailCell class] forCellReuseIdentifier:NSStringFromClass([HK_Tea_appointmentDetailCell class])];
    [self.teaDetailTab registerClass:[HK_teaDetailPeopleCell class] forCellReuseIdentifier:NSStringFromClass([HK_teaDetailPeopleCell class])];
    
    WeakSelf(self);
    self.bottomV.buttonClickBlock = ^(NSString * _Nonnull text) {
        [weakself bottomAction:text];
    };
}

- (void)tapAction {
    [self loadData];
}

- (void)loadData {
    self.topLabel.hidden=YES;
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        [ApiUtil getWithParent:self url:[ApiUtilHeader tea_meetingDetail:[ToolUtil isEqualToNonNullKong:self.teaAboutOrderId]] params:nil success:^(NSInteger code, id  _Nullable response) {
            [self.HK_dataArr removeAllObjects];
            NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
            if (data && data.count) {
                self.model = [AMMeetingOrderManagerListModel yy_modelWithDictionary:data];
            }
            if (!self.model) self.model = [[AMMeetingOrderManagerListModel alloc]init];
            dispatch_group_leave(group);
        } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
            dispatch_group_leave(group);
        }];
    });
    /// 获取温馨提示
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        [ApiUtil postWithParent:self url:[ApiUtilHeader getOrderInfoText] needHUD:NO params:@{@"articleCode":@"WXTS"} success:^(NSInteger code, id  _Nullable response) {
            NSDictionary *data = (NSDictionary *)[(NSArray *)[response objectForKey:@"data"] lastObject];
            if (data && data.count) {
                _tipsStr = [ToolUtil isEqualToNonNullKong:[data objectForKey:@"articleContent"]];
            }
            dispatch_group_leave(group);
        } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
            dispatch_group_leave(group);
        }];
    });
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.teaDetailTab reloadData];
        });
    });
}

- (void)setModel:(AMMeetingOrderManagerListModel *)model{
    _model = model;
    
    if (model.orderStatus == 1) {
        
        //待邀请
        self.sectionArr=@[@"4"];
        self.rowHeight=@[@[@"70",@"44",@"44",@"44"]];
        [self.HK_dataArr addObjectsFromArray:@[@[@[@"",@"预约时间",@"预约到期时间",@"约见保证金"]],@[@[@"",self.model.createTime?:@"",self.model.subscribeEndTime?:@"",[NSString stringWithFormat:@"%@",self.model.securityDeposit?:@""]]]]];
        
        NSArray *titleArray = @[@[@"",@"预约时间",@"预约到期时间",@"约见保证金"]];
        NSArray *valueArray = @[@[@"",[ToolUtil isEqualToNonNullKong:self.model.createTime],[ToolUtil isEqualToNonNullKong:self.model.subscribeEndTime],[ToolUtil isEqualToNonNull:self.model.securityDeposit replace:@"0"]]];
        
        [self.HK_dataArr addObjectsFromArray:@[titleArray, valueArray]];
        
        if ([model.payStatus isEqualToString:@"2"]) {//支付状态 1:支付 2:未支付',   2 可以继续支付
            self.bottomView.hidden = NO;
            [self.bottomV setLeftTitle:@"取消约见" rightTitle:@"立即支付"];
            self.topLabel.hidden=NO;
            self.topLabel.text=@"您尚未支付，支付成功后，才能收到会客邀请";
        }else{
            self.bottomView.hidden = YES;
        }
    }else if(model.orderStatus == 2){
        //待确认/待参加
        self.sectionArr=@[@"4",@"3"];
        self.rowHeight=@[@[@"70",@"44",@"44",@"44"],@[@"60",@"44",@"44"]];
        
        NSArray *titleArray = @[@[@"",@"预约时间",@"预约到期时间",@"约见保证金"]
                                ,@[@"会客信息",@"报名截止时间",@"会客开始时间"]];
        NSArray *valueArray = @[@[@"",[ToolUtil isEqualToNonNullKong:self.model.createTime],[ToolUtil isEqualToNonNullKong:self.model.subscribeEndTime],[ToolUtil isEqualToNonNull:self.model.securityDeposit replace:@"0"]]
                                ,@[@"查看详情",[ToolUtil isEqualToNonNullKong:self.model.teaSignUpEndTime],[ToolUtil isEqualToNonNullKong:self.model.teaStartTime]]];
        
        [self.HK_dataArr addObjectsFromArray:@[titleArray, valueArray]];
        
        self.bottomView.hidden = NO;
        [self.bottomV setLeftTitle:@"暂不参加" rightTitle:@"确认参加"];
        self.topLabel.hidden=NO;
        self.topLabel.text=@"艺术家已开启会客";

    }else if(model.orderStatus == 3){
        //已确认/已参加
        self.bottomView.hidden = YES;
        self.sectionArr=@[@"4",@"4"];
        self.rowHeight=@[@[@"70",@"44",@"44",@"44"],@[@"60",@"44",@"44",@"44"]];
        
        NSArray *titleArray = @[@[@"",@"预约时间",@"预约到期时间",@"约见保证金"]
                                ,@[@"会客信息",@"报名截止时间",@"会客开始时间",@"会客结束时间"]];
        NSArray *valueArray = @[@[@"",[ToolUtil isEqualToNonNullKong:self.model.createTime],[ToolUtil isEqualToNonNullKong:self.model.subscribeEndTime],[ToolUtil isEqualToNonNull:self.model.securityDeposit replace:@"0"]]
                                ,@[@"查看详情",[ToolUtil isEqualToNonNullKong:self.model.teaSignUpEndTime],[ToolUtil isEqualToNonNullKong:self.model.teaStartTime],[ToolUtil isEqualToNonNullKong:self.model.teaEndTime]]];
        
        [self.HK_dataArr addObjectsFromArray:@[titleArray, valueArray]];
        
    }else if(model.orderStatus == 4) {
        //已取消
        self.bottomView.hidden = YES;
        self.sectionArr = @[@"4",@"2",@"1"];
        self.rowHeight = @[@[@"70",@"44",@"44",@"44"],@[@"44",@"44"],@[@"44"]];
        
        NSArray *titleArray = @[@[@"", @"预约时间", @"预约到期时间", @"约见保证金"],
                                @[@"取消时间",@"取消原因"],
                                @[@"保证金"]];
        NSArray *valueArray = @[@[@"",[ToolUtil isEqualToNonNullKong:self.model.createTime],[ToolUtil isEqualToNonNullKong:self.model.subscribeEndTime],[ToolUtil isEqualToNonNull:self.model.securityDeposit replace:@"0"]],
                                @[[ToolUtil isEqualToNonNullKong:self.model.updateTime],[ToolUtil isEqualToNonNull:self.model.cancelReason replace:@"人数不足，系统自动取消"]],
                                @[@"待退还"]];
        
        [self.HK_dataArr addObjectsFromArray:@[titleArray, valueArray]];
    }
    
}

- (HK_appointmentFootView *)footView {
    if (!_footView) {
        _footView = [HK_appointmentFootView shareInstance];
        _footView.delegate = self;
    }
    return _footView;
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_sectionArr[section] integerValue];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    switch (self.model.orderStatus) {
        case 1:
            {
               return 1;
            }
            break;
        case 2:{
            return 2;
        }
            break;
        case 3:
        {
            return 2;
        }
        case 4:{
            return 3;
        }
        default:
            break;
    }
    return 2;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell addSectionCornerWithTableView:tableView tableViewCell:cell indexPath:indexPath cornerRadius:8.f];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.rowHeight[indexPath.section][indexPath.row] integerValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section?10.0f:(self.topLabel.hidden?10.0f:CGFLOAT_MIN);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (_model.orderStatus == 1 && section == [tableView numberOfSections] - 1) {
        return _footerHeight;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (_model.orderStatus == 1 && section == [tableView numberOfSections] - 1) {
        self.footView.tipsStr = _tipsStr;
        self.footView.footerHeight = _footerHeight;
        return self.footView;
    }
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0 && indexPath.row==0) {
        HK_teaDetailPeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HK_teaDetailPeopleCell class]) forIndexPath:indexPath];
        cell.backgroundColor=[UIColor clearColor];
        cell.model = self.model;
        cell.gotArtistBlock = ^(NSString * _Nonnull artistId) {
            AMBaseUserHomepageViewController * vc = [[AMBaseUserHomepageViewController alloc] init];
            vc.artuid = artistId;
            [self.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }else{
        HK_Tea_appointmentDetailCell *cell=[HK_Tea_appointmentDetailCell cellWithTableView:tableView andCellIdifiul:NSStringFromClass([HK_Tea_appointmentDetailCell class])];
        cell.backgroundColor=[UIColor clearColor];
        cell.delegate=self;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.leftStr=self.HK_dataArr.firstObject[indexPath.section][indexPath.row];
        cell.rightStr=self.HK_dataArr.lastObject[indexPath.section][indexPath.row];
        cell.time_Status=self.model.orderStatus;
        cell.model = self.model;
        cell.gotoDetailBlock = ^{
            AMMeetingDetailViewController * vc = [[AMMeetingDetailViewController alloc] init];
            vc.meetingid = self.model.teaAboutInfoId;
            [self.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }
}

#pragma mark--------延期
- (void)delayAction{
    SingleAMAlertView *alertView = [SingleAMAlertView shareInstance];
    alertView.title = @"是否延期一个月？";
    alertView.subTitle = @"延期后，在新的预约截止时间内，您将无法主动申请退还会客预约保证金";
    alertView.needCancelShow = YES;
    //    @weakify(self);
    alertView.confirmBlock = ^{
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];

        dic[@"teaAboutOrderId"] = [ToolUtil isEqualToNonNullKong:self.model.teaAboutOrderId];
        dic[@"createUserId"] = [UserInfoManager shareManager].uid;
        dic[@"createUserName"] = [UserInfoManager shareManager].model.username;
        
        [ApiUtil putWithParent:self url:[ApiUtilHeader appoint_endTime_Delay] params:dic success:^(NSInteger code, id  _Nullable response) {
            [SVProgressHUD showSuccess:@"延期成功"];
            [self loadData];
        } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        }];
    };
    [alertView show];
    
}
- (void)bottomAction:(NSString *)str{
    if ([str isEqualToString:@"暂不参加"]) {
        
        SingleAMAlertView *alertView = [SingleAMAlertView shareInstance];
        alertView.title = [NSString stringWithFormat:@"确定不参加%@本次的会客吗？",self.model.uname];
        alertView.subTitle = [NSString stringWithFormat:@"会客时间：%@\n确定不参加，即取消本次会客邀请，您可以等待下次会客的开启。",self.model.teaStartTime];
        alertView.needCancelShow = YES;
        //    @weakify(self);
        alertView.confirmBlock = ^{
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            dic[@"teaAboutOrderId"] = self.model.teaAboutOrderId;
            dic[@"peopleInviteStatus"] = @(2);
            dic[@"createUserId"] = [UserInfoManager shareManager].uid;
            dic[@"createUserName"] = [ToolUtil isEqualToNonNullKong:[UserInfoManager shareManager].model.username];
            
            [ApiUtil putWithParent:self url:[ApiUtilHeader appointment_statusChange] params:dic success:^(NSInteger code, id  _Nullable response) {
                [SVProgressHUD showSuccess:@"操作成功，等待下次会客邀请"];
                [self loadData];
            } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
                
            }];
        };
        [alertView show];
        
        
    }else if ([str isEqualToString:@"确认参加"]){
        SingleAMAlertView *alertView = [SingleAMAlertView shareInstance];
        alertView.title = [NSString stringWithFormat:@"确认参加%@本次的会客吗？",self.model.uname];
        alertView.subTitle = [NSString stringWithFormat:@"会客时间：%@\n由于名额有限，为保证其他用户的利益，参加后，将无法主动取消。同时，会客预约保证金将自动转为会客费。如果艺术家因故取消会客，本次会客视为无效，并退还预约保证金。",self.model.teaStartTime];
        alertView.needCancelShow = YES;
        //    @weakify(self);
        alertView.confirmBlock = ^{
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            dic[@"teaAboutOrderId"] = self.model.teaAboutOrderId;
            dic[@"peopleInviteStatus"] = @(1);
            dic[@"createUserId"] = [UserInfoManager shareManager].uid;
            dic[@"createUserName"] = [UserInfoManager shareManager].model.username;
            //        dic[@"peopleInviteStatus"] = self.model
            [ApiUtil putWithParent:self url:[ApiUtilHeader appointment_statusChange] params:dic success:^(NSInteger code, id  _Nullable response) {
                NSLog(@"success");
                [SVProgressHUD showSuccess:@"报名成功，等待会客开始"];
                [self loadData];
            } fail:nil];
        };
        [alertView show];
    }else if ([str isEqualToString:@"取消约见"]){
        [ApiUtil getWithParent:self url:[ApiUtilHeader teaOrderCancel:self.model.teaAboutOrderId] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response) {
            [SVProgressHUD showSuccess:@"取消约见成功"];
            [self loadData];
        } fail:nil];
    }else if ([str isEqualToString:@"立即支付"]){
        [self pay];
    }
}
- (void)pay{
    AMPayViewController *payVC = [[AMPayViewController alloc] init];
    payVC.delegate = self;
    payVC.priceStr = self.model.securityDeposit;
    payVC.payStyle = AMAwakenPayStyleDefalut;
    [self.navigationController presentViewController:payVC animated:YES completion:nil];
}

#pragma mark - HK_appointmentFootViewDelegate
- (void)footerCell:(HK_appointmentFootView *)footer didLoadItemsWithHeight:(CGFloat)height {

    _footerHeight = height;
    [self.teaDetailTab reloadSections:[[NSIndexSet alloc] initWithIndex:([self.teaDetailTab numberOfSections] - 1)] withRowAnimation:(UITableViewRowAnimationNone)];
}

#pragma mark - AMPayDelegate
- (void)payViewController:(BaseViewController *)payViewController didSelectPayForWay:(AMPayWay)payWay {
    [payViewController dismissViewControllerAnimated:YES completion:^{
        switch (payWay) {
            case AMPayWayWX:
                [[WechatManager shareManager] payMeetingOrderWithID:self.model.teaAboutOrderId type:@"1"];
                break;
            case AMPayWayAlipay:
                [[AlipayManager shareManager] payMeetingOrderWithID:self.model.teaAboutOrderId type:@"1"];
                break;
                
            default:
                break;
        }
    }];
}

#pragma mark -
- (void)showWXPayResult:(NSNotification *)noti {
    BOOL isSuccess = [noti.object boolValue];
    if (isSuccess) {
        [self showResultSuccess];
    }else
        [[AMAlertView shareInstanceWithTitle:@"支付失败，请重试！"
                                 buttonArray:@[@"确定"]
                                     confirm:nil
                                      cancel:nil] show];
}

- (void)showAliPayResult:(NSNotification *)noti {
    NSInteger code = [noti.object integerValue];
    if (code == 0) {
        [self showResultSuccess];
    }else if (code == 1) {
        [[AMAlertView shareInstanceWithTitle:@"已取消支付" buttonArray:@[@"确定"] confirm:nil cancel:nil] show];
    }else {
        [[AMAlertView shareInstanceWithTitle:@"支付失败，请重试！" buttonArray:@[@"确定"] confirm:nil cancel:nil] show];
    }
}
- (void)showResultSuccess {
    AMMeetingPayResultViewController *payResultVC = [[AMMeetingPayResultViewController alloc] init];
    payResultVC.artist_name = [ToolUtil isEqualToNonNullKong:self.model.uname];
    [self.navigationController pushViewController:payResultVC animated:YES];
}

@end
