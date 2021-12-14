//
//  ECoinRecordDetailViewController.m
//  ArtMedia2
//
//  Created by LY on 2020/10/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "ECoinRecordDetailViewController.h"
#import "ECoinRecordDetailNormalCell.h"
#import "ECoinRecordDetailHeadCell.h"
#import "ECoinRecordDetailModel.h"
@interface ECoinRecordDetailViewController ()<UITableViewDelegate , UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic , strong) ECoinRecordDetailModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

@end

@implementation ECoinRecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    [self loadData];
}
- (void)loadData{
    
    NSMutableDictionary *dic= [NSMutableDictionary dictionary];
    dic[@"goldId"] = self.goldId;
    [ApiUtil getWithParent:self url:[ApiUtilHeader selectAccountVirtualGoldDetailById] needHUD:NO params:dic success:^(NSInteger code, id  _Nullable response) {
        self.model = [ECoinRecordDetailModel yy_modelWithDictionary:response[@"data"]];
        [self.tableView endAllFreshing];
        [self.tableView reloadData];
        self.tableViewHeight.constant = self.tableView.contentSize.height;
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [self.tableView endAllFreshing];
        [SVProgressHUD showError:errorMsg];
    }];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"艺币明细详情";

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)setTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView addRefreshHeaderWithTarget:self action:@selector(loadData)];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ECoinRecordDetailHeadCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ECoinRecordDetailHeadCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ECoinRecordDetailNormalCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ECoinRecordDetailNormalCell class])];
}
#pragma mark - UITableViewDelegate , UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ECoinRecordDetailHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ECoinRecordDetailHeadCell class]) forIndexPath:indexPath];
        cell.model = self.model;
        return cell;
    }else{
        ECoinRecordDetailNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ECoinRecordDetailNormalCell class]) forIndexPath:indexPath];
        cell.indexPath = indexPath;
        cell.model = self.model;
        return cell;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.model.consumeType isEqualToString:@"1"]) {//充值
        return 7;
    }else{
        return 6;
    }
    
}
@end
