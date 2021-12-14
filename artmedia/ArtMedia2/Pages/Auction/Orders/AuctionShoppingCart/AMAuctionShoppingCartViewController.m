//
//  AMAuctionShoppingCartViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/11/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMAuctionShoppingCartViewController.h"

#import "AMAuctionOrderFillViewController.h"
#import "AuctionItemDetailViewController.h"

#import "AMAuctionShoppingCartTableCell.h"
#import "AMAuctionShoppingCartHeaderTableCell.h"

#import "AMAuctionOrderBaseModel.h"

@interface AMAuctionShoppingCartViewController () <UITableViewDelegate, UITableViewDataSource, AMAuctionShoppingCartCellDelegate, AMAuctionShoppingCartHeaderDelegate>

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;

@property (weak, nonatomic) IBOutlet AMButton *settlementBtn;
@property (weak, nonatomic) IBOutlet AMButton *allBtn;

@property (weak, nonatomic) IBOutlet UILabel *allLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPirceLabel;

@end

@implementation AMAuctionShoppingCartViewController {
    NSMutableArray <AMAuctionOrderBusinessModel *>*_dataArray;
    NSMutableArray <AMAuctionOrderBusinessModel *>*_selectArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.settlementBtn.titleLabel.font = [UIFont addHanSanSC:14.0 fontType:2];
    [self.settlementBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xE05227)] forState:UIControlStateNormal];
    [self.settlementBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0x9D9B98)] forState:UIControlStateDisabled];
    self.allBtn.titleLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
    self.totalCountLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
    
    _dataArray = @[].mutableCopy;
    _selectArray = @[].mutableCopy;
    
    self.tableView.bgColorStyle = AMBaseTableViewBackgroundColorStyleGray;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsMultipleSelectionDuringEditing = !self.tableView.editing;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMAuctionShoppingCartTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMAuctionShoppingCartTableCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMAuctionShoppingCartHeaderTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMAuctionShoppingCartHeaderTableCell class])];
    
    [self.tableView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
    self.tableView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self imageStr:@"icon-hummer-current" titleStr:nil detailStr:@"暂无未结拍品" btnTitleStr:nil action:@selector(loadData:)];
    self.bottomView.hidden = !_dataArray.count;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"未结拍品";
    
    [self loadData:nil];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray objectAtIndex:section].lots.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row) {
        AMAuctionShoppingCartTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMAuctionShoppingCartTableCell class]) forIndexPath:indexPath];
        cell.delegate = self;
        cell.isShoppingCart = YES;
        
        cell.hiddenBottomMargin = indexPath.row == 1;
        cell.insets = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0);
        if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
            cell.needCorner = YES;
            cell.rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
            cell.cornerRudis = 8.0f;
        }else
            cell.needCorner = NO;
        
        if (_dataArray.count) cell.model = [_dataArray[indexPath.section].lots objectAtIndex:(indexPath.row - 1)];
        
        return cell;
    }else {
        AMAuctionShoppingCartHeaderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMAuctionShoppingCartHeaderTableCell class]) forIndexPath:indexPath];
        cell.delegate = self;
        cell.isShoppingCart = YES;
        
        if (_dataArray.count) cell.model = _dataArray[indexPath.section];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section?CGFLOAT_MIN:20.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self updateCellSelectState:YES atIndexPath:indexPath];
//    return indexPath;
//}
//
//- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self updateCellSelectState:NO atIndexPath:indexPath];
//    return indexPath;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id cell = [tableView cellForRowAtIndexPath:indexPath];
    if (![cell isKindOfClass:[AMAuctionShoppingCartTableCell class]]) return;
    AMAuctionShoppingCartTableCell *cartCell = (AMAuctionShoppingCartTableCell *)cell;
    AuctionItemDetailViewController *detailVC = [[AuctionItemDetailViewController alloc] init];
    detailVC.auctionGoodId = cartCell.model.auctionGoodId;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - AMAuctionShoppingCartCellDelegate
- (void)shoppingCartCell:(AMAuctionShoppingCartTableCell *)cartCell didClickToSelected:(AMButton *)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cartCell];
    [self updateCellSelectState:!cartCell.model.isSelect atIndexPath:indexPath];
}

#pragma mark - AMAuctionShoppingCartHeaderDelegate
- (void)shoppingCartHeaderCell:(AMAuctionShoppingCartHeaderTableCell *)headerCell didClickToSelected:(AMButton *)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:headerCell];
    [self updateCellSelectState:!headerCell.model.isSelect atIndexPath:indexPath];
}


#pragma mark -
- (IBAction)clickToSettlement:(id)sender {
    AMAuctionOrderFillViewController *fillVC = [[AMAuctionOrderFillViewController alloc] init];
    fillVC.lots = [self getSelectArray];
    fillVC.totalPrice = [ self.totalPirceLabel.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
    
    [self.navigationController pushViewController:fillVC animated:YES];
}

- (IBAction)clickToAll:(AMButton *)sender {
    sender.selected = !sender.selected;
    [self updateCellSelectState:sender.selected atIndexPath:nil];
}

#pragma mark -
- (void)updateCellSelectState:(BOOL)isSelect atIndexPath:(NSIndexPath *_Nullable)indexPath {
    if (indexPath) {
        AMAuctionOrderBusinessModel *business = _dataArray[indexPath.section];
        NSMutableArray <AMAuctionLotModel *>*lots = business.lots.mutableCopy;
        if (!indexPath.row) {
            /// 第一行选中/取消
            business.isSelect = isSelect;
            [lots enumerateObjectsUsingBlock:^(AMAuctionLotModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.isSelect = isSelect;
                [lots replaceObjectAtIndex:idx withObject:obj];
            }];
            business.lots = lots.copy;
            
            [self changeCellSelectUI:indexPath];
        }else {
            /// 单行选中/取消
            NSInteger index = indexPath.row - 1;
            AMAuctionLotModel *lotModel = [lots objectAtIndex:index];
            lotModel.isSelect = isSelect;
            [lots replaceObjectAtIndex:index withObject:lotModel];
            business.lots = lots.copy;
            
            business.isSelect = [self judgeSelectOfArray:business.lots];
            /// 关联第一行是否选中/取消
            [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:indexPath.section] withRowAnimation:(UITableViewRowAnimationNone)];
//            if (business.isSelect) {
//                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section] animated:YES scrollPosition:(UITableViewScrollPositionNone)];
//            }else {
//                [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section] animated:YES];
//            }
        }
        [_dataArray replaceObjectAtIndex:indexPath.section withObject:business];
    }else {
        ///全部选中/取消
        [_dataArray enumerateObjectsUsingBlock:^(AMAuctionOrderBusinessModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            /// 第一行
            obj.isSelect = isSelect;
            /// 剩余行
            [obj.lots enumerateObjectsUsingBlock:^(AMAuctionLotModel * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
                obj1.isSelect = isSelect;
            }];
        }];
        [self changeCellSelectUI:indexPath];
    }
    
    [self updateBottom];
}

/// 全选中/取消的判断
- (BOOL)judgeAllBtnState {
    __block BOOL isAll = NO;
    /// 只判断拍品的选中/取消
    [_dataArray enumerateObjectsUsingBlock:^(AMAuctionOrderBusinessModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        isAll = [self judgeSelectOfArray:obj.lots];
        if (!isAll)  *stop = YES;
    }];
    return isAll;
}

/// 单个section的全选中/取消的判断
- (BOOL)judgeSelectOfArray:(NSArray <AMAuctionLotModel *>*)lotsArray {
    __block BOOL isAll = NO;
    [lotsArray enumerateObjectsUsingBlock:^(AMAuctionLotModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        isAll = obj.isSelect;
        if (!isAll)  *stop = YES;
    }];
    return isAll;
}

/// 刷新全部
- (void)changeCellSelectUI:(NSIndexPath *_Nullable)indexPath {
    if (indexPath) {
        [self changeUIsAtSection:indexPath.section];
    }else {
        [_dataArray enumerateObjectsUsingBlock:^(AMAuctionOrderBusinessModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self changeUIsAtSection:idx];
        }];
    }
}

/// 按section刷新
- (void)changeUIsAtSection:(NSInteger)section {
    
    [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:section] withRowAnimation:(UITableViewRowAnimationNone)];
//    AMAuctionOrderBusinessModel *business = [_dataArray objectAtIndex:section];
//    /// 第一行
//    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
//    /// 剩余行
//    [business.lots enumerateObjectsUsingBlock:^(AMAuctionLotModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx + 1 inSection:section];
//        if (obj.isSelect) {
//            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:(UITableViewScrollPositionNone)];
//        }else {
//            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//        }
//    }];
}

- (NSInteger)getTotalCount {
    __block NSInteger count = 0;
    [_dataArray enumerateObjectsUsingBlock:^(AMAuctionOrderBusinessModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        count += [self getCountWithSingle:idx];
    }];
    return count;
}

- (NSInteger)getCountWithSingle:(NSInteger)index {
    __block NSInteger count = 0;
    AMAuctionOrderBusinessModel *business = [_dataArray objectAtIndex:index];
    [business.lots enumerateObjectsUsingBlock:^(AMAuctionLotModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelect) count += 1;
    }];
    return count;
}

- (double)getTotalPrice {
    __block double price = 0.0;
    [_dataArray enumerateObjectsUsingBlock:^(AMAuctionOrderBusinessModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        price += [self getPirceWithSingle:idx];
    }];
    return price;
}

- (double)getPirceWithSingle:(NSInteger)index {
    __block double price = 0.0;
    AMAuctionOrderBusinessModel *business = [_dataArray objectAtIndex:index];
    [business.lots enumerateObjectsUsingBlock:^(AMAuctionLotModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelect) price += obj.actualPrice.doubleValue;
    }];
    return price;
}

- (NSArray *)getSelectArray {
    NSMutableArray <AMAuctionOrderBusinessModel *>*selectArray = @[].mutableCopy;
    [_dataArray enumerateObjectsUsingBlock:^(AMAuctionOrderBusinessModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelect) {
            [selectArray addObject:obj];
        }else {
            NSMutableArray <AMAuctionLotModel *>*objs = @[].mutableCopy;
            [obj.lots enumerateObjectsUsingBlock:^(AMAuctionLotModel * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
                if (obj1.isSelect) [objs addObject:obj1];
            }];
            if (objs.count) {
                obj.lots = objs.copy;
                [selectArray addObject:obj];
            }
        }
    }];
    return selectArray.copy;
}

- (void)updateBottom {
    self.bottomView.hidden = !_dataArray.count;
    /// 底部栏UI刷新
    self.allBtn.selected = [self judgeAllBtnState];
    NSInteger count = [self getTotalCount];
    self.totalCountLabel.text = [NSString stringWithFormat:@"共%@件", @(count)];
    self.settlementBtn.enabled = count;
    
    self.totalPirceLabel.text = [NSString stringWithFormat:@"¥%@", @([self getTotalPrice])];
}

#pragma mark -
- (void)loadData:(id)sender {
    self.tableView.allowsSelection = NO;
    if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
        [SVProgressHUD show];
    }
    if (![sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        if (_dataArray.count) [_dataArray removeAllObjects];
    }
    [ApiUtil getWithParent:self url:[ApiUtilHeader selectAuctionUnsettledGoodsListByCurrentUser] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response) {
        [self.tableView endAllFreshing];
        NSArray *data = (NSArray *)[response objectForKey:@"data"];
        if (data && data.count) {
            [_dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[AMAuctionOrderBusinessModel class] json:data]];
        }
        [self.tableView ly_updataEmptyView:!_dataArray.count];
        [self updateBottom];
        
        [self.tableView reloadData];
        
//        [self updateCellSelectState:YES atIndexPath:nil];
        
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [SVProgressHUD showError:errorMsg];
        [self.tableView endAllFreshing];
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
