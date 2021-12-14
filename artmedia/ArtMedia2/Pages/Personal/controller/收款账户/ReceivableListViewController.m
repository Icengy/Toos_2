//
//  ReceivableListViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/21.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "ReceivableListViewController.h"
#import "AddNewBankCardViewController.h"

#import "ReceivableListCell.h"
#import "ReceivableBlankTableCell.h"
#import "CashoutInputView.h"
#import "AMEmptyView.h"

#import <WXApi.h>

#import "ReceivableModel.h"

@interface ReceivableListViewController () <UITableViewDelegate ,UITableViewDataSource, CashoutInputDelegate, ReceivableListCellDelegate, ReceivableBlankDelegate>
@property (nonatomic ,strong) CashoutInputView *cashoutView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipsTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipsBottomConstraint;


@property (weak, nonatomic) IBOutlet BaseTableView *layoutTV;
@property (nonatomic ,weak) IBOutlet AMButton *confirmButton;

///// 经纪人数据 仅当_receiveType = 0时使用
//@property (nonatomic ,strong) NSMutableArray <ReceivableModel *>*dataArray_agent;
///// 本人数据
//@property (nonatomic ,strong) NSMutableArray <ReceivableModel *>*dataArray;

/// 本人数据
@property (nonatomic ,strong) NSMutableArray <NSMutableArray <ReceivableModel *> *>*dataArray;

@end

@implementation ReceivableListViewController {
    NSString *_shouldCashoutCount;
}

- (CashoutInputView *)cashoutView {
    if (!_cashoutView) {
        _cashoutView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CashoutInputView class]) owner:nil options:nil].lastObject;
        _cashoutView.frame = CGRectMake(0, 0, self.view.width, 225.0f);
        _cashoutView.receiveType = self.receiveType;
        _cashoutView.delegate = self;
    }return _cashoutView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
	
//    _dataArray = @[].mutableCopy;
    _dataArray = @[].mutableCopy;
    self.tipsLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
	
    if (self.receiveType) {
        self.tipsLabel.hidden = YES;
        _confirmButton.titleLabel.font = [UIFont addHanSanSC:16.0f fontType:1];
        _shouldCashoutCount = nil;
        self.layoutTV.contentInset = UIEdgeInsetsMake(0, 0, self.confirmButton.height + 15.0f, 0);
    }else {
//        _dataArray_agent = @[].mutableCopy;
        self.confirmButton.hidden = YES;
        self.layoutTV.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    self.layoutTV.bgColorStyle = AMBaseTableViewBackgroundColorStyleGray;
	self.layoutTV.delegate = self;
	self.layoutTV.dataSource = self;
	
    self.layoutTV.sectionFooterHeight = CGFLOAT_MIN;
    self.layoutTV.tableFooterView = [UIView new];
	
	[self.layoutTV registerNib:[UINib nibWithNibName:NSStringFromClass([ReceivableListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ReceivableListCell class])];
    [self.layoutTV registerNib:[UINib nibWithNibName:NSStringFromClass([ReceivableBlankTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ReceivableBlankTableCell class])];
	
    [self.layoutTV addRefreshHeaderWithTarget:self action:@selector(loadData:)];
    self.layoutTV.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadData:)];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self.navigationItem setTitle:_receiveType?@"申请提现":@"收款账户"];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self loadData:nil];
}

#pragma mark -
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.receiveType) return 2;
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!_dataArray.count) return 0;
    if (self.receiveType) {
        if (section == 0)  return 0;
        return [_dataArray[section - 1] count];;
    }
    return [_dataArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_dataArray.count) return 0;
    ReceivableModel *model = [_dataArray[self.receiveType?indexPath.section - 1:indexPath.section] objectAtIndex:indexPath.row];
        
    if (model.account_type.integerValue == 3 && [ToolUtil isEqualToNonNull:model.id]) {
        return 110.0f;
    }
    return 90.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_receiveType && section == 0)
        return 225.0f;
    return 50.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_receiveType && section == 0) {
        self.cashoutView.availableCount = self.cashoutCount;
        self.cashoutView.shouldCount = _shouldCashoutCount;
        return self.cashoutView;
    }
    UIView *wrapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_Width, 50.0f)];
    wrapView.backgroundColor = tableView.backgroundColor;
    
    UILabel *label = [[UILabel alloc] init];
    [wrapView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wrapView.mas_left).offset(15.0f);
        make.centerY.equalTo(wrapView);
    }];
    
    label.font = [UIFont addHanSanSC:14.0 fontType:0];
    label.textColor = RGB(122, 129, 153);
    if (_receiveType == 0) {
        if ([UserInfoManager shareManager].isArtist) {
            label.text = section?@"本人账户":@"经纪人账户";
        }else
            label.text = @"本人账户";
        
    }else if (_receiveType == 1) {
        label.text = @"经纪人账户";
    }else
        label.text = @"本人账户";
    
	return wrapView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataArray.count) {
        ReceivableModel *model = [_dataArray[self.receiveType?indexPath.section - 1:indexPath.section] objectAtIndex:indexPath.row];
        if ([ToolUtil isEqualToNonNull:model.id]) {
            return [self receivableTableView:tableView cellForRowAtIndexPath:indexPath withModel:model];
        }else {
            ReceivableBlankTableCell *blankCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ReceivableBlankTableCell class]) forIndexPath:indexPath];
            blankCell.model = model;
            blankCell.delegate = self;
            return blankCell;
        }
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
        if (!cell) cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:NSStringFromClass([self class])];
        return cell;
    }

}

- (ReceivableListCell *)receivableTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath withModel:(ReceivableModel *)model {
    ReceivableListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ReceivableListCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    cell.model = model;
     cell.receiveType = _receiveType;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.receiveType) {
        NSMutableArray *mutArray = _dataArray[indexPath.section - 1];
        ReceivableModel *model = mutArray[indexPath.row];
        if ([ToolUtil isEqualToNonNull:model.id]) {
            model.isSelected = !model.isSelected;
            [mutArray replaceObjectAtIndex:indexPath.row withObject:model];
            [_dataArray replaceObjectAtIndex:indexPath.section - 1 withObject:mutArray];
            if (model.isSelected) {
                [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:(UITableViewScrollPositionNone)];
            }else {
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
        }
    }
}

#pragma mark -
- (void)inputViewValueChanged:(NSString *)inputText {
    _shouldCashoutCount = inputText;
}

#pragma mark - ReceivableBlankDelegate
- (void)tableCell:(ReceivableBlankTableCell *)cell didClickToAddNewWithModel:(nonnull ReceivableModel *)model {
    AddNewBankCardViewController *vc = [[AddNewBankCardViewController alloc] init];
    vc.accountType = model.account_type.integerValue;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ReceivableListCellDelegate
- (void)cell:(ReceivableListCell *)cell didClickToRemoveBind:(id)sender withModel:(ReceivableModel *_Nullable)model {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"uid"] = [UserInfoManager shareManager].uid;
    params[@"id"] = model.id;
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader deleteUserBankAccount] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [SVProgressHUD showSuccess:@"解绑成功" completion:^{
            [self loadData:nil];
        }];
    } fail:nil];
}

#pragma mark -
- (IBAction)clickToConfirm:(id)sender {
    ///非固定数额提现
    if (![ToolUtil isEqualToNonNull:_shouldCashoutCount]) {
        [SVProgressHUD showError:@"请输入提现金额，最低10元"];
        return;
    }
    if (_shouldCashoutCount.doubleValue < 10.0f) {
        [SVProgressHUD showError:@"提现金额最低10元"];
        return;
    }
    if (_shouldCashoutCount.doubleValue > self.cashoutCount.doubleValue) {
        [SVProgressHUD showError:@"提现金额超出可提现金额，请确认"];
        return;
    }
    if (_shouldCashoutCount.doubleValue > 50000.00) {
        [SVProgressHUD showError:@"单次最大提现为5万元，请确认"];
        return;
    }
    
    static ReceivableModel *selectModel = nil;
    [_dataArray enumerateObjectsUsingBlock:^(NSMutableArray<ReceivableModel *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (selectModel) {
            *stop = YES;
        }else {
            [obj enumerateObjectsUsingBlock:^(ReceivableModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([ToolUtil isEqualToNonNull:obj.id] && obj.isSelected) {
                    selectModel = obj;
                    *stop = YES;
                }
            }];
        }
    }];
//    [_dataArray enumerateObjectsUsingBlock:^(ReceivableModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([ToolUtil isEqualToNonNull:obj.id] && obj.isSelected) {
//            selectModel = obj;
//            *stop = YES;
//        }
//    }];
    if (!selectModel) {
        [SVProgressHUD showError:@"请选择一种提现方式"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    params[@"ctype"] = @"1";
    params[@"cashcount"] = [ToolUtil isEqualToNonNullKong:selectModel.id];
    params[@"uid"] = [UserInfoManager shareManager].uid;
    params[@"draw_money"] = StringWithFormat(_shouldCashoutCount);
    params[@"state"] = StringWithFormat(@(self.receiveType));
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader applyOrderForWallet] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        SingleAMAlertView *alert = [SingleAMAlertView shareInstance];
        alert.title = @"提现申请已提交，预计1个工作日内到账";
        NSString *subTitle = [NSString stringWithFormat:@"提现金额：¥%@",_shouldCashoutCount];
        NSMutableAttributedString *attributedString = [self getCountLabelAttribute:subTitle];
        alert.canTouchBlank = NO;
        alert.subAttributedTitle = attributedString.copy;
        alert.confirmBlock = ^{
            if(_bottomClickBlock) _bottomClickBlock();
            [self.navigationController popViewControllerAnimated:YES];
        };
        [alert show];
    } fail:nil];
}

- (NSMutableAttributedString *)getCountLabelAttribute:(NSString *)string {
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"(¥[0-9]\\d*\\.?\\d*)" options:0 error:NULL];
    
    NSArray<NSTextCheckingResult *> *ranges = [regular matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:string];
    [attStr addAttribute:NSFontAttributeName value:[UIFont addHanSanSC:13.0 fontType:0] range:[string rangeOfString:string]];
    [attStr addAttribute:NSForegroundColorAttributeName value:RGB(153, 153, 153) range:[string rangeOfString:string]];
    
    [ranges enumerateObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [attStr addAttribute:NSForegroundColorAttributeName value:RGB(219, 17, 17) range:obj.range];
    }];
    return attStr;
}

#pragma mark -
- (void)loadData:(id)sender {
    self.layoutTV.allowsSelection = NO;
    
    if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
        [SVProgressHUD show];
    }
    
    if (_dataArray.count) [_dataArray removeAllObjects];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    params[@"uid"] = [UserInfoManager shareManager].uid;
    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    if (_receiveType == 0) {
        dispatch_group_async(group, dispatch_queue_create("com.loadItemData.list", DISPATCH_QUEUE_CONCURRENT), ^{
            if ([UserInfoManager shareManager].isArtist) {
                params[@"all"] = @3;
                [self loadItemData:params.copy withSemaphore:semaphore];
            }
            params[@"all"] = @2;
            [self loadItemData:params.copy withSemaphore:semaphore];
        });
    
    }else {
        dispatch_group_async(group, dispatch_queue_create("com.loadItemData.cashout", DISPATCH_QUEUE_CONCURRENT), ^{
            params[@"all"] = (_receiveType == 1)?@3:@2;
            [self loadItemData:params.copy withSemaphore:semaphore];
        });
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self updateUI];
    });
}

- (void)loadItemData:(NSDictionary *)params withSemaphore:(dispatch_semaphore_t)semaphore {
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader getUserBankAccountList] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        id data = [response objectForKey:@"data"];
        NSMutableArray <ReceivableModel *>*array1 = @[].mutableCopy;
        if (data && [data isKindOfClass:[NSArray class]] && [data count]) {
            [array1 addObjectsFromArray:[NSArray yy_modelArrayWithClass:[ReceivableModel class] json:(NSArray *)response[@"data"]]];
        }
        if ([params[@"all"] integerValue] == 2) {/// 个人
            ReceivableModel *model = [ReceivableModel new];
            model.account_type = params[@"all"];
            [array1 addObject:model];
            
        }else if ([params[@"all"] integerValue] == 3) {/// 经纪人
            if (!array1.count) {
                ReceivableModel *model = [ReceivableModel new];
                model.account_type = params[@"all"];
                [array1 addObject:model];
            }
        }
        [_dataArray addObject:array1];
        
        if (semaphore) dispatch_semaphore_signal(semaphore);
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [SVProgressHUD showError:errorMsg];
        if (semaphore) dispatch_semaphore_signal(semaphore);
    }];

    if (semaphore) dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

- (void)updateUI {
    /// 添加空白模块
    ///经纪人账户列表
    
    if (_dataArray.count && _receiveType == 0) {
        NSMutableArray <ReceivableModel *>*agentArray = _dataArray.firstObject;
        if ([UserInfoManager shareManager].isArtist && ![ToolUtil isEqualToNonNull:agentArray.firstObject.id]) {
            self.tipsLabel.hidden = NO;
            self.tipsLabel.text = @"您好，艺术家！\n您除了绑定自己的银行卡外，还可以添加一张您经纪人的银行卡作为您的收款账户。";
            [self.tipsLabel sizeToFit];
            self.tipsTopConstraint.constant = 15.0f;
            self.tipsBottomConstraint.constant = 15.0f;
        }
    }else {
        self.tipsLabel.hidden = YES;
        self.tipsLabel.text = @"";
        [self.tipsLabel sizeToFit];
        self.tipsTopConstraint.constant = 0.0f;
        self.tipsBottomConstraint.constant = 0.0f;
    }
    
    [self.layoutTV reloadData];
    [self.layoutTV endAllFreshing];
    [self.layoutTV ly_updataEmptyView:!_dataArray.count];
    
//    return;
//    if ([UserInfoManager shareManager].isArtist) {
//        if (!_dataArray_agent.count) {
//            [_dataArray_agent addObject:[ReceivableModel new]];
//        }
//        /// 个人账户列表
//        [_dataArray addObject:[ReceivableModel new]];
//        if (_receiveType == 0) {
//            if (![ToolUtil isEqualToNonNull:_dataArray_agent.firstObject.id]) {
//                self.tipsLabel.hidden = NO;
//                self.tipsLabel.text = @"您好，艺术家！\n您除了绑定自己的银行卡外，还可以添加一张您经纪人的银行卡作为您的收款账户。";
//                [self.tipsLabel sizeToFit];
//                self.tipsTopConstraint.constant = 15.0f;
//                self.tipsBottomConstraint.constant = 15.0f;
//            }else {
//                self.tipsLabel.hidden = YES;
//                self.tipsLabel.text = @"";
//                [self.tipsLabel sizeToFit];
//                self.tipsTopConstraint.constant = 0.0f;
//                self.tipsBottomConstraint.constant = 0.0f;
//            }
//        }
//    }else {
//        [_dataArray addObject:[ReceivableModel new]];
//        self.tipsLabel.hidden = YES;
//        self.tipsLabel.text = @"";
//        [self.tipsLabel sizeToFit];
//        self.tipsTopConstraint.constant = 0.0f;
//        self.tipsBottomConstraint.constant = 0.0f;
//    }
//
//    [self.layoutTV reloadData];
//    [self.layoutTV endAllFreshing];
//    [self.layoutTV ly_updataEmptyView:!_dataArray.count];
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
