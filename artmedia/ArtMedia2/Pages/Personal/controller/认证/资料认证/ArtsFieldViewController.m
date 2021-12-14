//
//  ArtsFieldViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/24.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "ArtsFieldViewController.h"

#import "ArtsFieldTableViewCell.h"
#import "AMEmptyView.h"

#import "IdentifyModel.h"

@interface ArtsFieldViewController () <UIGestureRecognizerDelegate, UITableViewDelegate ,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (weak, nonatomic) IBOutlet AMButton *confirmBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmBottomConstraint;

@property (assign, nonatomic) NSInteger selectedIndex;
@end

@implementation ArtsFieldViewController {
    NSMutableArray <ArtsFieldModel *>*_dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [RGB(0, 0, 0) colorWithAlphaComponent:0.2];
    
    _confirmBtn.titleLabel.font = [UIFont addHanSanSC:18.0f fontType:1];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    _dataArray = [NSMutableArray new];
    
    self.tableView.bgColorStyle = AMBaseTableViewBackgroundColorStyleGray;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.sectionFooterHeight = CGFLOAT_MIN;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ArtsFieldTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ArtsFieldTableViewCell class])];
    
    [self.tableView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
    self.tableView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadData:)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_dataArray.count) {
        [self loadData:nil];
    }
}

- (void)back:(id _Nullable)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    self.fieldModel = _dataArray[self.selectedIndex];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] animated:YES scrollPosition:(UITableViewScrollPositionNone)];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArtsFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ArtsFieldTableViewCell class]) forIndexPath:indexPath];
    
    cell.fieldModel = _dataArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *wrapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 50.0f)];
    wrapView.backgroundColor = tableView.backgroundColor;
    
    AMButton *backBtn = [AMButton buttonWithType:UIButtonTypeCustom];
    [wrapView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wrapView.mas_right).offset(-10.0f);
        make.centerY.equalTo(wrapView);
        make.size.sizeOffset(CGSizeMake(wrapView.height*0.8, wrapView.height*0.8));
    }];
    
    [backBtn setImage:ImageNamed(@"dialog_close") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] init];
    [wrapView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wrapView.mas_left).offset(10.0);
        make.centerY.equalTo(wrapView);
        make.right.greaterThanOrEqualTo(backBtn.mas_left);
    }];
    
    label.text = @"选择创作领域";
    label.textColor = RGB(21, 22, 26);
    label.font = [UIFont addHanSanSC:16.0f fontType:0];
    
    return wrapView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndex = indexPath.row;
}

#pragma mark -
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.tableView]) {
        return NO;
    }
    return YES;
}

#pragma mark -
- (IBAction)clickToConfirm:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(viewController:didSelectedArtField:)]) {
            [self.delegate viewController:self didSelectedArtField:self.fieldModel];
        }
    }];
}

#pragma mark -
- (void)loadData:(id _Nullable)sender {
    self.tableView.allowsSelection = NO;
    if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
        [SVProgressHUD show];
    }
    if (![sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        if (_dataArray.count) [_dataArray removeAllObjects];
    }
    [ApiUtil postWithParent:self url:[ApiUtilHeader getCateTree] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response) {
        [self.tableView endAllFreshing];
        NSArray *array = (NSArray *)[response objectForKey:@"data"];
        if (array && array.count) {
            _dataArray = [NSArray yy_modelArrayWithClass:[ArtsFieldModel class] json:array].mutableCopy;
        }
        
        [self.tableView ly_updataEmptyView:!_dataArray.count];
        [self.tableView reloadData];
        [self.tableView layoutIfNeeded];
        
        if (self.fieldModel && _dataArray.count) {
            [_dataArray enumerateObjectsUsingBlock:^(ArtsFieldModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.id isEqualToString:self.fieldModel.id]) {
                    self.selectedIndex = idx;
                    *stop = YES;
                }
            }];
        }else {
            self.selectedIndex = 0;
        }
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
