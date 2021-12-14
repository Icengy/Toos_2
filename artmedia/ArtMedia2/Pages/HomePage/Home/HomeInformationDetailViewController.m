//
//  HomeInformationDetailViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/2/25.
//  Copyright © 2020 lcy. All rights reserved.
//

#import "HomeInformationDetailViewController.h"

#import "WebViewURLViewController.h"

#import "HomeInforDetailTableViewCell.h"
#import "AMEmptyView.h"

#import "HomeInforModel.h"

@interface HomeInformationDetailViewController () <UITableViewDelegate ,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *tableView;
@end

@implementation HomeInformationDetailViewController {
    NSMutableArray <HomeInforModel *>*_dataArray;
    NSInteger _page;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.rowHeight = ADAPTATIONRATIOVALUE(190);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;;
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeInforDetailTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HomeInforDetailTableViewCell class])];
        
        [_tableView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
        [_tableView addRefreshFooterWithTarget:self action:@selector(loadData:)];
        _tableView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadData:)];
        
    }return _tableView;
}

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    
    _dataArray = [NSMutableArray new];
    _page = 0;
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!_dataArray.count)
        [self loadData:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeInforDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeInforDetailTableViewCell class]) forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HomeInforModel *model = _dataArray[indexPath.row];
    if (![ToolUtil isEqualToNonNull:model.id]) {
        [SVProgressHUD showMsg:@"资讯数据错误，请重试或联系客服"];
        return;
    }
//    [ApiUtil post:[ApiUtilHeader getInformationDetail]
//           params:@{@"informationid":[ToolUtil isEqualToNonNull:model.id replace:@"0"]}
//          success:^(id  _Nullable response) {
//        NSDictionary *dict = (NSDictionary *)response[@"data"];
//        WebViewURLViewController *webView = [[WebViewURLViewController alloc] initWithUrlString:dict[@"content"]];
//        NSString *title = [ToolUtil isEqualToNonNull:dict[@"title"] replace:_detailType];
//        if (![title hasPrefix:_detailType] && title.length > 10) {
//            title = [title substringToIndex:10];
//            title = [NSString stringWithFormat:@"%@...",title];
//        }
//        webView.navigationBarTitle = title;
//        [self.navigationController pushViewController:webView animated:YES];
//    } fail:nil];
}

#pragma mark -
- (void)loadData:(id _Nullable)sender {
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
    params[@"page"] = [NSString stringWithFormat:@"%@",@(_page)];
    params[@"type"] = StringWithFormat(_detailTypeID);
    params[@"num"] = StringWithFormat(@(0));
    
//    [ApiUtil post:[ApiUtilHeader get_information_list] needHUD:NO params:params success:^(id response) {
//        if (sender && ([sender isKindOfClass:[MJRefreshAutoNormalFooter class]] || [sender isKindOfClass:[MJRefreshNormalHeader class]])) {
//            [self.tableView endAllFreshing];
//        }
//        NSArray*array = (NSArray *)[response objectForKey:@"data"];
//        if (array && array.count) {
//            [_dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[HomeInforModel class] json:array]];
//        }
//
//        [self.tableView updataFreshFooter:(_dataArray.count && array.count != MaxListCount)];
//        [self.tableView ly_updataEmptyView:!_dataArray.count];
//        self.tableView.mj_footer.hidden = !_dataArray.count;
//        [self.tableView reloadData];
//
//    } fail:^(id _Nonnull error) {
//        if (error) [SVProgressHUD showError:showNetworkError];
//        [self.tableView endAllFreshing];
//    }];
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
