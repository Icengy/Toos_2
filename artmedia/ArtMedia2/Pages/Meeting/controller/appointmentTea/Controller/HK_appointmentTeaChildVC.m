//
//  HK_appointmentTeaChildVC.m
//  ArtMedia2
//
//  Created by guohongkai on 2020/8/17.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "HK_appointmentTeaChildVC.h"
#import "HK_appointmentTeaCell.h"
#import "HK_appointmentDetailVC.h"
#import "HK_appointment_model.h"
#import "AMEmptyView.h"

@interface HK_appointmentTeaChildVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *appointmentTab;
@end

@implementation HK_appointmentTeaChildVC

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

- (void)loadData:(id)sender{
    NSLog(@"%@",[ApiUtilHeader appoint_recordUrl]);
    if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
        [SVProgressHUD show];
    }
    if (sender && [sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        self.pageIndex ++;
    }else {
        self.pageIndex = 1;
        if (self.HK_dataArr.count) [self.HK_dataArr removeAllObjects];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = @"2";
    params[@"orderStatus"] = [NSString stringWithFormat:@"%ld",self.Appointment_status];
    params[@"page"] = [NSString stringWithFormat:@"%ld",self.pageIndex];
    [ApiUtil postWithParent:self url:[ApiUtilHeader appoint_recordUrl] params:params success:^(NSInteger code, id  _Nullable response) {
        NSLog(@"%@",response);
        [self.appointmentTab endAllFreshing];
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            NSArray *records = (NSArray *)[data objectForKey:@"records"];
            if (records && records.count) {
                [self.HK_dataArr addObjectsFromArray:[NSArray yy_modelArrayWithClass:[HK_appointment_model class] json:records]];
            }
            [self.appointmentTab updataFreshFooter:(self.HK_dataArr.count&&records.count!=MaxListCount)];
        }
        self.appointmentTab.mj_footer.hidden = !self.HK_dataArr.count;
        [self.appointmentTab ly_updataEmptyView:!self.HK_dataArr.count];
        [self.appointmentTab reloadData];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [self.appointmentTab endAllFreshing];
        [SVProgressHUD showError:errorMsg];
    }];
}
- (void)configUI{
    self.bgColorStyle=AMBaseBackgroundColorStyleGray;
    [self.view addSubview:self.appointmentTab];
}

- (UITableView *)appointmentTab{
    if (!_appointmentTab) {
        _appointmentTab=[[UITableView alloc]initWithFrame:CGRectMake(15, 0, K_Width-30, K_Height-StatusNav_Height-50) style:UITableViewStyleGrouped];
        _appointmentTab.delegate=self;
        _appointmentTab.dataSource=self;
        _appointmentTab.backgroundColor=[UIColor clearColor];
        [_appointmentTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_appointmentTab registerClass:[HK_appointmentTeaCell class] forCellReuseIdentifier:NSStringFromClass([HK_appointmentTeaCell class])];
        _appointmentTab.showsVerticalScrollIndicator = NO;
        _appointmentTab.showsHorizontalScrollIndicator = NO;
        
        [_appointmentTab addRefreshFooterWithTarget:self action:@selector(loadData:)];
        [_appointmentTab addRefreshHeaderWithTarget:self action:@selector(loadData:)];
        _appointmentTab.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadData:)];
    }
    return _appointmentTab;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.HK_dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell addSectionCornerWithTableView:tableView tableViewCell:cell indexPath:indexPath cornerRadius:8.f];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, K_Width, 10)];
    view.backgroundColor=RGB(247, 247, 247);
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HK_appointmentTeaCell *cell= [HK_appointmentTeaCell cellWithTableView:tableView andCellIdifiul:NSStringFromClass([HK_appointmentTeaCell class])];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    cell.model=self.HK_dataArr[indexPath.section];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HK_appointment_model *model=self.HK_dataArr[indexPath.section];
    HK_appointmentDetailVC *vc=[[HK_appointmentDetailVC alloc]init];
    vc.appointment_Status=model.orderStatus;
    vc.appointmentModel = model;
    [self.navigationController pushViewController:vc animated:YES];
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
