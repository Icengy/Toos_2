//
//  UserListViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/22.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "UserListViewController.h"

#import "TYTabButtonPagerController.h"
#import "UserListDetailViewController.h"

@interface UserListViewController () <TYPagerControllerDataSource>
@property (strong, nonatomic) TYTabButtonPagerController *contentView;

@property (nonatomic ,strong) NSMutableArray *contentChildArray;
@property (nonatomic ,strong) NSMutableArray *contentTitleArray;

@end

@implementation UserListViewController {
	BOOL _hadScroll;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	_hadScroll = NO;
	_contentChildArray = [NSMutableArray arrayWithArray:[self getContentChildArray]];
	_contentTitleArray = [NSMutableArray arrayWithArray:[self getContentTitleArray]];
	
	[self addChildViewController:self.contentView];
	[self.view addSubview:self.contentView.view];
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
    
	[self.navigationItem setTitle:[ToolUtil isEqualToNonNullKong:[UserInfoManager shareManager].model.username]];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
//	if (!_hadScroll && self.detailType) {
//		_hadScroll = YES;
//		[self.contentView moveToControllerAtIndex:self.detailType animated:YES];
//	}
	[self loadData:nil];
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	[self.contentView.view mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view.mas_top).offset(StatusNav_Height);
		make.left.right.bottom.equalTo(self.view);
	}];
}

#pragma mark -
- (NSArray *)getContentChildArray {
	UserListDetailViewController *followVC = [[UserListDetailViewController alloc] init];
	followVC.detailType = 0;
	
	UserListDetailViewController *fansVC = [[UserListDetailViewController alloc] init];
	fansVC.detailType = 1;
	
	return @[followVC, fansVC];
}

- (NSArray *)getContentTitleArray {
	return @[@"关注0", @"粉丝0"];
}

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
- (TYTabButtonPagerController *)contentView {
	if (!_contentView) {
		_contentView = [[TYTabButtonPagerController alloc] init];
		_contentView.dataSource = self;
		_contentView.barStyle = TYPagerBarStyleProgressView;
		_contentView.contentTopEdging = NavBar_Height;
		_contentView.collectionLayoutEdging = ADAptationMargin;
		_contentView.cellWidth = (K_Width - ADAptationMargin*(_contentChildArray.count + 1))/_contentChildArray.count;
		_contentView.cellSpacing = ADAptationMargin;
		_contentView.progressHeight = 3;
		_contentView.normalTextFont = [UIFont addHanSanSC:16.0f fontType:0];
		_contentView.selectedTextFont = [UIFont addHanSanSC:16.0f fontType:1];
		_contentView.progressColor = Color_MainBg;
		_contentView.normalTextColor = RGB(135, 138, 153);
		_contentView.selectedTextColor = Color_Black;
        _contentView.defaultIndex = _detailType;
		
	} return _contentView;
}

#pragma mark -
- (void)loadData:(id _Nullable)sender {
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"uid"] = [UserInfoManager shareManager].uid;
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader getCollFansCount] needHUD:NO params:params.copy success:^(NSInteger code, id  _Nullable response) {
        NSDictionary *dict = (NSDictionary *)response[@"data"];
        NSString *followTitle = [NSString stringWithFormat:@"关注%@",[ToolUtil isEqualToNonNull:dict[@"followcount"] replace:@"0"]];
        NSString *fansTitle = [NSString stringWithFormat:@"粉丝%@",[ToolUtil isEqualToNonNull:dict[@"fanscount"] replace:@"0"]];
        _contentTitleArray = [NSMutableArray arrayWithArray:@[followTitle, fansTitle]];
        [_contentView.collectionViewBar reloadData];
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
