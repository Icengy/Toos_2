//
//  SearchViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/15.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "SearchViewController.h"

#import "SearchNormalViewController.h"
#import "SearchResultViewController.h"

#import "SearchBarView.h"

@interface SearchViewController () <SearchBarViewDelegate>
@property (nonatomic ,strong) SearchBarView *searchBar;

@property (nonatomic ,strong) SearchNormalViewController *normalViewController;
@property (nonatomic ,strong) SearchResultViewController *resultViewController;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	[self.view addSubview:self.searchBar];
	self.searchBar.delegate = self;
	
	[self addChildViewController:self.normalViewController];
	[self.view addSubview:self.normalViewController.view];
	self.normalViewController.view.hidden = NO;
	@weakify(self);
	self.normalViewController.tagClickBlock = ^(NSString *keyword) {
		NSLog(@"keyword = %@",keyword);
		@strongify(self);
        [self.view endEditing:YES];
        
		self.searchBar.searchText = keyword;
        self.normalViewController.view.hidden = YES;
        self.resultViewController.view.hidden = NO;
		self.resultViewController.keyword = keyword;
	};
	[self addChildViewController:self.resultViewController];
	[self.view addSubview:self.resultViewController.view];
	self.resultViewController.view.hidden = YES;
	
	if (!_recordArray.count) {
		_recordArray = [NSMutableArray new];
	}else {
		self.normalViewController.tagArray = _recordArray;
	}
	self.searchBar.searchText = _keyword;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	//禁止返回
	id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
	UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
	[self.view addGestureRecognizer:pan];
	
	if (!self.normalViewController.view.hidden) {
		[self.searchBar enterFirstResponse];
	}
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	if (!_recordArray.count) {
		[self loadData:nil];
	}
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[self.searchBar endFirstResponse];
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	[self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view.mas_top).offset(StatusBar_Height);
		make.left.right.equalTo(self.view);
		make.height.offset(ADAPTATIONRATIOVALUE(100.0f));
	}];
	[self.normalViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.searchBar.mas_bottom);
		make.left.right.bottom.equalTo(self.view);
	}];
	[self.resultViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.searchBar.mas_bottom);
		make.left.right.bottom.equalTo(self.view);
	}];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[self.view resignFirstResponder];
}

#pragma mark - SearchBarViewDelegate
- (void)searchView:(SearchBarView *)search didClickToCancel:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)searchView:(SearchBarView *)search didClickToHideTag:(BOOL)hidden {
//	[self.normalViewController hideSubView:hidden];
}

- (void)searchView:(SearchBarView *)search didClickToSearch:(NSString *)keyword {
	NSLog(@"didClickToSearch");
	self.normalViewController.view.hidden = YES;
	self.resultViewController.view.hidden = NO;
	self.resultViewController.keyword = keyword;
}

#pragma mark -
- (SearchBarView *)searchBar {
	if (!_searchBar) {
		_searchBar = [SearchBarView shareInstance];
		_searchBar.placeholder = @"";
	}return _searchBar;
}

- (SearchNormalViewController *)normalViewController {
	if (!_normalViewController) {
		_normalViewController = [[SearchNormalViewController alloc] init];
	}return _normalViewController;
}

- (SearchResultViewController *)resultViewController {
	if (!_resultViewController) {
		_resultViewController = [[SearchResultViewController alloc] init];
	}return _resultViewController;
}

#pragma mark -
- (void)loadData:(id)sender {
    [ApiUtil postWithParent:self url:[ApiUtilHeader getSearchRecord] params:nil success:^(NSInteger code, id  _Nullable response) {
        if (_recordArray) [_recordArray removeAllObjects];
        NSArray *recordArray = [[response[@"data"] objectForKey:@"hot_record"] yy_modelToJSONObject];
        if (recordArray && recordArray.count) {
            [recordArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [_recordArray insertObject:obj[@"keyword"] atIndex:_recordArray.count];
            }];
            self.normalViewController.tagArray = _recordArray;
//            self.searchBar.searchText = _recordArray[arc4random()%_recordArray.count];
        }
    } fail:nil];
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
