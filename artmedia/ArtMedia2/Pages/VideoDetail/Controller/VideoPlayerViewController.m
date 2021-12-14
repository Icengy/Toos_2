//
//  VideoPlayerViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/25.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "VideoPlayerViewController.h"

#import <WXApi.h>

#import "MainNavigationController.h"

#import "OrderFillViewController.h"
#import "AMBaseUserHomepageViewController.h"
#import "GiftViewController.h"
#import "DiscussViewController.h"

#import "GoodsPartViewController.h"

#import "VideoListModel.h"

#import "VideoPlayerCollectionViewCell.h"
#import "AMShareView.h"
#import "AMReportView.h"
#import "DiscussInputView.h"

#import "AMVideoPlayer.h"

@interface VideoPlayerViewController () <VideoPlayerCellDelegate, AMVideoPlayerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, AMShareViewDelegate, DiscussInputDelegate,ZFSliderViewDelegate>

@property (nonatomic ,strong) UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong)  NSMutableArray        <VideoListModel *>*videos;

// 记录滑动前的播放状态
@property (nonatomic, assign) BOOL                        isPlaying_beforeScroll;

@property (nonatomic ,strong)  AMVideoViewModel   *viewModel;
///
@property (nonatomic, strong) AMVideoPlayer           *player;

@property (nonatomic ,strong) NSIndexPath              *currentIndexPath;
@property (nonatomic ,strong) NSDictionary *shareData;

@end

@implementation VideoPlayerViewController

- (instancetype)initWithStyle:(MyVideoShowStyle)style videos:(NSArray *)videos playIndex:(NSInteger)playIndex listUrlStr:(NSString *_Nullable)urlStr params:(NSDictionary *_Nullable)params {
	if (self = [super init]) {
        self.style = style;
        
        self.listVideos = videos;
        self.videoID = self.videos[playIndex].ID;
        self.playIndex = playIndex;
        
        self.viewModel.urlString = urlStr;
		self.viewModel.params = params;
		self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:playIndex];
	}
	return self;
}

- (instancetype)initWithVideoID:(NSString *)videoID {
	if (self = [super init]) {
        self.style = MyVideoShowStyleForSingle;
		self.videos = [[NSMutableArray alloc] initWithObjects:[VideoListModel new], nil];
		self.videoID = videoID;
        self.playIndex = 0;
        
        self.viewModel.urlString = nil;
        self.viewModel.params = nil;
		self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	}return self;
}

- (NSMutableArray <VideoListModel *>*)changeToVideoListModelArray:(NSArray *)videos {
    __block NSMutableArray <VideoListModel *>*newVideos = videos.mutableCopy;
    [videos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[VideoListModel class]]) {
            VideoListModel *model = [VideoListModel yy_modelWithDictionary:(NSDictionary *)obj];
            [newVideos replaceObjectAtIndex:idx withObject:model];
        }
    }];
    return newVideos;
}

- (void)dealloc {
	[self destoryPlayer];
	
	NSLog(@"playerVC dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	self.view.backgroundColor = RGB(0, 0, 0);
    self.barStyle = UIStatusBarStyleLightContent;
	
    self.collectionView.collectionViewLayout = self.flowLayout;
	self.collectionView.delegate = self;
	self.collectionView.dataSource = self;
    self.collectionView.scrollsToTop = NO;
    
	if (@available(iOS 11.0, *)) {
		self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}
	[self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([VideoPlayerCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([VideoPlayerCollectionViewCell class])];
    
    [self.collectionView scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    
    if (self.style && self.currentIndexPath.section == self.videos.count - 1) {
        [self loadMoreData:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	 //将status bar 文本颜色设置为白色
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
	
    [self playVideo];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	//将status bar 文本颜色设置为默认
	self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
	
	// 停止播放
	[self pause];
}

#pragma mark -
- (void)setStyle:(MyVideoShowStyle)style {
    _style = style;
    _viewModel.style = _style;
    
    [self updatePlaySource];
}

- (void)setPlayIndex:(NSInteger)playIndex {
    _playIndex = playIndex;
    
    [self updatePlaySource];
}

- (void)setUrlStr:(NSString *)urlStr {
    _urlStr = urlStr;
    _viewModel.urlString = _urlStr;
    
    [self updatePlaySource];
}

- (void)setParams:(NSDictionary *)params {
    _params = params;
    _viewModel.params = params;
    
    [self updatePlaySource];
}

- (void)setVideoID:(NSString *)videoID {
    _videoID = videoID;
    
//    [self updatePlaySource];
}

- (void)setListVideos:(NSArray *)listVideos {
    _listVideos = listVideos;
    
    self.videos = [self changeToVideoListModelArray:_listVideos];
}

- (void)updatePlaySource {
    
    if (self.style == MyVideoShowStyleForList) {
        self.videoID = [self.videos[self.playIndex] ID];
        self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:self.playIndex];
    }
    if (self.style && self.currentIndexPath.section == self.videos.count - 1) {
        [self loadMoreData:nil];
    }
    [self.collectionView reloadData];
}

#pragma mark - Private Methods
- (void)playVideo {
	
	// 移除原来的播放
	[self.player removeVideo];
    self.shareData = @{};
	
	NSLog(@"当前播放索引====%zd", self.currentIndexPath.section);
	if (self.style) {
		NSString *videoID = [(VideoListModel *)self.videos[self.currentIndexPath.section] ID];
		if (![videoID isEqualToString:self.videoID]) {
			self.videoID = videoID;
		}
	}
    if (![ToolUtil isEqualToNonNull:self.videoID]) return;
//    [self.collectionView scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
	///更新当前Model数据
    self.collectionView.allowsSelection = NO;
	[self.viewModel refreshAnyVideoDetailWithVideoID:self.videoID success:^(VideoListModel * _Nonnull model) {
		[self.collectionView endAllFreshing];
		if (model) {
			[self.videos replaceObjectAtIndex:self.currentIndexPath.section withObject:model];
			[self.collectionView reloadData];
			dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *indexPath = [self.collectionView indexPathForCell:self.collectionView.visibleCells.lastObject];
                if (self.currentIndexPath != indexPath) {
                    [self.collectionView scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
                }
				// 重新播放
				@weakify(self);
				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
					@strongify(self);
					VideoPlayerCollectionViewCell *cell = (VideoPlayerCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.currentIndexPath];
					cell.videoModel = model;
					[self.player playVideoWithView:cell.controlView.coverImgView url:cell.controlView.model.video_url];
				});
			});
        }
    } failure:^(NSString * _Nullable errorStr) {
        [self.collectionView endAllFreshing];
        [SVProgressHUD showError:errorStr];
    }];
}

- (void)pause {
	if (self.player.isPlaying) {
		self.isPlaying_beforeScroll = YES;
	}else {
		self.isPlaying_beforeScroll = NO;
	}
	
	[self.player pausePlay];
}

- (void)resume {
	if (self.isPlaying_beforeScroll) {
		[self.player resumePlay];
	}
}

- (void)destoryPlayer {
	[self.player removeVideo];
	[self.player deallocPlay];
}

#pragma mark - AMVideoViewDelegate
- (void)didClickForPlayControl:(id)sender {
	if (self.player.isPlaying) {
		[self.player pausePlay];
	}else {
		[self.player resumePlay];
	}
}

- (void)resetVideoModel:(VideoListModel *)newVideoModel atIndexPath:(nonnull NSIndexPath *)indexPath {
	[self.videos replaceObjectAtIndex:indexPath.section withObject:newVideoModel];
}

////收藏
//- (void)videoCell:(VideoPlayerCollectionViewCell *)cell didClickCollect:(VideoListModel *)videoModel atIndexPath:(NSIndexPath *)indexPath {
//	[self clickToThumsOrCollectWithCell:cell model:videoModel atIndexPath:indexPath type:0];
//}

//点赞
- (void)videoCell:(VideoPlayerCollectionViewCell *)cell didClickLike:(nonnull AMButton *)sender model:(nonnull VideoListModel *)videoModel atIndexPath:(nonnull NSIndexPath *)indexPath {
    [self clickToThumsOrCollect:sender withCell:cell model:videoModel atIndexPath:indexPath type:1];
}

- (void)clickToThumsOrCollect:(AMButton *)sender withCell:(VideoPlayerCollectionViewCell *)cell model:(VideoListModel *_Nullable)model atIndexPath:(NSIndexPath *)indexPath type:(NSInteger)type {
    if (![UserInfoManager shareManager].isLogin) {
        [self jumpToLoginWithBlock:nil];
        return;
    }
	NSMutableDictionary *params = [NSMutableDictionary new];
	
    params[@"uid"] = [UserInfoManager shareManager].uid;
	params[@"objid"] = [ToolUtil isEqualToNonNullKong:model.ID];
	params[@"type"] = [NSString stringWithFormat:@"%@",@(type+1)];
	params[@"objtype"] = @"5";
	
    [ApiUtil postWithParent:self url:[ApiUtilHeader collectObject] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        if (type) {///点赞
            if (!model.islike) {
                [SVProgressHUD showSuccess:@"点赞成功"];
            }
            model.islike = !model.islike;
            NSInteger num = model.like_num.integerValue;
            if (model.islike) {
                model.like_num = [NSString stringWithFormat:@"%@",@(num +1)];
            }else {
                model.like_num = [NSString stringWithFormat:@"%@",@(num -1)];
                if (model.like_num.integerValue < 0) model.like_num = @"0";
            }
            
        }else {
            if (!model.iscollect) {
                [SVProgressHUD showSuccess:@"收藏成功"];
            }
            model.iscollect = !model.iscollect;
            NSInteger num = model.collect_num.integerValue;
            if (model.iscollect) {
                model.collect_num = [NSString stringWithFormat:@"%@",@(num +1)];
            }else {
                model.collect_num = [NSString stringWithFormat:@"%@",@(num -1)];
            }
        }
        cell.videoModel = model;
    } fail:nil];
}

/// 评论
- (void)videoCell:(VideoPlayerCollectionViewCell *)cell didClickDiscuss:(nonnull VideoListModel *)videoModel atIndexPath:(nonnull NSIndexPath *)indexPath {
    if (![UserInfoManager shareManager].isLogin) {
        [self jumpToLoginWithBlock:nil];
        return;
    }
    DiscussViewController *discuss = [[DiscussViewController alloc] init];
    discuss.videoModel = videoModel;
    [self.navigationController presentViewController:discuss animated:YES completion:nil];
}

/// 分享
- (void)videoCell:(VideoPlayerCollectionViewCell *)cell didClickShare:(nonnull VideoListModel *)videoModel {
    if (self.shareData && self.shareData.allKeys.count) {
        AMShareView *shareView = [AMShareView shareInstanceWithStyle:AMShareViewStyleInvite];
        shareView.params = self.shareData;
        shareView.delegate = self;
        [shareView show];
    }else {
        @weakify(self);
        [ApiUtil postWithParent:self url:[ApiUtilHeader getShareUrl] params:@{@"videoid":[ToolUtil isEqualToNonNullKong:videoModel.ID]} success:^(NSInteger code, id  _Nullable response) {
            @strongify(self);
            self.shareData = (NSDictionary *)[response objectForKey:@"data"];
            if (self.shareData && self.shareData.allKeys.count) {
                AMShareView *shareView = [AMShareView shareInstanceWithStyle:AMShareViewStyleInvite];
                shareView.params = self.shareData;
                shareView.delegate = self;
                [shareView show];
            }else {
                [SVProgressHUD showError:@"数据错误，分享失败"];
            }
        } fail:nil];
    }
}

/////赠送
//- (void)videoCell:(VideoPlayerCollectionViewCell *)cell didClickGift:(nonnull VideoListModel *)videoModel atIndexPath:(nonnull NSIndexPath *)indexPath {
//    if (![UserInfoManager shareManager].isLogin) {
//        [self jumpToLoginWithBlock:nil];
//        return;
//    }
//	GiftViewController *giftVC = [[GiftViewController alloc] initWithModel:videoModel];
//	giftVC.paySuccessForGift = ^(NSInteger giftNum) {
//		NSLog(@"cross here");
//		if (!videoModel.isreward) {
//			videoModel.isreward = YES;
//		}
//		NSInteger num = videoModel.reward_num.integerValue;
//		num += giftNum;
//		videoModel.reward_num = [NSString stringWithFormat:@"%@",@(num)];
//		NSInteger myNum = videoModel.myrewardnum.integerValue;
//		myNum += giftNum;
//		videoModel.myrewardnum = [NSString stringWithFormat:@"%@",@(myNum)];
//		[self.videos replaceObjectAtIndex:indexPath.section withObject:videoModel];
////		[cell.controlView showGifWithNewModel:videoModel currentCount:giftNum];
//	};
//    giftVC.payFailForGift = ^{
//        cell.videoModel = videoModel;
//    };
//	[giftVC showEnterance:self];
//}

//购物
- (void)videoCell:(VideoPlayerCollectionViewCell *)cell didClickShopping:(VideoListModel *)videoModel {
    if (![UserInfoManager shareManager].isLogin) {
        [self jumpToLoginWithBlock:nil];
        return;
    }
    GoodsPartViewController *detailVC = nil;
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 2 && [viewControllers[viewControllers.count - 2] isKindOfClass:[GoodsPartViewController class]]) {
        detailVC = viewControllers[viewControllers.count - 2];
        [self.navigationController popToViewController:detailVC animated:YES];
        return;
    }
    detailVC = [[GoodsPartViewController alloc] init];
    detailVC.goodsID = videoModel.obj_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

//更多
- (void)videoCell:(VideoPlayerCollectionViewCell *)cell didClickMore:(VideoListModel *)videoModel {
    AMShareView *shareView = [AMShareView shareInstanceWithStyle:AMShareViewStyleDefalut];
    shareView.delegate = self;
    [shareView show];
}

//个人中心
- (void)videoCell:(VideoPlayerCollectionViewCell *)cell didClickPersonal:(VideoListModel *)videoModel {
//    if (![UserInfoManager shareManager].isLogin) {
//        [self jumpToLoginWithBlock:nil];
//        return;
//    }
    AMBaseUserHomepageViewController * vc = [[AMBaseUserHomepageViewController alloc] init];
    vc.artuid = [ToolUtil isEqualToNonNullKong:videoModel.artModel.ID];
    [self.navigationController pushViewController:vc animated:YES];
}

///关注
- (void)videoCell:(VideoPlayerCollectionViewCell *)cell didClickFollow:(VideoListModel *)videoModel atIndexPath:(NSIndexPath *)indexPath {
    if (![UserInfoManager shareManager].isLogin) {
        [self jumpToLoginWithBlock:nil];
        return;
    }
	NSMutableDictionary *params = [NSMutableDictionary new];

    params[@"uid"] = [UserInfoManager shareManager].uid;
	params[@"collect_uid"] = [ToolUtil isEqualToNonNullKong:videoModel.artModel.ID];

    [ApiUtil postWithParent:self url:[ApiUtilHeader collectUser] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        VideoArtModel *artModel = videoModel.artModel;
        artModel.is_collect = !artModel.is_collect;
        int fansNum = artModel.fans_num.intValue;
        if (artModel.is_collect) {
            [SVProgressHUD showSuccess:@"关注成功"];
            artModel.fans_num = [NSString stringWithFormat:@"%d", fansNum + 1];
        }else {
            artModel.fans_num = [NSString stringWithFormat:@"%d", fansNum - 1];
        }
        videoModel.artModel = artModel;
        cell.videoModel = videoModel;
    } fail:nil];
}

- (void)videoCell:(VideoPlayerCollectionViewCell *)cell didClickBack:(id _Nullable)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)videoCell:(VideoPlayerCollectionViewCell *)cell didClickCreateTalk:(nonnull VideoListModel *)videoModel atIndexPath:(nonnull NSIndexPath *)indexPath {
    DiscussInputView *inputView = [DiscussInputView shareInstance];
    inputView.delegate = self;
    [inputView showWithKeybord:YES];
}

#pragma mark - DiscussInputDelegate
- (void)inputView:(DiscussInputView *)inputView didFinishInputWith:(NSString *)inputStr {
    VideoListModel *videoModel = (VideoListModel *)self.videos[self.currentIndexPath.section];
    if ([ToolUtil isEqualToNonNull:inputStr] && inputStr.length > 80.0f) {
        [SVProgressHUD showMsg:@""];
        return;
    }else
        [inputView hide];
    NSLog(@"didFinishInputWith = %@",inputStr);
    
    if (inputStr.length) {
        NSMutableDictionary *params = @{}.mutableCopy;
        
        params[@"obj_type"] = @"1";
        params[@"obj_id"] = [ToolUtil isEqualToNonNullKong:videoModel.ID];
        params[@"user_id"] = [UserInfoManager shareManager].uid;
        params[@"comment"] = inputStr;
        
        [ApiUtil postWithParent:self url:[ApiUtilHeader addComment] params:params.copy success:^(NSInteger code, id  _Nullable response) {
            [SVProgressHUD showSuccess:@"评论成功!" completion:^{
                [inputView hide];
                
                NSInteger comment_num = videoModel.comment_num.integerValue;
                comment_num += 1;
                videoModel.comment_num = StringWithFormat(@(comment_num));
                VideoPlayerCollectionViewCell *cell = (VideoPlayerCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.currentIndexPath];
                cell.videoModel = videoModel;
            }];
        } fail:nil];
    }
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

#pragma mark - AMShareViewDelegate
- (void)shareView:(AMShareView *)shareView didSelectedWithItemStyle:(AMShareViewItemStyle)itemStyle {
    if (![UserInfoManager shareManager].isLogin) {
        [self jumpToLoginWithBlock:nil];
        return;
    }
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
    if (![UserInfoManager shareManager].isLogin) {
        [self jumpToLoginWithBlock:nil];
        return;
    }
	AMReportView *reportView = [AMReportView shareInstance];
    
    reportView.obj_type = @"1";
    VideoListModel *videoModel = (VideoListModel *)self.videos[self.currentIndexPath.section];
    reportView.obj_id = videoModel.ID;
    
	[reportView show];
}

- (void)clickToShield:(void (^ __nullable)(void))completion {
    if (![UserInfoManager shareManager].isLogin) {
        [self jumpToLoginWithBlock:nil];
        return;
    }
    VideoListModel *videoModel = (VideoListModel *)self.videos[self.currentIndexPath.section];
	NSMutableDictionary *params = [NSMutableDictionary new];
	
	//{"uid":"142","type":"2","objtype":"5","objid":"332"}
    params[@"uid"] = [UserInfoManager shareManager].uid;
	params[@"objid"] = [ToolUtil isEqualToNonNullKong:videoModel.ID];
	params[@"type"] = @"4";
	params[@"objtype"] = @"7";
	
    @weakify(self);
    [ApiUtil postWithParent:self url:[ApiUtilHeader collectObject] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccess:@"已屏蔽此条" completion:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    @strongify(self);
                    if (completion) completion();
                    if (1 == self.videos.count) {///只有一行
                        [self.navigationController popViewControllerAnimated:YES];
                    }else {
                        NSIndexPath *indexPath = self.currentIndexPath;
                        [self.videos removeObjectAtIndex:indexPath.section];
                        if (self.currentIndexPath.section == self.videos.count) {
                            self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section - 1];
                        }
                        [self playVideo];
                    }
                });
            }];
        });
    } fail:nil];
}

#pragma mark - AMVideoPlayerDelegate
- (void)player:(AMVideoPlayer *)player statusChanged:(AMVideoPlayerStatus)status {
	VideoPlayerCollectionViewCell *cell = (VideoPlayerCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.currentIndexPath];
	switch (status) {
		case AMVideoPlayerStatusUnload:   // 未加载
			
			break;
		case AMVideoPlayerStatusPrepared:   // 准备播放
			[cell.controlView startLoading];
			break;
		case AMVideoPlayerStatusLoading: {     // 加载中
			[cell.controlView hidePlayBtn];
		}
			break;
		case AMVideoPlayerStatusPlaying: {    // 播放中
			[cell.controlView stopLoading];
			[cell.controlView hidePlayBtn];
		}
			break;
		case AMVideoPlayerStatusPaused: {     // 暂停
			[cell.controlView stopLoading];
			[cell.controlView showPlayBtn];
		}
			break;
		case AMVideoPlayerStatusEnded: {   // 播放结束
			// 重新开始播放
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				[self.player resetPlay];
			});
		}
			break;
		case AMVideoPlayerStatusError:   // 错误
			
			break;
			
		default:
			break;
	}
}

- (void)player:(AMVideoPlayer *)player currentTime:(float)currentTime totalTime:(float)totalTime progress:(float)progress {
	VideoPlayerCollectionViewCell *cell = (VideoPlayerCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.currentIndexPath];
	dispatch_async(dispatch_get_main_queue(), ^{
//		[cell.controlView setProgress:progress];
        [cell.controlView setCurrentTime:currentTime totalTime:totalTime progress:progress];
	});
}

#pragma mark - ZFSliderViewDelegate

// 滑块滑动结束
- (void)sliderTouchEnded:(float)value
{
    [self.player seekPlay:value];
}

#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return self.videos.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	VideoPlayerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([VideoPlayerCollectionViewCell class]) forIndexPath:indexPath];
	
	cell.delegate = self;
    cell.sliderDelegate = self;
	cell.currentIndexPath = indexPath;
	if (self.videos.count) cell.videoModel = self.videos[indexPath.section];

	return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	NSLog(@"scrollView.contentOffset.y/K_Height = %f",scrollView.contentOffset.y/self.flowLayout.itemSize.height);
	NSInteger index = (NSInteger)scrollView.contentOffset.y/self.flowLayout.itemSize.height;
	if (scrollView.contentOffset.y/self.flowLayout.itemSize.height == index) {
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
		if (self.currentIndexPath != indexPath) {
			self.currentIndexPath = indexPath;
			if (self.currentIndexPath.section == self.videos.count - 1) {
				[self loadMoreData:nil];
			}
			[self playVideo];
		}
	}else {
		[self.collectionView scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
	}
}

#pragma mark -
- (AMVideoViewModel *)viewModel {
	if (!_viewModel) {
		_viewModel = [[AMVideoViewModel alloc] init];
		
        _viewModel.style = self.style;
        _viewModel.superViewController = self;
		
	}return _viewModel;
}

- (UICollectionViewFlowLayout *)flowLayout {
	if (!_flowLayout) {
		_flowLayout = [[UICollectionViewFlowLayout alloc] init];
		
//		_flowLayout.minimumLineSpacing = CGFLOAT_MIN;
//		_flowLayout.minimumInteritemSpacing = CGFLOAT_MIN;
        _flowLayout.itemSize = [UIScreen mainScreen].bounds.size;
//		_flowLayout.sectionInset = UIEdgeInsetsMake(SafeAreaStatuBarHeight, 0, SafeAreaBottomHeight, 0);
	}return _flowLayout;
}

- (AMVideoPlayer *)player {
	if (!_player) {
		_player = [AMVideoPlayer sharedSingleton];
        _player.delegate = self;
	}
	return _player;
}


#pragma mark -
- (void)loadMoreData:(id)sender {
	NSLog(@"loadMoreData");
    self.collectionView.allowsSelection = NO;
	[SVProgressHUD show];
	[self.viewModel refreshMoreListWithSuccess:^(NSArray<VideoListModel *> * _Nonnull list) {
        [self.collectionView endAllFreshing];
		if (list && list.count) {
			[self.videos addObjectsFromArray:list];
			[self.collectionView reloadData];
		}else {
			if ([sender isKindOfClass:[MJRefreshAutoFooter class]]) {
				[SVProgressHUD showMsg:@"无更多数据"];
			}
		}
	} failure:^(NSError * _Nullable error) {
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
