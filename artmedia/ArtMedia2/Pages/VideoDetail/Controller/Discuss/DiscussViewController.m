//
//  DiscussViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/2.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "DiscussViewController.h"

#import "DiscussDetailListViewController.h"
//#import "CustomPersonalViewController.h"
#import "AMBaseUserHomepageViewController.h"

#import "AMHeaderTapView.h"
#import "DiscussHeaderView.h"
#import "DiscussInfoHeaderView.h"
#import "DiscussInfoFooterView.h"
#import "DiscussInfoTableCell.h"
#import "DiscussBlackInfoTableCell.h"

#import "DiscussInputView.h"
#import "DiscussMenuView.h"

#import "VideoListModel.h"
#import "DiscussItemInfoModel.h"

#import "AMEmptyView.h"

@interface DiscussViewController () <UIGestureRecognizerDelegate, UITableViewDelegate , UITableViewDataSource, AMHeaderTapDelegate, DiscussHeaderDelegate, DiscussInputDelegate, DiscussInfoHeaderDelegate, DiscussInfoFooterDelegate, DiscussInfoTableCellDelegate ,DiscussMenuDelegate>

@property (nonatomic ,weak) IBOutlet UIView *contentView;
@property (nonatomic ,weak) IBOutlet BaseTableView *tableView;

@property (nonatomic ,weak) IBOutlet AMHeaderTapView *headerTapView;
@property (nonatomic ,strong) DiscussHeaderView *headerView;
@property (nonatomic ,strong) DiscussInfoFooterView *footerView;


@end

@implementation DiscussViewController {
    BOOL _isQuiting;
    int _page;
    NSInteger _disscussCount;
    NSMutableArray <DiscussItemInfoModel *>*_dataArray;
    DiscussItemInfoModel *_selectModel;
    DiscussItemInfoModel *_longPModel;
}

- (DiscussHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DiscussHeaderView class]) owner:nil options:nil].lastObject;
        _headerView.frame = CGRectMake(0, 0, K_Width, 50.0f);
        _headerView.delegate = self;
    }return _headerView;
}

- (DiscussInfoFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DiscussInfoFooterView class]) owner:nil options:nil].lastObject;
    }return _footerView;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (instancetype) init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToHide:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    self.view.backgroundColor = [Color_Black colorWithAlphaComponent:0.2];
    
    _headerTapView.delegate = self;
    
    _dataArray = @[].mutableCopy;
    _isQuiting = NO;
    _page = 0;
    
    [self.contentView addRoundedCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) withRadii:CGSizeMake(20.0f, 20.0f)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(50.0f, 0, 0, 0);
    
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DiscussInfoTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([DiscussInfoTableCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DiscussBlackInfoTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([DiscussBlackInfoTableCell class])];
    
    [self.tableView addRefreshFooterWithTarget:self action:@selector(loadData:)];
    self.tableView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadData:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self loadData:nil];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 + _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 0;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscussItemInfoModel *model = _dataArray[indexPath.section - 1];
    if (!model.is_delete.boolValue) {
        DiscussInfoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DiscussInfoTableCell class]) forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = model;
        return cell;
    }
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DiscussBlackInfoTableCell class]) forIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return self.headerView.height;
    return 50.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        self.headerView.discussCount = _disscussCount;
        return self.headerView;
    }
    DiscussInfoHeaderView *header = (DiscussInfoHeaderView *)[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DiscussInfoHeaderView class]) owner:nil options:nil].lastObject;
    header.delegate = self;
    header.frame = CGRectMake(0, 0, K_Width, 50.0f);
    header.model = _dataArray[section - 1];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section) {
        DiscussItemInfoModel *infoModel = _dataArray[section - 1];
        if (!infoModel.is_delete.boolValue && infoModel.reply_data.count) {
            self.footerView.model = infoModel;
            return [self.footerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        }
    }
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section) {
        DiscussItemInfoModel *infoModel = _dataArray[section - 1];
        if (!infoModel.is_delete.boolValue && infoModel.reply_data.count) {
            DiscussInfoFooterView *footerView = (DiscussInfoFooterView *)[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DiscussInfoFooterView class]) owner:nil options:nil].lastObject;
            footerView.model = _dataArray[section - 1];
            footerView.delegate = self;
            return footerView;
        }
    }
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _selectModel = _dataArray[indexPath.section - 1];
    
    DiscussInputView *inputView = [DiscussInputView shareInstance];
    inputView.delegate = self;
    inputView.placeholder = [NSString stringWithFormat:@"回复 %@", _selectModel.user_info.username];
    
    [inputView show];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < -88.0f && _isQuiting == NO) {
        _isQuiting = YES;
        [self clickToHide:nil];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.contentView]) {
        return NO;
    }
    return YES;
}

#pragma mark - DiscussInputDelegate
- (void)inputView:(DiscussInputView *)inputView didFinishInputWith:(NSString *)inputStr {
    if ([ToolUtil isEqualToNonNull:inputStr] && inputStr.length > 80.0f) {
        [SVProgressHUD showMsg:@""];
        return;
    }else
        [inputView hide];
    NSLog(@"didFinishInputWith = %@",inputStr);
    
    if (inputStr.length) {
        if (_selectModel) {
            NSMutableDictionary *params = @{}.mutableCopy;
            
            params[@"comment_id"] = [ToolUtil isEqualToNonNullKong:_selectModel.id];
            params[@"reply_type"] = @"1";/// 回复评论
            params[@"to_reply_id"] = @"0";
            params[@"user_id"] = [UserInfoManager shareManager].uid;
            params[@"reply_comment"] = inputStr;
            
            @weakify(self);
            [ApiUtil postWithParent:self url:[ApiUtilHeader addReplyToComment] params:params.copy success:^(NSInteger code, id  _Nullable response) {
                [SVProgressHUD  showSuccess:@"发送成功!" completion:^{
                    @strongify(self);
                    [self loadData:nil];
                }];
            } fail:nil];
        }else {
            NSMutableDictionary *params = @{}.mutableCopy;
            
            params[@"obj_type"] = @"1";
            params[@"obj_id"] = [ToolUtil isEqualToNonNullKong:_videoModel.ID];
            params[@"user_id"] = [UserInfoManager shareManager].uid;
            params[@"comment"] = inputStr;
            
            @weakify(self);
            [ApiUtil postWithParent:self url:[ApiUtilHeader addComment] params:params.copy success:^(NSInteger code, id  _Nullable response) {
                [SVProgressHUD showSuccess:@"发送成功!" completion:^{
                    @strongify(self);
                    [self loadData:nil];
                }];
            } fail:nil];
        }
    }
}

#pragma mark - AMHeaderTapDelegate
- (void)tapView:(AMHeaderTapView *)tapView didSwipe:(id)sender {
    [self clickToHide:nil];
}

#pragma mark - DiscussInfoTableCellDelegate
- (void)infoCell:(DiscussInfoTableCell *)infoCell clickToShowMenuWithModel:(DiscussItemInfoModel *)model {
    _longPModel = model;
    
    DiscussMenuView *menuVC = [DiscussMenuView shareInstance];
    menuVC.delegate = self;
    [menuVC show];
    
    return;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *opeationAction = [UIAlertAction actionWithTitle:@"复制评论" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *jubaoAction = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:opeationAction];
    [alert addAction:jubaoAction];
    
    [cancelAction setValue:Color_Black forKey:@"_titleTextColor"];
    [opeationAction setValue:Color_Black forKey:@"_titleTextColor"];
    [jubaoAction setValue:Color_Black forKey:@"_titleTextColor"];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - DiscussHeaderDelegate
- (void)headerView:(DiscussHeaderView *)headerView didSelectedSort:(id)sender {
    
}

- (void)headerView:(DiscussHeaderView *)headerView didSelectedAdd:(id)sender {
    _selectModel = nil;
    DiscussInputView *inputView = [DiscussInputView shareInstance];
    inputView.delegate = self;
    [inputView showWithKeybord:YES];
}

#pragma mark - DiscussInfoHeaderDelegate
- (void)infoHeader:(DiscussInfoHeaderView *)header didClickToLike:(AMButton *)sender withModel:(nonnull DiscussItemInfoModel *)model {

    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"user_id"] = [UserInfoManager shareManager].uid;
    params[@"comment_id"] = [ToolUtil isEqualToNonNullKong:model.id];
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader aboutCommentLike] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        model.is_liked = StringWithFormat(@(!model.is_liked.boolValue));
        sender.selected = model.is_liked.boolValue;
        if (model.is_liked.boolValue) {
            model.like_num = StringWithFormat(@(model.like_num.integerValue + 1));
            [sender setTitle:[ToolUtil isEqualToNonNull:model.like_num replace:@"0"] forState:UIControlStateSelected];
            [SVProgressHUD showSuccess:@"点赞成功" completion:nil];
        }else {
            model.like_num = StringWithFormat(@(model.like_num.integerValue - 1));
            [sender setTitle:[ToolUtil isEqualToNonNull:model.like_num replace:@"0"] forState:UIControlStateNormal];
        }
    } fail:nil];
    
}

- (void)infoHeader:(DiscussInfoHeaderView *)header didClickToLogo:(id)sender withModel:(nonnull DiscussItemInfoModel *)model {
//    CustomPersonalViewController *personalVC = [CustomPersonalViewController shareInstance];
//    personalVC.artuid = model.user_id;
//    [self.navigationController pushViewController:personalVC animated:YES];
    
    AMBaseUserHomepageViewController * vc = [[AMBaseUserHomepageViewController alloc] init];
    vc.artuid = model.user_id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - DiscussInfoFooterDelegate
- (void)infoFooter:(DiscussInfoFooterView *)infoCell didSelectedMore:(id)sender withModel:(nonnull DiscussItemInfoModel *)model {
    [self clickToDetail:model];
}

#pragma mark -
- (void)menuView:(DiscussMenuView *)menuView didSelectMenuWay:(NSInteger)way {
    if (way) {/// 举报
        AMReportView *reportView = [AMReportView shareInstance];
        reportView.obj_type = @"2";
        reportView.obj_id = _longPModel.id;
        
        [reportView show];
    }else {/// 复制
        UIPasteboard *pasted = [UIPasteboard generalPasteboard];
        pasted.string = [ToolUtil isEqualToNonNullKong:_longPModel.comment];
        [SVProgressHUD showSuccess:@"复制成功"];
    }
}

#pragma mark -
- (IBAction)clickToHide:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickToDetail:(DiscussItemInfoModel *)model {
    DiscussDetailListViewController *detailVC = [[DiscussDetailListViewController alloc] init];
    detailVC.obj_id = model.id;
    
    MainNavigationController *navi = [[MainNavigationController alloc] initWithRootViewController:detailVC];
    [self presentViewController:navi animated:YES completion:nil];
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
        if (_dataArray.count) [_dataArray removeAllObjects];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"obj_id"] = [ToolUtil isEqualToNonNullKong:_videoModel.ID];
    params[@"page"] = [NSString stringWithFormat:@"%@",@(_page)];
    params[@"user_id"] = [UserInfoManager shareManager].uid;
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader getTreeCommentList] needHUD:NO params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [self.tableView endAllFreshing];
        
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        NSArray *array = (NSArray *)[data objectForKey:@"comment_list"];
        if (array && array.count) {
            [_dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[DiscussItemInfoModel class] json:array]];
        }
        _disscussCount = [[data objectForKey:@"count"] integerValue];
        
        [self.tableView updataFreshFooter:(_dataArray.count && array.count != MaxListCount)];
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
