//
//  BlacklistViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2020/1/9.
//  Copyright © 2020 lcy. All rights reserved.
//

#import "BlacklistViewController.h"

#import "BlacklistTableViewCell.h"
#import "AMEmptyView.h"

@interface BlacklistViewController () <UITableViewDelegate ,UITableViewDataSource>

@property (nonatomic ,strong) NSMutableArray *dataArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BlacklistViewController {
	int _page;
}

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.bgColorStyle = AMBaseBackgroundColorStyleGray;
	
	_dataArray = [NSMutableArray new];
	_page = 0;
	
	_tableView.rowHeight = ADAPTATIONRATIOVALUE(120.0f);
	_tableView.delegate = self;
	_tableView.dataSource = self;
	[_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BlacklistTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BlacklistTableViewCell class])];
	
	[_tableView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
	[_tableView addRefreshFooterWithTarget:self action:@selector(loadData:)];
	
    _tableView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadData:)];
}

- (void)viewWillAppear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self.navigationItem setTitle:@"黑名单管理"];
	
	if (!_dataArray.count) {
		[self loadData:nil];
	}
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	[self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.edges.offset(0);
	}];
}

#pragma mark -
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return [UIView new];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	BlacklistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BlacklistTableViewCell class])];
	
	cell.model = _dataArray[indexPath.row];
	cell.removeBlock = ^(BlacklistModel * _Nonnull model) {
		[self removeBlacklist:model];
	};
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
- (void)removeBlacklist:(BlacklistModel *)model {
	
	NSMutableDictionary *params = [NSMutableDictionary new];
	
	params[@"uid"] = [UserInfoManager shareManager].uid;
	params[@"type"] = @"3";
	params[@"objtype"] = @"6";
	params[@"objid"] = [ToolUtil isEqualToNonNullKong:model.collect_id];
	
    [ApiUtil postWithParent:self url:[ApiUtilHeader collectObject] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [SVProgressHUD showSuccess:@"已移除黑名单" completion:^{
            [self loadData:nil];
        }];
    } fail:nil];
}

#pragma mark -
- (void)loadData:(id _Nullable)sender {
    self.tableView.allowsSelection = NO;
    
	if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
		[SVProgressHUD show];
	}
	if (sender && [sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
		_page ++;
	}else {
		_page = 0;
        if (_dataArray.count) [_dataArray removeAllObjects];
	}
	NSMutableDictionary *params = [NSMutableDictionary new];
	
    params[@"uid"] = [UserInfoManager shareManager].uid;
	params[@"page"] = StringWithFormat(@(_page));
	
    [ApiUtil postWithParent:self url:[ApiUtilHeader get_blacklist] needHUD:NO params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [self.tableView endAllFreshing];
        
        NSArray *array = (NSArray *)response[@"data"];
        if (array && array.count) {
            [_dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[BlacklistModel class] json:array]];
        }
        [self.tableView updataFreshFooter:(_dataArray.count && array.count != MaxListCount)];
        [self.tableView ly_updataEmptyView:!_dataArray.count];
        self.tableView.mj_footer.hidden = !_dataArray.count;
        [self.tableView reloadData];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [SVProgressHUD showError:errorMsg];
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
