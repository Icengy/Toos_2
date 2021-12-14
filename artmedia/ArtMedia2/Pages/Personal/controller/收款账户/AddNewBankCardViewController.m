//
//  AddNewBankCardViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/21.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "AddNewBankCardViewController.h"
#import "BankCardListViewController.h"

#import "AddNewBankCardCell.h"

@interface AddNewBankCardViewController () <UITableViewDelegate ,UITableViewDataSource, AddNewBankCardCellDelegate, BankCardListDelegate>
@property (weak, nonatomic) IBOutlet BaseTableView *layoutTV;

/// 银行信息
@property (nonatomic ,strong ,nullable) BankCardListModel *bankModel;
/// 持卡人姓名
@property (nonatomic ,copy) NSString *ownerName;
/// 身份证号
@property (nonatomic ,copy) NSString *cardNum;
/// 银行卡号
@property (nonatomic ,copy) NSString *bankCardNum;

@property (weak, nonatomic) IBOutlet AMButton *confirmBtn;

@end

@implementation AddNewBankCardViewController

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (_accountType == 2 && [UserInfoManager shareManager].isAuthed) {
        _ownerName = [ToolUtil isEqualToNonNullKong:[UserInfoManager shareManager].model.auth_data.real_name];
        _cardNum = [ToolUtil isEqualToNonNullKong:[UserInfoManager shareManager].model.auth_data.id_card_number];
    }
    _confirmBtn.titleLabel.font = [UIFont addHanSanSC:18.0 fontType:1];
	
    _layoutTV.bgColorStyle = AMBaseTableViewBackgroundColorStyleGray;
	_layoutTV.delegate = self;
	_layoutTV.dataSource = self;
	
    _layoutTV.rowHeight = 50.0f;
    _layoutTV.tableFooterView = [UIView new];
    _layoutTV.sectionFooterHeight = CGFLOAT_MIN;
	
	[_layoutTV registerNib:[UINib nibWithNibName:NSStringFromClass([AddNewBankCardCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AddNewBankCardCell class])];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self.navigationItem setTitle:[NSString stringWithFormat:@"添加银行卡%@",( _accountType%2)?@"（经纪人）":@"（本人）"]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[self.view endEditing:YES];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *wrapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_Width, 50.0f)];
    wrapView.backgroundColor = tableView.backgroundColor;
    
	UILabel *titleLabel = [[UILabel alloc] init];
	[wrapView addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(wrapView);
        make.left.equalTo(wrapView.mas_left).offset(15.0f);
	}];
    
    titleLabel.text = [NSString stringWithFormat:@"请绑定%@的银行卡",( _accountType%2)?@"经纪人":@"您本人"];
	titleLabel.textColor = RGB(122,129,153);
	titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    [titleLabel sizeToFit];
	
	return wrapView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	AddNewBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AddNewBankCardCell class])];
    
	cell.delegate = self;
	
	switch (indexPath.row) {
		case 0:
            [cell addNameText:@"持卡人：" detailName:_ownerName placeholder:[NSString stringWithFormat:@"请输入%@姓名", ( _accountType%2)?@"经纪人":@"您本人的"] indexPath:indexPath enabled:![ToolUtil isEqualToNonNull:_ownerName]];
			break;
		case 1:
			[cell addNameText:@"身份证号：" detailName:_cardNum placeholder:[NSString stringWithFormat:@"请输入%@身份证号",( _accountType%2)?@"经纪人":@"您本人的"] indexPath:indexPath enabled:![ToolUtil isEqualToNonNull:_cardNum]];
			break;
		case 2:
            [cell addNameText:@"银行名：" detailName:_bankModel.bank_name placeholder:@"请选择银行" indexPath:indexPath];
			break;
        case 3:
            [cell addNameText:@"卡号：" detailName:_bankCardNum placeholder:@"请输入银行卡号" indexPath:indexPath];
            break;
		default:
			break;
	}
	
	return cell;
}

#pragma mark - AddNewBankCardCellDelegate
- (void)cellClickToAddBankName {
	NSLog(@"cellClickToAddBankName");
	[self.view endEditing:YES];
    BankCardListViewController *listVC = [[BankCardListViewController alloc] init];
    listVC.delegate = self;
    listVC.selectedModel = self.bankModel;
    listVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self.navigationController presentViewController:listVC animated:YES completion:nil];
}

- (void)writeTFValue:(NSString *)tfValue indexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case 0:
            _ownerName = tfValue;
			break;
		case 1:
            _cardNum = tfValue;
			break;
		case 3:
			_bankCardNum = tfValue;
			break;
			
		default:
			break;
	}
}
#pragma mark - BankCardListDelegate
- (void)viewController:(BaseViewController *)viewController didSelectedArtField:(BankCardListModel *)bankModel {
    self.bankModel = bankModel;
    [self.layoutTV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
}

#pragma mark -
- (IBAction)clickToCommitNew:(id)sender {
    if (![ToolUtil isEqualToNonNull:_bankModel.id]) {
		[SVProgressHUD showMsg:@"请选择银行"];
		return;
	}
	if (![ToolUtil isEqualToNonNull:_ownerName]) {
		[SVProgressHUD showMsg:@"请填写持卡人姓名"];
		return;
	}
    if (![ToolUtil verifyIDCardString:_cardNum]) {
        [SVProgressHUD showMsg:@"请填写正确的身份证号"];
        return;
    }
	if (![ToolUtil isEqualToNonNull:_bankCardNum]) {
		[SVProgressHUD showMsg:@"请填写银行卡号"];
		return;
	}
	
	NSMutableDictionary *params = [NSMutableDictionary new];
	
    params[@"uid"] = [UserInfoManager shareManager].uid;
	params[@"account_type"] = StringWithFormat(@(_accountType));
	params[@"account_user_name"] = [ToolUtil isEqualToNonNullKong:_ownerName];
	NSString *cardID = [_bankCardNum stringByReplacingOccurrencesOfString:@" " withString:@""];
	params[@"account_number"] = [ToolUtil isEqualToNonNullKong:cardID];
    params[@"idcard"] = [ToolUtil isEqualToNonNullKong:_cardNum];
    params[@"bank_id"] = [ToolUtil isEqualToNonNullKong:_bankModel.id];
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader addUserBankAccount] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [SVProgressHUD showSuccess:@"添加成功" completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } fail:nil];
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
