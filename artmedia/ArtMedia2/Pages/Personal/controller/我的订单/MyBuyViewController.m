//
//  MyBuyViewController.m
//  ArtMedia
//
//  Created by 美术传媒 on 2018/10/27.
//  Copyright © 2018 lcy. All rights reserved.
//

#import "MyBuyViewController.h"

#import "TYTabButtonPagerController.h"
#import "MyOrderListViewController.h"
#import "UIViewController+BackButtonHandler.h"

@interface MyBuyViewController () <TYPagerControllerDataSource, BackButtonHandlerProtocol>

@property (strong, nonatomic) TYTabButtonPagerController *contentView;
@property (nonatomic ,strong) NSMutableArray *contentChildArray;
@property (nonatomic ,strong) NSMutableArray *contentTitleArray;

@end

@implementation MyBuyViewController {
	MyOrderWayType _wayType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的订单";
	_wayType = MyOrderWayTypeBuyed;
    
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

	
	_contentChildArray = [NSMutableArray arrayWithArray:[self getContentChildArray]];
	_contentTitleArray = [NSMutableArray arrayWithArray:[self getContentTitleArray]];
	
	[self addChildViewController:self.contentView];
	[self.view addSubview:self.contentView.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
    [self.contentView.view mas_makeConstraints:^(MASConstraintMaker *make) {
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

#pragma mark - TYPagerControllerDataSource
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
- (NSArray *)getContentChildArray {
	NSMutableArray *array = [NSMutableArray array];
	for (NSInteger i = 1; i < 7; i ++) {
		MyOrderListViewController *listVC = [[MyOrderListViewController alloc] init];
		listVC.wayType = _wayType;
		listVC.itemType = i;
		[array insertObject:listVC atIndex:array.count];
	}
	return (NSArray *)[array copy];
}

- (NSArray *)getContentTitleArray {
	return @[@"全部", @"待付款", @"待发货", @"待收货", @"已完成", @"退货退款"];
}

- (TYTabButtonPagerController *)contentView {
	if (!_contentView) {
		_contentView = [[TYTabButtonPagerController alloc] init];
		_contentView.pagerBarView.backgroundColor = RGB(242, 242, 242);
		_contentView.dataSource = self;
		_contentView.barStyle = TYPagerBarStyleCoverView;
		_contentView.contentTopEdging = NavBar_Height;
		_contentView.collectionLayoutEdging = ADAptationMargin;
		
		_contentView.cellWidth = K_Width/_contentChildArray.count;
		_contentView.cellSpacing = ADAptationMargin;

		_contentView.normalTextFont = [UIFont addHanSanSC:15.0f fontType:0];
		_contentView.selectedTextFont = [UIFont addHanSanSC:15.0f fontType:0];
		_contentView.progressColor = RGB(230, 230, 230);
		_contentView.normalTextColor = RGB(135, 138, 153);
		_contentView.selectedTextColor = Color_Black;
        _contentView.defaultIndex = self.pageIndex;
		
	} return _contentView;
}



@end
