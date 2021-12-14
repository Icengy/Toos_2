//
//  HK_Tea_ManagerVC.m
//  ArtMedia2
//
//  Created by guohongkai on 2020/8/19.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "HK_Tea_ManagerVC.h"

#import "TYTabButtonPagerController.h"
#import "AMMeetingCreateViewController.h"
#import "AMMeetingSettingViewController.h"

#import "AMMeetingManagerChildViewController.h"

#import "AMAlertView.h"

@interface HK_Tea_ManagerVC ()<TYPagerControllerDataSource>
@property (strong, nonatomic)NSArray<NSString *> *titles;
@property (strong, nonatomic)NSArray *childVC;

@property (strong, nonatomic) TYTabButtonPagerController *contentView;
@end

@implementation HK_Tea_ManagerVC

- (TYTabButtonPagerController *)contentView {
    if (!_contentView) {
        _contentView = [[TYTabButtonPagerController alloc] init];
        _contentView.dataSource = self;
        _contentView.barStyle = TYPagerBarStyleProgressView;
        _contentView.contentTopEdging = NavBar_Height;
        _contentView.collectionLayoutEdging = ADAptationMargin;
        _contentView.cellWidth = (K_Width - ADAptationMargin*(self.childVC.count + 1))/self.childVC.count;
        _contentView.cellSpacing = ADAptationMargin;
        _contentView.progressHeight = 3;
        _contentView.normalTextFont = [UIFont addHanSanSC:14.0f fontType:0];
        _contentView.selectedTextFont = [UIFont addHanSanSC:14.0f fontType:0];
        _contentView.progressColor = Color_MainBg;
        _contentView.normalTextColor = UIColorFromRGB(0x999999);
        _contentView.selectedTextColor = Color_Black;
        _contentView.defaultIndex = self.pageIndex;
        
    } return _contentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    [self createChildVC];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationItem.title = @"会客管理";
    
    AMButton *addNew = [AMButton buttonWithType:UIButtonTypeCustom];
    [addNew setTitle:@"新建会客" forState:UIControlStateNormal];
    [addNew setTitleColor:UIColorFromRGB(0xE22020) forState:UIControlStateNormal];
    addNew.titleLabel.font = [UIFont addHanSanSC:13.0 fontType:0];
    
    [addNew addTarget:self action:@selector(addNewMeeting:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addNew];
}

- (void)createChildVC {
    self.titles = @[
                    @"全部",
                    @"待开始",@"进行中",@"已结束",@"已取消"
                    ];
    
    self.childVC = [self setupChildVcAndTitle];
    [self addChildViewController:self.contentView];
    [self.view addSubview:self.contentView.view];
    
    [self.contentView.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(StatusNav_Height);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (NSArray *)setupChildVcAndTitle {
    NSMutableArray *childVcs = @[].mutableCopy;
    [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AMMeetingManagerChildViewController *childVC = [[AMMeetingManagerChildViewController alloc] init];
        childVC.managerStatus = idx;
        [childVcs addObject:childVC];
    }];
    
    return childVcs.copy;
}
#pragma mark -- TYPagerController
- (NSInteger)numberOfControllersInPagerController {
    return self.childVC.count;
}

- (NSString *)pagerController:(TYPagerController *)pagerController titleForIndex:(NSInteger)index {
    return self.titles[index];
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index {
    return self.childVC[index];
}

- (void)addNewMeeting:(id)sender {
    [ApiUtil postWithParent:self url:[ApiUtilHeader canNewTea] params:@{@"artistId":[UserInfoManager shareManager].uid} success:^(NSInteger code, id  _Nullable response) {
        [self.navigationController pushViewController:[[AMMeetingCreateViewController alloc] init] animated:YES];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        if (errorCode == 466) {// 人数不足
            AMMeetingNewAlertView *alertView = [AMMeetingNewAlertView shareInstance];
            alertView.titleStr = errorMsg;
            alertView.type = AMMeetingNewAlertViewTypeUnderstaffed;
            [alertView show];
            
        }else if (errorCode == 455) {
            AMMeetingNewAlertView *alertView = [AMMeetingNewAlertView shareInstance];
            alertView.titleStr = errorMsg;
            alertView.type = AMMeetingNewAlertViewTypeNotOpen;
            @weakify(self);
            alertView.confirmBlock = ^{
                @strongify(self);
                [self.navigationController pushViewController:[[AMMeetingSettingViewController alloc] init] animated:YES];
            };
            [alertView show];
            
        }else [SVProgressHUD showError:errorMsg];
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
