//
//  InviteNewViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/15.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "InviteNewViewController.h"

#import "WebViewURLViewController.h"

#import "InviteNewCodeTableCell.h"
#import "InviteNewListTableCell.h"
#import "InviteNewHeaderView.h"

#import "MyInviterView.h"

#import "InviteInfoModel.h"

#import "AMEmptyView.h"
#import "WechatManager.h"


@interface InviteNewViewController () <UITableViewDelegate,
                UITableViewDataSource, WebViewURLViewControllerDelegate>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (nonatomic ,strong) InviteNewHeaderView *headerView;
@property (nonatomic ,strong) MyInviterView *inviterView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation InviteNewViewController {
    NSMutableArray <InviteInfoModel *>*_dataArray;
    NSInteger _page;
    NSString *_myInviteCode, *_count;
    InviteInfoModel *_myInviterModel;
}

- (InviteNewHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([InviteNewHeaderView class]) owner:nil options:nil].lastObject;
        _headerView.frame = CGRectMake(0, 0, self.view.width, 44.0f);
    }return _headerView;
}

- (MyInviterView *)inviterView {
    if (!_inviterView) {
        _inviterView = [MyInviterView shareInstance];
        @weakify(self);
        _inviterView.confirmBlock = ^(NSString * _Nullable inviteCode) {
            NSLog(@"inviteCode = %@",inviteCode);
            @strongify(self);
            [self clickToAddMyInviter:inviteCode];
        };
    } return _inviterView;
}

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    _page = 0;
    _dataArray = @[].mutableCopy;
    self.isSecondary = YES;
    
    self.countLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([InviteNewCodeTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([InviteNewCodeTableCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([InviteNewListTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([InviteNewListTableCell class])];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self.tableView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
    [self.tableView addRefreshFooterWithTarget:self action:@selector(loadData:)];
    self.tableView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadData:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationItem.title = @"我的邀请";
    [self initRightNaviBar];
    
    if (!_dataArray.count) [self loadData:nil];
}

- (void)initRightNaviBar {
    AMButton *rightBtn = [AMButton buttonWithType:UIButtonTypeCustom];
    
    [rightBtn setTitle:@"我的邀请人" forState:UIControlStateNormal];
    [rightBtn setTitleColor:Color_Black forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    [rightBtn addTarget:self action:@selector(clickToShowMyInviter:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InviteNewListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([InviteNewListTableCell class])];
    cell.isSecondary = self.isSecondary;
    cell.model = _dataArray[indexPath.section];
    @weakify(self);
    cell.inviteBlock = ^(InviteInfoModel * _Nonnull model) {
        @strongify(self);
        [self clickToInvte:model];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section) return CGFLOAT_MIN;
    return 10.0f;
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
}

- (void)clickToInvte:(InviteInfoModel *)model {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"uid"] = [ToolUtil isEqualToNonNullKong:model.uid];
    params[@"userType"] = [ToolUtil isEqualToNonNull:model.utype replace:@"1"];
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader addMessageStatus] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [SVProgressHUD showSuccess:@"邀请成功!"];
    } fail:nil];
}

#pragma mark - WebViewURLViewControllerDelegate
- (void)webViewDidSelectedJSForShare:(NSInteger)shareType {
    NSDictionary *params = @{@"title":@"邀请好友",
                             @"des":@"艺术融媒体全新上线来这里，和我们一起“搞艺术",
                             @"img":@"logo",
                             @"url":[ApiUtil_H5Header h5_registerWith:[ToolUtil isEqualToNonNullKong:_myInviteCode]]
    };
    [[WechatManager shareManager] wxSendReqWithScene:shareType?AMShareViewItemStyleWXFriend:AMShareViewItemStyleWX withParams:params];
}

- (void)webViewDidSelectedJSForSaveImage:(id _Nullable)imageData {
    if (imageData) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        UIAlertAction *save = [UIAlertAction actionWithTitle:@"保存" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            NSURL *baseImageUrl = [NSURL URLWithString:imageData];
            NSData *imageData = [NSData dataWithContentsOfURL:baseImageUrl];
            UIImage *image = [UIImage imageWithData:imageData];
//            [self calulateImageFileSize:image];
            if (image) {
                UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinshSavingWithError:contextInfo:), NULL);
            }
        }];
        [alert addAction:cancel];
        [alert addAction:save];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark -
// 保存图片错误提示方法
- (void)image:(UIImage *)image didFinshSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *mes = nil;
    if (error != nil) {
        mes = @"保存图片失败";
    } else {
        mes = @"保存图片成功";
    }
    SingleAMAlertView *alert = [SingleAMAlertView shareInstance];
    alert.title = mes;
    [alert show];
}

#pragma mark -
- (void)clickToShowMyInviter:(id)sender {
    if (_myInviterModel) {
        self.inviterView.inviterModel = _myInviterModel;
        [self.inviterView show];
    }else {
        [ApiUtil postWithParent:self url:[ApiUtilHeader getMyInviter] params:@{@"uid":[UserInfoManager shareManager].uid} success:^(NSInteger code, id  _Nullable response) {
            NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
            if (data && data.count) {
                _myInviterModel = [InviteInfoModel yy_modelWithDictionary:data];
            }
            self.inviterView.inviterModel = _myInviterModel;
            [self.inviterView show];

        } fail:nil];
    }
}

- (void)inviteOther:(id)sender {
    NSString *url = [NSString stringWithFormat:@"http://wechat.ysrmt.cn/appShare/index.html?uid=%@",[UserInfoManager shareManager].uid];
    WebViewURLViewController *webView = [[WebViewURLViewController alloc] initWithUrlString:url];
//    webView.delegate = self;
    webView.isShare = YES;
    webView.navigationBarTitle = @"邀请好友";
    webView.needSafeAreaBottomHeight = YES;
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)clickToAddMyInviter:(NSString *)inviteCode {
    [self.view endEditing:YES];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"uid"] = [UserInfoManager shareManager].uid;
    params[@"type"] = @"2";
    params[@"code"] = inviteCode;
    params[@"agentType"] = @"1";
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader addMyInviter] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [self.inviterView hide];
    } fail:nil];
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
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"page"] = StringWithFormat(@(_page));
    params[@"uid"] = !self.isSecondary?[ToolUtil isEqualToNonNullKong:self.hostModel.uid]:[UserInfoManager shareManager].uid;
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader getMyInviterList] needHUD:NO params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [self.tableView endAllFreshing];
        _myInviteCode = [ToolUtil isEqualToNonNullForZanWu:[[response objectForKey:@"data"] objectForKey:@"ivcode"]];
        _count = [ToolUtil isEqualToNonNull:[[response objectForKey:@"data"] objectForKey:@"count"] replace:@"0"];
        _countLabel.text = [NSString stringWithFormat:@"已成功邀请%@人", _count];
        NSArray *array = (NSArray *)[[response objectForKey:@"data"] objectForKey:@"list"];
        if (array && array.count) {
            [_dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[InviteInfoModel class] json:array]];
        }
        [self.tableView updataFreshFooter:(_dataArray.count && array.count != MaxListCount)];
        self.tableView.mj_footer.hidden = !_dataArray.count;
        [self.tableView ly_updataEmptyView: !_dataArray.count];
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
