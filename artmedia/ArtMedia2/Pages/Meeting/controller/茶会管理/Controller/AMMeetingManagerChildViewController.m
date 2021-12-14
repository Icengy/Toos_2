//
//  AMMeetingManagerChildViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/9/8.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMMeetingManagerChildViewController.h"

#import "AMEmptyView.h"
#import "AMMeetingManagerTableCell.h"

#import "HK_tea_managerModel.h"

#import "AMMeetingDetailViewController.h"
#import "HK_invitationList.h"
#import "AMMeetingMainViewController.h"

@interface AMMeetingManagerChildViewController ()<UITableViewDelegate,UITableViewDataSource, AMMeetingManagerDelegate>
@property (nonatomic,weak) IBOutlet BaseTableView *tableView;
@end

@implementation AMMeetingManagerChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bgColorStyle=AMBaseBackgroundColorStyleGray;
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMMeetingManagerTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMMeetingManagerTableCell class])];
    
    [_tableView addRefreshFooterWithTarget:self action:@selector(loadData:)];
    [_tableView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
    _tableView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadData:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData:nil];
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.HK_dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  section?CGFLOAT_MIN:10.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AMMeetingManagerTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMMeetingManagerTableCell class]) forIndexPath:indexPath];
    
    cell.delegate = self;
    if (self.HK_dataArr.count) cell.model = self.HK_dataArr[indexPath.section];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AMMeetingManagerTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self clickToDetail:cell.model];
}

#pragma mark - AMMeetingManagerDelegate
- (void)managerCell:(AMMeetingManagerTableCell *)managerCell didSelectedToDetail:(id)sender {
    [self clickToDetail:managerCell.model];
}

- (void)managerCell:(AMMeetingManagerTableCell *)managerCell didSelectedToEnterRoom:(id)sender {
    
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"uid"] = [UserInfoManager shareManager].uid;
    params[@"timespan"] = [AMMeetingMainViewController getNowTimeStamp];
    params[@"token"] = [AMMeetingMainViewController md5StringWith:[params copy]];
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader enterMeetingRoom] params:params success:^(NSInteger code, id  _Nullable response) {
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            // TRTC相关参数设置
            LS_TRTCParams *param = [[LS_TRTCParams alloc] init];
            param.sdkAppId = [[data objectForKey:@"SDKAppID"] intValue];
            param.userId = [UserInfoManager shareManager].uid;
            param.roomId = managerCell.model.teaAboutInfoId.intValue;
            param.userSig = [data objectForKey:@"sig"];
            param.role = TRTCRoleAnchor;
            
            param.ownerID = StringWithFormat(@(managerCell.model.artistId));
            param.ownerName = [ToolUtil isEqualToNonNullKong:managerCell.model.createUserName];
            param.teaEndTime = managerCell.model.teaEndTime;
            param.currentTime = [TimeTool timestampForTeaToTime:[[ToolUtil isEqualToNonNull:[data objectForKey:@"now_time"]  replace:@"0"] doubleValue]];
            
            [self.navigationController pushViewController:[AMMeetingMainViewController shareInstance:param] animated:YES];
        }else {
            [SVProgressHUD showError:@"数据错误，请重试"];
        }
    } fail:nil];
}

- (void)managerCell:(AMMeetingManagerTableCell *)managerCell didSelectedToLookInvtation:(id)sender {
    HK_invitationList *inviteList = [[HK_invitationList alloc] init];
    inviteList.meetingid = managerCell.model.teaAboutInfoId;
    
    [self.navigationController pushViewController:inviteList animated:YES];
}

#pragma mark -
- (void)clickToDetail:(HK_tea_managerModel *)model {
    AMMeetingDetailViewController *detail = [[AMMeetingDetailViewController alloc] init];
    detail.meetingid = [ToolUtil isEqualToNonNull:model.teaAboutInfoId replace:@"2"];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark -
- (void)loadData:(id)sender {
    self.tableView.allowsSelection = NO;
    if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || ![sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
        [SVProgressHUD show];
    }
    if (sender && [sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        self.pageIndex ++;
    }else {
        self.pageIndex = 1;
        if (self.HK_dataArr.count) [self.HK_dataArr removeAllObjects];
    }
    
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"current"] = @(self.pageIndex);
    params[@"artistId"] = [UserInfoManager shareManager].uid;
    params[@"infoStatus"] = @(self.managerStatus);
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader tea_Manager] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [self.tableView endAllFreshing];
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            NSArray *records = (NSArray *)[data objectForKey:@"records"];
            if (records && records.count) {
                [self.HK_dataArr addObjectsFromArray:[NSArray yy_modelArrayWithClass:[HK_tea_managerModel class] json:records]];
            }
            [self.tableView updataFreshFooter:(self.HK_dataArr.count&&records.count!=MaxListCount)];
        }
        [self.tableView ly_updataEmptyView:!self.HK_dataArr.count];
        self.tableView.mj_footer.hidden = !self.HK_dataArr.count;
        [self.tableView reloadData];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [self.tableView endAllFreshing];
        [SVProgressHUD showError:errorMsg];
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
