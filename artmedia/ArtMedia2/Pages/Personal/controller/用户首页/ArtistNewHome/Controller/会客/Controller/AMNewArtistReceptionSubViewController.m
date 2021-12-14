//
//  AMNewArtistReceptionSubViewController.m
//  ArtMedia2
//
//  Created by 刘洋 on 2020/9/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMNewArtistReceptionSubViewController.h"

#import "AMNewArtistMainHeadView.h"
#import "AMNewArtistMainTimeLineCell.h"

@interface AMNewArtistReceptionSubViewController ()<UITableViewDataSource , UITableViewDelegate>

@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (nonatomic , strong) NSMutableArray *data;

@end

@implementation AMNewArtistReceptionSubViewController {
    NSInteger _meetingCount;
}

- (NSMutableArray *)data{
    if (!_data) {
        _data = [[NSMutableArray alloc] init];
    }
    return _data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _meetingCount = 0;
    
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
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMNewArtistMainTimeLineCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMNewArtistMainTimeLineCell class])];
    
    self.tableView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadData:)];
    
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
}

//- (void)setPageIndex:(NSInteger)pageIndex {
//
//}

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
    AMNewArtistMainTimeLineCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMNewArtistMainTimeLineCell class]) forIndexPath:indexPath];
    if (self.data.count) cell.model = self.data[indexPath.row];
    
    if (indexPath.row == 0) {
        if (self.data.count == 1) {
            cell.linePosition = -2;
        }else
            cell.linePosition = -1;
    }else if (indexPath.row == (self.data.count - 1)) {
        cell.linePosition = 1;
    }else
        cell.linePosition = 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.data.count) return 44.0f;
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (!self.data.count)  return [UIView new];
    
    AMNewArtistMainHeadView * headView = [AMNewArtistMainHeadView share];
    headView.frame = CGRectMake(0, 0, tableView.width, 44.0f);
    headView.headLabel.text = @"近期会客";
    
    headView.meetNumberLabel.hidden = NO;
    headView.moreVideoButton.hidden = YES;
    headView.timeLabel.hidden = YES;
    headView.stackBackView.hidden = NO;
    headView.moreInfoButton.hidden = YES;
    
    headView.meetNumberLabel.text = [NSString stringWithFormat:@"已会客%@次",@(_meetingCount)];
    
    return headView;
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
    }
    
    if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
        [SVProgressHUD show];
    }
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("ArtustReception", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setObject:self.artistID forKey:@"optUserId"];
        [param setObject:@(self.pageIndex) forKey:@"current"];
        
        [ApiUtil postWithParent:self url:[ApiUtilHeader selectInfoLogByArtId] params:param.copy success:^(NSInteger code, id  _Nullable response) {
            dispatch_group_leave(group);
            
            NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
            if (data && data.count) {
                NSArray *records = (NSArray *)[data objectForKey:@"records"];
                if (records && records.count) {
                    if (![sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
                        if (self.data.count) [self.data removeAllObjects];
                    }
                    [self.data addObjectsFromArray:[NSArray yy_modelArrayWithClass:[AMNewArtistTimeLineModel class] json:records]];
                }
                [self.tableView updataFreshFooter:(self.data.count && records.count != MaxListCount)];
            }
        } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setObject:self.artistID forKey:@"artistId"];
        
        [ApiUtil postWithParent:self url:[ApiUtilHeader selectArtInfoCountByInfoStatus] needHUD:NO params:param.copy success:^(NSInteger code, id  _Nullable response) {
            dispatch_group_leave(group);
            NSString *data = (NSString *)[response objectForKey:@"data"];
            _meetingCount = [ToolUtil isEqualToNonNull:data replace:@"0"].integerValue;
            
        } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [self.tableView endAllFreshing];
            [self.tableView ly_updataEmptyView:!self.data.count];
            self.tableView.mj_footer.hidden = !self.data.count;
            [self.tableView reloadData];
        });
    });
    
}

@end
