//
//  HomeNormalViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/12.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "HomeNormalViewController.h"
#import <SDCycleScrollView.h>

#import "HomeToppedCollectionViewCell.h"
#import "HomeNormalCollectionViewCell.h"
#import "HomeFullImageCollectionCell.h"
#import "HomeHeaderCollectionReusableView.h"

#import "VideoPlayerViewController.h"
#import "WebViewURLViewController.h"
//#import "CustomPersonalViewController.h"
#import "AMBaseUserHomepageViewController.h"
#import "GoodsPartViewController.h"
#import "ClassDetailViewController.h"
#import "AuctionSpecialDetailViewController.h"
#import "AuctionItemDetailViewController.h"

#import "AMEmptyView.h"
#import "AMShareView.h"
#import "AMReportView.h"

#import "VideoListModel.h"
#import "HomeInforModel.h"

#import "WaterCollectionViewFlowLayout.h"

#import "TOCropViewController.h"

@interface HomeNormalViewController () <UICollectionViewDataSource, WaterCollectionViewFlowLayoutDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate , AMShareViewDelegate, HomeHeaderDelegate>

@property (nonatomic ,strong) WaterCollectionViewFlowLayout *waterFlowLayout;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic ,strong) NSMutableArray <VideoListModel  *>    *dataArray;
@property (nonatomic ,strong) NSMutableArray <HomeBannerModel *>    *bannerArray;
@property (nonatomic ,strong) HomeBannerModel   *adModel;
@property (nonatomic ,strong) NSMutableArray <VideoArtModel   *>    *artistsArray;
@property (nonatomic ,strong) NSMutableArray <HomeInforModel  *>    *noticeArray;

@end

@implementation HomeNormalViewController {
	NSInteger _page;
	BOOL _isFinishLoad;
    VideoListModel *_selectedModel;/// 长按选中的IndexPath
    NSString *_urlString;
    NSMutableDictionary *_params;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	self.bgColorStyle = AMBaseBackgroundColorStyleGray;
	
	//初始化数据载体
    self.dataArray = [NSMutableArray new];
    self.bannerArray = [NSMutableArray new];
    self.artistsArray = [NSMutableArray new];
    self.noticeArray = [NSMutableArray new];
	
	_page = 0;
    _urlString = nil;
    _params = @{}.mutableCopy;
	_isFinishLoad = YES;
	
	self.collectionView.collectionViewLayout = self.waterFlowLayout;
	
	self.collectionView.delegate = self;
	self.collectionView.dataSource = self;
	self.collectionView.backgroundColor = [UIColor clearColor];
	
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([UICollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    
	[self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeNormalCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HomeNormalCollectionViewCell class])];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeHeaderCollectionReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HomeHeaderCollectionReusableView class])];

	self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, TabBar_Height, 0);
	if (@available(iOS 11.0, *)) {
		self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}
	
	[self.collectionView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
	[self.collectionView addRefreshFooterWithTarget:self action:@selector(loadData:)];
	
    self.collectionView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self imageStr:@"video_list_null_img" action:@selector(loadData:)];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if (_listType == -2) {
		if (![UserInfoManager shareManager].isLogin) {
			[self jumpToLoginWithBlock:nil];
			return;
		}
	}
    if (!_dataArray.count) [self loadData:nil];
}

#pragma mark -
#pragma mark ====== UICollectionViewDelegate ======
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    HomeHeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HomeHeaderCollectionReusableView class]) forIndexPath:indexPath];
    CGRect frame = {.origin = CGPointZero, .size = self.waterFlowLayout.headerReferenceSize};
    header.frame = frame;
    header.delegate = self;
    
    header.bannerImgUriArray = self.bannerArray.copy;
    header.adModel = self.adModel;
    header.artsArray = self.artistsArray.copy;
    header.noticeArray = self.noticeArray.copy;
    
    return header;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeNormalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HomeNormalCollectionViewCell class]) forIndexPath:indexPath];
    if (self.dataArray.count) {
        cell.model = self.dataArray[indexPath.item];
    }
    
    if (self.dataArray.count) cell.model = self.dataArray[indexPath.item];

    __block HomeNormalCollectionViewCell *weakCell = cell;
    cell.clickToShowMenu = ^(VideoListModel * _Nonnull model) {
        [self clickToShowMenuCell:weakCell withModel:model];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.dataArray.count) return;
	[self clickToDetailWithModel:self.dataArray[indexPath.item]];
}

#pragma mark ====== WaterCollectionViewFlowLayoutDelegate ======
/**
 获取每一个item的高度
 */
- (CGSize)flowLayout:(WaterCollectionViewFlowLayout *)flowLayout heightForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (!self.dataArray.count) return CGSizeZero;
    if (indexPath.item >= self.dataArray.count) return CGSizeZero;
    
    VideoListModel *model = self.dataArray[indexPath.item];
    VideoItemSizeModel *sizeModel =  model.itemSizeModel;
    return sizeModel?CGSizeMake(sizeModel.itemWidth, sizeModel.itemHeight):CGSizeZero;
}

#pragma mark -  HomeHeaderDelegate
/// 点击banner    0.无跳转 1拍品  2.商品 3拍场   4.艺术家首页   6.短视频   7.http协议(jump_name) 8功能栏目（adsurlid：1会客厅，2创作视频 ，3名家课堂, 4拍卖专场）9课堂
- (void)homeHeader:(HomeHeaderCollectionReusableView *)header didSelectBannerItem:(nonnull HomeBannerModel *)bannerModel {
    if (![ToolUtil isEqualToNonNull:bannerModel.adsurlid]) {
        [SVProgressHUD showError:@"数据错误，请重试或联系客服"];
        return;
    }
    if (bannerModel.jump_type.integerValue == 8) {
        if (self.clickToMoveBlock) {
            switch (bannerModel.adsurlid.integerValue) {
                case 1:///会客厅
                    self.clickToMoveBlock(2);
                    break;
                case 2:///创作视频
                    self.clickToMoveBlock(5);
                    break;
                case 3:///名家课堂
                    self.clickToMoveBlock(4);
                    break;
                case 4:///拍场
                    self.clickToMoveBlock(3);
                    break;
                    
                default:
                    break;
            }
        }
    }else if (bannerModel.jump_type.integerValue == 6) {
        [SVProgressHUD show];
        //跳转视频
        VideoListModel *model = [[VideoListModel alloc] init];
        model.ID = bannerModel.adsurlid;
        [self clickToSingleDetailWithModel:model];
    }else if (bannerModel.jump_type.integerValue == 5) {
        //跳转文章
        [ApiUtil postWithParent:self url:[ApiUtilHeader getInformationDetail] params:@{@"informationid":[ToolUtil isEqualToNonNull:bannerModel.adsurlid replace:@"0"]} success:^(NSInteger code, id  _Nullable response) {
            NSDictionary *dict = (NSDictionary *)response[@"data"];
            WebViewURLViewController *webView = [[WebViewURLViewController alloc] initWithUrlString:[dict objectForKey:@"content"]];
            NSString *title = [ToolUtil isEqualToNonNull:[dict objectForKey:@"title"] replace:@"资讯详情"];
            if (![title hasPrefix:@"资讯详情"] && title.length > 10) {
                title = [title substringToIndex:10];
                title = [NSString stringWithFormat:@"%@...",title];
            }
            webView.navigationBarTitle = title;
            [self.navigationController pushViewController:webView animated:YES];
        } fail:nil];
    }else if (bannerModel.jump_type.integerValue == 2) {
        GoodsPartViewController *detailVC = [[GoodsPartViewController alloc] init];
        detailVC.goodsID = bannerModel.adsurlid;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else if (bannerModel.jump_type.integerValue == 4) {
        AMBaseUserHomepageViewController *vc = [[AMBaseUserHomepageViewController alloc] init];
        vc.artuid = bannerModel.adsurlid;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (bannerModel.jump_type.integerValue == 7) {
        WebViewURLViewController *webView = [[WebViewURLViewController alloc] initWithUrlString:[NSString stringWithFormat:@"%@",bannerModel.jump_name]];
        webView.isShare = YES;
        webView.navigationBarTitle = [ToolUtil isEqualToNonNullKong:bannerModel.adstitle];
        webView.needSafeAreaBottomHeight = YES;
        [self.navigationController pushViewController:webView animated:YES];
    }else if (bannerModel.jump_type.integerValue == 9) {
        ClassDetailViewController *vc = [[ClassDetailViewController alloc] init];
        vc.courseId = bannerModel.adsurlid;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (bannerModel.jump_type.integerValue == 1) {
        /// 拍品
        AuctionItemDetailViewController *detailVC = [[AuctionItemDetailViewController alloc] init];
        detailVC.auctionGoodId = bannerModel.adsurlid;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else if (bannerModel.jump_type.integerValue == 3) {
        /// 专场
        AuctionSpecialDetailViewController *detailVC = [[AuctionSpecialDetailViewController alloc] init];
        detailVC.auctionFieldId = bannerModel.adsurlid;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}

/// 点击艺术家
- (void)homeHeader:(HomeHeaderCollectionReusableView *)header didSelectArtsItem:(NSUInteger)artIndex {
    VideoArtModel *artModel = self.artistsArray[artIndex];
    if (![ToolUtil isEqualToNonNull:artModel.ID]) {
        [SVProgressHUD showMsg:@"艺术家数据错误，请重试或联系客服"];
        return;
    }
    AMBaseUserHomepageViewController * vc = [[AMBaseUserHomepageViewController alloc] init];
    vc.artuid = artModel.ID;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 点击公告
- (void)homeHeader:(HomeHeaderCollectionReusableView *)header didSelectNoitceItem:(NSUInteger)noticeIndex {
    HomeInforModel *model = self.noticeArray[noticeIndex];
    if (![ToolUtil isEqualToNonNull:model.id]) {
        [SVProgressHUD showMsg:@"公告数据错误，请重试或联系客服"];
        return;
    }
    [ApiUtil postWithParent:self url:[ApiUtilHeader getInformationDetail] params:@{@"informationid":[ToolUtil isEqualToNonNull:model.id replace:@"0"]} success:^(NSInteger code, id  _Nullable response) {
        NSDictionary *dict = (NSDictionary *)response[@"data"];
        WebViewURLViewController *webView = [[WebViewURLViewController alloc] initWithUrlString:[dict objectForKey:@"content"]];
        NSString *title = [ToolUtil isEqualToNonNull:[dict objectForKey:@"title"] replace:@"公告详情"];
        if (![title hasPrefix:@"公告详情"] && title.length > 10) {
            title = [title substringToIndex:10];
            title = [NSString stringWithFormat:@"%@...",title];
        }
        webView.navigationBarTitle = title;
        [self.navigationController pushViewController:webView animated:YES];
    } fail:nil];
}

- (void)homeHeader:(HomeHeaderCollectionReusableView *)header didSelectedMeeting:(id)sender {
}

#pragma mark -
- (void)clickToDetailWithModel:(VideoListModel *)videoModel {
	[SVProgressHUD dismiss];
    VideoPlayerViewController *videoDetail = [[VideoPlayerViewController alloc] initWithStyle:MyVideoShowStyleForList videos:self.dataArray.copy playIndex:[self.dataArray indexOfObject:videoModel] listUrlStr:_urlString params:_params];
	[self.navigationController pushViewController:videoDetail animated:YES];
}

- (void)clickToSingleDetailWithModel:(VideoListModel *)videoModel {
    [SVProgressHUD dismiss];
	VideoPlayerViewController *videoDetail = [[VideoPlayerViewController alloc] initWithVideoID:videoModel.ID];
	[self.navigationController pushViewController:videoDetail animated:YES];
}

- (void)clickToShowMenuCell:(UICollectionViewCell *)cell withModel:(VideoListModel *)videoModel {
    _selectedModel = videoModel;
    
	AMShareView *shareView = [AMShareView shareInstanceWithStyle:AMShareViewStyleDefalut];
    shareView.delegate = self;
	[shareView show];
}

#pragma mark - AMShareViewDelegate
- (void)shareView:(AMShareView *)shareView didSelectedWithItemStyle:(AMShareViewItemStyle)itemStyle {
    if (itemStyle == AMShareViewItemStyleReport) {
        @weakify(self);
        [shareView hide:^{
            @strongify(self);
            [self clickToReport];
        }];
    }
    if (itemStyle == AMShareViewItemStyleShield) {
        [self clickToShield:^{
            [shareView hide:nil];
        }];
    }
}

- (void)clickToReport {
    
	AMReportView *reportView = [AMReportView shareInstance];
    reportView.obj_id = _selectedModel.ID;
    reportView.obj_type = @"1";
    
	[reportView show];
}

- (void)clickToShield:(void (^ __nullable)(void))completion {
	
	NSMutableDictionary *params = [NSMutableDictionary new];
	
	//{"uid":"142","type":"2","objtype":"5","objid":"332"}
	params[@"uid"] = [UserInfoManager shareManager].uid;
	params[@"objid"] = [ToolUtil isEqualToNonNullKong:_selectedModel.ID];
	params[@"type"] = @"4";
	params[@"objtype"] = @"7";
	
    [ApiUtil postWithParent:self url:[ApiUtilHeader collectObject] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        @weakify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccess:@"已屏蔽此条" completion:^{
                if (completion)  completion();
                @strongify(self);
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.dataArray indexOfObject:_selectedModel] inSection:0];
                [self.dataArray removeObject:_selectedModel];
                [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            }];
        });
    } fail:nil];
}

#pragma mark -
- (WaterCollectionViewFlowLayout *)waterFlowLayout {
	if (!_waterFlowLayout) {
		_waterFlowLayout = [[WaterCollectionViewFlowLayout alloc] init];
        
        _waterFlowLayout.minimumInteritemSpacing = 15.0f; //行间距
		_waterFlowLayout.minimumLineSpacing = 10.0f; //列间距
		_waterFlowLayout.sectionInset = UIEdgeInsetsMake(15.0f, 15.0f, 0.0f, 15.0f);
        
		_waterFlowLayout.delegate = self;
        
	}return _waterFlowLayout;
}

#pragma mark -
- (void)reloadCurrent:(NSNotification *)notification {
    [self loadData:notification];
}

- (void)loadData:(id _Nullable)sender {
	if (!_isFinishLoad) {
		return;
	}
	_isFinishLoad = NO;
    
    self.collectionView.allowsSelection = NO;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("com.loadData.home", DISPATCH_QUEUE_CONCURRENT);
    if (_listType == -1 && ![sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {//推荐
        dispatch_group_async(group, queue, ^{
            [self loadBannerData:sender withSemaphore:semaphore];
        });
        dispatch_group_async(group, queue, ^{
            [self loadAdData:sender withSemaphore:semaphore];
        });
    }
    dispatch_group_async(group, queue, ^{
        [self loadContentData:sender withSemaphore:semaphore];
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        _isFinishLoad = YES;
        if (_listType == -1) {
            CGFloat height = CGFLOAT_MIN;
            if (self.bannerArray.count) {
                HomeBannerModel *model = self.bannerArray.firstObject;
                if (model && [ToolUtil isEqualToNonNull:model.picture_width] && [ToolUtil isEqualToNonNull:model.picture_height] && model.picture_width.doubleValue != 0) {
                    CGFloat scale = model.picture_height.doubleValue/model.picture_width.doubleValue;
                    height += K_Width*scale;
                }
            }
            if (self.adModel && [ToolUtil isEqualToNonNull:self.adModel.picture_width] && [ToolUtil isEqualToNonNull:self.adModel.picture_height] &&  self.adModel.picture_width.doubleValue != 0) {
                CGFloat scale = self.adModel.picture_height.doubleValue/self.adModel.picture_width.doubleValue;
                height += K_Width*scale + 1.0f;
            }
            if (self.noticeArray.count) {
                height += 50.0f + ADAptationMargin;///公告高度
            }
            if (self.artistsArray.count) {
                height += 165.0f + ADAptationMargin;/// 推荐艺术家高度
            }
            self.waterFlowLayout.headerReferenceSize = CGSizeMake(K_Width, height);
            self.collectionView.collectionViewLayout = self.waterFlowLayout;
        }
        if ([sender isKindOfClass:[NSNotification class]]) {
            self.collectionView.contentOffset = CGPointMake(0, 0);
        }
        [self.collectionView reloadData];
    });
}

- (void)loadBannerData:(id)sender withSemaphore:(dispatch_semaphore_t)semaphore {
    [ApiUtil postWithParent:self url:[ApiUtilHeader getAds] needHUD:NO params:@{@"type":@"1",@"client_type":@"ios"} success:^(NSInteger code, id  _Nullable response) {
        NSArray *array = (NSArray *)response[@"data"];
        if (array && array.count) {
            if (self.bannerArray.count) [self.bannerArray removeAllObjects];
            [self.bannerArray addObjectsFromArray: [NSArray yy_modelArrayWithClass:[HomeBannerModel class] json:array]];
            
            [self.bannerArray enumerateObjectsUsingBlock:^(HomeBannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([ToolUtil isEqualToNonNull:obj.adsbanner]) {
                    NSString *url = nil;
                    if ([obj.adsbanner hasPrefix:@"https://"] || [obj.adsbanner hasPrefix:@"http://"]) {
                        url = obj.adsbanner;
                    }else {
                        if ([obj.adsbanner hasPrefix:@"group"]) {/// java
                            url = [NSString stringWithFormat:@"%@/%@", IMAGE_JAVA_HOST ,obj.adsbanner];
                        }else
                            if ([obj.adsbanner hasPrefix:@"Upload"]) {
                                url = [NSString stringWithFormat:@"%@/%@", IMAGE_HOST ,obj.adsbanner];
                            }else
                                url = [NSString stringWithFormat:@"%@%@", IMAGE_HOST ,obj.adsbanner];
                    }
                    obj.adsbanner = url;
                    [self.bannerArray replaceObjectAtIndex:idx withObject:obj];
                }
            }];
        }
        if (semaphore) dispatch_semaphore_signal(semaphore);
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        if (semaphore) dispatch_semaphore_signal(semaphore);
    }];
    if (semaphore) dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

- (void)loadRecommendArtistData:(id)sender withSemaphore:(dispatch_semaphore_t)semaphore {
//    [ApiUtil post:[ApiUtilHeader getRecommendArtist] needHUD:NO needTips:NO params:@{@"uid":[UserInfoManager shareManager].uid} success:^(id response) {
//        if (semaphore) dispatch_semaphore_signal(semaphore);
//        if ([response[@"code"] integerValue] == 0) {
//            NSArray *array = (NSArray *)response[@"data"];
//            if (array && array.count) {
//                if (self.artistsArray.count) [self.artistsArray removeAllObjects];
//                [self.artistsArray addObjectsFromArray: [NSArray yy_modelArrayWithClass:[VideoArtModel class] json:array]];
//            }
//        }
//    } fail:^(NSError *error) {
//        if (semaphore) dispatch_semaphore_signal(semaphore);
//    }];
//    if (semaphore) dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

- (void)loadAdData:(id)sender withSemaphore:(dispatch_semaphore_t)semaphore {
    [ApiUtil postWithParent:self url:[ApiUtilHeader get_slogan] needHUD:NO params:@{@"type":@"1"} success:^(NSInteger code, id  _Nullable response) {
        NSArray *data = (NSArray *)[response objectForKey:@"data"];
        if (data && data.count) {
            self.adModel = [HomeBannerModel yy_modelWithDictionary:data.firstObject];
        }
        if (semaphore) dispatch_semaphore_signal(semaphore);
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        if (semaphore) dispatch_semaphore_signal(semaphore);
    }];
    if (semaphore) dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

- (void)loadContentData:(id)sender withSemaphore:(dispatch_semaphore_t)semaphore {
    
	if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
		[SVProgressHUD show];
	}
    if (sender && [sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) _page ++;
    else {
        _page = 0;
        if (_params.count) [_params removeAllObjects];
        if (self.dataArray.count) [self.dataArray removeAllObjects];
    }
    if (_listType == -1) {//推荐
        _urlString = [ApiUtilHeader getRecommendVideoList];
        _params[@"column_id"] = @"";
    }else if (_listType == -2) {//关注
        _urlString = [ApiUtilHeader getMyCollectVideoList];
    }else {
        _urlString = [ApiUtilHeader getRecommendVideoList];
        _params[@"column_id"] = StringWithFormat(@(_listType));
    }
    
	_params[@"uid"] = [UserInfoManager shareManager].uid;
	_params[@"page"] = [NSString stringWithFormat:@"%@",@(_page)];
	
    [ApiUtil postWithParent:self url:_urlString needHUD:NO params:_params.copy success:^(NSInteger code, id  _Nullable response) {
        [self.collectionView endAllFreshing];
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            if (_page == 0) {
                _params[@"timespan"] = [data objectForKey:@"timespan"];
            }
            NSArray *videos = (NSArray *)[data objectForKey:@"video"];
            [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[VideoListModel class] json:videos]];
            [self.dataArray enumerateObjectsUsingBlock:^(VideoListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ///置顶数据的宽高为固定值，其他数据为瀑布流源数据，动态计算并缓存
                ///sort值不为0的k均为瀑布流数据
                ///处理cell高度
                VideoItemSizeModel *itemModel = [VideoItemSizeModel new];
                itemModel.itemWidth = (K_Width - self.waterFlowLayout.sectionInset.left - self.waterFlowLayout.sectionInset.right - self.waterFlowLayout.minimumLineSpacing)/2;
                itemModel.imageWidth = itemModel.itemWidth;
                itemModel.textWidth = itemModel.itemWidth;
                //计算图片高度
                if (obj.image_width != 0 && obj.image_height != 0) {
                    itemModel.imageHeight = itemModel.itemWidth* obj.image_height/obj.image_width;
                }else {
                    itemModel.imageHeight = itemModel.itemWidth;
                }
                ///计算文字高度
                CGFloat textHeight = 0.0f;
                if ([ToolUtil isEqualToNonNull:obj.video_des]) {
                    textHeight = [obj.video_des sizeWithFont:[UIFont addHanSanSC:14.0f fontType:0] andMaxSize:CGSizeMake(itemModel.itemWidth - 8.0f*2, CGFLOAT_MAX) numberOfLines:2].height;
                }
                itemModel.textHeight = textHeight;
                //计算cell高度
                itemModel.itemHeight = itemModel.imageHeight + itemModel.textHeight + 40.0f + 25.0f;

                obj.itemSizeModel = itemModel;
                                
                [self.dataArray replaceObjectAtIndex:idx withObject:obj];
            }];
            [self.collectionView updataFreshFooter:(self.dataArray.count && videos.count != MaxListCount)];
        }
        [self.collectionView ly_updataEmptyView:!self.dataArray.count];
        self.collectionView.mj_footer.hidden = !self.dataArray.count;
        
        if (semaphore) dispatch_semaphore_signal(semaphore);
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        if (semaphore) dispatch_semaphore_signal(semaphore);
        [SVProgressHUD showError:errorMsg];
        [self.collectionView endAllFreshing];
    }];
    if (semaphore) dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
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
