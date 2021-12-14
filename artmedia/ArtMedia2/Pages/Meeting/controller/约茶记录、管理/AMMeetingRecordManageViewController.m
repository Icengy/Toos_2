//
//  AMMeetingRecordManageViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/8/17.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMMeetingRecordManageViewController.h"

#import "TYTabButtonPagerController.h"

#import "AMMeetingRecordManageListViewController.h"
#import "AMMeetingSettingViewController.h"

#import "AMSegment.h"

@interface AMMeetingRecordManageViewController () <TYPagerControllerDataSource, TYTabPagerControllerDelegate, AMSegmentDelegate>
@property (weak, nonatomic) IBOutlet AMSegment *segmentView;

@property (strong, nonatomic) TYTabButtonPagerController *contentView;
@property (nonatomic ,strong) NSMutableArray *contentChildArray;
@property (nonatomic ,strong) NSMutableArray *contentTitleArray;
@property (nonatomic ,strong) NSMutableArray *totalArray;
@property (nonatomic ,assign) NSInteger currentIndex;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *segment_height_constraint;

@end

@implementation AMMeetingRecordManageViewController


- (TYTabButtonPagerController *)contentView {
    if (!_contentView) {
        _contentView = [[TYTabButtonPagerController alloc] init];
        _contentView.contentTopEdging = 0.0f;
        _contentView.delegate = self;
        _contentView.dataSource = self;
        _contentView.defaultIndex = self.pageIndex;
        
    } return _contentView;
}

- (instancetype) init {
    if (self = [super init]) {
        _contentChildArray = @[].mutableCopy;
        _contentTitleArray = @[].mutableCopy;
        _totalArray = @[@0, @0, @0, @0, @0].mutableCopy;
    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    
    [self getContentChildArray];
    
    self.segment_height_constraint.constant = self.style?44.0:60.0f;
    self.segmentView.delegate = self;
    self.segmentView.segStyle = AMSegmentStyleProgressView;
    self.segmentView.sliderColor = UIColorFromRGB(0xE22020);
    self.segmentView.normalItemTextAttributes = @{NSForegroundColorAttributeName:UIColorFromRGB(0x999999), NSFontAttributeName:[UIFont addHanSanSC:14.0f fontType:0]};
    self.segmentView.selectedItemTextAttributes = @{NSForegroundColorAttributeName:Color_Black, NSFontAttributeName:[UIFont addHanSanSC:14.0f fontType:0]};
    self.segmentView.items = _contentTitleArray.copy;
    self.segmentView.selectedSegmentIndex = self.pageIndex;
    
    [self addChildViewController:self.contentView];
    [self.view addSubview:self.contentView.view];
    
    self.navigationItem.title = @"约见记录";
    if (self.style == AMMeetingRecordManageStyleManage) {
        self.navigationItem.title = @"约见管理";
        AMButton *button = [AMButton buttonWithType:UIButtonTypeCustom];
        [button setImage:ImageNamed(@"meeting-约见设置") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickToSetting:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        [self loadData];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.contentView.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.segmentView.mas_bottom);
    }];
}

- (void)getContentChildArray {
    [self getContentTitleArray];
    [_contentTitleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AMMeetingRecordManageListViewController *listVC = [[AMMeetingRecordManageListViewController alloc] init];
        listVC.style = self.style;
        listVC.listStyle = idx;
        
        listVC.updateTotalBlock = ^(AMMeetingRecordManageListStyle style, NSInteger total) {
            if (total != [[_totalArray objectAtIndex:style] integerValue]) {
                [_totalArray replaceObjectAtIndex:style withObject:@(total)];
                [self getContentTitleArray];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.segmentView.items = _contentTitleArray.copy;
                });
            }
        };
        [_contentChildArray addObject:listVC];
    }];
}

- (void)getContentTitleArray {
    if (_contentTitleArray.count) [_contentTitleArray removeAllObjects];
    NSArray <NSString *>*titleArray = @[@"全部", @"待邀请", self.style?@"已邀请":@"待确认", @"已确认", @"已取消"];
    [titleArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.style) {
            [_contentTitleArray addObject:[NSString stringWithFormat:@"%@\n%@", obj, [_totalArray objectAtIndex:idx]]];
        }else
            [_contentTitleArray addObject:obj];
    }];
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

- (void)pagerController:(TYTabPagerController *)pagerController didScrollToTabPageIndex:(NSInteger)index {
    NSLog(@"didScrollToTabPageIndex - %@",@(index));
    self.currentIndex = index;
    self.segmentView.selectedSegmentIndex = self.currentIndex;
}

#pragma mark -
- (void)segment:(AMSegment *)seg switchSegmentIndex:(NSInteger)index {
    self.currentIndex = index;
    [self.contentView moveToControllerAtIndex:self.currentIndex animated:YES];
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    [self.contentView moveToControllerAtIndex:_currentIndex animated:YES];
}

#pragma mark -
- (void)clickToSetting:(id)sender {
    [self.navigationController pushViewController:[[AMMeetingSettingViewController alloc] init] animated:YES];
}

- (void)loadData {
    [ApiUtil postWithParent:self url:[ApiUtilHeader getMeetingOrderManageListStatusCountByGroup] needHUD:NO params:@{@"artistId":[UserInfoManager shareManager].uid} success:^(NSInteger code, id  _Nullable response) {
        NSArray *data = (NSArray *)[response objectForKey:@"data"];
        if (data && data.count) {
            [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSInteger orderStatus = [[obj objectForKey:@"orderStatus"] integerValue];
                if (orderStatus < _totalArray.count) {
                    [_totalArray replaceObjectAtIndex:orderStatus withObject:[obj objectForKey:@"num"]];
                }
            }];
        }
        [self getContentTitleArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.segmentView.items = _contentTitleArray.copy;
        });
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
