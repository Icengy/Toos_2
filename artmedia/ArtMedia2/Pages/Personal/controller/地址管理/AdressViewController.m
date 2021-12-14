//
//  AdressViewController.m
//  ArtMedia
//
//  Created by 美术传媒 on 2018/10/27.
//  Copyright © 2018 lcy. All rights reserved.
//

#import "AdressViewController.h"
#import "AdressTableViewCell.h"
#import "AddAdressViewController.h"
#import "AMEmptyView.h"

@interface AdressViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak) IBOutlet BaseTableView *tableView;
@property(nonatomic,weak) IBOutlet AMButton *addBtn;
@property(nonatomic,strong) NSMutableArray <MyAddressModel *>*dataArray;

@end

@implementation AdressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
    _dataArray = [NSMutableArray new];
    
    self.addBtn.titleLabel.font = [UIFont addHanSanSC:16.0f fontType:0];
	
    self.tableView.bgColorStyle = AMBaseTableViewBackgroundColorStyleGray;
    self.tableView.rowHeight = ADAPTATIONRATIOVALUE(300.0f);
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableHeaderView = [UIView new];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AdressTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AdressTableViewCell class])];
    
	[self.tableView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
    self.tableView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadData:)];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = (_style == 2)?@"选择退货地址":@"地址管理";
	[self loadData:nil];
}

#pragma mark -
-(IBAction)addBtnClick:(id)sender {
    AddAdressViewController *vc = [[AddAdressViewController alloc]init];
    vc.type = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section)
		return CGFLOAT_MIN;
	return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return [UIView new];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AdressTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AdressTableViewCell class]) forIndexPath:indexPath];
    cell.selectionStyle = 0;
	
    MyAddressModel *model = _dataArray[indexPath.section];
	cell.model = model;
	
    @weakify(self);
    cell.editBlock = ^{
        @strongify(self);
        AddAdressViewController *vc = [[AddAdressViewController alloc]init];
        vc.addressModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    };
    cell.deleteBlock = ^{
        @strongify(self);
		AMAlertView *alertView = [AMAlertView shareInstanceWithTitle:@"是否删除该地址？" buttonArray:@[@"是",@"否"] confirm:^{
			[self changeAddressWithModel:model withType:@"3"];
		} cancel:nil];
		[alertView show];
    };
    cell.markBlock = ^{
        @strongify(self);
        [self changeAddressWithModel:model withType:@"4"];
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.chooseAdress) {
        self.chooseAdress(_dataArray[indexPath.section]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -
-(void)loadData:(id)sender {
    self.tableView.allowsSelection = NO;
	if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
		[SVProgressHUD show];
	}
    if (![sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        if (_dataArray.count) [_dataArray removeAllObjects];
    }
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader getUserAddressList] needHUD:NO params:@{@"uid":[UserInfoManager shareManager].uid} success:^(NSInteger code, id  _Nullable response) {
        [self.tableView endAllFreshing];
        
        NSArray*array = (NSArray *)[response objectForKey:@"data"];
        if (array && array.count) {
            [_dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[MyAddressModel class] json:array]];
        }
        [self.tableView ly_updataEmptyView:!_dataArray.count];
        self.tableView.mj_footer.hidden = !_dataArray.count;
        [self.tableView reloadData];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [SVProgressHUD showError:errorMsg];
        [self.tableView endAllFreshing];
    }];
}

-(void)changeAddressWithModel:(MyAddressModel*)model withType:(NSString*)type {
    NSMutableDictionary*address=[NSMutableDictionary dictionary];
    address[@"uid"] = [UserInfoManager shareManager].uid;
    address[@"id"] = [ToolUtil isEqualToNonNullKong:model.ID];
    address[@"reciver"] = [ToolUtil isEqualToNonNullKong:model.reciver];
    address[@"phone"] = [ToolUtil isEqualToNonNullKong:model.phone];
    address[@"addrregion"] = [ToolUtil isEqualToNonNullKong:model.addrregion];
    address[@"address"] = [ToolUtil isEqualToNonNullKong:model.address];
    address[@"is_default"] = StringWithFormat(@(model.is_default));
    
    NSMutableDictionary*dic = @{}.mutableCopy;
    [dic setObject:type forKey:@"type"];
    [dic setObject:address.copy forKey:@"address"];
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader editUserAddress] params:dic.copy success:^(NSInteger code, id  _Nullable response) {
        [SVProgressHUD showSuccess:response[@"message"] completion:^{
            [self loadData:nil];
        }];
    } fail:nil];
}


@end
