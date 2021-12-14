//
//  ArtworkListViewController.m
//  ArtMedia2
//
//  Created by LY on 2020/12/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "ArtworkListViewController.h"
#import "GoodsPartViewController.h"
#import "ArtworkListCell.h"
#import "ArtWorkListModel.h"

@interface ArtworkListViewController ()<UITableViewDelegate , UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic , assign) NSInteger page;
@property (nonatomic , strong) NSMutableArray <ArtWorkListModel *>*listData;
@property (nonatomic , assign) NSInteger timespan;

@end

@implementation ArtworkListViewController

- (NSMutableArray<ArtWorkListModel *> *)listData{
    if (!_listData) {
        _listData = [[NSMutableArray alloc] init];
    }
    return _listData;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setTableView];
    [self get_goods_list_with_map:nil];
}


- (void)get_goods_list_with_map:(id _Nullable)sender{
    self.tableView.allowsSelection = NO;
    
    if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
        [SVProgressHUD show];
    }
    if (sender && [sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) _page ++;
    else {
        self.page = 0;
        if (self.listData.count) [self.listData removeAllObjects];
    }

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"page"] = @(self.page);
    if (self.page > 0) {
        dic[@"timespan"] = @(self.timespan);
    }else{
        dic[@"timespan"] = @"";
    }
    dic[@"good_type"] = self.type;
    [ApiUtil postWithParent:self url:[ApiUtilHeader get_goods_list_with_map] needHUD:NO params:dic success:^(NSInteger code, id  _Nullable response) {
        if (response) {
            NSArray *array = [NSArray yy_modelArrayWithClass:[ArtWorkListModel class] json:response[@"data"][@"goods_list"]];
            if (array && array.count) {
                [self.listData addObjectsFromArray:array];
            }
            self.timespan = (NSInteger)response[@"data"][@"timespan"];
            NSLog(@"%ld",(long)self.timespan);
            [self.tableView updataFreshFooter:(self.listData.count && array.count != MaxListCount)];
        }
        [self.tableView reloadData];
        [self.tableView endAllFreshing];
        [self.tableView ly_updataEmptyView:!self.listData.count];
        self.tableView.mj_footer.hidden = !self.listData.count;
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [self.tableView endAllFreshing];
    }];
}


//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//
//}
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//}
- (void)setTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ArtworkListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ArtworkListCell class])];
    [self.tableView addRefreshHeaderWithTarget:self action:@selector(get_goods_list_with_map:)];
    [self.tableView addRefreshFooterWithTarget:self action:@selector(get_goods_list_with_map:)];
    
    self.tableView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(get_goods_list_with_map:)];
}

#pragma mark - UITableViewDelegate , UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ArtworkListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ArtworkListCell class]) forIndexPath:indexPath];
    cell.model = self.listData[indexPath.row];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodsPartViewController *vc = [[GoodsPartViewController alloc] init];
    vc.goodsID = self.listData[indexPath.row].gid;
    [self.navigationController pushViewController:vc animated:YES];
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    ArtWorkListModel *model = self.listData[indexPath.row];
//    if (model.pic_width > K_Width) {
//        return  (K_Width - 30) *(model.pic_height/model.pic_width);
//    }else{
//        return  K_Width - 30;
//    }

//}
@end
