//
//  PersonalListViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/17.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "PersonalListViewController.h"

#import "GoodsPartViewController.h"
#import "OrderFillViewController.h"

#import "PersonalCommonCollectionCell.h"
#import "PersonalEditCollectionCell.h"
#import "PersonalDraftCollectionCell.h"
#import "PersonalArtGalleryCollectionViewCell.h"
#import "PersonalFullImageCollectionCell.h"
#import "AMNewArtistMainVideoCollectionCell.h"

#import "PublishVideoViewController.h"
#import "VideoPlayerViewController.h"
#import "PersonalEditListHeaderView.h"

#import "VideoListModel.h"

#import "AMEmptyView.h"

#import "WaterCollectionViewFlowLayout.h"

@interface PersonalListViewController ()<UICollectionViewDelegate , UICollectionViewDataSource, WaterCollectionViewFlowLayoutDelegate, UIGestureRecognizerDelegate>
@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) PersonalEditListHeaderView *headerView;

@property (nonatomic ,strong) WaterCollectionViewFlowLayout *waterFlowLayout;
@property (strong , nonatomic) UICollectionViewFlowLayout *flowLayout;

@end

@implementation PersonalListViewController {
	NSInteger _page;
	NSMutableArray <VideoListModel *>*_dataArray;
	BOOL _isShowGoods;
	NSInteger _videoStatus;//0：全部、1：待审核、2：已审核
    NSString *_urlString;
    NSMutableDictionary *_params;
}
- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //    flowLayout.minimumInteritemSpacing = 8;
        _flowLayout.itemSize = CGSizeMake((K_Width - 30 -8 -8 -8 - 20)/3, (K_Width - 30 -8 -8 -8 -20)/3);
        _flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    
    }
    return _flowLayout;
}
- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view from its nib.
	
	_page = 0;
    _urlString = nil;
    _params = @{}.mutableCopy;
	_dataArray = [NSMutableArray new];
    
	if (_listType == PersonalControllerListTypeMineVideo) {
		_isShowGoods = NO;
		_videoStatus = 0;
		[self.view addSubview:self.headerView];
		@weakify(self);
		self.headerView.showGoodsSwitchBlock = ^(BOOL show) {
			@strongify(self);
			_isShowGoods = show;
			[self loadData:nil];
		};
		self.headerView.selectedVideoStatusBlock = ^(NSInteger status) {
			@strongify(self);
			_videoStatus = status;
			[self loadData:nil];
		};
	}
	[self.view addSubview:self.collectionView];

    [self.collectionView addRefreshFooterWithTarget:self action:@selector(loadData:)];
    self.collectionView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadData:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_listType == PersonalControllerListTypeMineVideo) {
        [self.headerView updateToolBar];
    }
    if (!_dataArray.count) [self loadData:nil];
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	if (_listType == PersonalControllerListTypeMineVideo) {
		[self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.top.left.right.equalTo(self.view);
			make.height.offset(NavBar_Height);
		}];
		[self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.headerView.mas_bottom);
			make.left.right.bottom.equalTo(self.view).offset(0);
		}];
	}else {
		[self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.left.top.right.bottom.equalTo(self.view).offset(0);
		}];
	}
}

- (UIScrollView *)scrollView {
    return self.collectionView;
}

#pragma mark -
- (void)loadData:(id _Nullable)sender {
    
	if (sender && [sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
		_page ++;
	}else {
		_page = 0;
        if (_dataArray.count) [_dataArray removeAllObjects];
	}
	if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
		[SVProgressHUD show];
	}
	NSString *cellIdentifier = NSStringFromClass([PersonalCommonCollectionCell class]);
    if (_params.allValues.count) [_params removeAllObjects];

	switch (_listType) {
		case PersonalControllerListTypeOtherVideo: {
			_urlString = [ApiUtilHeader getIndexOtherVideoList];
			_params[@"artuid"] = [ToolUtil isEqualToNonNullKong:_userID];
			break;
		}
		case PersonalControllerListTypeOtherLike: {
			_urlString = [ApiUtilHeader getIndexOtherLikeList];
			_params[@"artuid"] = [ToolUtil isEqualToNonNullKong:_userID];
			break;
		}
		case PersonalControllerListTypeMineVideo: {
			_urlString = [ApiUtilHeader getIndexMineVideoList];
            _userID = [UserInfoManager shareManager].uid;
			_params[@"examineState"] = [NSString stringWithFormat:@"%@",@(_videoStatus)];
			_params[@"isIncludeAuction"] = [NSString stringWithFormat:@"%@", @(_isShowGoods)];
			_params[@"uid"] = [ToolUtil isEqualToNonNullKong:_userID];
            cellIdentifier = NSStringFromClass([PersonalEditCollectionCell class]);
			break;
		}
		case PersonalControllerListTypeMineCollection: {
            _userID = [UserInfoManager shareManager].uid;
			_urlString = [ApiUtilHeader getIndexMineCollectionList];
			_params[@"uid"] = [ToolUtil isEqualToNonNullKong:_userID];
			break;
		}
		case PersonalControllerListTypeMineDraft: {
            _userID = [UserInfoManager shareManager].uid;
			_urlString = [ApiUtilHeader getIndexMineDraftList];
			_params[@"uid"] = [ToolUtil isEqualToNonNullKong:_userID];
            cellIdentifier = NSStringFromClass([PersonalDraftCollectionCell class]);
			break;
		}
        case PersonalControllerListTypeArtCreate: {
            _urlString = [ApiUtilHeader getIndexOtherVideoList];
            _params[@"artuid"] = [ToolUtil isEqualToNonNullKong:_userID];
            cellIdentifier = NSStringFromClass([PersonalFullImageCollectionCell class]);
            
            break;
        }
        case PersonalControllerListTypeArtGallery: {
            _urlString = [ApiUtilHeader getIndexOtherVideoList];
            _params[@"artuid"] = [ToolUtil isEqualToNonNullKong:_userID];
            _params[@"is_include_obj"] = @"1";
            cellIdentifier = NSStringFromClass([PersonalArtGalleryCollectionViewCell class]);
            
            self.waterFlowLayout.colums = 1;
            self.waterFlowLayout.itemSize = CGSizeMake(K_Width - ADAptationMargin*2, K_Width*3/4);
//            self.collectionView.collectionViewLayout = self.waterFlowLayout;
            self.collectionView.collectionViewLayout = self.flowLayout;
            break;
        }
		default:
			[SVProgressHUD dismiss];
			break;
	}
	
	_params[@"page"] = [NSString stringWithFormat:@"%@",@(_page)];
    [_collectionView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    
    if ([ToolUtil isEqualToNonNull:_urlString ] && _params.allValues.count) {
        [self loadVideoListData:_urlString params:_params.copy sender:sender];
	}
}

- (void)loadVideoListData:(NSString *)urlString params:(NSDictionary *)params sender:(id)sender {
    self.collectionView.allowsSelection = NO;
    [ApiUtil postWithParent:self url:urlString needHUD:NO params:params success:^(NSInteger code, id  _Nullable response) {
        [self.collectionView endAllFreshing];
        NSArray *array = @[];
        if ([[response objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
            array = (NSArray *)[response objectForKey:@"data"];
        }else if ([[response objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
            if (data && data.count) {
                array = (NSArray *)[data objectForKey:@"video"];
            }
        }
        if (array && array.count) {
            [_dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[VideoListModel class] json:array]];
            
            if (_listType == PersonalControllerListTypeArtCreate) {
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
            }
            [self.collectionView updataFreshFooter:(_dataArray.count && array.count != MaxListCount)];
            [self.collectionView ly_updataEmptyView:!_dataArray.count];
            self.collectionView.mj_footer.hidden = !_dataArray.count;
            [self.collectionView reloadData];
        }
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [SVProgressHUD showError:errorMsg];
        [self.collectionView endAllFreshing];
    }];
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//	if (_listType == PersonalControllerListTypeMineDraft) {
//		PersonalDraftCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PersonalDraftCollectionCell class]) forIndexPath:indexPath];
//
//		if (_dataArray.count) cell.model = _dataArray[indexPath.item];
//
//		return cell;
//	}else if (_listType == PersonalControllerListTypeMineVideo) {
//		PersonalEditCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PersonalEditCollectionCell class]) forIndexPath:indexPath];
//
//		if (_dataArray.count) cell.model = _dataArray[indexPath.item];
//		cell.editVideoBlock = ^(VideoListModel * _Nonnull model) {
//			[self clickToEditMineVideo:model];
//		};
//		cell.deleteVideoBlock = ^(VideoListModel * _Nonnull model) {
//			[self clickToDeleteMineVideo:model];
//		};
//
//		return cell;
//    }else if (_listType == PersonalControllerListTypeArtGallery) {
//        PersonalArtGalleryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PersonalArtGalleryCollectionViewCell class]) forIndexPath:indexPath];
//
//        if (_dataArray.count) cell.model = _dataArray[indexPath.item];
//
//        cell.buyGoodsBlock = ^(VideoListModel * _Nonnull model) {
//            [self clickToBuy:model];
//        };
//
//        return cell;
//    }else if (_listType == PersonalControllerListTypeArtCreate) {
//        PersonalFullImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PersonalFullImageCollectionCell class]) forIndexPath:indexPath];
//
//        if (_dataArray.count) cell.model = _dataArray[indexPath.item];
//        return cell;
//    }else {
//		PersonalCommonCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PersonalCommonCollectionCell class]) forIndexPath:indexPath];
//
//		if (_dataArray.count) cell.model = _dataArray[indexPath.item];
//
//		return cell;
//	}
    AMNewArtistMainVideoCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AMNewArtistMainVideoCollectionCell class]) forIndexPath:indexPath];
    if (_dataArray.count) cell.model = _dataArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	if (_listType == PersonalControllerListTypeMineDraft) {
		[self getVideoDetailWithModel:_dataArray[indexPath.item]];
    }else if (_listType == PersonalControllerListTypeArtGallery) {
        [self clickToBuy:_dataArray[indexPath.item]];
    }else {
        VideoPlayerViewController *videoDetail = [[VideoPlayerViewController alloc] initWithStyle:(MyVideoShowStyleForList) videos:_dataArray.copy playIndex:indexPath.item listUrlStr:_urlString params:_params];
        [self.navigationController pushViewController:videoDetail animated:YES];
	}
}
#pragma mark -WaterCollectionViewFlowLayoutDelegate
/**
 获取每一个item的高度
 */
//- (CGSize)flowLayout:(WaterCollectionViewFlowLayout *)flowLayout heightForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    CGFloat width = (self.view.width- ADAptationMargin*3)/2;
//    if (_listType == PersonalControllerListTypeMineDraft) {
//        return CGSizeMake(width , width *3/4);
//    }else if (_listType == PersonalControllerListTypeMineVideo) {
//        return CGSizeMake(width, width + 45.0f);
//    }else if (_listType == PersonalControllerListTypeArtGallery) {
//        return CGSizeMake(K_Width - ADAptationMargin*2, K_Width*3/4);
//    }else if (_listType == PersonalControllerListTypeArtCreate) {
//        if (!_dataArray.count) return CGSizeZero;
//        if (indexPath.item >= _dataArray.count) return CGSizeZero;
//
//        VideoListModel *model = _dataArray[indexPath.item];
//        VideoItemSizeModel *sizeModel =  model.itemSizeModel;
//        return sizeModel?CGSizeMake(sizeModel.itemWidth, sizeModel.itemHeight):CGSizeZero;
//    }
//    return CGSizeMake(width, width*0.65+40.0f);
//}

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

#pragma mark - ShoppingDetailDelegate
- (void)shoppingDetail:(BaseViewController *)shoppingDetail clickToOrderWithGoodsModel:(VideoGoodsModel *)model {
    @weakify(self);
    [shoppingDetail dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        OrderFillViewController *orderVC = [[OrderFillViewController alloc] init];
        orderVC.goodsModel = model;
        [self.navigationController pushViewController:orderVC animated:YES];
    }];
}

#pragma mark -
- (void)clickToEditMineVideo:(VideoListModel *)model {
	[self getVideoDetailWithModel:model];
}

- (void)clickToDeleteMineVideo:(VideoListModel *)model {
	AMAlertView *alert = [AMAlertView shareInstanceWithTitle:@"是否要删除该视频？" buttonArray:@[@"是", @"否"] confirm:^{
		dispatch_async(dispatch_get_main_queue(), ^{
            [ApiUtil postWithParent:self url:[ApiUtilHeader deleteVideo] params:@{@"videoid":[ToolUtil isEqualToNonNullKong:model.ID]} success:^(NSInteger code, id  _Nullable response) {
                [SVProgressHUD showSuccess:@"删除视频成功！" completion:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:ReloadDataAfterDelete object:nil];
                    [self loadData:nil];
                }];
            } fail:nil];
		});
	} cancel:nil];
	[alert show];
}

- (void)clickToBuy:(VideoListModel *)model {
    
//    ShoppingDetailViewController *detailVC = [[ShoppingDetailViewController alloc] init];
//
//    detailVC.goodsID = model.obj_id;
//    detailVC.delegate = self;
//
//    [self.navigationController presentViewController:detailVC animated:YES completion:nil];
    GoodsPartViewController *detailVC = [[GoodsPartViewController alloc] init];
    detailVC.goodsID = model.obj_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)getVideoDetailWithModel:(VideoListModel *)model {
	NSMutableDictionary *params = [NSMutableDictionary new];
	
    params[@"uid"] = [UserInfoManager shareManager].uid;
	params[@"id"] = [ToolUtil isEqualToNonNullKong:model.ID];
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader getVideoDetailForUpdate] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        VideoListModel *videoModel = [[VideoListModel alloc] init];
        
        NSDictionary *data = (NSDictionary *)response[@"data"];
        NSDictionary *videoData = [data[@"videoData"] yy_modelToJSONObject];
        
        if (_listType == PersonalControllerListTypeMineDraft) {
            if (videoData && videoData.allKeys.count) {
                videoModel = [VideoListModel yy_modelWithJSON:videoData];
                NSDictionary *goodsData = [data[@"stockData"] yy_modelToJSONObject];
                
                if (goodsData && goodsData.allKeys.count) {
                    videoModel.goodsModel = [VideoGoodsModel yy_modelWithJSON:goodsData];
                    NSMutableArray *goodsImageData = [NSMutableArray arrayWithArray:[data[@"stockimglist"] yy_modelToJSONObject]];
                    if (goodsImageData && goodsImageData.count) {
                        videoModel.goodsModel.auctionpic = [NSArray yy_modelArrayWithClass:[VideoGoodsImageModel class] json:goodsImageData];
                    }
                }
            }
            videoModel.canSaveDraft = YES;
        }else if (_listType == PersonalControllerListTypeMineVideo) {
            if (videoData && videoData.allKeys.count) {
                videoModel = [VideoListModel yy_modelWithJSON:videoData];
                NSDictionary *goodsData = [data[@"goodsData"] yy_modelToJSONObject];
                
                if (goodsData && goodsData.allKeys.count) {
                    videoModel.goodsModel = [VideoGoodsModel yy_modelWithJSON:goodsData];
                    NSMutableArray *goodsImageData = [NSMutableArray arrayWithArray:[data[@"goodsimglist"] yy_modelToJSONObject]];
                    if (goodsImageData && goodsImageData.count) {
                        videoModel.goodsModel.auctionpic = [NSArray yy_modelArrayWithClass:[VideoGoodsImageModel class] json:goodsImageData];
                    }
                }
            }
            videoModel.canSaveDraft = NO;
        }
        
        
        PublishVideoViewController *videoVC = [[PublishVideoViewController alloc] init];
        videoModel.modify_state = YES;
        videoVC.videoModel = videoModel;
        [self.navigationController pushViewController:videoVC animated:YES];
    } fail:nil];
}

#pragma mark -
- (UICollectionView *)collectionView {
	if (!_collectionView) {
//        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.waterFlowLayout];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
		_collectionView.delegate = self;
		_collectionView.dataSource = self;
		_collectionView.backgroundColor = RGB(255, 255, 255);
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([AMNewArtistMainVideoCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([AMNewArtistMainVideoCollectionCell class])];
	}return _collectionView;
}

- (PersonalEditListHeaderView *)headerView {
	if (!_headerView) {
		_headerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PersonalEditListHeaderView class]) owner:self options:nil].lastObject;
	}return _headerView;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
