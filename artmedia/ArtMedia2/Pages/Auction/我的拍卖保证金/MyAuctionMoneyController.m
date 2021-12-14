//
//  MyAuctionMoneyController.m
//  ArtMedia2
//
//  Created by LY on 2020/11/13.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "MyAuctionMoneyController.h"
#import "WebViewURLViewController.h"

#import "MyAuctionMoneyTableCell.h"

#import "MyAuctionMoneyModel.h"

@interface MyAuctionMoneyController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet AMIconImageView *logoIV;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (nonatomic , strong) NSMutableArray <MyAuctionMoneyModel *>*listData;
@end

@implementation MyAuctionMoneyController {
    NSInteger _lockDepositAmount;
    NSArray *_records;
}

- (NSMutableArray *)listData{
    if (!_listData) {
        _listData = [[NSMutableArray alloc] init];
    }return _listData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tipsLabel.font = [UIFont addHanSanSC:12.0 fontType:0];
    self.priceLabel.font = [UIFont addHanSanSC:36.0 fontType:2];
    
    _lockDepositAmount = 0;
    
    [self.logoIV addBorderWidth:4.0 borderColor:[UIColor.whiteColor colorWithAlphaComponent:0.95]];
    [self.logoIV am_setImageWithURL:[UserInfoManager shareManager].model.headimg placeholderImage:ImageNamed(@"logo") contentMode:UIViewContentModeScaleAspectFill];
    
    [self setTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if (!self.listData.count) [self loadData:nil];
}

- (void)setTableView {
    _records = @[];
    
    self.tableView.bgColorStyle = AMBaseTableViewBackgroundColorStyleGray;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyAuctionMoneyTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MyAuctionMoneyTableCell class])];
    [self.tableView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
    [self.tableView addRefreshFooterWithTarget:self action:@selector(loadData:)];
    self.tableView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self imageStr:@"icon-hummer-current" titleStr:nil detailStr:@"暂无保证金记录" btnTitleStr:nil action:@selector(loadData:)];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

#pragma mark -  UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyAuctionMoneyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyAuctionMoneyTableCell class]) forIndexPath:indexPath];
    cell.model = [self.listData objectAtIndex:indexPath.section];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section?CGFLOAT_MIN:20.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

#pragma mark -
- (IBAction)clickToBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickToQuestion:(id)sender {
    WebViewURLViewController *webView = [[WebViewURLViewController alloc] initWithUrlString:[ApiUtil_H5Header h5_agreement:@"BZJXY"]];
    webView.navigationBarTitle = @"保证金协议";
    [self.navigationController pushViewController:webView animated:YES];
}

#pragma mark -
- (void)loadData:(id)sender {
    
    self.tableView.allowsSelection = NO;
    _records = @[];
    if (sender && [sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        self.pageIndex ++;
    }else {
        self.pageIndex = 1;
        if (self.listData.count) [self.listData removeAllObjects];
    }
    if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
        [SVProgressHUD show];
    }
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);

        NSMutableDictionary *params = @{}.mutableCopy;
        params[@"current"] = StringWithFormat(@(self.pageIndex));
        params[@"size"] = StringWithFormat(@(MaxListCount));
        
        [ApiUtil postWithParent:self url:[ApiUtilHeader selectAuctionUserDepositOrderListOfCurrentUser] needHUD:NO params:params.copy success:^(NSInteger code, id  _Nullable response) {
            NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
            if (data && data.count) {
                _records = (NSArray *)[data objectForKey:@"records"];
                if (_records && _records.count) {
                    [self.listData addObjectsFromArray:[NSArray yy_modelArrayWithClass:[MyAuctionMoneyModel class] json:_records]];
                }
            }
            dispatch_group_leave(group);
        } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
            [SVProgressHUD showError:errorMsg];
            dispatch_group_leave(group);
        }];
    });
    if (!(sender && [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
        /// 获取冻结资金信息
        dispatch_group_async(group, queue, ^{
            dispatch_group_enter(group);
            [ApiUtil getWithParent:self url:[ApiUtilHeader selectDepositOrderStatisticsInfoOfCurrentUser] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response) {
                NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
                if (data && data.count) {
                    _lockDepositAmount = [ToolUtil isEqualToNonNull:[data objectForKey:@"lockDepositAmount"] replace:@"0"].integerValue;
                }
                dispatch_group_leave(group);
            } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
                [SVProgressHUD showError:errorMsg];
                dispatch_group_leave(group);
            }];
        });
    }
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.priceLabel.text = [NSString stringWithFormat:@"%@", @(_lockDepositAmount)];
            
            [self.tableView endAllFreshing];
            [self.tableView updataFreshFooter:(self.listData.count && _records.count != MaxListCount)];
            [self.tableView ly_updataEmptyView:!self.listData.count];
            self.tableView.mj_footer.hidden = !self.listData.count;
            [self.tableView reloadData];
        });
    });
}




@end
