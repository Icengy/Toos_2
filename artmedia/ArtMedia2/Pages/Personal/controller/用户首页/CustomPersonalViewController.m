//
//  CustomPersonalViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/15.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "CustomPersonalViewController.h"

#import "CustomInfoTableCell.h"
#import "CustomArtInfoTableCell.h"
#import "PersonalListTitleView.h"

#import "PersonalDataEditViewController.h"
#import "PersonalListViewController.h"
//#import "AMMeetingRecordManageViewController.h"
#import "AMMeetingOrderViewController.h"
#import "AMMeetingSettingViewController.h"
#import "HK_appointmentDetailVC.h"

#import "CustomPersonalModel.h"
#import "SelectTeaStatusModel.h"

#define CustomeItemContentSectionHeight  (K_Height - StatusNav_Height - 44.0f)

@interface CustomPersonalViewController () <CustomInfoTableCellDelegate, CustomArtInfoTableCellDelegate>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;

@property (nonatomic ,strong) PersonalListTitleView *headerView;

@end

@implementation CustomPersonalViewController {
	BOOL _naviHidden;
    NSString *_updatetime, *_meeting_status, *_orderBtnStatus , *_teaAboutOrderId;
    CustomPersonalModel *_userModel;
}

- (PersonalListTitleView *)headerView {
    if (_headerView) return _headerView;
    _headerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PersonalListTitleView class]) owner:self options:nil].lastObject;
    _headerView.frame = CGRectMake(0, 0, K_Width, 44.0f);
    _headerView.dataArray = self.contentTitleArray.mutableCopy;
    @weakify(self);
    _headerView.clickIndexBlock = ^(NSInteger index) {
        @strongify(self);
        if (self.currentIndex != index) {
            self.currentIndex = index;
            [self.contentCarrier moveToControllerAtIndex:self.currentIndex animated:YES];
        }
    };
    return _headerView;
}

+ (CustomPersonalViewController *)shareInstance {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"个人简介"];
    
	self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    
    self.currentIndex = 0;
    self.canScroll = YES;
    _naviHidden = YES;
    
    self.contentChildArray = [self getContentChildArray].mutableCopy;
    self.contentCarrier.delegate = self;
    self.contentCarrier.dataSource = self;
	[self addChildViewController:self.contentCarrier];
    
    self.tableView.multipleGestureEnable = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.sectionFooterHeight = CGFLOAT_MIN;
    
    [self.tableView registerClass:[EmptyTableViewCell class] forCellReuseIdentifier:NSStringFromClass([EmptyTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CustomInfoTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([CustomInfoTableCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CustomArtInfoTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([CustomArtInfoTableCell class])];
    
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
	[self.navigationController setNavigationBarHidden:_naviHidden animated:NO];
    
    if (!_userModel) [self getData:nil];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return UITableViewAutomaticDimension;
    }
    return CustomeItemContentSectionHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (_userModel.userData.utype.intValue == 3) {
            CustomArtInfoTableCell *artCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CustomArtInfoTableCell class]) forIndexPath:indexPath];
            artCell.delegate = self;
            artCell.model = _userModel;
            return artCell;
        }
        CustomInfoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CustomInfoTableCell class]) forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = _userModel;
        
        return cell;
    }
    EmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EmptyTableViewCell class]) forIndexPath:indexPath];
    
    cell.insets = (_userModel.userData.utype.integerValue == 3)?UIEdgeInsetsZero:UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f);
    cell.corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
    cell.cornersRadii = AMCellcornersRadiusDefault;
    cell.contentCarrier = self.contentCarrier.view;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 44.0f;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        self.headerView.insets = (_userModel.userData.utype.integerValue == 3)?UIEdgeInsetsZero:UIEdgeInsetsMake(0.0f, 10.0f, 0.0, 10.0f);
        self.headerView.dataArray = self.contentTitleArray.copy;
        return self.headerView;
    }
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    ///隐藏导航栏
    _naviHidden = YES;
    if (offsetY >= StatusNav_Height) {
        _naviHidden = NO;
    }
    [self.navigationController setNavigationBarHidden:_naviHidden animated:YES];
    
    CGFloat bottomCellOffset = [self.tableView rectForSection:self.tableView.numberOfSections - 1].origin.y - StatusNav_Height;
    [self tableViewDidScroll:scrollView bottomCellOffset:bottomCellOffset];
}

#pragma mark - BaseItemViewController
- (void)itemListController:(BaseItemViewController *)listVC scrollToTopOffset:(BOOL)scrollTop {
    [self tableViewScrollToTopOffset];
}

#pragma mark -
- (NSArray *)getContentChildArray {
    self.contentTitleArray = [self getContentTitleArray].mutableCopy;
    if (_userModel.userData.utype.integerValue == 3) {
        NSMutableArray *customArray = [NSMutableArray new];
        for (int i = 0; i < 2; i ++) {
            PersonalListViewController *listVC = [[PersonalListViewController alloc] init];
            listVC.listType = i?PersonalControllerListTypeArtGallery:PersonalControllerListTypeArtCreate;
            listVC.userID = self.artuid;
            listVC.delegate = self;
            [customArray insertObject:listVC atIndex:customArray.count];
        }
        return customArray;
    }
    NSMutableArray *customArray = [NSMutableArray new];
    for (int i = 0; i < 2; i ++) {
        PersonalListViewController *listVC = [[PersonalListViewController alloc] init];
        listVC.listType = i?PersonalControllerListTypeOtherLike:PersonalControllerListTypeOtherVideo;
        listVC.userID = self.artuid;
        listVC.delegate = self;
        [customArray insertObject:listVC atIndex:customArray.count];
    }
    return customArray;
}

- (NSArray *)getContentTitleArray {
    if (_userModel.userData.utype.integerValue == 3)
        return @[@"短视频", @"作品集"];
    return @[@"视频0", @"喜欢0"];
}

- (NSInteger)numberOfControllersInPagerController {
    return self.contentChildArray.count;
}

- (NSString *)pagerController:(TYPagerController *)pagerController titleForIndex:(NSInteger)index {
    return self.contentTitleArray[index];
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index {
	return self.contentChildArray[index];
}

- (void)pagerController:(TYTabPagerController *)pagerController didScrollToTabPageIndex:(NSInteger)index {
    NSLog(@"didScrollToTabPageIndex - %@",@(index));
    if (self.currentIndex != index) {
        self.currentIndex = index;
        _headerView.currentIndex = self.currentIndex;
    }
}

#pragma mark - CustomPersonalHeaderDelegate
- (void)headerView:(CustomInfoTableCell *)headView didClickToBack:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)headerView:(CustomInfoTableCell *)headView didClickToMore:(id)sender {
	NSString *title = @"拉入黑名单";
	if (_userModel.userData.is_blacklist) title = @"移除黑名单";
    
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		[alert dismissViewControllerAnimated:YES completion:nil];
	}];
	
	UIAlertAction *opeationAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		[self clickToMore:nil];
	}];
	
	[alert addAction:cancelAction];
	[alert addAction:opeationAction];
	
	[self presentViewController:alert animated:YES completion:nil];
}

- (void)headerView:(CustomInfoTableCell *)headView didClickToFollow:(id)sender {
	NSLog(@"关注");
    if (![UserInfoManager shareManager].isLogin) {
        [self jumpToLoginWithBlock:nil];
        return;
    }
	[self clickToFollow:sender];
}

- (void)headerView:(CustomInfoTableCell *)headView didClickToRemoveBlack:(id)sender {
    if (![UserInfoManager shareManager].isLogin) {
        [self jumpToLoginWithBlock:nil];
        return;
    }
    [self clickToMore:sender];
}

- (void)headerView:(CustomInfoTableCell *)headView didClickToEditInfo:(id)sender {
    [self.navigationController pushViewController: [[PersonalDataEditViewController alloc] init] animated:YES];
}

- (void)headerView:(CustomArtInfoTableCell *)headView didClickToMeeting:(id _Nullable)sender {
    if (![UserInfoManager shareManager].isLogin) {
        [self jumpToLoginWithBlock:nil];
        return;
    }
    
    if ([_orderBtnStatus isEqualToString:@"4"]) {
        HK_appointmentDetailVC * vc = [[HK_appointmentDetailVC alloc] init];
        vc.teaAboutOrderId = _teaAboutOrderId;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        AMMeetingOrderViewController *orderVC = [[AMMeetingOrderViewController alloc] init];
        orderVC.artuid = self.artuid;
        [self.navigationController pushViewController:orderVC animated:YES];
    }
}

- (void)headerView:(CustomArtInfoTableCell *)headView didClickToMeetingSetting:(id _Nullable)sender {
    [self.navigationController pushViewController:[[AMMeetingSettingViewController alloc] init] animated:YES];
}

#pragma mark -
- (void)clickToFollow:(AMButton *)sender {
    
	if ([ToolUtil isEqualOwner:_userModel.userData.id]) {
		AMAlertView *alertView = [AMAlertView shareInstanceWithTitle:@"无法关注自己" buttonArray:@[@"确定"] confirm:nil cancel:nil];
		[alertView show];
		return;
	}
	if (_userModel.userData.is_collect) {
		AMAlertView *alert = [AMAlertView shareInstanceWithTitle:@"是否取消关注？" buttonArray:@[ @"是", @"否"] confirm:^{
			[self clickToCollect:nil];
		} cancel:nil];
		[alert show];
	}else {
		[self clickToCollect:nil];
	}
}

- (void)clickToCollect:(id)sender {
	NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"uid"] = [UserInfoManager shareManager].uid;
	params[@"collect_uid"] = [ToolUtil isEqualToNonNullKong:self.artuid];
	
    [ApiUtil postWithParent:self url:[ApiUtilHeader collectUser] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        NSString *keyword = nil;
        if (!_userModel.userData.is_collect) {
            keyword = @"关注成功";
        }else {
            keyword = @"取消关注成功";
        }
        [SVProgressHUD showSuccess:keyword];
        _userModel.userData.is_collect = !_userModel.userData.is_collect;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:(UITableViewRowAnimationAutomatic)];
        [self updateNaviData];
        
    } fail:nil];
}

- (void)clickToMore:(id _Nullable)sender {
	if ([ToolUtil isEqualOwner:_userModel.userData.id]) {
		AMAlertView *alertView = [AMAlertView shareInstanceWithTitle:@"无法拉黑自己" buttonArray:@[@"确定"] confirm:nil cancel:nil];
		[alertView show];
		return;
	}
	if (!_userModel.userData.is_blacklist) {
		AMAlertView *alert = [AMAlertView shareInstanceWithTitle:@"确认拉黑该用户" message:@"拉黑该用户后，将自动取消对他的关注，并且不再收到他的相关视频推荐。" buttonArray:@[@"确定", @"取消"] alertType:AMAlertTypeNormal confirm:^{
			[self clickToBlacklist:nil];
		} cancel:nil];
		[alert show];
	}else {
		[self clickToBlacklist:nil];
	}
}

- (void)clickToBlacklist:(id _Nullable)sender {
	NSMutableDictionary *params = [NSMutableDictionary new];
	
	params[@"uid"] = [UserInfoManager shareManager].uid;
	params[@"type"] = @"3";
	params[@"objtype"] = @"6";
	params[@"objid"] = [ToolUtil isEqualToNonNullKong:self.artuid];
 
    [ApiUtil postWithParent:self url:[ApiUtilHeader collectObject] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        NSString *keyword = nil;
        if (_userModel.userData.is_blacklist) {
            keyword = @"已移除黑名单";
        }else {
            keyword = @"已拉入黑名单";
        }
        [SVProgressHUD showSuccess:keyword];
        _userModel.userData.is_blacklist = !_userModel.userData.is_blacklist;
        _userModel.userData.is_collect = NO;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:(UITableViewRowAnimationAutomatic)];
        [self updateNaviData];
    } fail:nil];
}

#pragma mark -
- (void)getData:(id)sender {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_t group = dispatch_group_create();
    
    /// 获取页面信息
    dispatch_group_async(group, queue, ^{
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setObject:[UserInfoManager shareManager].uid forKey:@"uid"];
        [param setObject:self.artuid forKey:@"artuid"];
        
        dispatch_group_enter(group);
        [ApiUtil postWithParent:self url:[ApiUtilHeader getOtherUserInfo] params:param.copy success:^(NSInteger code, id  _Nullable response) {
            
            if (!_userModel) _userModel = [CustomPersonalModel new];
            _userModel = [CustomPersonalModel yy_modelWithJSON:[response objectForKey:@"data"]];
            dispatch_group_leave(group);
        } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
            dispatch_group_leave(group);
        }];
    });
    if (![StringWithFormat(self.artuid) isEqualToString:[UserInfoManager shareManager].uid]) {
        /// 获取约见信息
        dispatch_group_async(group, queue, ^{
            NSMutableDictionary *param = [NSMutableDictionary new];
            [param setObject:[UserInfoManager shareManager].uid forKey:@"memberId"];
            [param setObject:self.artuid forKey:@"artistId"];
            
            dispatch_group_enter(group);
            [ApiUtil postWithParent:self url:[ApiUtilHeader getArtTeaStatus] needHUD:NO params:param success:^(NSInteger code, id  _Nullable response) {
                NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
                
                _updatetime = StringWithFormat([data objectForKey:@"updateTime"]);
                _orderBtnStatus = StringWithFormat([data objectForKey:@"showStatus"]);
                _teaAboutOrderId = StringWithFormat([data objectForKey:@"teaAboutOrderId"]);
                dispatch_group_leave(group);
            } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
                dispatch_group_leave(group);
            }];
        });
    }
    
    dispatch_group_notify(group, queue, ^{
        _userModel.userData.updatetime = _updatetime;
        _userModel.userData.orderBtnStatus = _orderBtnStatus.integerValue;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_userModel.userData.utype.integerValue == 3) {
                [self.navigationItem setTitle:@"艺术家简介"];
                self.contentChildArray = [self getContentChildArray].mutableCopy;
            }else {
                [self.navigationItem setTitle:@"个人简介"];
                NSString *videoTitle = [NSString stringWithFormat:@"视频%@",[ToolUtil isEqualToNonNull:_userModel.videoDataCount replace:@"0"]];
                NSString *likeTitle = [NSString stringWithFormat:@"喜欢%@",[ToolUtil isEqualToNonNull:_userModel.collectDataCount replace:@"0"]];
                self.contentTitleArray = @[videoTitle, likeTitle].mutableCopy;
            }
            [self.tableView reloadData];
            self.contentCarrier.defaultIndex = self.contentCarrier.curIndex;
            [self.contentCarrier reloadData];
            [self updateNaviData];
        });
    });
}

- (void)updateNaviData {
    if (!self.navigationItem.title) {
        [self.navigationItem setTitle:[ToolUtil isEqualToNonNullKong:_userModel.userData.username]];
    }
    self.navigationItem.rightBarButtonItem = nil;
    if (![ToolUtil isEqualOwner:_userModel.userData.id] && !_userModel.userData.is_blacklist) {
        self.navigationItem.rightBarButtonItem = [self rightItemBtn];
    }
}

- (UIBarButtonItem *)rightItemBtn {
    AMButton *rightItemBtn = [AMButton buttonWithType:UIButtonTypeCustom];
    BOOL isCollected = _userModel.userData.is_collect;
    [rightItemBtn setTitle:isCollected?@"已关注":@"+关注" forState:UIControlStateNormal];
    [rightItemBtn setTitleColor:isCollected?RGB(122,129,153):Color_Black forState:UIControlStateNormal];
    rightItemBtn.titleLabel.font = [UIFont addHanSanSC:16.0f fontType:0];
    [rightItemBtn addTarget:self action:@selector(clickToFollow:) forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:rightItemBtn];
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
