//
//  AMMeetingBookingListViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/8/13.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMMeetingBookingListViewController.h"
#import "AMMeetingEditViewController.h"

#import "AMMeetingBookingListTableCell.h"
#import "AMEmptyView.h"

#import "AMMeetingPleaseUserModel.h"

typedef NS_ENUM(NSUInteger, AMMeetingBookingListSortStyle) {
    /// 降序 2
    AMMeetingBookingListSortStyleDescending = 0,
    /// 升序 1
    AMMeetingBookingListSortStyleAscending
};

@interface AMMeetingBookingListViewController () <UITableViewDelegate ,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *selectedCountLabel;
@property (weak, nonatomic) IBOutlet AMButton *confirmBtn;

@property (weak, nonatomic) IBOutlet AMReverseButton *sortBtn;
@property (weak, nonatomic) IBOutlet AMReverseButton *selectAllBtn;

@property (weak, nonatomic) IBOutlet BaseTableView *tableView;

@end

@implementation AMMeetingBookingListViewController {
    
    AMMeetingBookingListSortStyle _listSortStyle;
    /// 是否全选
    BOOL _selectAll;
    NSInteger _page;
    NSMutableArray <NSString *>*_selectedArray;
    NSMutableArray <AMMeetingPleaseUserModel *>*_dataArray;
}

- (instancetype)init {
    if (self = [super init]) {
        _selectedArray = @[].mutableCopy;
        _dataArray = @[].mutableCopy;
        _page = 1;
        
        _listSortStyle = AMMeetingBookingListSortStyleDescending;
        _selectAll = NO;
    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    [self.navigationItem setTitle:@"邀请预约用户"];
    
    _selectedCountLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    _sortBtn.titleLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
    _selectAllBtn.titleLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
    _confirmBtn.titleLabel.font = [UIFont addHanSanSC:18.0f fontType:0];
    
    _sortBtn.selected = _listSortStyle?YES:NO;
    _selectAllBtn.selected = _selectAll;
    
    if (self.isEditMeeting) {///已有会客
        [self.confirmBtn setBackgroundImage:[UIImage imageWithColor:Color_Black] forState:UIControlStateNormal];
        [self.confirmBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xCCCCCC)] forState:UIControlStateDisabled];
        self.confirmBtn.enabled = NO;
        
        [self.confirmBtn setTitle:@"继续邀请" forState:UIControlStateNormal];
    }else {
        self.confirmBtn.enabled = YES;
        
        [self.confirmBtn setTitle:@"下一步" forState:UIControlStateNormal];
    }
    [self updateConfirmBtnState];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMMeetingBookingListTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMMeetingBookingListTableCell class])];
    
    [_tableView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
    [_tableView addRefreshFooterWithTarget:self action:@selector(loadData:)];
    _tableView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadData:)];
    
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if (!_dataArray.count) {
        [self loadData:nil];
    }
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AMMeetingBookingListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMMeetingBookingListTableCell class]) forIndexPath:indexPath];
    
    AMMeetingPleaseUserModel *model = [_dataArray objectAtIndex:indexPath.section];
    if ([_selectedArray containsObject:model.teaAboutOrderId]) {
        model.isSelected = YES;
    }else
        model.isSelected = NO;
    
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AMMeetingPleaseUserModel *model = [_dataArray objectAtIndex:indexPath.section];
    if ([_selectedArray containsObject:model.teaAboutOrderId]) {
        [_selectedArray removeObject:model.teaAboutOrderId];
    }else {
        [_selectedArray addObject:model.teaAboutOrderId];
    }
    
    _selectAll = (_selectedArray.count == _dataArray.count);
    _selectAllBtn.selected = _selectAll;
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
    
    [self updateConfirmBtnState];
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

#pragma mark -
- (IBAction)clickToConfirm:(id)sender {
    if ([ToolUtil isEqualToNonNull:self.teaAboutInfoId]) {
        NSMutableDictionary *params = @{}.mutableCopy;
        params[@"teaAboutInfoId"] = [ToolUtil isEqualToNonNullKong:self.teaAboutInfoId];
        if (_selectedArray.count) params[@"orderIds"] = _selectedArray;
        
        [ApiUtil postWithParent:self url:[ApiUtilHeader addTwoSubmit] params:params.copy success:^(NSInteger code, id  _Nullable response) {
            [SVProgressHUD showSuccess:@"提交成功!" completion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } fail:nil];
    }else {
        AMMeetingEditViewController *editVC = [[AMMeetingEditViewController alloc] init];
        editVC.selectedArray = _selectedArray.copy;
        [self.navigationController pushViewController:editVC animated:YES];
    }
}

- (IBAction)clickToSelectAll:(id)sender {
    _selectAllBtn.selected = !_selectAllBtn.selected;
    _selectAll = _selectAllBtn.selected;
    
    if (_selectedArray.count) [_selectedArray removeAllObjects];
    if (_selectAll) {
        [_dataArray enumerateObjectsUsingBlock:^(AMMeetingPleaseUserModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_selectedArray addObject:obj.teaAboutOrderId];
        }];
    }
    [self.tableView reloadData];
    [self updateConfirmBtnState];
}

- (IBAction)clickToAdjustSort:(id)sender {
    _sortBtn.selected = !_sortBtn.selected;
    _listSortStyle = _sortBtn.selected?AMMeetingBookingListSortStyleAscending:AMMeetingBookingListSortStyleDescending;
    [self loadData:nil];
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
        _page = 1;
        if (_dataArray.count) [_dataArray removeAllObjects];
    }
    NSString *urlStr = _isEditMeeting?[ApiUtilHeader selectMakeByPage]:[ApiUtilHeader selectMakePleaseList];
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"artistId"] = [UserInfoManager shareManager].uid;
    params[@"sortStatus"] = _listSortStyle?@"1":@"2";
    
    if ([ToolUtil isEqualToNonNull:self.teaAboutInfoId]) {
        params[@"teaAboutInfoId"] = self.teaAboutInfoId;
    }
    
    [ApiUtil postWithParent:self url:urlStr needHUD:NO params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [self.tableView endAllFreshing];
        
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            NSArray *records = (NSArray *)[data objectForKey:@"records"];
            if (records && records.count) {
                [_dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[AMMeetingPleaseUserModel class] json:records]];
            }
            [self.tableView updataFreshFooter:(_dataArray.count && records.count != MaxListCount)];
        }
        [self.tableView ly_updataEmptyView:!_dataArray.count];
        self.tableView.mj_footer.hidden = !_dataArray.count;
        self.selectAllBtn.hidden = !_dataArray.count;
        self.selectedCountLabel.hidden = !_dataArray.count;
        
        [self.tableView reloadData];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [self.tableView endAllFreshing];
        [SVProgressHUD showError:errorMsg];
    }];
}

- (void)updateConfirmBtnState {
    if (self.isEditMeeting) {
        self.confirmBtn.enabled = (_selectedArray && _selectedArray.count)?YES:NO;
    }
    NSString *count = StringWithFormat(@(_selectedArray.count));
    self.selectedCountLabel.text = [NSString stringWithFormat:@"已选择%@人", count];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.selectedCountLabel.text];
    [attr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xE22020) range:[self.selectedCountLabel.text rangeOfString:count]];
    self.selectedCountLabel.attributedText = attr;
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
