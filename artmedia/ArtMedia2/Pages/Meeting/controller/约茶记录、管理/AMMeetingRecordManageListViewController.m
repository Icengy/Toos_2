//
//  AMMeetingRecordManageListViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/8/17.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMMeetingRecordManageListViewController.h"
#import "HK_appointmentDetailVC.h"

#import "AMMeetingRecordManageListTableCell.h"
#import "AMEmptyView.h"

#import "AMMeetingOrderManagerListModel.h"

@interface AMMeetingRecordManageListViewController () <UITableViewDelegate ,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;

@end

@implementation AMMeetingRecordManageListViewController {
    NSInteger _page;
    NSMutableArray <AMMeetingOrderManagerListModel *>*_dataArray;
}

- (instancetype)init {
    if (self = [super init]) {
        _page = 1;
        _dataArray = @[].mutableCopy;
    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMMeetingRecordManageListTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMMeetingRecordManageListTableCell class])];
    
    [self.tableView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
    [self.tableView addRefreshFooterWithTarget:self action:@selector(loadData:)];
    self.tableView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadData:)];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData:nil];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AMMeetingRecordManageListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMMeetingRecordManageListTableCell class]) forIndexPath:indexPath];
    cell.style = self.style;
    if (_dataArray.count) cell.model = _dataArray[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section?CGFLOAT_MIN:10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = UIColor.clearColor;
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = UIColor.clearColor;
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.style == AMMeetingRecordManageStyleManage) return;
    HK_appointmentDetailVC *detailVC = [[HK_appointmentDetailVC alloc] init];
//    detailVC.appointment_Status = _dataArray[indexPath.section].orderStatus;
    detailVC.teaAboutOrderId = _dataArray[indexPath.section].teaAboutOrderId;
    [self.navigationController pushViewController:detailVC animated:YES];
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
        _page = 1;
        if (_dataArray.count) [_dataArray removeAllObjects];
    }
    
    NSString *urlStr = self.style?[ApiUtilHeader getMeetingOrderManageList]:[ApiUtilHeader getMeetingOrderRecordList];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"current"] = @(_page);
    if (self.style) {
        params[@"artistId"] = [UserInfoManager shareManager].uid;
        params[@"orderStatus"] = @(self.listStyle);
    }else {
        params[@"memberId"] = [UserInfoManager shareManager].uid;
        params[@"orderStatus"] = @(self.listStyle);
    }
    
    [ApiUtil postWithParent:self url:urlStr needHUD:NO params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [self.tableView endAllFreshing];
        
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            NSArray *records = (NSArray *)[data objectForKey:@"records"];
            if (records && records.count) {
                [_dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[AMMeetingOrderManagerListModel class] json:records]];
            }
            [self.tableView updataFreshFooter:(_dataArray.count && records.count != MaxListCount)];
        }
        
        [self.tableView ly_updataEmptyView:!_dataArray.count];
        self.tableView.mj_footer.hidden = !_dataArray.count;
        [self.tableView reloadData];
        
        if (_updateTotalBlock) _updateTotalBlock(self.listStyle, [[data objectForKey:@"total"] integerValue]);
        
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [self.tableView endAllFreshing];
        [SVProgressHUD showError:errorMsg];
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
