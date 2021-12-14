//
//  AMMeetingSettingViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/8/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMMeetingSettingViewController.h"

#import "SystemArticleViewController.h"

#import "AMMeetingSettingAView.h"
#import "AMMeetingSettingBView.h"
#import "AMMeetingSettingCView.h"

#import "AMAlertView.h"

@interface AMMeetingSettingViewController () < AMMeetingSettingAViewDelegate, AMMeetingSettingBViewDelegate, AMMeetingSettingCViewDelegate>

@property (weak, nonatomic) IBOutlet AMButton *agreementBtn;
@property (weak, nonatomic) IBOutlet UIView *agreementView;
@property (weak, nonatomic) IBOutlet UILabel *agreementTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *agreementLabel;

@property (weak, nonatomic) IBOutlet UILabel *hadUpdateLabel;

@property (weak, nonatomic) IBOutlet AMMeetingSettingAView *meeting_a_View;
@property (weak, nonatomic) IBOutlet AMMeetingSettingBView *meeting_b_View;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *meeting_b_height_constraint;
@property (weak, nonatomic) IBOutlet AMMeetingSettingCView *meeting_c_View;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *meeting_c_height_constraint;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet AMButton *confirmBtn;

@end

@implementation AMMeetingSettingViewController {
    /// 约见功能开启是否
    BOOL _isOpen, _isUpdated;
    /// 输入金额、约见须知
    NSString *_priceStr, *_tipsStr;
    /// 是否同意协议
    BOOL _isSelectAgree;
    
    NSDictionary *_initialStatusInfo;
    NSMutableArray <AMMeetingBondModel *>*_bondArray;
}

- (instancetype)init {
    if (self = [super init]) {
        _isOpen = NO;
        _isSelectAgree = YES;
        _bondArray = @[].mutableCopy;
    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    [self.navigationItem setTitle:@"约见设置"];
    
    _bondArray = [NSMutableArray new];
    
    _meeting_a_View.delegate = self;
    _meeting_b_View.delegate = self;
    _meeting_c_View.delegate = self;
    
    self.agreementLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    self.agreementTitleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    
    self.agreementBtn.selected = _isSelectAgree;
    
    self.confirmBtn.titleLabel.font = [UIFont addHanSanSC:18.0f fontType:0];
    [self.confirmBtn setBackgroundImage:[UIImage imageWithColor:Color_Black] forState:UIControlStateNormal];
    [self.confirmBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xCCCCCC)] forState:UIControlStateDisabled];
    
    [self updateUIs];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self loadData:nil];
}

#pragma mark - AMMeetingSettingAViewDelegate
- (void)settingACell:(AMMeetingSettingAView *)cell didSelectedOpen:(AMButton *)sender {
    if (!_isOpen) {
        _isOpen = !_isOpen;
        cell.isOpen = _isOpen;
        [self updateUIs];
    }else {
        if (([[_initialStatusInfo objectForKey:@"teaSystemStatus"] integerValue] == 1)) {
            AMMeetingSettingAlertView *alertView = [AMMeetingSettingAlertView shareInstance];
            alertView.title = @"确认关闭约见功能嘛？";
            alertView.subTitle = @"关闭后，其他用户无法预约你的会客";
            alertView.confirmBlock = ^{
                [self commitChangesToServer:0];
            };
            [alertView show];
        }else {
            _isOpen = !_isOpen;
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.isOpen = _isOpen;
                [self updateUIs];
            });
        }
    }
}

#pragma mark - AMMeetingSettingBViewDelegate
- (void)settingBCell:(AMMeetingSettingBView *)cell didSelectedItem:(NSString *)selectedNum {
    _priceStr = StringWithFormat(selectedNum);
    
    [self updateUIs];
}

- (void)settingBCell:(AMMeetingSettingBView *)cell didLoadItemsToHeight:(CGFloat)height {
    _meeting_b_height_constraint.constant = height;
}

#pragma mark - AMMeetingSettingCViewDelegate
- (void)settingCCell:(AMMeetingSettingCView *)cell didLoadItemsToHeight:(CGFloat)height {
    _meeting_c_height_constraint.constant = height;
}

#pragma mark -
- (IBAction)clickToConfrim:(id)sender {
    if (_initialStatusInfo && _initialStatusInfo.count) {
        if (_priceStr.doubleValue != [[_initialStatusInfo objectForKey:@"securityDeposit"] doubleValue]) {/// 修改了约见设置
            AMMeetingSettingAlertView *alertView = [AMMeetingSettingAlertView shareInstance];
            alertView.title = @"确认修改约见保证金金额吗？";
            alertView.subTitle = [NSString stringWithFormat:@"约见保证金修改为：¥%.2f",_priceStr.doubleValue];
            alertView.confirmBlock = ^{
                [self commitChangesToServer:2];
            };
            [alertView show];
            return;
        }else {
            AMMeetingSettingAlertView *alertView = [AMMeetingSettingAlertView shareInstance];
            alertView.title = @"确认开启约见功能嘛？";
            alertView.subTitle = [NSString stringWithFormat:@"约见保证金：¥%.2f",_priceStr.doubleValue];
            alertView.confirmBlock = ^{
                [self commitChangesToServer:1];
            };
            [alertView show];
            return;
        }
    }else
        [SVProgressHUD showMsg:@"数据错误，请重试" completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
}

- (IBAction)clickToSeeAgreemegnt:(id)sender {
    SystemArticleViewController *agreementVC = [[SystemArticleViewController alloc] init];
    agreementVC.needBottom = YES;
    /// 约见会客服务协议
    agreementVC.articleID = @"YSRMTYJHKFWXY";
    @weakify(self);
    agreementVC.completion = ^{
        @strongify(self);
        _isSelectAgree = YES;
        [self updateUIs];
    };
    [self.navigationController pushViewController:agreementVC animated:YES];
}

- (IBAction)clickToSelectedAgree:(AMButton *)sender {
    sender.selected = !sender.selected;
    _isSelectAgree = sender.selected;
    
    [self updateUIs];
}


/// 提交修改
/// @param type 0 关闭 1开启 2修改
- (void)commitChangesToServer:(NSInteger)type {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"artistId"] = [UserInfoManager shareManager].uid;
    params[@"teaSystemStatus"] = type?@"1":@"2";
    params[@"securityDeposit"] = _priceStr;
    params[@"artistName"] = [ToolUtil isEqualToNonNullKong:[UserInfoManager shareManager].model.username];
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader changeTeaSystemStatus] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        NSString *data = (NSString *)[response objectForKey:@"data"];
        if ([ToolUtil isEqualToNonNullKong:data]) {
            [SVProgressHUD showSuccess:data completion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else
            [self.navigationController popViewControllerAnimated:YES];
    } fail:nil];
}

#pragma mark -
- (void)updateUIs {
    
    self.agreementView.hidden = !_isOpen;
    self.bottomView.hidden = !_isOpen;
    
    if (_isOpen) {
        if (_isSelectAgree && [ToolUtil isEqualToNonNull:_priceStr]) {
            self.confirmBtn.enabled = YES;
        }else
            self.confirmBtn.enabled = NO;
    }else {
        self.confirmBtn.enabled = YES;
    }
    
    _hadUpdateLabel.hidden = !_isUpdated;
    _meeting_a_View.isOpen = _isOpen;
    
    _meeting_b_View.hidden = !_isOpen;
    _meeting_b_View.dataArray = _bondArray.copy;
    _meeting_b_View.priceStr = _priceStr;
    [_meeting_b_View reloadData];
    
    _meeting_c_View.tipsStr = _tipsStr;
}

#pragma mark -
- (void)loadData:(id)sender {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_t group = dispatch_group_create();
    
    /// 获取约见设置
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);

        [ApiUtil getWithParent:self url:[ApiUtilHeader getArtTeaStting:[UserInfoManager shareManager].uid] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response) {

            NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
            if (data && data.count) {
                _initialStatusInfo = data;
            }
            dispatch_group_leave(group);
        } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
            dispatch_group_leave(group);
        }];
    });
    /// 获取保证金数组
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        if (![sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
            if (_bondArray.count) [_bondArray removeAllObjects];
        }
        [ApiUtil getWithParent:self url:[ApiUtilHeader getTeaBondList] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response) {
            NSArray *data = (NSArray *)[response objectForKey:@"data"];
            if (data && data.count) {
                _bondArray = [NSArray yy_modelArrayWithClass:[AMMeetingBondModel class] json:data].mutableCopy;
            }
            dispatch_group_leave(group);
        } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
            dispatch_group_leave(group);
        }];
    });
    /// 获取关于约见
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        [ApiUtil postWithParent:self url:[ApiUtilHeader getOrderInfoText] needHUD:NO params:@{@"articleCode":@"GYYJ"} success:^(NSInteger code, id  _Nullable response) {
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
        [_bondArray enumerateObjectsUsingBlock:^(AMMeetingBondModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.isDefault) _priceStr = StringWithFormat(obj.teaPrice);
        }];
        ///  1:开启 2:关闭
        _isOpen = ([[_initialStatusInfo objectForKey:@"teaSystemStatus"] integerValue] == 1)?YES:NO;
        if ([ToolUtil isEqualToNonNull:[_initialStatusInfo objectForKey:@"securityDeposit"]]) {
            _priceStr = StringWithFormat([_initialStatusInfo objectForKey:@"securityDeposit"]);
        }
        __block BOOL hadExist = NO;
        [_bondArray enumerateObjectsUsingBlock:^(AMMeetingBondModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.teaPrice isEqualToString:_priceStr]) {
                hadExist = YES;
                *stop = YES;
            }
        }];
        _isUpdated = (_isOpen && [ToolUtil isEqualToNonNull:[_initialStatusInfo objectForKey:@"securityDeposit"]] && !hadExist);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUIs];
        });
    });
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
