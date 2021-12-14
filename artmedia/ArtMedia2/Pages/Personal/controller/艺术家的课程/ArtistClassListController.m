//
//  ArtistClassListController.m
//  ArtMedia2
//
//  Created by LY on 2020/10/22.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "ArtistClassListController.h"
#import "AMCourseAddChaptersViewController.h"
#import "AMCourseNewViewController.h"
#import "ClassDetailViewController.h"
#import "FKAlertController.h"

#import "ArtistClassListCell.h"
#import "AMCourseModel.h"
@interface ArtistClassListController ()<UITableViewDelegate , UITableViewDataSource>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (nonatomic , strong) NSMutableArray <AMCourseModel *>*listData;
@property (nonatomic , assign) NSInteger page;
@end

@implementation ArtistClassListController
- (NSMutableArray<AMCourseModel *> *)listData{
    if (!_listData) {
        _listData = [[NSMutableArray alloc] init];
    }
    return _listData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self loadData:nil];
    self.page = 1;
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    
    [self setTableView];
    [self addRightNaviBarItem];
}
- (void)setTableView{
    self.tableView.bgColorStyle = AMBaseTableViewBackgroundColorStyleGray;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ArtistClassListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ArtistClassListCell class])];
    [self.tableView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
    [self.tableView addRefreshFooterWithTarget:self action:@selector(loadData:)];
    self.tableView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadData:)];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.tableView.mj_header beginRefreshing];
    [self loadData:nil];
    self.navigationItem.title = @"我的课程";
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}


- (void)loadData:(id _Nullable)sender {
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
    [ApiUtil postWithParent:self url:[ApiUtilHeader getLiveCourseListOfCurrentTeacher] needHUD:NO params:dic success:^(NSInteger code, id  _Nullable response) {
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
        
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [self.tableView endAllFreshing];
        [SVProgressHUD showError:errorMsg];
    }];
}
- (void)addRightNaviBarItem {
    
    AMButton *rightBtn = [AMButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 52.0f, 26.0f);
    
    [rightBtn setTitle:@"创建" forState:UIControlStateNormal];
    [rightBtn setTitleColor:Color_Whiter forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xDB1111)] forState:UIControlStateNormal];
    
    rightBtn.titleLabel.font = [UIFont addHanSanSC:13.0 fontType:0];
    
    rightBtn.layer.cornerRadius = 13.0f;
    rightBtn.clipsToBounds = YES;
    
    [rightBtn addTarget:self action:@selector(creatClassClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];

}
- (void)creatClassClick{
    AMCourseNewViewController *vc = [[AMCourseNewViewController alloc] init];
    vc.isCourseEdit = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate , UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ArtistClassListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ArtistClassListCell class]) forIndexPath:indexPath];
    cell.model = self.listData[indexPath.section];
    cell.editClassBlock = ^(AMCourseModel * _Nonnull model, NSString * _Nonnull buttonTitle) {
        if ([buttonTitle isEqualToString:@"编辑"]) {
            AMCourseNewViewController *vc = [[AMCourseNewViewController alloc] init];
            vc.isCourseEdit = YES;
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([buttonTitle isEqualToString:@"删除"]){
            FKAlertController *alert = [[FKAlertController alloc] init];
            [alert showAlertWithController:self title:[NSString stringWithFormat:@"您确定要删除课程《%@》吗？",model.courseTitle] content:@"删除的课程将无法恢复，请慎重操作" sureClickBlock:^{
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                dic[@"courseId"] = model.courseId;
                [ApiUtil postWithParent:self url:[ApiUtilHeader deleteLiveCourse] needHUD:YES params:dic success:^(NSInteger code, id  _Nullable response) {
                    if (response) {
                        [SVProgressHUD showSuccess:@"删除课程成功"];
                        [self loadData:nil];
                    }
                } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
                    
                }];
            } sureCompletion:^{
                
            }];
        }
    };
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AMCourseModel *model = self.listData[indexPath.section];
  
    ClassDetailViewController * vc = [[ClassDetailViewController alloc] init];
    vc.courseId = model.courseId;
    [self.navigationController pushViewController:vc animated:YES];
    
//    AMCourseAddChaptersViewController *vc = [[AMCourseAddChaptersViewController alloc] init];
//    vc.model = self.listData[indexPath.section];
//    [self.navigationController pushViewController:vc animated:YES];
}
@end
