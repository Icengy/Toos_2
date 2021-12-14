//
//  AMAuctionOrderViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/11/13.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMAuctionOrderViewController.h"

#import "AMAuctionOrderListViewController.h"
#import "UIViewController+BackButtonHandler.h"

@interface AMAuctionOrderViewController () <BackButtonHandlerProtocol>

@end

@implementation AMAuctionOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    
    if (self.needBackHome) {
        // 设置代理
        id target = self.navigationController.interactivePopGestureRecognizer.delegate;
        // 创建手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
        // 添加手势
        [self.view addGestureRecognizer:pan];
        // 将系统自带的手势覆盖掉
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    self.contentChildArray = [self getContentChildArray].mutableCopy;
    
    self.contentCarrier.pagerBarView.backgroundColor = self.view.backgroundColor;
    self.contentCarrier.barStyle = TYPagerBarStyleProgressView;
    self.contentCarrier.contentTopEdging = NavBar_Height;
    self.contentCarrier.collectionLayoutEdging = ADAptationMargin*2;
    
    self.contentCarrier.cellWidth = K_Width/self.contentChildArray.count;
    self.contentCarrier.cellSpacing = ADAptationMargin;
    self.contentCarrier.progressHeight = 2.0;
    self.contentCarrier.progressWidth = (K_Width/self.contentChildArray.count)/3;
    
    self.contentCarrier.normalTextFont = [UIFont addHanSanSC:14.0f fontType:0];
    self.contentCarrier.selectedTextFont = [UIFont addHanSanSC:14.0f fontType:0];
    self.contentCarrier.progressColor = Color_MainBg;
    self.contentCarrier.normalTextColor = RGB(122, 129, 153);
    self.contentCarrier.selectedTextColor = UIColorFromRGB(0xE05227);
    self.contentCarrier.customShadowColor = UIColor.clearColor;
    self.contentCarrier.defaultIndex = self.pageIndex;
    
    self.contentCarrier.pagerBarColor = [UIColor clearColor];
    
    self.contentCarrier.dataSource = self;
    [self addChildViewController:self.contentCarrier];
    [self.view addSubview:self.contentCarrier.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"拍卖订单";
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.contentCarrier.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(StatusNav_Height);
    }];
}

#pragma mark -
- (void)handleNavigationTransition:(UIPanGestureRecognizer *)recognizer {
    [self clickToBack];
}

- (BOOL)navigationShouldPopOnBackButton {
    [self clickToBack];
    return NO;
}

- (void)clickToBack {
    if (self.needBackHome) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -
- (NSArray *)getContentChildArray {
    self.contentTitleArray = [self getContentTitleArray].mutableCopy;
    NSMutableArray *customArray = [NSMutableArray new];
    for (int i = 0; i < self.contentTitleArray.count; i ++) {
        AMAuctionOrderListViewController *listVC = [[AMAuctionOrderListViewController alloc] init];
        listVC.style = i;
        [customArray addObject:listVC];
    }
    return customArray.copy;
}

- (NSArray *)getContentTitleArray {
    return @[@"全部", @"待支付", @"待发货", @"已发货", @"已收货"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
