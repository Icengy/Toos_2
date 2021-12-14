//
//  HK_TeaMeetingRecordVC.m
//  ArtMedia2
//
//  Created by guohongkai on 2020/8/13.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "HK_TeaMeetingRecordVC.h"

#import "TYTabButtonPagerController.h"

#import "HK_TeaChildVC.h"
@interface HK_TeaMeetingRecordVC ()<TYPagerControllerDataSource>
@property (strong, nonatomic)NSArray<NSString *> *titles;
@property (strong, nonatomic)NSArray *childVC;

@property (strong, nonatomic) TYTabButtonPagerController *contentView;
@end

@implementation HK_TeaMeetingRecordVC

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
        
    } return _contentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    self.navigationItem.title = @"会客记录";
    
    [self createChildVC];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)createChildVC{
    self.titles = @[
                    @"全部",
                    @"待开始",@"进行中",@"已结束",@"已取消"
                    ];
    self.childVC = [self setupChildVcAndTitle];
    [self addChildViewController:self.contentView];
    [self.view addSubview:self.contentView.view];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.contentView.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(StatusNav_Height);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (NSArray *)setupChildVcAndTitle {
    NSMutableArray *childVcs = @[].mutableCopy;
    [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HK_TeaChildVC *childVC = [[HK_TeaChildVC alloc] init];
        childVC.Status_type = idx;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
