//
//  SearchResultViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/15.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "SearchResultViewController.h"

#import "TYTabButtonPagerController.h"

#import "SearchResultListViewController.h"

@interface SearchResultViewController () <TYPagerControllerDataSource>

@property (strong, nonatomic) TYTabButtonPagerController *contentView;
@property (nonatomic ,strong) NSMutableArray <SearchResultListViewController *>*contentChildArray;
@property (nonatomic ,strong) NSMutableArray *contentTitleArray;

@end

@implementation SearchResultViewController {
	NSInteger _page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	//添加主视图
	_contentChildArray = [NSMutableArray arrayWithArray:[self getContentChildArray]];
	_contentTitleArray = [NSMutableArray arrayWithArray:[self getContentTitleArray]];
	
	[self addChildViewController:self.contentView];
	[self.view addSubview:self.contentView.view];
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	[self.contentView.view mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.offset(0);
	}];
}

- (void)setKeyword:(NSString *)keyword {
	_keyword = keyword;
	
	[_contentChildArray enumerateObjectsUsingBlock:^(SearchResultListViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		obj.keyword = _keyword;
	}];
}

#pragma mark -
- (NSArray <SearchResultListViewController *>*)getContentChildArray {
	SearchResultListViewController *videoList = [[SearchResultListViewController alloc] init];
	videoList.resultType = SearchResultTypeForVideo;
	videoList.keyword = self.keyword;
	
	SearchResultListViewController *personList = [[SearchResultListViewController alloc] init];
	personList.resultType = SearchResultTypeForCustom;
	personList.keyword = self.keyword;
	
	return @[videoList ,personList];
}

- (NSArray *)getContentTitleArray {
	return @[@"视频", @"用户"];
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
- (TYTabButtonPagerController *)contentView {
	if (!_contentView) {
		_contentView = [[TYTabButtonPagerController alloc] init];
		_contentView.dataSource = self;
		_contentView.barStyle = TYPagerBarStyleProgressView;
		_contentView.contentTopEdging = NavBar_Height;
		_contentView.collectionLayoutEdging = ADAptationMargin;
		_contentView.cellWidth = (K_Width - ADAptationMargin*(_contentChildArray.count + 1))/_contentChildArray.count;
		_contentView.cellSpacing = ADAptationMargin;
		_contentView.progressHeight = 2;
        _contentView.progressWidth = K_Width/6;
		_contentView.normalTextFont = [UIFont addHanSanSC:15.0f fontType:0];
		_contentView.selectedTextFont = [UIFont addHanSanSC:15.0f fontType:0];
		_contentView.progressColor = Color_MainBg;
		_contentView.normalTextColor = RGB(157,161,179);
		_contentView.selectedTextColor = RGB(21, 22, 26);
		
		_contentView.pagerBarColor = Color_Whiter;
		_contentView.collectionViewBarColor = Color_Whiter;
		
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
