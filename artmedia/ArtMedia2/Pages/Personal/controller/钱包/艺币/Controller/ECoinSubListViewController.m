//
//  ECoinSubListViewController.m
//  ArtMedia2
//
//  Created by 刘洋 on 2020/10/19.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "ECoinSubListViewController.h"
#import "ECoinRecordDetailViewController.h"

#import "ECoinRecordCell.h"

#import "ECoinRecordModel.h"
@interface ECoinSubListViewController ()<UITableViewDelegate , UITableViewDataSource>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (nonatomic , strong) NSMutableArray <ECoinRecordModel *>*listData;
@property (nonatomic , assign) NSInteger page;
@end

@implementation ECoinSubListViewController
- (NSMutableArray *)listData{
    if (!_listData) {
        _listData = [[NSMutableArray alloc] init];
    }
    return _listData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    [self setTableView];
    [self loadData:nil];
}
- (void)loadData:(id _Nullable)sender{
    NSString *type;
    if (self.type == ECoinListRecordTypeAll) {
        type = @"";
    }else if (self.type == ECoinListRecordTypeConsumption){
        type = @"2";
    }else if (self.type == ECoinListRecordTypeRecharge){
        type = @"1";
    }
    if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
        [SVProgressHUD show];
    }
    if (sender && [sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        self.page ++;
    }else {
        self.page = 1;
        if (self.listData.count) [self.listData removeAllObjects];
    }
    
    NSMutableDictionary *dic= [NSMutableDictionary dictionary];
    dic[@"current"] = @(self.page);
    dic[@"consumeType"] = type;
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader selectAccountVirualGoldDetailListByMemberId] needHUD:NO params:dic success:^(NSInteger code, id  _Nullable response) {
        [self.tableView endAllFreshing];
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            NSArray *records = (NSArray *)[data objectForKey:@"records"];
            if (records && records.count) {
                [self.listData addObjectsFromArray:[NSArray yy_modelArrayWithClass:[ECoinRecordModel class] json:records]];
            }
            [self.tableView updataFreshFooter:(self.listData.count && records.count != MaxListCount)];
            [self.tableView ly_updataEmptyView:!self.listData.count];
            self.tableView.mj_footer.hidden = !self.listData.count;
            [self.tableView reloadData];
        }
        
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [self.tableView endAllFreshing];
        [SVProgressHUD showError:errorMsg];
    }];
}


- (void)setTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorInset = UIEdgeInsetsMake(15, 0, 15, 0);
    self.tableView.separatorColor = RGB(230, 230, 230);
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ECoinRecordCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ECoinRecordCell class])];
    [self.tableView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
    [self.tableView addRefreshFooterWithTarget:self action:@selector(loadData:)];
    self.tableView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadData:)];
}

#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ECoinRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ECoinRecordCell class]) forIndexPath:indexPath];
    cell.model = self.listData[indexPath.row];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ECoinRecordDetailViewController *vc = [[ECoinRecordDetailViewController alloc] init];
    vc.goldId = self.listData[indexPath.row].goldId;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
