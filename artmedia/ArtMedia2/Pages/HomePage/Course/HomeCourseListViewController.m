//
//  HomeCourseListViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/10/9.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "HomeCourseListViewController.h"
#import "AMCourseNewViewController.h"
#import "ClassDetailViewController.h"

#import "AMCourseModel.h"

#import "HomeCourseListItemCell.h"

#import "AMEmptyView.h"

@interface HomeCourseListViewController () <UITableViewDelegate ,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (weak, nonatomic) IBOutlet AMButton *courseBtn;

@property (strong, nonatomic) NSMutableArray <AMCourseModel *>*dataArray;

@end

@implementation HomeCourseListViewController {
    NSInteger _page;
}

- (instancetype)init {
    if (self = [super init]) {
        _page = 1;
        self.dataArray = @[].mutableCopy;
    }return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"名家课堂";
    // Do any additional setup after loading the view from its nib.
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeCourseListItemCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HomeCourseListItemCell class])];
    [self.tableView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
    [self.tableView addRefreshFooterWithTarget:self action:@selector(loadData:)];
    
    self.tableView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadData:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.courseBtn.hidden = YES;
    if ([UserInfoManager shareManager].isLogin && [UserInfoManager shareManager].isArtist) {
        self.courseBtn.hidden = NO;
    }
    if (!self.dataArray.count) [self loadData:nil];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 10;
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCourseListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeCourseListItemCell class]) forIndexPath:indexPath];
    
    if (_dataArray.count) cell.model = [_dataArray objectAtIndex:indexPath.row];
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
    if ([UserInfoManager shareManager].isLogin) {
        ClassDetailViewController *vc = [[ClassDetailViewController alloc] init];
        vc.courseId = [_dataArray objectAtIndex:indexPath.row].courseId;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self jumpToLoginWithBlock:^(id  _Nullable data) {
            
        }];
    }
    
}

#pragma mark -

- (IBAction)clickToNewCourse:(id)sender {
    [self.navigationController pushViewController:[[AMCourseNewViewController alloc] init] animated:YES];
}

#pragma mark -
- (void)reloadCurrent:(NSNotification *)notification {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    [self loadData:notification];
}

- (void)loadData:(id _Nullable)sender {
    self.tableView.allowsSelection = NO;
    if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
        [SVProgressHUD show];
    }
    if (sender && [sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        _page ++;
    }else {
        _page = 1;
        if (self.dataArray.count) [self.dataArray removeAllObjects];
    }
    
//    if (sender) {
//        if ([sender isKindOfClass:[MJRefreshNormalHeader class]])  {
//            _page = 1;
//            if (self.dataArray.count) [self.dataArray removeAllObjects];
//        }
//        if ([sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) _page ++;
//    }else {
//        if (self.dataArray.count) [self.dataArray removeAllObjects];
//    }
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader getLiveCourseList] needHUD:NO params:@{@"current":@(_page)} success:^(NSInteger code, id  _Nullable response) {
        [self.tableView endAllFreshing];
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            NSArray *records = (NSArray *)[data objectForKey:@"records"];
            if (records && records.count) {
                [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[AMCourseModel class] json:records]];
            }
            [self.tableView updataFreshFooter:(self.dataArray.count && records.count != MaxListCount)];
        }
        [self.tableView ly_updataEmptyView:!self.dataArray.count];
        self.tableView.mj_footer.hidden = !self.dataArray.count;
        if ([sender isKindOfClass:[NSNotification class]]) self.tableView.contentOffset = CGPointMake(0.0, 0.0);
        [self.tableView reloadData];
        
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [self.tableView endAllFreshing];
        [SVProgressHUD showError:errorMsg];
    }];
}
@end
