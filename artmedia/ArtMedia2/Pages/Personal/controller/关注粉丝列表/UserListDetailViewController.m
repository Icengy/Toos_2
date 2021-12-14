//
//  UserListDetailViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/22.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "UserListDetailViewController.h"

#import "UserListDetailTableViewCell.h"
//#import "CustomPersonalViewController.h"
#import "AMBaseUserHomepageViewController.h"
#import "AMEmptyView.h"

@interface UserListDetailViewController () <UITableViewDelegate ,UITableViewDataSource>
@property (nonatomic ,weak) IBOutlet BaseTableView *tableView;
@property (nonatomic ,strong) NSMutableArray <NSDictionary *>*dataArray;
@end

@implementation UserListDetailViewController {
	NSInteger _page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = _detailType?@"我的粉丝":@"我的关注";
    
	_dataArray = [NSMutableArray new];
	_page = 0;
	
    self.tableView.bgColorStyle = AMBaseTableViewBackgroundColorStyleGray;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = ADAPTATIONRATIOVALUE(120.0f);
    self.tableView.sectionFooterHeight = CGFLOAT_MIN;
    self.tableView.sectionHeaderHeight = CGFLOAT_MIN;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UserListDetailTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UserListDetailTableViewCell class])];
    
	[self.tableView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
	[self.tableView addRefreshFooterWithTarget:self action:@selector(loadData:)];
    self.tableView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadData:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if (!_dataArray.count) [self loadData:nil];
}

#pragma mark -
- (void)loadData:(id)sender {
    
    self.tableView.allowsSelection = NO;
	if (sender && [sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
		_page ++;
	}else {
		_page = 0;
		if (_dataArray.count) [_dataArray removeAllObjects];
	}
	if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
		[SVProgressHUD show];
	}
	NSString *urlString = _detailType?[ApiUtilHeader getFansList]:[ApiUtilHeader getCollectUserList];
	NSMutableDictionary *params = [NSMutableDictionary new];
	
	params[@"uid"] = [UserInfoManager shareManager].uid;
	params[@"page"] = StringWithFormat(@(_page));
	
    [ApiUtil postWithParent:self url:urlString needHUD:NO params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [self.tableView endAllFreshing];
        
        NSArray*array = (NSArray *)[response objectForKey:@"data"];
        if (array && array.count) {
            [_dataArray addObjectsFromArray:array];
        }
        
        [self.tableView updataFreshFooter:(_dataArray.count && array.count != MaxListCount)];
        [self.tableView ly_updataEmptyView:!_dataArray.count];
        self.tableView.mj_footer.hidden = !_dataArray.count;
        [self.tableView reloadData];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [self.tableView endAllFreshing];
    }];
}

#pragma mark -
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UserListDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UserListDetailTableViewCell class]) forIndexPath:indexPath];
	
    cell.detailType = self.detailType;
	cell.model = _dataArray[indexPath.row];
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSDictionary *model = _dataArray[indexPath.row];
    if (self.detailType) {/// 粉丝
        if ([ToolUtil isEqualToNonNull:[model objectForKey:@"uid"]] && [[model objectForKey:@"uid"] integerValue] <= 0) {
            [SVProgressHUD showError:@"该用户已删除，无法访问"];
            return;
        }
    }else {/// 关注
        if ([ToolUtil isEqualToNonNull:[model objectForKey:@"cuid"]] && [[model objectForKey:@"cuid"] integerValue] <= 0) {
            [SVProgressHUD showError:@"该用户已删除，无法访问"];
            return;
        }
    }

//	CustomPersonalViewController *cpVC = [CustomPersonalViewController shareInstance];
//    cpVC.artuid = [ToolUtil isEqualToNonNullKong:self.detailType?[model objectForKey:@"uid"]:[model objectForKey:@"cuid"]];
//	[self.navigationController pushViewController:cpVC animated:YES];

    AMBaseUserHomepageViewController * vc = [[AMBaseUserHomepageViewController alloc] init];
    vc.artuid = [ToolUtil isEqualToNonNullKong:self.detailType?[model objectForKey:@"uid"]:[model objectForKey:@"cuid"]];
    [self.navigationController pushViewController:vc animated:YES];
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
