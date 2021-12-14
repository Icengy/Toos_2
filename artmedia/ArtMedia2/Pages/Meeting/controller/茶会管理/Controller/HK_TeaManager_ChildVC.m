//
//  HK_TeaManager_ChildVC.m
//  ArtMedia2
//
//  Created by guohongkai on 2020/8/19.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "HK_TeaManager_ChildVC.h"
#import "AMMeetingDetailViewController.h"
#import "HK_invitationList.h"
#import "HK_appointmentDetailVC.h"


#import "HK_TeaManager_cell.h"
#import "TeaMeetingManagerCell.h"

#import "HK_invitationList.h"
#import "HK_tea_managerModel.h"
#import "AMEmptyView.h"


@interface HK_TeaManager_ChildVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) BaseTableView *TeaManagerTab;

@end

@implementation HK_TeaManager_ChildVC

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
    [self.view addSubview:self.TeaManagerTab];
}

- (void)loadData:(id)sender {
    if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
        [SVProgressHUD show];
    }
    if (sender && [sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        self.pageIndex ++;
    }else {
        self.pageIndex = 1;
        if (self.HK_dataArr.count) [self.HK_dataArr removeAllObjects];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"page"] = @(self.pageIndex);
    dic[@"artistId"] = [UserInfoManager shareManager].uid;
    dic[@"infoStatus"] = [NSString stringWithFormat:@"%ld",self.managerStatus];
    [ApiUtil postWithParent:self url:[ApiUtilHeader tea_Manager] params:dic success:^(NSInteger code, id  _Nullable response) {
        [self.TeaManagerTab endAllFreshing];
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            NSArray *records = (NSArray *)[data objectForKey:@"records"];
            if (records && records.count) {
                [self.HK_dataArr addObjectsFromArray:[NSArray yy_modelArrayWithClass:[HK_tea_managerModel class] json:records]];
            }
            [self.TeaManagerTab updataFreshFooter:(self.HK_dataArr.count&&records.count!=MaxListCount)];
        }
        [self.TeaManagerTab ly_updataEmptyView:!self.HK_dataArr.count];
        self.TeaManagerTab.mj_footer.hidden = !self.HK_dataArr.count;
        [self.TeaManagerTab reloadData];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [self.TeaManagerTab endAllFreshing];
        [SVProgressHUD showError:errorMsg];
    }];

}
- (UITableView *)TeaManagerTab{
    if (!_TeaManagerTab) {
        _TeaManagerTab=[[BaseTableView alloc]initWithFrame:CGRectMake(15, 0, K_Width-30, K_Height-StatusNav_Height-50) style:UITableViewStyleGrouped];
        _TeaManagerTab.delegate=self;
        _TeaManagerTab.dataSource=self;
        _TeaManagerTab.backgroundColor=[UIColor clearColor];
        [_TeaManagerTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _TeaManagerTab.tableFooterView=[UIView new];
        [_TeaManagerTab registerNib:[UINib nibWithNibName:NSStringFromClass([TeaMeetingManagerCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TeaMeetingManagerCell class])];
//        [_TeaManagerTab registerClass:[HK_TeaManager_cell class] forCellReuseIdentifier:NSStringFromClass([HK_TeaManager_cell class])];
        _TeaManagerTab.showsVerticalScrollIndicator = NO;
        _TeaManagerTab.showsHorizontalScrollIndicator = NO;
        
        [_TeaManagerTab addRefreshFooterWithTarget:self action:@selector(loadData:)];
        [_TeaManagerTab addRefreshHeaderWithTarget:self action:@selector(loadData:)];
        _TeaManagerTab.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadData:)];
    }
    return _TeaManagerTab;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.HK_dataArr.count;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell addSectionCornerWithTableView:tableView tableViewCell:cell indexPath:indexPath cornerRadius:8.f];
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 153;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section?CGFLOAT_MIN:10;
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
    TeaMeetingManagerCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TeaMeetingManagerCell class]) forIndexPath:indexPath];
    cell.model = self.HK_dataArr[indexPath.section];
    cell.roomBlock = ^(NSString * _Nonnull ID) {
//        NSMutableDictionary *params = @{}.mutableCopy;
//           params[@"uid"] = [UserInfoManager shareManager].uid;
//           params[@"timespan"] = [AMMeetingMainViewController getNowTimeStamp];
//           params[@"token"] = [AMMeetingMainViewController md5StringWith:[params copy]];
//
//           [ApiUtil postWithParent:self url:[ApiUtilHeader enterMeetingRoom] params:params success:^(NSInteger code, id  _Nullable response) {
//               NSDictionary *data = (NSDictionary *)response[@"data"];
//
//               if (data && data.count) {
//                   // 房间号，注意这里是32位无符号整型
//           //        NSString *roomId = StringWithFormat(@(arc4random()%10+9999));
//
//                   // TRTC相关参数设置
//                   LS_TRTCParams *param = [[LS_TRTCParams alloc] init];
//                   param.sdkAppId = (UInt32)[data[@"SDKAppID"] integerValue];
//                   param.userId = [UserInfoManager shareManager].uid;
//           //        param.roomId = (UInt32)_model.id.integerValue;
//                   param.roomId = 99789;
//                   param.userSig = data[@"sig"];
//                   param.privateMapKey = @"";
//                   param.role = TRTCRoleAnchor;
//
//           //        param.id = _model.id;
//                   param.ownerID = StringWithFormat(@(_model.createUserId));
//                   param.ownerNickName = [ToolUtil isEqualToNonNullKong:_model.uname];
//                   param.roomName = [NSString stringWithFormat:@"%@的茶会",param.ownerNickName];
//
//                   [self.navigationController pushViewController:[AMMeetingMainViewController shareInstance:param] animated:YES];
//               }else {
//                   [SVProgressHUD showError:@"数据错误，请重试"];
//               }
//
//           } fail:nil];
    };
    cell.detailBlock = ^(NSString * _Nonnull ID) {
        AMMeetingDetailViewController *detail = [[AMMeetingDetailViewController alloc] init];
        detail.meetingid = ID;
        [self.navigationController pushViewController:detail animated:YES];
    };
    cell.inviteBlock = ^(NSString * _Nonnull ID) {
        HK_invitationList *inviteList = [[HK_invitationList alloc] init];
        inviteList.meetingid = ID;
        [self.navigationController pushViewController:inviteList animated:YES];
    };
    return  cell;
    
//    HK_TeaManager_cell *cell=[HK_TeaManager_cell cellWithTableView:tableView andCellIdifiul:NSStringFromClass([HK_TeaManager_cell class])];
//    cell.backgroundColor=[UIColor clearColor];
//    cell.selectionStyle=UITableViewCellSelectionStyleNone;
//    cell.model=self.HK_dataArr[indexPath.section];
//    cell.clickToDetailBlock = ^(HK_tea_managerModel * _Nonnull model) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self clickToDetail:model];
//        });
//    };
//    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HK_TeaManager_cell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self clickToDetail:cell.model];
}

- (void)clickToDetail:(HK_tea_managerModel *)model {
    AMMeetingDetailViewController *detail = [[AMMeetingDetailViewController alloc] init];
    detail.meetingid = [ToolUtil isEqualToNonNull:model.ID replace:@"1"];
    [self.navigationController pushViewController:detail animated:YES];
}


@end
