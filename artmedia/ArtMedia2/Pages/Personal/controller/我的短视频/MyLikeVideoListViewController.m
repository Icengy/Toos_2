//
//  MyLikeVideoListViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/9/9.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "MyLikeVideoListViewController.h"
#import "VideoPlayerViewController.h"

#import "VideoListModel.h"

#import "WaterCollectionViewFlowLayout.h"

#import "MyLikeVideoListCollectionCell.h"
#import "AMNewArtistMainVideoCollectionCell.h"
#import "AMEmptyView.h"

@interface MyLikeVideoListViewController () <WaterCollectionViewFlowLayoutDelegate, UICollectionViewDelegate , UICollectionViewDataSource>
@property (nonatomic ,weak) IBOutlet UICollectionView *collectionView;

@property (nonatomic ,strong) WaterCollectionViewFlowLayout *waterFlowLayout;
@end

@implementation MyLikeVideoListViewController {
    NSString *_urlString;
    NSMutableDictionary *_params;
    NSInteger _page;
    NSMutableArray <VideoListModel *>*_dataArray;
}

#pragma mark -
- (WaterCollectionViewFlowLayout *)waterFlowLayout {
    if (!_waterFlowLayout) {
        _waterFlowLayout = [[WaterCollectionViewFlowLayout alloc] init];
        
        _waterFlowLayout.minimumInteritemSpacing = ADAptationMargin; //行间距
        _waterFlowLayout.minimumLineSpacing = ADAptationMargin; //列间距
        _waterFlowLayout.sectionInset = UIEdgeInsetsMake(ADAptationMargin, ADAptationMargin, 0.0f, ADAptationMargin);
        
        _waterFlowLayout.delegate = self;
        
    }return _waterFlowLayout;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _page = 0;
    _urlString = nil;
    _params = @{}.mutableCopy;
    _dataArray = [NSMutableArray new];
    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //    flowLayout.minimumInteritemSpacing = 8;
        flowLayout.itemSize = CGSizeMake((K_Width - 30 -8 -8 -8)/3, (K_Width - 30 -8 -8 -8)/3);
        flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    self.collectionView.collectionViewLayout = flowLayout;
//    self.collectionView.collectionViewLayout = self.waterFlowLayout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
//    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MyLikeVideoListCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MyLikeVideoListCollectionCell class])];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([AMNewArtistMainVideoCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([AMNewArtistMainVideoCollectionCell class])];
    [self.collectionView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
    [self.collectionView addRefreshFooterWithTarget:self action:@selector(loadData:)];
    self.collectionView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadData:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"我喜欢的";
    if (!_dataArray.count) [self loadData:nil];
}


#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //    MyLikeVideoListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MyLikeVideoListCollectionCell class]) forIndexPath:indexPath];
    //    if (_dataArray.count) cell.model = _dataArray[indexPath.item];
    //    return cell;
    AMNewArtistMainVideoCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AMNewArtistMainVideoCollectionCell class]) forIndexPath:indexPath];
    if (_dataArray.count) cell.model = _dataArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoPlayerViewController *videoDetail = [[VideoPlayerViewController alloc] initWithStyle:(MyVideoShowStyleForList) videos:_dataArray.copy playIndex:indexPath.item listUrlStr:_urlString params:_params];
    [self.navigationController pushViewController:videoDetail animated:YES];
}
#pragma mark -WaterCollectionViewFlowLayoutDelegate
/**
 获取每一个item的高度
 */
- (CGSize)flowLayout:(WaterCollectionViewFlowLayout *)flowLayout heightForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (!_dataArray.count) return CGSizeZero;
    if (indexPath.item >= _dataArray.count) return CGSizeZero;
        
    VideoListModel *model = _dataArray[indexPath.item];
    VideoItemSizeModel *sizeModel =  model.itemSizeModel;
    return sizeModel?CGSizeMake(sizeModel.itemWidth, sizeModel.itemHeight):CGSizeZero;
}

#pragma mark -
- (void)loadData:(id _Nullable)sender {
    self.collectionView.allowsSelection = NO;
    if (sender && [sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        _page ++;
    }else {
        _page = 0;
        if (_dataArray.count) [_dataArray removeAllObjects];
    }
    if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
        [SVProgressHUD show];
    }
    _urlString = [ApiUtilHeader getIndexMineCollectionList];
    _params[@"uid"] = [UserInfoManager shareManager].uid;
    _params[@"page"] = [NSString stringWithFormat:@"%@",@(_page)];
    
    [ApiUtil postWithParent:self url:_urlString needHUD:NO params:_params.copy success:^(NSInteger code, id  _Nullable response) {
        [self.collectionView endAllFreshing];
        
        NSArray*array = (NSArray *)[response objectForKey:@"data"];
        if (array && array.count) {
            [_dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[VideoListModel class] json:array]];
            
            [_dataArray enumerateObjectsUsingBlock:^(VideoListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ///置顶数据的宽高为固定值，其他数据为瀑布流源数据，动态计算并缓存
                ///sort值不为0的k均为瀑布流数据
                ///处理cell高度
                VideoItemSizeModel *itemModel = [VideoItemSizeModel new];
                itemModel.itemWidth = (self.view.width - ADAptationMargin*3)/2;
                itemModel.imageWidth = itemModel.itemWidth;
                itemModel.textWidth = itemModel.itemWidth;
                //计算图片高度
                if (obj.image_width != 0 && obj.image_height != 0) {
                    itemModel.imageHeight = itemModel.itemWidth* obj.image_height/obj.image_width;
                }else {
                    itemModel.imageHeight = itemModel.itemWidth;
                }
                //计算cell高度
                itemModel.itemHeight = itemModel.imageHeight + 40.0f;
                obj.itemSizeModel = itemModel;
                
                [_dataArray replaceObjectAtIndex:idx withObject:obj];
            }];
            [self.collectionView updataFreshFooter:(_dataArray.count && array.count != MaxListCount)];
        }
        [self.collectionView ly_updataEmptyView:!_dataArray.count];
        self.collectionView.mj_footer.hidden = !_dataArray.count;
        [self.collectionView reloadData];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [SVProgressHUD showError:errorMsg];
        [self.collectionView endAllFreshing];
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
