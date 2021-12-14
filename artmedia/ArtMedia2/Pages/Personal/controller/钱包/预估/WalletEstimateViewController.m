//
//  WalletEstimateViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "WalletEstimateViewController.h"

#import "MainNavigationController.h"
#import "WalletClassifiedItemViewController.h"

#import "WalletEstimateListHeaderView.h"
#import "WalletEstimateListTableCell.h"

@interface WalletEstimateViewController ()
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (nonatomic ,strong) WalletEstimateListHeaderView *headerView;
@end

@implementation WalletEstimateViewController

- (WalletEstimateListHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WalletEstimateListHeaderView class]) owner:nil options:nil].lastObject;
        _headerView.currentIndex = self.currentIndex;
        _headerView.dataArray = self.contentTitleArray.copy;
        _headerView.frame = CGRectMake(0, 0, self.view.width, 44.0f);
        @weakify(self);
        _headerView.clickIndexBlock = ^(NSInteger index) {
            @strongify(self);
            self.currentIndex = index;
            [self.contentCarrier moveToControllerAtIndex:self.currentIndex animated:YES];
        };
    }return _headerView;
}

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    
    self.contentChildArray = [self getContentChildArray].mutableCopy;
    
    self.contentCarrier.dataSource = self;
    self.contentCarrier.delegate = self;
    self.contentCarrier.customShadowColor = UIColor.clearColor;
    [self addChildViewController:self.contentCarrier];
    
    self.tableView.multipleGestureEnable = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerClass:[EmptyTableViewCell class] forCellReuseIdentifier:NSStringFromClass([EmptyTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WalletEstimateListTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WalletEstimateListTableCell class])];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (_style == AMWalletItemStyleEstimateSale) {
        self.navigationItem.title = @"预估销售";
    }
    if (_style == AMWalletItemStyleEstimateProfit) {
        self.navigationItem.title = @"预估收益";
    }
    self.barStyle = UIStatusBarStyleLightContent;
    self.navigationBarStyle = AMNavigationBarStyleWhite;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.barStyle = UIStatusBarStyleDefault;
    self.navigationBarStyle = AMNavigationBarStyleDetault;
}

//- (void)setEstimateMoney:(NSString *)estimateMoney {
//    _estimateMoney = estimateMoney;
//    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
//}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section?(K_Height - 54.0f - StatusNav_Height):88.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WalletEstimateListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WalletEstimateListTableCell class]) forIndexPath:indexPath];
        cell.estimateMoney = self.estimateMoney;
        return cell;
    }else {
        EmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EmptyTableViewCell class]) forIndexPath:indexPath];
        
        cell.insets = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f);
        cell.corners = UIRectCornerAllCorners;
        cell.contentCarrier = self.contentCarrier.view;
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) return 54.0f;
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) return self.headerView;
    return [UIView new];
}

#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat bottomCellOffset = [self.tableView rectForSection:self.tableView.numberOfSections - 1].origin.y;
    [self tableViewDidScroll:scrollView bottomCellOffset:bottomCellOffset];
}

#pragma mark - BaseItemViewControllerDelegate
- (void)itemListController:(BaseItemViewController *)listVC scrollToTopOffset:(BOOL)scrollTop {
    [self tableViewScrollToTopOffset];
}

#pragma mark - TYPagerController
- (NSArray *)getContentChildArray {
    self.contentTitleArray = @[@"当前", @"已失效"].mutableCopy;
    NSMutableArray *customArray = [NSMutableArray new];
    for (int i = 0; i < self.contentTitleArray.count; i ++) {
        WalletClassifiedItemViewController *listVC = [[WalletClassifiedItemViewController alloc] init];
        listVC.delegate = self;
        listVC.style = [self itemStyle:i];
        [customArray insertObject:listVC atIndex:customArray.count];
    }
    return customArray;
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

- (void)pagerController:(TYTabPagerController *)pagerController didScrollToTabPageIndex:(NSInteger)index {
    self.currentIndex = index;
    _headerView.currentIndex = self.currentIndex;
}

#pragma mark -
- (AMWalletItemDetailStyle)itemStyle:(int)index {
    
    if (_style == AMWalletItemStyleEstimateSale) {/// 预估销售
        switch (index) {
            case 0:  /// 预估销售-有效
                return AMWalletItemDetailStyleEstimateSaleValid;
                break;
            case 1: /// 预估销售-无效
                return AMWalletItemDetailStyleEstimateSaleInvalid;
                break;
                
            default:
                break;
        }
    }
    
    if (_style == AMWalletItemStyleEstimateProfit) {/// 预估收益
        switch (index) {
            case 0:  /// 预估收益-有效
                return AMWalletItemDetailStyleEstimateProfitValid;
                break;
            case 1: /// 预估收益-无效
                return AMWalletItemDetailStyleEstimateProfitInvalid;
                break;
                
            default:
                break;
        }
    }
    
    return AMWalletItemDetailStyleNone;
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
