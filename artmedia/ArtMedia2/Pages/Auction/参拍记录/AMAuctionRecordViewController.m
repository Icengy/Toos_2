//
//  AMAuctionRecordViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/11/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMAuctionRecordViewController.h"
#import "AuctionItemDetailViewController.h"

#import "AMAuctionRecordTableViewCell.h"

#import "AMAuctionRecordModel.h"

@interface AMAuctionRecordViewController () <UITableViewDelegate , UITableViewDataSource>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@end

@implementation AMAuctionRecordViewController {
    NSMutableArray <AMAuctionRecordModel *>*_dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.bgColorStyle = AMBaseBackgroundColorStyleGray;
    
    _dataArray = @[].mutableCopy;
    self.pageIndex = 1;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMAuctionRecordTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMAuctionRecordTableViewCell class])];
    
    [self.tableView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
    [self.tableView addRefreshFooterWithTarget:self action:@selector(loadData:)];
    self.tableView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self imageStr:@"icon-hummer-current" titleStr:nil detailStr:@"暂无参拍记录" btnTitleStr:nil action:@selector(loadData:)];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"参拍记录";
    
    if (!_dataArray.count) [self loadData:nil];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AMAuctionRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMAuctionRecordTableViewCell class]) forIndexPath:indexPath];
    if(_dataArray.count) cell.model = _dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AMAuctionRecordTableViewCell *cell = (AMAuctionRecordTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    AuctionItemDetailViewController *detailVC = [[AuctionItemDetailViewController alloc] init];
    detailVC.auctionGoodId = cell.model.auctionGoodId;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark -
- (void)loadData:(id)sender {
    self.tableView.allowsSelection = NO;
    if (sender && [sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        self.pageIndex ++;
    }else {
        self.pageIndex = 1;
        if (_dataArray.count) [_dataArray removeAllObjects];
    }
    if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
        [SVProgressHUD show];
    }
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"current"] = StringWithFormat(@(self.pageIndex));
    params[@"size"] = StringWithFormat(@(MaxListCount));
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader selectAuctionUserGoodsRecordListOfCurrentUser] needHUD:NO params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [self.tableView endAllFreshing];
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            NSArray *records = (NSArray *)[data objectForKey:@"records"];
            if (records && records.count) {
                [_dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[AMAuctionRecordModel class] json:records]];
            }
            [self.tableView updataFreshFooter:(_dataArray.count && records.count != MaxListCount)];
        }
        
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
