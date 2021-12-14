//
//  AMNewArtistCourseViewController.m
//  ArtMedia2
//
//  Created by LY on 2020/11/26.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMNewArtistCourseViewController.h"
#import "AMNewArtistCourseVCell.h"
#import "ClassDetailViewController.h"

@interface AMNewArtistCourseViewController ()<UITableViewDelegate , UITableViewDataSource>

@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (nonatomic , strong) NSMutableArray <AMCourseModel *>*data;

@end

@implementation AMNewArtistCourseViewController

- (NSMutableArray *)data{
    if (!_data) {
        _data = [[NSMutableArray alloc] init];
    }
    return _data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.data.count) [self loadData:nil];
}

- (void)setTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, SafeAreaBottomHeight, 0.0f);
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMNewArtistCourseVCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMNewArtistCourseVCell class])];
    
    self.tableView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadData:)];
    
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
}


#pragma mark -- UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.vcCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y <= 0) {
        self.vcCanScroll = NO;
        scrollView.contentOffset = CGPointZero;
        if (self.delegate && [self.delegate respondsToSelector:@selector(itemListController:scrollToTopOffset:)])
            [self.delegate itemListController:self scrollToTopOffset:YES];
    }
    self.tableView.showsVerticalScrollIndicator = self.vcCanScroll;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AMNewArtistCourseVCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMNewArtistCourseVCell class]) forIndexPath:indexPath];
    if (self.data.count) cell.model = self.data[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassDetailViewController *vc = [[ClassDetailViewController alloc] init];
    vc.courseId = self.data[indexPath.section].courseId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
- (void)reloadData {
    [self loadData:nil];
}

- (void)loadData:(id)sender {
    self.tableView.allowsSelection = NO;
    if (sender && [sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        self.pageIndex ++;
    }else {
        self.pageIndex = 1;
        if (self.data.count) [self.data removeAllObjects];
    }
    
    if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
        [SVProgressHUD show];
    }
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:self.artistID forKey:@"teacherId"];
    [param setObject:@(self.pageIndex) forKey:@"current"];
    [param setObject:@(10) forKey:@"size"];
    [ApiUtil postWithParent:self url:[ApiUtilHeader selectEffectLiveCourseListOfTeacher] params:param.copy success:^(NSInteger code, id  _Nullable response) {
        
        [self.tableView endAllFreshing];
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            NSArray *records = (NSArray *)[data objectForKey:@"records"];
            if (records && records.count) {
                [self.data addObjectsFromArray:[NSArray yy_modelArrayWithClass:[AMCourseModel class] json:records]];
            }
            [self.tableView updataFreshFooter:(self.data.count && records.count != MaxListCount)];
        }
        
        [self.tableView ly_updataEmptyView:!self.data.count];
        self.tableView.mj_footer.hidden = !self.data.count;
        [self.tableView reloadData];
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
