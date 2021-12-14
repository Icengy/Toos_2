//
//  UGCKitBGMViewController.m
//  UGCKit
//
//  Created by icnengy on 2020/8/3.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "UGCKitBGMViewController.h"

#import "TYTabButtonPagerController.h"
#import "UGCKitBGMListViewController.h"

#import "ApiUtil.h"
#import "ToolUtil.h"
#import "AMEmptyView.h"

#import "UGCKit_UIViewAdditions.h"
#import "UGCKitColorMacro.h"

@interface UGCKitBGMViewController () <TYPagerControllerDataSource, TCBGMControllerListener>

@property (strong, nonatomic) TYTabButtonPagerController *contentView;

@property (nonatomic ,strong) NSMutableArray <NSDictionary *>*contentTitleArray;
@property (nonatomic ,strong) NSMutableArray <UGCKitBGMListViewController *>*contentChildArray;

@property(nonatomic,weak) id<UGCKitBGMControllerListener> bgmListener;

@end

@implementation UGCKitBGMViewController
{
    NSIndexPath *_BGMCellPath;
    BOOL      _useLocalMusic;
    UGCKitTheme *_theme;
    NSMutableDictionary* _progressList;
    NSTimeInterval lastUIFreshTick;
}

- (instancetype)initWithTheme:(UGCKitTheme *)theme {
    if (self = [self init]) {
        _theme = theme;
        _progressList = [NSMutableDictionary new];
        _useLocalMusic = NO;
    }
    return self;
}

-(void)setBGMControllerListener:(id<UGCKitBGMControllerListener>) listener {
    _bgmListener = listener;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _contentTitleArray = @[].mutableCopy;
    _contentChildArray = @[].mutableCopy;
    
    [self addChildViewController:self.contentView];
    [self.view addSubview:self.contentView.view];
    
    self.title = [_theme localizedString:@"UGCKit.BGMListView.TitileChooseBGM"];
    UIBarButtonItem *customBackButton = [[UIBarButtonItem alloc] initWithImage:_theme.backIcon style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = customBackButton;
    
    self.view.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadCategoryData)];
    [self.view ly_hideEmptyView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:RGB(25, 29, 38)];
    self.navigationController.navigationBar.tintColor = UIColor.whiteColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = RGB(25, 29, 38);
    
    if (!_contentTitleArray.count)
        [self loadCategoryData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIEdgeInsets safeEdgeInsets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        safeEdgeInsets = [[[UIApplication sharedApplication] delegate] window].safeAreaInsets;
    }
    self.contentView.view.frame = CGRectMake(0, safeEdgeInsets.top + 44.0, self.view.ugckit_width, self.view.ugckit_height - (safeEdgeInsets.top + 44.0));
}

- (TYTabButtonPagerController *)contentView {
    if (!_contentView) {
        _contentView = [[TYTabButtonPagerController alloc] init];
        _contentView.dataSource = self;
        _contentView.barStyle = TYPagerBarStyleCoverView;
        _contentView.contentTopEdging = 50.0f;
        _contentView.collectionLayoutEdging = 15.0f;
        _contentView.cellSpacing = 15.0f;
        
        _contentView.normalTextFont = [UIFont systemFontOfSize:14.0f];
        _contentView.selectedTextFont = [UIFont systemFontOfSize:14.0f];
        
        _contentView.customShadowColor = UIColorFromRGB(0x333333);
        _contentView.normalTextColor = UIColorFromRGB(0x999999);
        _contentView.selectedTextColor = UIColorFromRGB(0xFFFFFF);
        _contentView.progressColor = UIColorFromRGB(0x333333);
        
        _contentView.pagerBarColor = [UIColor clearColor];
        _contentView.collectionViewBarColor = [UIColor clearColor];
        _contentView.view.backgroundColor = RGB(25, 29, 38);
        
    } return _contentView;
}

- (void)contentChildArray:(NSArray *)contentArray {
    if (contentArray && contentArray.count) {
        if (_contentTitleArray.count) [_contentTitleArray removeAllObjects];
        _contentTitleArray = [contentArray mutableCopy];
        if (_contentChildArray.count) [_contentChildArray removeAllObjects];
        NSArray <NSDictionary *>*titleArray = _contentTitleArray.copy;
        [titleArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([ToolUtil isEqualToNonNull:[obj objectForKey:@"category_name"]] && [ToolUtil isEqualToNonNull:[obj objectForKey:@"id"]]) {
                UGCKitBGMListViewController *listVC = [[UGCKitBGMListViewController alloc] initWithTheme:_theme];
                [listVC setBGMControllerListener:self];
                listVC.listPrams = obj;
                [_contentChildArray addObject:listVC];
            }else
                [_contentTitleArray removeObjectAtIndex:idx];
        }];
        if (_contentTitleArray.count) {
            [self.view ly_hideEmptyView];
            [self.contentView reloadData];
        }else
            [self.view ly_showEmptyView];
    }
}

- (void)setSelectedBGMPath:(NSString *)selectedBGMPath {
    _selectedBGMPath = selectedBGMPath;
    [_contentChildArray enumerateObjectsUsingBlock:^(UGCKitBGMListViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selectedBGMPath = _selectedBGMPath;
    }];
}

- (void)goBack {
    [_bgmListener onBGMControllerPlay:nil];
}

#pragma mark - TCBGMControllerListener
-(void) onBGMControllerPlay:(NSObject*) path {
    if (_bgmListener && [_bgmListener respondsToSelector:@selector(onBGMControllerPlay:)]) {
        [_bgmListener onBGMControllerPlay:path];
    }
}

#pragma mark -- TYPagerControllerDataSource
- (NSInteger)numberOfControllersInPagerController {
    return _contentChildArray.count;
}

- (NSString *)pagerController:(TYPagerController *)pagerController titleForIndex:(NSInteger)index {
    return [_contentTitleArray[index] objectForKey:@"category_name"];
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index {
    return _contentChildArray[index];
}

#pragma mark -
- (void)loadCategoryData {
    [ApiUtil postWithParent:self url:[ApiUtilHeader getMusicCategory] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response) {
        [self contentChildArray:(NSArray *)[response objectForKey:@"data"]];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {}];
}

- (void)clearSelectStatus {
    [_contentChildArray enumerateObjectsUsingBlock:^(UGCKitBGMListViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj clearSelectStatus];
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
