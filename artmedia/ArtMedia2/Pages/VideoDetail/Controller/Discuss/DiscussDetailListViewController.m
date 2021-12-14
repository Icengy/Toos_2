//
//  DiscussDetailListViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/7/7.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "DiscussDetailListViewController.h"

//#import "CustomPersonalViewController.h"
#import "AMBaseUserHomepageViewController.h"
#import "VideoPlayerViewController.h"

#import "DiscussInfoHeaderView.h"
#import "DiscussDetailTableCell.h"
#import "DiscussInfoTableCell.h"

#import "AMEmptyView.h"
#import "DiscussMenuView.h"

#import "DiscussItemInfoModel.h"

@interface DiscussDetailListViewController () <AMTextViewDelegate, UITableViewDelegate, UITableViewDataSource, DiscussInfoHeaderDelegate, DiscussDetailTableCellDelegate, DiscussMenuDelegate>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet AMTextView *inputView;
@property (weak, nonatomic) IBOutlet AMButton *finishBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputHeightConstraint;

@end

@implementation DiscussDetailListViewController {
    int _page;
    NSMutableArray *_dataArray;
    /// 回复的对象
    DiscussItemInfoModel *_itemModel;
    DiscussItemInfoModel *_toReplyModel;
    
    DiscussItemInfoModel *_longPModel;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"回复详情";
    
    _dataArray = @[].mutableCopy;
    _page = 0;
    
//    if (!(_toReplyModel && [ToolUtil isEqualToNonNull:_toReplyModel.id]))
//        _toReplyModel = [DiscussItemInfoModel new];
    
    _tableView.bgColorStyle = AMBaseBackgroundColorStyleGray;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.contentInset = UIEdgeInsetsMake(10.0f, 0, 0.0f, 0);
    
    _tableView.estimatedRowHeight = 80.0f;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DiscussDetailTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([DiscussDetailTableCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DiscussInfoTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([DiscussInfoTableCell class])];
    
    _inputView.ownerDelegate = self;
    _inputView.text = nil;
    _inputView.placeholder = @"写下你想说的...";
    _inputView.charCount = 80;
    _inputView.font = [UIFont addHanSanSC:15.0f fontType:0];
    _finishBtn.titleLabel.font = [UIFont addHanSanSC:16.0f fontType:0];
    _finishBtn.enabled = [ToolUtil isEqualToNonNull:_inputView.text];
    
    [self.tableView addRefreshFooterWithTarget:self action:@selector(loadData:)];
    [self.tableView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
    self.view.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self imageStr:@"discuss-empty" action:@selector(loadData:)];
    if (_itemModel) {
        [self.view ly_hideEmptyView];
    }else
        [self.view ly_showEmptyView];
    
    self.tableView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadData:)];
    if (_itemModel) {
        [self.tableView ly_showEmptyView];
    }else
        [self.tableView ly_hideEmptyView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if (self.navigationController.viewControllers.count < 2) {
        self.navigationItem.title = @"评论详情";
        AMButton *backBtn = [AMButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:ImageNamed(@"back_black") forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(clickToBack:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    }else {
        AMButton *rightBtn = [AMButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setTitle:@"查看来源" forState:UIControlStateNormal];
        [rightBtn setTitleColor:Color_Black forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont addHanSanSC:16.0f fontType:0];
        [rightBtn addTarget:self action:@selector(clickToSource:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    }
    
    if (!_dataArray.count) [self loadData:nil];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section) return _dataArray.count;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        DiscussDetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DiscussDetailTableCell class]) forIndexPath:indexPath];
        cell.delegate = self;
        cell.itemModel = _dataArray[indexPath.row];
        
        return cell;
    }
    DiscussInfoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DiscussInfoTableCell class]) forIndexPath:indexPath];
    cell.model = _itemModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section) return 40.0f;
    return 60.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section) {
        UIView *wrapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_Width, 40.0f)];
        wrapView.backgroundColor = RGB(245, 245, 245);
        
        UILabel *label = [[UILabel alloc] init];
        [wrapView addSubview:label];
        label.text = [NSString stringWithFormat:@"共%@条相关回复", [ToolUtil isEqualToNonNull:_itemModel.reply_num replace:@"0"]];
        label.font = [UIFont addHanSanSC:13.0f fontType:0];
        label.textColor = RGB(157, 161, 179);
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wrapView.mas_left).offset(15.0f);
            make.centerY.equalTo(wrapView);
        }];
        return wrapView;
    }
    DiscussInfoHeaderView *header = (DiscussInfoHeaderView *)[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DiscussInfoHeaderView class]) owner:nil options:nil].lastObject;
    header.delegate = self;
    header.frame = CGRectMake(0, 0, K_Width, 60.0f);
    header.model = _itemModel;
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section) return CGFLOAT_MIN;
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *wrapView = [UIView new];
    if (!section) wrapView.backgroundColor = Color_Whiter;
    return wrapView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!indexPath.section)  {
        _toReplyModel = _itemModel;
    }else {
        _toReplyModel = _dataArray[indexPath.row];
    }
    
    [self.inputView becomeFirstResponder];
    self.inputView.text = nil;
    self.inputView.placeholder = [NSString stringWithFormat:@"回复 %@", [ToolUtil isEqualToNonNullKong:_toReplyModel.user_info.username]];
    [self updateInputViewLayout];
}

#pragma mark -
- (void)amTextViewDidChange:(AMTextView *)textView {
    [self updateInputViewLayout];
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

#pragma mark - DiscussDetailTableCellDelegate
- (void)detailCell:(DiscussDetailTableCell *)cell didSelectedLogo:(id)sender withModel:(DiscussItemInfoModel *)model {
//    CustomPersonalViewController *personalVC = [CustomPersonalViewController shareInstance];
//    personalVC.artuid = model.user_id;
//    [self.navigationController pushViewController:personalVC animated:YES];
    
    AMBaseUserHomepageViewController * vc = [[AMBaseUserHomepageViewController alloc] init];
    vc.artuid = model.user_id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)detailCell:(DiscussDetailTableCell *)cell clickToShowMenuWithModel:(DiscussItemInfoModel *)model {
     if (self.navigationController.viewControllers.count > 1)
         return;
    _longPModel = model;
    
    DiscussMenuView *menuVC = [DiscussMenuView shareInstance];
    menuVC.delegate = self;
    [menuVC show];
}

#pragma mark -
- (void)menuView:(DiscussMenuView *)menuView didSelectMenuWay:(NSInteger)way {
    if (way) {/// 举报
        AMReportView *reportView = [AMReportView shareInstance];
        reportView.obj_type = @"3";
        reportView.obj_id = _longPModel.id;
        
        [reportView show];
    }else {/// 复制
        UIPasteboard *pasted = [UIPasteboard generalPasteboard];
        pasted.string = [ToolUtil isEqualToNonNullKong:_longPModel.comment];
        [SVProgressHUD showSuccess:@"复制成功"];
    }
}

#pragma mark -
- (IBAction)clickToFinish:(id)sender {
    if (_inputView.text.length) {
        
        NSMutableDictionary *params = @{}.mutableCopy;
        params[@"comment_id"] = [ToolUtil isEqualToNonNullKong:_itemModel.id];
        if ([_toReplyModel.id isEqualToString:_itemModel.id]) {
            params[@"reply_type"] = @"1";/// 回复评论
            params[@"to_reply_id"] = @"0";
        }else {
            params[@"reply_type"] = @"2";/// 回复他人
            params[@"to_reply_id"] = [ToolUtil isEqualToNonNullKong:_toReplyModel.id];
        }
        params[@"user_id"] = [UserInfoManager shareManager].uid;
        params[@"reply_comment"] = _inputView.text;
        
        [ApiUtil postWithParent:self url:[ApiUtilHeader addReplyToComment] params:params.copy success:^(NSInteger code, id  _Nullable response) {
            [SVProgressHUD  showSuccess:@"发送成功!" completion:^{
                [self loadData:nil];
                [self.inputView resignFirstResponder];
                self.inputView.text = nil;
                [self updateInputViewLayout];
            }];
        } fail:nil];
    }
}

- (void)clickToSource:(id)sender {
    if ([ToolUtil isEqualToNonNull:_itemModel.obj_id]) {
        VideoPlayerViewController *videoDetail = [[VideoPlayerViewController alloc] initWithVideoID:_itemModel.obj_id];
        [self.navigationController pushViewController:videoDetail animated:YES];
    }else {
        [SVProgressHUD showError:@"数据错误"];
    }
}

- (void)clickToBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)updateInputViewLayout {
    _finishBtn.enabled = [ToolUtil isEqualToNonNull:self.inputView.text];
    if (self.inputView.contentSize.height > 40.0f) {
        _inputHeightConstraint.constant = self.inputView.contentSize.height;
    }else {
        _inputHeightConstraint.constant = 40.0f;
    }
}
#pragma mark --键盘弹出
- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    //取出键盘动画的时间(根据userInfo的key----UIKeyboardAnimationDurationUserInfoKey)
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //取得键盘最后的frame(根据userInfo的key----UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 227}, {320, 253}}";)
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:duration animations:^{
        _inputBottomConstraint.constant = keyboardFrame.size.height;
    }];
}
#pragma mark --键盘收回
- (void)keyboardDidHide:(NSNotification *)notification{
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        _inputBottomConstraint.constant = 4.0f;
    }];
}

#pragma mark -
- (void)loadData:(id _Nullable)sender {
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
    params[@"obj_id"] = [ToolUtil isEqualToNonNullKong:_obj_id];
    params[@"page"] = [NSString stringWithFormat:@"%@",@(_page)];
    params[@"user_id"] = [UserInfoManager shareManager].uid;

    [ApiUtil postWithParent:self url:[ApiUtilHeader getReplyBySingleComment] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [self.tableView endAllFreshing];
        
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        
        NSDictionary *comment = (NSDictionary *)[data objectForKey:@"comment"];
        _itemModel = [DiscussItemInfoModel yy_modelWithDictionary:comment];
        
        if (_itemModel) {
            [self.view ly_hideEmptyView];
        }else
            [self.view ly_showEmptyView];
        
        _toReplyModel = _itemModel;
        self.inputView.text = nil;
        self.inputView.placeholder = [NSString stringWithFormat:@"回复 %@", [ToolUtil isEqualToNonNullKong:_toReplyModel.user_info.username]];
        
        NSArray *array = (NSArray *)[data objectForKey:@"reply_list"];
        if (array && array.count) {
            [_dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[DiscussItemInfoModel class] json:array]];
        }

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
