//
//  MessageListViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/5/25.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "MessageListViewController.h"

#import "VideoPlayerViewController.h"
#import "DiscussDetailListViewController.h"

#import "MessageCollectTableCell.h"
#import "MessageReplyTableCell.h"

#import "AMEmptyView.h"

#import "MessageInfoModel.h"
#import "DiscussItemInfoModel.h"

@interface MessageListViewController () <UITableViewDelegate ,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@end

@implementation MessageListViewController {
    NSMutableArray <MessageInfoModel *>*_dataArray;
    NSInteger _page;
}

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _dataArray = [NSMutableArray new];
    _page = 0;
    
    self.tableView.bgColorStyle = AMBaseTableViewBackgroundColorStyleGray;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.sectionHeaderHeight = CGFLOAT_MIN;
    [self.tableView setTableHeaderView:[UIView new]];
    self.tableView.sectionFooterHeight = CGFLOAT_MIN;
    [self.tableView setTableFooterView:[UIView new]];
    
    self.tableView.estimatedRowHeight = ADAPTATIONRATIOVALUE(180.0f);
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    if (_listStyle == MessageDetailListStyleReply) {
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MessageReplyTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MessageReplyTableCell class])];
    }else
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MessageCollectTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MessageCollectTableCell class])];
    
    
    [self.tableView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
    [self.tableView addRefreshFooterWithTarget:self action:@selector(loadData:)];
    
    self.tableView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self imageStr:@"message_list_null_img" action:@selector(loadData:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_listStyle == MessageDetailListStyleCollect) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.navigationItem.title = @"收到的赞";
    }

    
    [self loadData:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_listStyle == MessageDetailListStyleCollect) {
        if (_dataArray.count)
            [self clearUnreadData:nil];
    }
}

//view布局完子控件的时候调用
- (void)viewDidLayoutSubviews
{
//iOS7只需要设置SeparatorInset(iOS7开始有的)就可以了，但是iOS8的话单单只设置这个是不行的，还需要设置LayoutMargins(iOS8开始有的)
   if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
       [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
   }

   if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
       [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
   }
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_listStyle == MessageDetailListStyleReply) {
        MessageReplyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MessageReplyTableCell class]) forIndexPath:indexPath];
        cell.model = (MessageReplyInfoModel *)_dataArray[indexPath.row];
        return cell;
    }
    MessageCollectTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MessageCollectTableCell class])];
    cell.listStyle = _listStyle;
    
    if (_listStyle == MessageDetailListStyleDiscuss) {
        cell.model = _dataArray[indexPath.row];
    }else
        cell.model = _dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_listStyle == MessageDetailListStyleReply) {
        MessageReplyInfoModel *model = (MessageReplyInfoModel *)_dataArray[indexPath.row];
        
        if ([ToolUtil isEqualToNonNull:[model.reply objectForKey:@"comment_id"]]) {
            NSMutableDictionary *params = @{}.mutableCopy;
            params[@"obj_id"] = [model.reply objectForKey:@"comment_id"];
            params[@"obj_type"] = @"2";
            
            [ApiUtil postWithParent:self url:[ApiUtilHeader setNoticeRead] needHUD:NO params:params.copy success:^(NSInteger code, id  _Nullable response) {} fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {}];
            
            DiscussDetailListViewController *detailVC = [[DiscussDetailListViewController alloc] init];
            detailVC.obj_id = [model.reply objectForKey:@"comment_id"];
            
            [self.navigationController pushViewController:detailVC animated:YES];
        }else {
            [SVProgressHUD showError:@"数据错误"];
        }
        
    }else if (_listStyle == MessageDetailListStyleDiscuss) {
        MessageDiscussInfoModel *model = (MessageDiscussInfoModel *)_dataArray[indexPath.row];
        if ([ToolUtil isEqualToNonNull:model.obj_id]) {
            
            NSMutableDictionary *params = @{}.mutableCopy;
            params[@"obj_id"] = model.obj_id;
            params[@"obj_type"] = @"1";
            
            [ApiUtil postWithParent:self url:[ApiUtilHeader setNoticeRead] needHUD:NO params:params.copy success:^(NSInteger code, id  _Nullable response) {} fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {}];
            
            VideoPlayerViewController *videoDetail = [[VideoPlayerViewController alloc] initWithVideoID:model.obj_id];
            [self.navigationController pushViewController:videoDetail animated:YES];
        }else {
            [SVProgressHUD showError:@"数据错误"];
        }
    }else {
        MessageCollectInfoModel *model = (MessageCollectInfoModel *)_dataArray[indexPath.row];
        if (model.collect_type.integerValue == 8) {
            DiscussDetailListViewController *detailVC = [[DiscussDetailListViewController alloc] init];
            
            detailVC.obj_id = model.collect_id;
            
            [self.navigationController pushViewController:detailVC animated:YES];
        }else {
            if ([ToolUtil isEqualToNonNull:model.collect_id]) {
                VideoPlayerViewController *videoDetail = [[VideoPlayerViewController alloc] initWithVideoID:model.collect_id];
                [self.navigationController pushViewController:videoDetail animated:YES];
            }else {
                [SVProgressHUD showError:@"数据错误"];
            }
        }
    }
}

//cell即将展示的时候调用
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
   if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
       [cell setSeparatorInset:UIEdgeInsetsZero];
   }
   if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
       [cell setLayoutMargins:UIEdgeInsetsZero];
   }
    //  隐藏每个分区最后一个cell的分割线
    if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
        // 1.系统分割线,移到屏幕外
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
    }
}

#pragma mark -
- (void)loadData:(id)sender {
    self.tableView.allowsSelection = NO;
    if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
        [SVProgressHUD show];
    }
    if (sender && [sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        _page ++;
    }else {
        _page = 0;
    }
    NSString *url = nil;
    switch (_listStyle) {
        case MessageDetailListStyleDiscuss: {
            url = [ApiUtilHeader getCommentNoticeList];
            break;
        }
        case MessageDetailListStyleReply: {
            url = [ApiUtilHeader getReplyNoticeList];
            break;
        }
        case MessageDetailListStyleCollect: {
            url = [ApiUtilHeader getUserObjectLikedList];
            break;
        }
        default:
            break;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"page"] = StringWithFormat(@(_page));
    params[@"user_id"] = [UserInfoManager shareManager].uid;
    
    [ApiUtil postWithParent:self url:url needHUD:NO params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [self.tableView endAllFreshing];
        
        if ([response[@"code"] integerValue] == 0) {
            switch (_listStyle) {
                case MessageDetailListStyleDiscuss: {/// 评论列表
                    NSDictionary *dict = (NSDictionary *)response[@"data"];
                    NSMutableDictionary *unreadInfo = dict.mutableCopy;
                    [unreadInfo removeObjectForKey:@"notice_list"];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(messagelistVC:updateUnreadCount:)]) {
                        [self.delegate messagelistVC:self updateUnreadCount:unreadInfo.copy];
                    }
                    
                    NSArray *array = (NSArray *)[dict objectForKey:@"notice_list"];
                    if (array && array.count)  {
                        if (![sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
                            if (_dataArray.count) [_dataArray removeAllObjects];
                        }
                        [_dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[MessageDiscussInfoModel class] json:array]];
                    }
                    [self.tableView updataFreshFooter:(_dataArray.count && array.count != MaxListCount)];
                    break;
                }
                case MessageDetailListStyleReply: {/// 回复列表
                    NSDictionary *dict = (NSDictionary *)response[@"data"];
                    NSArray *array = (NSArray *)[dict objectForKey:@"notice_list"];
                    if (array && array.count)  {
                        if (![sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
                            if (_dataArray.count) [_dataArray removeAllObjects];
                        }
                        [_dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[MessageReplyInfoModel class] json:array]];
                    }
                    [self.tableView updataFreshFooter:(_dataArray.count && array.count != MaxListCount)];
                    break;
                }
                case MessageDetailListStyleCollect: {/// 收藏列表
                    NSArray *array = (NSArray *)response[@"data"];
                    if (array && array.count)  {
                        if (![sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
                            if (_dataArray.count) [_dataArray removeAllObjects];
                        }
                        [_dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[MessageCollectInfoModel class] json:array]];
                    }
                    [self.tableView updataFreshFooter:(_dataArray.count && array.count != MaxListCount)];
                    break;
                }
                default:
                    break;
            }
        }
        [self.tableView ly_updataEmptyView:!_dataArray.count];
        self.tableView.mj_footer.hidden = !_dataArray.count;
        [self.tableView reloadData];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [SVProgressHUD showError:errorMsg];
        [self.tableView endAllFreshing];
    }];
}

- (void)clearUnreadData:(id)sender {
    [ApiUtil postWithParent:self url:[ApiUtilHeader clearUnreadFabulous] needHUD:NO params:@{@"uid":[UserInfoManager shareManager].uid} success:^(NSInteger code, id  _Nullable response) {} fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {}];
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
