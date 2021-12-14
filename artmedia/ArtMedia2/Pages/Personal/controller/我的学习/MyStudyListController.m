//
//  MyStudyListController.m
//  ArtMedia2
//
//  Created by LY on 2020/10/20.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "MyStudyListController.h"
#import "ClassDetailViewController.h"
#import "HomeCourseListViewController.h"
#import "MainTabBarController.h"

//#import "MyStudyListModel.h"
#import "AMCourseModel.h"

#import "MyStudyListCell.h"
@interface MyStudyListController ()<UITableViewDelegate , UITableViewDataSource>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , strong) NSMutableArray <AMCourseModel *>*listData;
//@property (nonatomic , strong) UIButton *quKanButton;
@property (nonatomic , strong) UIView *noneView;


@end

@implementation MyStudyListController
- (UIView *)noneView{
    if (!_noneView) {
        _noneView = [[UIView alloc] init];
        _noneView.width = K_Width;
        _noneView.height = K_Width/2;
        _noneView.center = self.view.center;
        
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"mystudylist_none"];
        [imageView sizeToFit];
        imageView.center = _noneView.center;
        imageView.y = 0;
        [_noneView addSubview:imageView];
        
        UIButton *quKanButton = [[UIButton alloc] init];
        [quKanButton setTitle:@"去看看" forState:UIControlStateNormal];
        quKanButton.layer.cornerRadius = 20;
        quKanButton.backgroundColor = RGB(21, 22, 26);
        quKanButton.width = K_Width*0.7;
        quKanButton.height = 40;
        quKanButton.center = self.tableView.center;
        quKanButton.y = CGRectGetMaxY(imageView.frame) + 10;
        [quKanButton addTarget:self action:@selector(QuKanKan) forControlEvents:UIControlEventTouchUpInside];
        [_noneView addSubview:quKanButton];
        
        [self.view addSubview:_noneView];
        
    }
    return _noneView;
}
//- (UIButton *)quKanButton{
//    if (!_quKanButton) {
//        _quKanButton = [[UIButton alloc] init];
//        [_quKanButton setTitle:@"去看看" forState:UIControlStateNormal];
//        _quKanButton.layer.cornerRadius = 20;
//        _quKanButton.backgroundColor = RGB(21, 22, 26);
//        _quKanButton.width = K_Width*0.7;
//        _quKanButton.height = 40;
//        _quKanButton.center = self.tableView.center;
//        [_quKanButton addTarget:self action:@selector(QuKanKan) forControlEvents:UIControlEventTouchUpInside];
//        [_tableView addSubview:_quKanButton];
//    }
//    return _quKanButton;
//}



- (NSMutableArray<AMCourseModel *> *)listData{
    if (!_listData) {
        _listData = [[NSMutableArray alloc] init];
    }
    return _listData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    [self setTableView];
    [self loadData:nil];
}
- (void)setTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorInset = UIEdgeInsetsMake(15, 0, 15, 0);
    self.tableView.separatorColor = RGB(242, 242, 242);
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyStudyListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MyStudyListCell class])];
    [self.tableView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
    [self.tableView addRefreshFooterWithTarget:self action:@selector(loadData:)];
//    self.tableView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadData:)];
}
- (void)loadData:(id _Nullable)sender{
    
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
    [ApiUtil postWithParent:self url:[ApiUtilHeader selectLiveCourseOrderListOfMySelf] needHUD:NO params:dic success:^(NSInteger code, id  _Nullable response) {
        [self.tableView endAllFreshing];
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            NSArray *records = (NSArray *)[data objectForKey:@"records"];
            if (records && records.count) {
                [self.listData addObjectsFromArray:[NSArray yy_modelArrayWithClass:[AMCourseModel class] json:records]];
            }
            [self.tableView updataFreshFooter:(self.listData.count && records.count != MaxListCount)];
            [self.tableView ly_updataEmptyView:!self.listData.count];
            self.tableView.mj_footer.hidden = !self.listData.count;
            [self.tableView reloadData];
        }
        if (self.listData.count == 0) {
            self.noneView.hidden = NO;
        }else{
            self.noneView.hidden = YES;
        }
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [self.tableView endAllFreshing];
        [SVProgressHUD showError:errorMsg];
    }];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"我的学习";
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)QuKanKan{
    self.tabBarController.selectedIndex = 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeToClassList" object:nil];
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark - UITableViewDelegate  UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyStudyListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyStudyListCell class]) forIndexPath:indexPath];
    cell.model = self.listData[indexPath.row];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassDetailViewController *vc = [[ClassDetailViewController alloc] init];
    vc.courseId = self.listData[indexPath.row].courseId;
    [self.navigationController pushViewController:vc animated:YES];
}



@end
