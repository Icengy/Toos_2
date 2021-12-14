//
//  AMCertificateListViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/9/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMCertificateListViewController.h"
#import "AMCertificateDetailViewController.h"

#import "AMCertificateListCollectionCell.h"
#import "AMEmptyView.h"
#import "WaterCollectionViewFlowLayout.h"

@interface AMCertificateListViewController () <WaterCollectionViewFlowLayoutDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic ,strong) WaterCollectionViewFlowLayout *waterFlowLayout;
@end

@implementation AMCertificateListViewController {
    NSMutableArray <AMCertificateListModel *>*_dataArray;
}

- (instancetype)init {
    if (self = [super init]) {
        _dataArray = @[].mutableCopy;
    }return self;
}


- (WaterCollectionViewFlowLayout *)waterFlowLayout {
    if (!_waterFlowLayout) {
        _waterFlowLayout = [[WaterCollectionViewFlowLayout alloc] init];
        
        _waterFlowLayout.minimumInteritemSpacing = 15.0f; //行间距
        _waterFlowLayout.minimumLineSpacing = 15.0f; //列间距
        _waterFlowLayout.sectionInset = UIEdgeInsetsMake(15.0f, 15.0f, 15.0f, 15.0f);
        
        _waterFlowLayout.delegate = self;
        
    }return _waterFlowLayout;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    
    self.collectionView.collectionViewLayout = self.waterFlowLayout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([AMCertificateListCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([AMCertificateListCollectionCell class])];
    [self.collectionView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
    self.collectionView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadData:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!_dataArray.count) [self loadData:nil];
}

#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AMCertificateListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AMCertificateListCollectionCell class]) forIndexPath:indexPath];
        
    if (_dataArray.count) cell.model = _dataArray[indexPath.item];
        
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    AMCertificateDetailViewController *detailVC = [[AMCertificateDetailViewController alloc] init];
    AMCertificateListCollectionCell *cell = (AMCertificateListCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    detailVC.model = cell.model;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (CGSize)flowLayout:(WaterCollectionViewFlowLayout *)flowLayout heightForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CGFloat width = (K_Width - 15.0f*3)/2;
    return CGSizeMake(width, width*(283.0f/167.0f));
}

#pragma mark -
- (void)loadData:(id _Nullable)sender {
    self.collectionView.allowsSelection = NO;
    if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
        [SVProgressHUD show];
    }
    if (![sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        if (_dataArray.count) [_dataArray removeAllObjects];
    }
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"ownerUserId"] = [UserInfoManager shareManager].uid;
    params[@"certStatus"] = @(self.style);
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader certificateQueryList] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [self.collectionView endAllFreshing];
        NSDictionary *data =(NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {

            [_dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[AMCertificateListModel class] json:data]];
        }
        [self.collectionView ly_updataEmptyView:!_dataArray.count];
        [self.collectionView reloadData];
        
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [self.collectionView endAllFreshing];
        [SVProgressHUD showError:errorMsg];
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
