//
//  MyOrderViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/23.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "MyOrderViewController.h"

#import "TYTabButtonPagerController.h"

#import "MyBuyViewController.h"
#import "MySellViewController.h"

#import "PersonalListTitleView.h"

@interface MyOrderViewController () <TYPagerControllerDataSource, TYTabPagerControllerDelegate>
@property (strong, nonatomic) TYTabButtonPagerController *contentView;
@property (nonatomic ,strong) NSMutableArray *contentChildArray;
@property (nonatomic ,strong) NSMutableArray *contentTitleArray;

@property (nonatomic ,strong) PersonalListTitleView *headerView;
@property (nonatomic ,assign) NSInteger currentIndex;
@property (nonatomic ,strong) NSMutableArray *badgeArray;

@end

@implementation MyOrderViewController

- (PersonalListTitleView *)headerView {
    if (_headerView) return _headerView;
    _headerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PersonalListTitleView class]) owner:nil options:nil].lastObject;
    _headerView.frame = CGRectMake(0, 0, K_Width, 44.0f);
    _headerView.dataArray = _contentTitleArray.copy;
    _headerView.badges = _badgeArray.copy;
    @weakify(self);
    _headerView.clickIndexBlock = ^(NSInteger index) {
        @strongify(self);
        self.currentIndex = index;
        [self.contentView moveToControllerAtIndex:self.currentIndex animated:YES];
    };
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
    _contentChildArray = [self getContentChildArray].mutableCopy;
	
	if ([UserInfoManager shareManager].isArtist) {
        _badgeArray = @[@"0", @"0"].mutableCopy;
        NSDictionary *unreadInfo = AMUserDefaultsObjectForKey(AMUserMsg);
        if ([unreadInfo objectForKey:@"buyerUntreatedNum"]) {
            [_badgeArray replaceObjectAtIndex:0 withObject:[ToolUtil isEqualToNonNull:unreadInfo[@"buyerUntreatedNum"] replace:@"0"]];
        }
        if ([unreadInfo objectForKey:@"sellerUntreatedNum"]) {
            [_badgeArray replaceObjectAtIndex:1 withObject:[ToolUtil isEqualToNonNull:unreadInfo[@"sellerUntreatedNum"] replace:@"0"]];
        }
        
		_contentTitleArray = [NSMutableArray arrayWithArray:[self getContentTitleArray]];
        
		[self addChildViewController:self.contentView];
		[self.view addSubview:self.contentView.view];
        
        [self.view insertSubview:self.headerView aboveSubview:self.contentView.view];
        self.headerView.badges = _badgeArray.copy;
        
        [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(StatusNav_Height);
            make.left.right.equalTo(self.view);
            make.height.offset(44.0f);
        }];
        [self.contentView.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.top.equalTo(self.headerView.mas_bottom);
        }];
	}else {
		MyBuyViewController *buyVC = (MyBuyViewController *)_contentChildArray.firstObject;
		[self addChildViewController:buyVC];
		[self.view addSubview:buyVC.view];
        
        [buyVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(StatusNav_Height);
            make.left.right.equalTo(self.view);
            make.height.offset(K_Height - StatusNav_Height);
        }];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self.navigationItem setTitle:@"我的订单"];
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

- (void)pagerController:(TYTabPagerController *)pagerController didScrollToTabPageIndex:(NSInteger)index {
    NSLog(@"didScrollToTabPageIndex - %@",@(index));
    self.currentIndex = index;
    self.headerView.currentIndex = self.currentIndex;
}

#pragma mark -
- (NSArray *)getContentChildArray {
	MyBuyViewController *buyVC = [[MyBuyViewController alloc] init];
	MySellViewController *sellVC = [[MySellViewController alloc] init];
	
	return @[buyVC, sellVC];
}

- (NSArray *)getContentTitleArray {
	return @[@"我买到的", @"我卖出的"];
}

- (TYTabButtonPagerController *)contentView {
    if (!_contentView) {
        _contentView = [[TYTabButtonPagerController alloc] init];
        _contentView.contentTopEdging = 0.0f;
        _contentView.delegate = self;
        _contentView.dataSource = self;
        
    } return _contentView;
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
