//
//  HK_invitationListVC.m
//  ArtMedia2
//
//  Created by guohongkai on 2020/8/21.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "HK_invitationListVC.h"
#import "HK_invitationListCell.h"
#import "HK_tea_managerModel.h"

#import "AMBaseUserHomepageViewController.h"

@interface HK_invitationListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@end

@implementation HK_invitationListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}

- (void)configUI{
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HK_invitationListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HK_invitationListCell class])];
    
    [self.tableView addRefreshFooterWithTarget:self action:@selector(loadData:)];
    [self.tableView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
    
    self.tableView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadData:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.HK_dataArr.count) {
        [self loadData:nil];
    }
}

- (void)loadData:(id)sender {
    self.tableView.allowsSelection = NO;
    if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
        [SVProgressHUD show];
    }
    if (sender && [sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        self.pageIndex ++;
    }else {
        self.pageIndex = 1;
        if (self.HK_dataArr.count) [self.HK_dataArr removeAllObjects];
    }

    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"teaAboutInfoId"] = [ToolUtil isEqualToNonNullKong:self.teaAboutInfoId];
    params[@"status"] = @(self.InvitaStatus);
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader invitationNumberList] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [self.tableView endAllFreshing];
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            NSArray *records = (NSArray *)[data objectForKey:@"records"];
            if (records && records.count) {
                [self.HK_dataArr addObjectsFromArray:[NSArray yy_modelArrayWithClass:[HK_tea_managerModel class] json:records]];
            }
            [self.tableView updataFreshFooter:(self.HK_dataArr.count&&records.count!=MaxListCount)];
        }
        [self.tableView updataFreshFooter:(self.HK_dataArr.count&&self.HK_dataArr.count!=MaxListCount)];
        [self.tableView ly_updataEmptyView:!self.HK_dataArr.count];
        [self.tableView reloadData];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [self.tableView endAllFreshing];
        [SVProgressHUD showError:errorMsg];
    }];
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.HK_dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section?CGFLOAT_MIN:10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HK_invitationListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HK_invitationListCell class])];
    
    cell.model = self.HK_dataArr[indexPath.section];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HK_tea_managerModel * model = self.HK_dataArr[indexPath.section];
    AMBaseUserHomepageViewController * vc = [[AMBaseUserHomepageViewController alloc] init];
    vc.artuid = model.memberId;
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
