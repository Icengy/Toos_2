//
//  GoodsClassViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/28.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "GoodsClassViewController.h"

#import "AMEmptyView.h"
#import "GoodsClassTableCell.h"

#define GoodsClassTableViewTag 98765

@interface GoodsClassViewController () <UITableViewDelegate ,UITableViewDataSource, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbale;

@property (weak, nonatomic) IBOutlet BaseTableView *baseTableView;
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;

@property (weak, nonatomic) IBOutlet AMButton *confirmBtn;

@property (nonatomic ,strong) NSMutableArray <GoodsClassModel *>*dataArray;
@property (nonatomic ,strong) NSIndexPath *selectedIndexPath;
@property (nonatomic ,strong) NSIndexPath *itemSelectedIndexPath;
@end

@implementation GoodsClassViewController

- (instancetype) init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [RGB(0, 0, 0) colorWithAlphaComponent:0.2];
    
    [self.view endEditing:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToBack:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    _dataArray = @[].mutableCopy;
    
    _baseTableView.bgColorStyle = AMBaseTableViewBackgroundColorStyleGray;
    _baseTableView.delegate = self;
    _baseTableView.dataSource = self;
    _baseTableView.tableFooterView = [UIView new];
    _baseTableView.sectionFooterHeight = CGFLOAT_MIN;
    _baseTableView.tableHeaderView = [UIView new];
    _baseTableView.sectionHeaderHeight = CGFLOAT_MIN;
    _baseTableView.rowHeight = 50.0f;
    _baseTableView.tag = GoodsClassTableViewTag;
    [_baseTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsClassTableCell class]) bundle:nil] forCellReuseIdentifier:[self cellReuseIdentifier:0]];
    
    _contentView.backgroundColor = _baseTableView.backgroundColor;
    
//    _tableView.bgColorStyle = AMBaseTableViewBackgroundColorStyleDetault;
    _tableView.backgroundColor = Color_Whiter;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.sectionFooterHeight = CGFLOAT_MIN;
    _tableView.tableHeaderView = [UIView new];
    _tableView.sectionHeaderHeight = CGFLOAT_MIN;
    _tableView.rowHeight = 60.0f;
    _tableView.tag = GoodsClassTableViewTag + 1;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsClassTableCell class]) bundle:nil] forCellReuseIdentifier:[self cellReuseIdentifier:1]];
    
    _confirmBtn.titleLabel.font = [UIFont addHanSanSC:17.0f fontType:0];
    
    [_baseTableView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
    _baseTableView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self titleStr:@"暂无分类" detailStr:nil action:@selector(loadData:)];
    _tableView.ly_emptyView = [AMEmptyView emptyActionViewWithImageStr:nil
                                             titleStr:@"暂无分类"
                                            detailStr:nil
                                          btnTitleStr:nil
                                               target:self
                                               action:@selector(loadData:)];
}

- (NSString *)cellReuseIdentifier:(NSInteger)tag {
    return [NSString stringWithFormat:@"%@_%@", NSStringFromClass([GoodsClassTableCell class]), tag?@"TableView":@"BaseTableView"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_dataArray.count) [self loadData:nil];
}

- (void)setSelectedIndexPath:(NSIndexPath *)selectedIndexPath {
    _selectedIndexPath = selectedIndexPath;
    
    NSLog(@"_selectedIndexPath  = %@",_selectedIndexPath);
    
    [self.baseTableView selectRowAtIndexPath:_selectedIndexPath animated:YES scrollPosition:(UITableViewScrollPositionNone)];
    [self.tableView reloadData];
    [self.tableView ly_updataEmptyView:!_dataArray[_selectedIndexPath.row].secondcate.count];
}

- (void)setItemSelectedIndexPath:(NSIndexPath *)itemSelectedIndexPath {
    _itemSelectedIndexPath = itemSelectedIndexPath;
    
    NSLog(@"_itemSelectedIndexPath  = %@",_itemSelectedIndexPath);
    [self.tableView selectRowAtIndexPath:_itemSelectedIndexPath animated:YES scrollPosition:(UITableViewScrollPositionNone)];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == GoodsClassTableViewTag) {
        return _dataArray.count;
    }
    if (!_dataArray.count) return 0;
    return _dataArray[_selectedIndexPath.row].secondcate.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger tag = tableView.tag - GoodsClassTableViewTag;
    GoodsClassTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[self cellReuseIdentifier:tag] forIndexPath:indexPath];
    cell.style = tag;
    if (tag) {
        cell.model = [_dataArray[_selectedIndexPath.row].secondcate objectAtIndex:indexPath.row];
    }else {
        cell.model = _dataArray[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == GoodsClassTableViewTag) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (self.selectedIndexPath != indexPath) self.selectedIndexPath = indexPath;
    }else {
        if (self.itemSelectedIndexPath != indexPath) {
            self.itemSelectedIndexPath = indexPath;
            [self clickToConfirm:nil];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (tableView.tag == GoodsClassTableViewTag) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        //  隐藏每个分区最后一个cell的分割线
        if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
            // 1.系统分割线,移到屏幕外
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
        }
    }
}

#pragma mark -
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.contentView]) {
        return NO;
    }
    return YES;
}

#pragma mark -
- (IBAction)clickToBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickToConfirm:(id)sender {
    GoodsClassModel *model = [GoodsClassModel new];
    if (_dataArray && _dataArray.count) {
        model = _dataArray[_selectedIndexPath.row];
    }
    if (model.secondcate && model.secondcate.count) {
        GoodsClassModel *selectedModel = [model.secondcate objectAtIndex:_itemSelectedIndexPath.row];
        if ([ToolUtil isEqualToNonNull:selectedModel.id]) {
            model.secondcate = @[selectedModel];
            if (self.delegate && [self.delegate respondsToSelector:@selector(viewController:didSelectedGoodsClass:)]) {
                [self.delegate viewController:self didSelectedGoodsClass:model];
            }
        }
    }
}

#pragma mark -
- (void)loadData:(id _Nullable)sender {
    self.baseTableView.allowsSelection = NO;
    if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
        [SVProgressHUD show];
    }
    if (![sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        if (_dataArray.count) [_dataArray removeAllObjects];
    }
    [ApiUtil postWithParent:self url:[ApiUtilHeader getCateTree] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response) {
        [self.baseTableView endAllFreshing];
        if (![sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
            if (_dataArray.count) [_dataArray removeAllObjects];
        }
        NSArray *array = (NSArray *)[response objectForKey:@"data"];
        if (array && array.count) {
            _dataArray = [NSArray yy_modelArrayWithClass:[GoodsClassModel class] json:array].mutableCopy;
        }
        
        [self.baseTableView ly_updataEmptyView:!_dataArray.count];
        [self.baseTableView reloadData];
        
        if (_dataArray.count) {
            if (!(self.classModel && [ToolUtil isEqualToNonNullKong:self.classModel.id])) {
               self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
               self.itemSelectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
           }else {
               [_dataArray enumerateObjectsUsingBlock:^(GoodsClassModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                   if ([obj.id isEqualToString:self.classModel.id]) {
                       self.selectedIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                       *stop = YES;
                   }
               }];
               
               [self.baseTableView selectRowAtIndexPath:self.selectedIndexPath animated:YES scrollPosition:(UITableViewScrollPositionNone)];
               [self.tableView reloadData];
               [self.tableView ly_updataEmptyView:!_dataArray[self.selectedIndexPath.row].secondcate.count];
               
               if (self.classModel.secondcate) {
                   NSArray <GoodsClassModel *>*secondcate = _dataArray[self.selectedIndexPath.row].secondcate;
                   [secondcate enumerateObjectsUsingBlock:^(GoodsClassModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                       if ([obj.id isEqualToString:self.classModel.secondcate.lastObject.id]) {
                           self.itemSelectedIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                           *stop = YES;
                       }
                   }];
               }
           }
        }
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [SVProgressHUD showError:errorMsg];
        [self.baseTableView endAllFreshing];
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
