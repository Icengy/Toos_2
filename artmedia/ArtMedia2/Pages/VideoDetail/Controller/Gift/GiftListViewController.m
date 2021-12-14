//
//  GiftListViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/26.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "GiftListViewController.h"

#import "VideoListModel.h"

#import "GiftListTableViewCell.h"
#import "AMEmptyView.h"


@interface GiftListViewController () <UITableViewDelegate ,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray <GiftRankListModel *>*dataArray;

@end

@implementation GiftListViewController {
	NSInteger _page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.view.backgroundColor = UIColor.clearColor;
	
	_dataArray = [NSMutableArray new];
	_page = 0;
	
	self.tableView.sectionFooterHeight = CGFLOAT_MIN;
	self.tableView.sectionHeaderHeight = CGFLOAT_MIN;
	self.tableView.tableFooterView = [UIView new];
	self.tableView.tableHeaderView = [UIView new];
	
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	
	[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GiftListTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([GiftListTableViewCell class])];
	
	[self.tableView addRefreshFooterWithTarget:self action:@selector(loadData:)];
//	[self.tableView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
    self.tableView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self imageStr:@"gift_null" action:@selector(loadData:)];
    
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (!_dataArray.count)
        [self loadData:nil];
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return ADRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	GiftListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GiftListTableViewCell class]) forIndexPath:indexPath];
	
	cell.model = _dataArray[indexPath.row];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
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
	params[@"obj_uid"] = [ToolUtil isEqualToNonNullKong:_model.artModel.ID];
	params[@"page"] = [NSString stringWithFormat:@"%@",@(_page)];
	
    [ApiUtil postWithParent:self url:[ApiUtilHeader getGiftRank] needHUD:NO params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [self.tableView endAllFreshing];
        
        NSArray *array = (NSArray *)[response objectForKey:@"data"];
        if (array && array.count) {
            [_dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[GiftRankListModel class] json:array]];
            [_dataArray enumerateObjectsUsingBlock:^(GiftRankListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.sort = [NSString stringWithFormat:@"%@",@(idx + 1)];
            }];
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
