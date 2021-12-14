//
//  HomeBaseViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/12.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "HomeBaseViewController.h"

#import "TYTabButtonPagerController.h"

#import "HomeNormalViewController.h"
#import "LivingRoomMainViewController.h"
#import "HomeInformationViewController.h"
#import "HomeCourseListViewController.h"
#import "HomeAuctionListController.h"

#import "SearchViewController.h"
#import "MessageViewController.h"

#import "AMEmptyView.h"

#import "MessageCountModel.h"

//测试直播用
#import "AMLivePushViewController.h"
#import "LiveRoomListViewController.h"

@interface HomeBaseViewController () <TYPagerControllerDataSource>

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *contentCarrier;

@property (strong, nonatomic) TYTabButtonPagerController *contentView;
@property (nonatomic ,strong) NSMutableArray *contentChildArray;
@property (nonatomic ,strong) NSMutableArray *contentTitleArray;

@property (nonatomic ,weak) IBOutlet SearchButton *searchBtn;
@property (nonatomic ,strong) NSMutableArray *recordArray;
@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet AMBadgePointButton *messageButton;

@end

@implementation HomeBaseViewController {
    NSString *_currentTitle;
    MessageCountModel *_countModel;
}

- (TYTabButtonPagerController *)contentView {
    if (!_contentView) {
        _contentView = [[TYTabButtonPagerController alloc] init];
        _contentView.dataSource = self;
        _contentView.barStyle = TYPagerBarStyleProgressView;
        _contentView.contentTopEdging = NavBar_Height;
        _contentView.collectionLayoutEdging = ADAptationMargin*2;
        _contentView.cellSpacing = ADAptationMargin*2;
        _contentView.progressHeight = 3;
        _contentView.normalTextFont = [UIFont addHanSanSC:14.0f fontType:0];
        _contentView.selectedTextFont = [UIFont addHanSanSC:14.0f fontType:2];
        _contentView.progressColor = Color_MainBg;
        _contentView.normalTextColor = RGB(122, 129, 153);
        _contentView.selectedTextColor = UIColorFromRGB(0xE05227);
        _contentView.defaultIndex = 1;
        
    } return _contentView;
}

#pragma mark -
- (void)viewDidLoad {
    NSLog(@"%f %f",K_Width , K_Height);
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToClass) name:@"ChangeToClassList" object:nil];
    // Do any additional setup after loading the view.
    
    _headerHeightConstraint.constant = StatusNav_Height;
    
    _recordArray = [NSMutableArray new];
    _dataArray = [NSMutableArray new];
    //添加主视图
    _contentChildArray = [self getContentChildArray].mutableCopy;
    
    [self addChildViewController:self.contentView];
    [self.view addSubview:self.contentView.view];
    
//    self.view.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self imageStr:@"video_list_null_img" action:@selector(loadData:)];
//    [self.view ly_hideEmptyView];
    
    self.messageButton.badgeView.hidden = YES;
    self.searchBtn.titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if (![UserInfoManager shareManager].isLogin && self.contentView.curIndex == 0) {
        [self.contentView moveToControllerAtIndex:1 animated:YES];
    }
    
//    [self loadBadge];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickToReloadList:) name:AMHomeUpdatesDefaults object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AMHomeUpdatesDefaults object:nil];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.contentView.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.width.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-SafeAreaBottomHeight);
    }];
}

#pragma mark - 滚动到名家课堂
- (void)scrollToClass {
    [self.contentView moveToControllerAtIndex:4 animated:YES];
}

- (void)clickToReloadList:(NSNotification *)notification {
    BaseViewController *currentVC  = [_contentChildArray objectAtIndex:self.contentView.curIndex];
    if (currentVC && [currentVC respondsToSelector:@selector(reloadCurrent:)])
        [currentVC reloadCurrent:notification];
}

#pragma mark -
- (NSArray *)getContentChildArray {
    _contentTitleArray = [self getContentTitleArray].mutableCopy;
    
    NSMutableArray *childArray = @[].mutableCopy;
    [_contentTitleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 4) {//直播课
            HomeCourseListViewController *courseList = [[HomeCourseListViewController alloc] init];
            [childArray addObject:courseList];
        }else if (idx == 3) {// 拍卖
            HomeAuctionListController *courseList = [[HomeAuctionListController alloc] init];
            [childArray addObject:courseList];
        }else if (idx == 2) {//会客厅
            LivingRoomMainViewController * vc = [[LivingRoomMainViewController alloc] init];
            [childArray addObject:vc];
        }else{
            HomeNormalViewController *homeNormal = [[HomeNormalViewController alloc] init];
            if (idx == 0) {/// 关注
                homeNormal.listType = -2;
            }else if (idx == 1) {///推荐
                homeNormal.listType = -1;
                @weakify(self);
                homeNormal.clickToMoveBlock = ^(NSInteger index) {
                    @strongify(self);
                    [self.contentView moveToControllerAtIndex:index animated:YES];
                };
            }else {//废弃
                homeNormal.listType = 0;
            }
            [childArray addObject:homeNormal];
        }
    }];
    return childArray.copy;
}

- (NSArray *)getContentTitleArray {
    /// -2, -1, 0, 2, 3, 4
//    return @[@"关注", @"推荐", @"会客厅",@"名家课堂", @"创作视频" ];
//    return @[@"关注", @"推荐", @"会客厅",@"拍卖专场",@"名家课堂", @"创作视频" ];
    
    return @[@"关注", @"推荐", @"会客厅",@"拍卖专场",@"名家课堂"];
    
//    return @[@"关注", @"推荐", @"会客厅",@"名家课堂"];
}

#pragma mark -
- (IBAction)clickToSearch:(id)sender {
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    searchVC.keyword = _currentTitle;
//    searchVC.recordArray = _recordArray;
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (IBAction)clickToMessage:(id)sender {
    if ([UserInfoManager shareManager].isLogin) {

        MessageViewController * vc = [[MessageViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
//        LiveRoomListViewController *vc = [[LiveRoomListViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];

    }else{
        [self jumpToLoginWithBlock:nil];
    }
}

#pragma mark -
#pragma mark -- TYPagerControllerDataSource
- (NSInteger)numberOfControllersInPagerController {
    return _contentChildArray.count;
}

- (NSString *)pagerController:(TYPagerController *)pagerController titleForIndex:(NSInteger)index {
    return _contentTitleArray[index];
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index {
    return _contentChildArray[index];
}


#pragma mark -
- (void)loadBadge {
    [ApiUtil postWithParent:self url:[ApiUtilHeader getUnreadCount] needHUD:NO params:@{@"uid":[UserInfoManager shareManager].uid} success:^(NSInteger code, id  _Nullable response) {
        if (code == 0) {
            NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
            AMUserDefaultsSetObject(data, AMUserMsg);
        }
        _countModel = [MessageCountModel yy_modelWithDictionary:AMUserDefaultsObjectForKey(AMUserMsg)];
        if (_countModel) {
            self.messageButton.badgeView.hidden = !_countModel.all_user_unread_msg.integerValue;
        }else
            self.messageButton.badgeView.hidden = YES;
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        _countModel = [MessageCountModel yy_modelWithDictionary:AMUserDefaultsObjectForKey(AMUserMsg)];
        if (_countModel) {
            self.messageButton.badgeView.hidden = !_countModel.all_user_unread_msg.integerValue;
        }else
            self.messageButton.badgeView.hidden = YES;
    }];
}

- (void)loadData:(id _Nullable)sender {
    [ApiUtil postWithParent:self url:[ApiUtilHeader getInfoTypeList] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response) {
        NSArray *array = (NSArray *)response[@"data"];
        if (array && array.count) {
            if (_dataArray.count) [_dataArray removeAllObjects];
            [_dataArray addObjectsFromArray:array];
            
            if (_contentTitleArray.count) [_contentTitleArray removeAllObjects];
            if (_contentChildArray.count) [_contentChildArray removeAllObjects];
            
            _contentChildArray  = [self getContentChildArray].mutableCopy;
            [self.contentView reloadData];
        }
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {}];
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
