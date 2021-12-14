//
//  AMNewArtistVideoSubViewController.m
//  ArtMedia2
//
//  Created by 刘洋 on 2020/9/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMNewArtistVideoSubViewController.h"
#import "VideoPlayerViewController.h"

#import "AMNewArtistMainVideoCollectionCell.h"
#import "AMNewArtistVideoHeadReusableView.h"

@interface AMNewArtistVideoSubViewController ()<UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , copy) NSString *listType;
@property (nonatomic , copy) NSString *count_num;
@end

@implementation AMNewArtistVideoSubViewController {
    NSString *_urlString;
    NSMutableDictionary *_params;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listType = @"2";
    
    _urlString = [ApiUtilHeader getIndexOtherVideoList];
    _params = @{}.mutableCopy;
    
    [self setCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.dataArray.count) [self loadData:nil];
}

- (void)setCollectionView{
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((K_Width - 30.0f -8.0f *3)/3, (K_Width - 30.0f -8.0f *3)/3);
    flowLayout.sectionInset = UIEdgeInsetsMake(15.0f, 15.0f, 15.0f, 15.0f);
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, SafeAreaBottomHeight, 0.0f);
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource =self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([AMNewArtistMainVideoCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([AMNewArtistMainVideoCollectionCell class])];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([AMNewArtistVideoHeadReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([AMNewArtistVideoHeadReusableView class])];
    
    self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    
    [self.collectionView addRefreshFooterWithTarget:self action:@selector(loadData:)];
    [self.collectionView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
    self.collectionView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadData:)];
}

#pragma mark -- UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.vcCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y <= 0) {
        self.vcCanScroll = NO;
        scrollView.contentOffset = CGPointZero;
        if (self.delegate && [self.delegate respondsToSelector:@selector(itemListController:scrollToTopOffset:)])
            [self.delegate itemListController:self scrollToTopOffset:YES];
    }
    self.collectionView.showsVerticalScrollIndicator = self.vcCanScroll;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    VideoPlayerViewController *videoDetail = [[VideoPlayerViewController alloc] initWithStyle:(MyVideoShowStyleForList) videos:self.dataArray.copy playIndex:indexPath.item listUrlStr:_urlString params:_params];
    [self.navigationController pushViewController:videoDetail animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AMNewArtistMainVideoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AMNewArtistMainVideoCollectionCell class]) forIndexPath:indexPath];
    if(self.dataArray.count) cell.model = self.dataArray[indexPath.row];

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        AMNewArtistVideoHeadReusableView *view  = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([AMNewArtistVideoHeadReusableView class]) forIndexPath:indexPath];
        view.count_num = self.count_num;
        @weakify(self);
        view.buttonClickBlock = ^(NSInteger tag) {
            @strongify(self);
            if (tag == 1) {
                self.listType = @"1";
            }else
                self.listType = @"2";
            [self loadData:nil];
        };
        return view;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(K_Width, 44.0f);
}

#pragma mark -
- (void)reloadData {
    [self loadData:nil];
}

- (void)loadData:(id _Nullable)sender {
    self.collectionView.allowsSelection = NO;
    if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
        [SVProgressHUD show];
    }
    if (sender && [sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        self.pageIndex ++;
    }else {
        self.pageIndex = 0;
        _urlString = [ApiUtilHeader getIndexOtherVideoList];
        if (_params.count) [_params removeAllObjects];
        if (self.dataArray.count) [self.dataArray removeAllObjects];
    }
    
    _params[@"artuid"] = self.artistID;
    _params[@"is_include_obj"] = self.listType;
    _params[@"page"] = @(self.pageIndex);
    
    [ApiUtil postWithParent:self url:_urlString needHUD:NO params:_params success:^(NSInteger code, id  _Nullable response) {
        [self.collectionView endAllFreshing];
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            if (self.pageIndex == 0) {
                _params[@"timespan"] = [data objectForKey:@"timespan"];
            }
            self.count_num = [ToolUtil isEqualToNonNull:[data objectForKey:@"count_num"] replace:@"0"];
            
            NSArray *array = (NSArray *)[data objectForKey:@"video"];
            if (array && array.count) {
                [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[VideoListModel class] json:array]];
            }
            [self.collectionView updataFreshFooter:(self.dataArray.count && array.count != MaxListCount)];
        }
        
        [self.collectionView ly_updataEmptyView:!self.dataArray.count];
        self.collectionView.mj_footer.hidden = !self.dataArray.count;
        [self.collectionView reloadData];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [SVProgressHUD showError:errorMsg];
        [self.collectionView endAllFreshing];
    }];
}

@end
