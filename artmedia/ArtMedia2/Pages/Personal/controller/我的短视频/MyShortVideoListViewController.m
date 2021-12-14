//
//  MyShortVideoListViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/9/9.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "MyShortVideoListViewController.h"
#import "VideoPlayerViewController.h"
#import "PublishVideoViewController.h"
#import "GoodsPartViewController.h"

#import "VideoListModel.h"

#import "MyShortVideoListTableCell.h"
#import "AMEmptyView.h"

@interface MyShortVideoListViewController () <UITableViewDelegate ,UITableViewDataSource, MyShortVideoListTableCellDelegate>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@end

@implementation MyShortVideoListViewController {
    NSInteger _page;
    NSMutableArray <VideoListModel *>*_dataArray;
    NSString *_urlString;
    NSMutableDictionary *_params;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    
    _page = 0;
    _urlString = nil;
    _params = @{}.mutableCopy;
    _dataArray = @[].mutableCopy;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyShortVideoListTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MyShortVideoListTableCell class])];
    
    [_tableView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
    [_tableView addRefreshFooterWithTarget:self action:@selector(loadData:)];
    _tableView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadData:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"我的短视频";
    
    [self loadData:nil];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyShortVideoListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyShortVideoListTableCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    if (_dataArray.count) cell.model = _dataArray[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section?CGFLOAT_MIN:10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    /// 视频未下架
    VideoPlayerViewController *videoDetail = [[VideoPlayerViewController alloc] initWithStyle:(MyVideoShowStyleForList) videos:_dataArray.copy playIndex:indexPath.section listUrlStr:_urlString params:_params];
    [self.navigationController pushViewController:videoDetail animated:YES];
}

#pragma mark - MyShortVideoListTableCellDelegate
/// 查看视频详情
- (void)shortVideoCell:(MyShortVideoListTableCell *)shortVideoCell didSelectedToDetail:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:shortVideoCell];
    VideoPlayerViewController *videoDetail = [[VideoPlayerViewController alloc] initWithStyle:(MyVideoShowStyleForList) videos:_dataArray.copy playIndex:indexPath.section listUrlStr:_urlString params:_params];
    [self.navigationController pushViewController:videoDetail animated:YES];
}

/// 删除
- (void)shortVideoCell:(MyShortVideoListTableCell *)shortVideoCell didSelectedToDelete:(id)sender {
    if (![UserInfoManager shareManager].isLogin) {
        [self jumpToLoginWithBlock:nil];
        return;
    }
    if (shortVideoCell.model.check_state.integerValue == 3) {///已下架
        [self deleteVideoWithModel:shortVideoCell.model];
    }else {
        NSString *message = nil;
        if ([UserInfoManager shareManager].isArtist && shortVideoCell.model.is_include_obj.integerValue != 0) {
            message = [NSString stringWithFormat:@"该短视频是作品《%@》的认证视频，删除将自动删除作品",shortVideoCell.model.goodsModel.name];
        }
        AMAlertView *alert = [AMAlertView shareInstanceWithTitle:@"是否要删除该视频？"
                                                          message:message
                                                      buttonArray:@[@"确定删除", @"取消"]
                                                        alertType:(AMAlertTypeNormal)
                                                          confirm:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self deleteVideoWithModel:shortVideoCell.model];
                });
        } cancel:nil];
        [alert show];
    }
}

/// 编辑
- (void)shortVideoCell:(MyShortVideoListTableCell *)shortVideoCell didSelectedToEdit:(id)sender {
    if (![UserInfoManager shareManager].isLogin) {
        [self jumpToLoginWithBlock:nil];
        return;
    }
    PublishVideoViewController *videoVC = [[PublishVideoViewController alloc] init];
    
    VideoListModel *videoModel = shortVideoCell.model;
    videoModel.modify_state = YES;
    videoVC.videoModel = videoModel;
    
    [self.navigationController pushViewController:videoVC animated:YES];
}

/// 查看作品详情
- (void)shortVideoCell:(MyShortVideoListTableCell *)shortVideoCell didSelectedToLookworks:(id)sender {
    if (![UserInfoManager shareManager].isLogin) {
        [self jumpToLoginWithBlock:nil];
        return;
    }
    GoodsPartViewController *detailVC = [[GoodsPartViewController alloc] init];
    detailVC.goodsID = shortVideoCell.model.obj_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}


- (void)deleteVideoWithModel:(VideoListModel *)model {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"videoid"] = [ToolUtil isEqualToNonNullKong:model.ID];
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader deleteVideo] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [SVProgressHUD showSuccess:@"删除视频成功！" completion:^{
            [self loadData:nil];
        }];
    } fail:nil];
}

#pragma mark -
- (void)loadData:(id _Nullable)sender {
    self.tableView.allowsSelection = NO;
    if (sender && [sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        _page ++;
    }else {
        _page = 0;
        if (_dataArray.count) [_dataArray removeAllObjects];
    }
    if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
        [SVProgressHUD show];
    }
    
    _urlString = [ApiUtilHeader getIndexMineVideoList];
    
    _params = @{}.mutableCopy;
    _params[@"examineState"] = @"2";/// 0 所有的 1待审核 2已审核
    _params[@"isIncludeAuction"] = @"0";/// 1只看带商品的 0看所有的
    _params[@"uid"] = [UserInfoManager shareManager].uid;
    
    _params[@"page"] = [NSString stringWithFormat:@"%@",@(_page)];
    
    [ApiUtil postWithParent:self url:_urlString needHUD:NO params:_params.copy success:^(NSInteger code, id  _Nullable response) {
        [self.tableView endAllFreshing];
        NSArray*array = (NSArray *)[response objectForKey:@"data"];
        if (array && array.count) {
            [_dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[VideoListModel class] json:array]];
            [self.tableView updataFreshFooter:(_dataArray.count && array.count != MaxListCount)];
        }
        [self.tableView ly_updataEmptyView:!_dataArray.count];
        self.tableView.mj_footer.hidden = !_dataArray.count;
        [self.tableView reloadData];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [SVProgressHUD showError:errorMsg];
        [self.tableView endAllFreshing];
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
