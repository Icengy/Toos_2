//
//  HK_TeaChildVC.m
//  ArtMedia2
//
//  Created by guohongkai on 2020/8/13.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "HK_TeaChildVC.h"
#import "AMMeetingRecordManageViewController.h"
#import "AMMeetingMainViewController.h"
#import "AMMeetingDetailViewController.h"
#import "TeaMeetingRecordCell.h"

#import "HK_tea_managerModel.h"

@interface HK_TeaChildVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)BaseTableView *TearecordTab;
@end

@implementation HK_TeaChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.HK_dataArr.count) {
        [self loadData:nil];
    }
}

- (void)configUI{
    self.bgColorStyle=AMBaseBackgroundColorStyleGray;
    [self.view addSubview:self.TearecordTab];
}

- (void)loadData:(id)sender {
    self.TearecordTab.allowsSelection = NO;
    if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
        [SVProgressHUD show];
    }
    if (sender && [sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        self.pageIndex ++;
    }else {
        self.pageIndex = 1;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.pageIndex);
    params[@"memberId"] = [UserInfoManager shareManager].uid;
    params[@"infoStatus"] = [NSString stringWithFormat:@"%ld",self.Status_type];
    [ApiUtil postWithParent:self url:[ApiUtilHeader tea_Record] params:params success:^(NSInteger code, id  _Nullable response) {
        [self.TearecordTab endAllFreshing];
          NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
          if (data && data.count) {
              NSArray *records = (NSArray *)[data objectForKey:@"records"];
              if (records && records.count) {
                  if (![sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
                      if (self.HK_dataArr.count) [self.HK_dataArr removeAllObjects];
                  }
                  [self.HK_dataArr addObjectsFromArray:[NSArray yy_modelArrayWithClass:[HK_tea_managerModel class] json:records]];
              }
              [self.TearecordTab updataFreshFooter:(self.HK_dataArr.count&&records.count!=MaxListCount)];
          }
        [self.TearecordTab ly_updataEmptyView:!self.HK_dataArr.count];
        self.TearecordTab.mj_footer.hidden = !self.HK_dataArr.count;
        [self.TearecordTab reloadData];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [self.TearecordTab endAllFreshing];
        [SVProgressHUD showError:errorMsg];
    }];
}

- (BaseTableView *)TearecordTab{
    if (!_TearecordTab) {
        _TearecordTab=[[BaseTableView alloc]initWithFrame:CGRectMake(15, 0, K_Width-30, K_Height-StatusNav_Height-50) style:UITableViewStyleGrouped];
        _TearecordTab.delegate=self;
        _TearecordTab.dataSource=self;
        _TearecordTab.showsVerticalScrollIndicator = NO;
        _TearecordTab.showsHorizontalScrollIndicator = NO;
        [_TearecordTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_TearecordTab registerNib:[UINib nibWithNibName:NSStringFromClass([TeaMeetingRecordCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TeaMeetingRecordCell class])];
        [_TearecordTab addRefreshFooterWithTarget:self action:@selector(loadData:)];
        [_TearecordTab addRefreshHeaderWithTarget:self action:@selector(loadData:)];
        _TearecordTab.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadData:)];
    }
    return _TearecordTab;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.HK_dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section?CGFLOAT_MIN:10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TeaMeetingRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TeaMeetingRecordCell class]) forIndexPath:indexPath];
    cell.model = self.HK_dataArr[indexPath.section];
    cell.gotoDetailBlock = ^(NSString * _Nonnull meetingid) {
        AMMeetingDetailViewController *detail = [[AMMeetingDetailViewController alloc] init];
        detail.meetingid = meetingid;
        [self.navigationController pushViewController:detail animated:YES];
    };
    cell.gotoMeetingRoomBlock = ^(HK_tea_managerModel * _Nonnull model) {
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
               param.roomId = model.teaAboutInfoId.intValue;
               param.userSig = [data objectForKey:@"sig"];
               param.role = TRTCRoleAnchor;
               
               param.ownerID = StringWithFormat(@(model.artistId));
               param.ownerName = [ToolUtil isEqualToNonNullKong:model.createUserName];
               param.teaEndTime = model.teaEndTime;
               param.currentTime = [TimeTool timestampForTeaToTime:[[ToolUtil isEqualToNonNull:[data objectForKey:@"now_time"]  replace:@"0"] doubleValue]];
               
               [self.navigationController pushViewController:[AMMeetingMainViewController shareInstance:param] animated:YES];
           }else {
               [SVProgressHUD showError:@"数据错误，请重试"];
           }

       } fail:nil];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TeaMeetingRecordCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    AMMeetingDetailViewController *detail = [[AMMeetingDetailViewController alloc] init];
    detail.meetingid = cell.model.teaAboutInfoId;
    [self.navigationController pushViewController:detail animated:YES];
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
