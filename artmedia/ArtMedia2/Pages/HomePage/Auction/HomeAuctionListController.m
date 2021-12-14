//
//  HomeAuctionListController.m
//  ArtMedia2
//
//  Created by LY on 2020/11/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "HomeAuctionListController.h"
#import "AuctionSpecialDetailViewController.h"

#import "AuctionHomeListCell.h"
#import "AuctionModel.h"


@interface HomeAuctionListController ()<UITableViewDataSource , UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic , strong) NSMutableArray <AuctionModel *>*listData;
@property (nonatomic , assign) NSInteger page;
@property (weak, nonatomic) IBOutlet AMButton *hammerButton;
@end

@implementation HomeAuctionListController
- (NSMutableArray<AuctionModel *> *)listData{
    if (!_listData) {
        _listData = [[NSMutableArray alloc] init];
    }
    return _listData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
    // Do any additional setup after loading the view from its nib.
}

- (void)setTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AuctionHomeListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AuctionHomeListCell class])];
    [self.tableView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
    [self.tableView addRefreshFooterWithTarget:self action:@selector(loadData:)];
    
    self.tableView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadData:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isSecond) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.navigationItem.title = @"历史专场";
        self.hammerButton.hidden = YES;
    }
    if (!self.listData.count) [self loadData:nil];
}

- (IBAction)goAuctionHistoryList:(id)sender {
    
    HomeAuctionListController *vc = [[HomeAuctionListController alloc] init];
    vc.isSecond = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)reloadCurrent:(NSNotification *)notification {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    [self loadData:notification];
}

#pragma mark -
- (void)loadData:(id _Nullable)sender {
    self.tableView.allowsSelection = NO;
    
    if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
        [SVProgressHUD show];
    }
    if (sender && [sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) _page ++;
    else {
        _page = 1;
        if (self.listData.count) [self.listData removeAllObjects];
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"current"] = @(_page);
    dic[@"size"] = @"10";
    dic[@"fieldStatus"] = self.isSecond?@"7" : @"1";
    [ApiUtil postWithParent:self url:[ApiUtilHeader selectAuctionFieldListOfHome] needHUD:NO params:dic success:^(NSInteger code, id  _Nullable response) {
        [self.tableView endAllFreshing];
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            NSArray *records = (NSArray *)[data objectForKey:@"records"];
            if (records && records.count) {
                [self.listData addObjectsFromArray:[NSArray yy_modelArrayWithClass:[AuctionModel class] json:records]];
            }
            [self.tableView updataFreshFooter:(self.listData.count && records.count != MaxListCount)];
        }
        [self.tableView ly_updataEmptyView:!self.listData.count];
        self.tableView.mj_footer.hidden = !self.listData.count;
        [self.tableView reloadData];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [self.tableView endAllFreshing];
        [SVProgressHUD showError:errorMsg];
    }];
}

#pragma mark - UITableViewDataSource , UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AuctionHomeListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AuctionHomeListCell class]) forIndexPath:indexPath];
    if (self.listData.count) cell.model = self.listData[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AuctionHomeListCell *cell = (AuctionHomeListCell *)[tableView cellForRowAtIndexPath:indexPath];
    AuctionSpecialDetailViewController *vc = [[AuctionSpecialDetailViewController alloc] init];
    vc.auctionFieldId = cell.model.auctionFieldId;
    [self.navigationController pushViewController:vc animated:YES];
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


@end
