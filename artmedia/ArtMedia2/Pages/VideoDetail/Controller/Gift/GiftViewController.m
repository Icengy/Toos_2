//
//  GiftViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/26.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "GiftViewController.h"

#import "TYTabButtonPagerController.h"

#import "GiftPresentViewController.h"
#import "GiftListViewController.h"

#import "GiftHeaderView.h"

#import "VideoListModel.h"

@interface GiftViewController () <TYPagerControllerDataSource ,UIGestureRecognizerDelegate>

//@property(nonatomic, strong) GiftHeaderView *headerView;

@property (strong, nonatomic) TYTabButtonPagerController *contentView;
@property (nonatomic ,strong) NSMutableArray *contentChildArray;
@property (nonatomic ,strong) NSMutableArray *contentTitleArray;

@property (nonatomic ,strong) UILabel *totalContentLabel;
@property (nonatomic ,strong) AMButton *backBtn;
@end

@implementation GiftViewController {
	CGFloat _contentHeight;
}

#pragma mark -
- (instancetype)initWithModel:(VideoListModel *)model {
	if (self = [super init]) {
		self.view.alpha = 0.01;
		self.model = model;
		
		[self initSubViews];
	}return self;
}

//- (GiftHeaderView *)headerView {
//	if (!_headerView) {
//		_headerView = [GiftHeaderView shareInstance];
//		_headerView.model = self.model;
//	}return _headerView;
//}

- (void)initSubViews {
	
//	[self.view addSubview:self.headerView];
	
	_contentChildArray = [NSMutableArray arrayWithArray:[self getContentChildArray]];
		//添加主视图
	_contentTitleArray = [NSMutableArray arrayWithArray:[self getContentTitleArray]];
	
	[self addChildViewController:self.contentView];
	[self.view addSubview:self.contentView.view];
	
	if (![ToolUtil isEqualOwner:self.model.uid]) {
		[self.view insertSubview:self.totalContentLabel aboveSubview:self.contentView.view];
	}else {
		[self.view insertSubview:self.backBtn aboveSubview:self.contentView.view];
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = UIColor.clearColor;
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideEnterance)];
	tap.delegate = self;
	[self.view addGestureRecognizer:tap];
    
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	//禁用右滑返回手势
	id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
	UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:traget action:nil];
	[self.view addGestureRecognizer:pan];
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	_contentHeight = ADBottomButtonHeight *3 + ADAptationMargin*2 + 15.0f*2 + 50.0f;
    [self.contentView.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.offset(NavBar_Height + _contentHeight + SafeAreaBottomHeight);
    }];
	if (![ToolUtil isEqualOwner:self.model.uid]) {
        [self.totalContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(NavBar_Height);
            make.width.offset(K_Width/2-ADAptationMargin);
            make.top.equalTo(self.contentView.view);
            make.right.equalTo(self.view.mas_right).offset(-ADAptationMargin);
        }];
	}else {
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.contentView.view);
            make.height.width.offset(NavBar_Height);
        }];
	}
	
//	[self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
//		make.bottom.equalTo(self.contentView.view.mas_top);
//		make.centerX.equalTo(self.view);
//		make.size.sizeOffset(self.headerView.size);
//	}];
}

- (void)setModel:(VideoListModel *)model {
	_model = model;
	[_contentChildArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if (idx) {
			[(GiftListViewController *)obj setModel:_model];
		}else {
			[(GiftPresentViewController *)obj setModel:_model];
		}
	}];
	NSLog(@"_model.myrewardnum = %@",_model.myrewardnum);
	self.totalContentLabel.attributedText = [self getCountLabelAttribute:[NSString stringWithFormat:@"已支持%@朵",[ToolUtil isEqualToNonNull:_model.myrewardnum replace:@"0"]]];
}

- (void)clickToBack:(id)sender {
	[self hideEnterance];
}

- (void)showEnterance:(UIViewController *_Nullable)viewControllerr {
	[viewControllerr addChildViewController:self];
	[viewControllerr.view addSubview:self.view];
	self.view.frame = [UIApplication sharedApplication].keyWindow.bounds;
	[UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^ {
		self.view.alpha = 1.0;
		NSLog(@"in animate start");
	} completion:^(BOOL finished) {
		NSLog(@"in animate completion");
	}];
}

- (void)hideEnterance:(void (^ __nullable)(void))completion {
	if (self.view.hidden == NO) {
		self.view.alpha = 1.0;
		[UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^ {
			self.view.alpha = 0.01;
			NSLog(@"out animate start");
		}completion:^(BOOL finished) {
			NSLog(@"out animate completion");
			self.view.hidden = YES;
			[self.view removeFromSuperview];
			if (completion) completion();
		}];
	}
}

- (void)hideEnterance {
	[self hideEnterance:nil];
}

#pragma mark -
- (NSArray *)getContentChildArray {
	GiftPresentViewController *presentVC = [[GiftPresentViewController alloc] init];
	presentVC.model = _model;
	@weakify(self);
	presentVC.paySuccessForGift = ^(NSInteger giftNum) {
		@strongify(self);
		[self hideEnterance:^{
			if (_paySuccessForGift) _paySuccessForGift(giftNum);
		}];
	};
    presentVC.payFailForGift = ^{
        @strongify(self);
        [self hideEnterance:^{
            if (_payFailForGift) _payFailForGift();
        }];
    };
	
	GiftListViewController *listVC = [[GiftListViewController alloc] init];
	listVC.model = _model;
	
	if ([ToolUtil isEqualOwner:self.model.uid]) {
		return @[listVC];
	}
	return @[presentVC ,listVC];
}

- (NSArray *)getContentTitleArray {
	if ([ToolUtil isEqualOwner:self.model.uid]) {
		return @[ @"礼物排行"];
	}
	return @[@"礼物", @"排行"];
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

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//	if ([touch.view isDescendantOfView:self.contentView.view] || [touch.view isDescendantOfView:self.headerView]) {
    if ([touch.view isDescendantOfView:self.contentView.view]) {
		return NO;
	}
	return YES;
}

#pragma mark -
- (TYTabButtonPagerController *)contentView {
	if (!_contentView) {
		_contentView = [[TYTabButtonPagerController alloc] init];
		_contentView.dataSource = self;
		_contentView.barStyle = TYPagerBarStyleNoneView;
        _contentView.customShadowColor = RGB(51, 42, 46);
		_contentView.contentTopEdging = NavBar_Height;
		_contentView.collectionLayoutEdging = ADAptationMargin;
		_contentView.cellSpacing = ADAptationMargin;
		if ([ToolUtil isEqualOwner:self.model.uid]) {
			_contentView.progressHeight = 0.0f;
			_contentView.cellWidth = K_Width;
		}else {
			_contentView.cellWidth = (K_Width/2 - 30.f*(_contentChildArray.count + 1))/_contentChildArray.count;
			_contentView.progressHeight = 3.0f;
		}
		_contentView.normalTextFont = [UIFont addHanSanSC:18.0f fontType:0];
		_contentView.selectedTextFont = [UIFont addHanSanSC:18.0f fontType:0];
        _contentView.normalTextColor = RGBA(233, 80, 80, 0.3);
		_contentView.selectedTextColor = RGB(233, 80, 80);
        
        _contentView.pagerBarColor = [UIColor clearColor];
        _contentView.collectionViewBarColor = [UIColor clearColor];
        
        _contentView.view.backgroundColor = [RGB(0, 0, 0) colorWithAlphaComponent:0.9];
        
	} return _contentView;
}

- (UILabel *)totalContentLabel {
	if (!_totalContentLabel) {
		_totalContentLabel = [[UILabel alloc] init];
		
		_totalContentLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
		_totalContentLabel.textAlignment = NSTextAlignmentRight;
		_totalContentLabel.textColor = RGB(233, 80, 80);
		_totalContentLabel.text = @"已支持0朵";
		
	}return _totalContentLabel;
}

- (AMButton *)backBtn {
	if (!_backBtn) {
		_backBtn = [AMButton buttonWithType:UIButtonTypeCustom];
		
		[_backBtn setImage:ImageNamed(@"left_aw") forState:UIControlStateNormal];
		[_backBtn addTarget:self action:@selector(clickToBack:) forControlEvents:UIControlEventTouchUpInside];
		
	}return _backBtn;
}

#pragma mark - private
- (NSMutableAttributedString *)getCountLabelAttribute:(NSString *)string {
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"([0-9]\\d*\\.?\\d*)" options:0 error:NULL];
    
    NSArray<NSTextCheckingResult *> *ranges = [regular matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:string];
    
    for (int i = 0; i < ranges.count; i++) {
        [attStr setAttributes:@{NSForegroundColorAttributeName : Color_Whiter} range:ranges[i].range];
    }
    return attStr;
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
