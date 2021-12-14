//
//  VideoReplayListViewController.m
//  ArtMedia2
//
//  Created by 刘洋 on 2020/10/19.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "VideoReplayListViewController.h"
#import <SJVideoPlayer/SJVideoPlayer.h>
#import "NSAttributedString+SJMake.h"
#import "VideoListCell.h"

#import "AMCourseModel.h"
#import "VideoReplayModel.h"
@interface VideoReplayListViewController ()<UITableViewDelegate , UITableViewDataSource ,SJVideoPlayerControlLayerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *videoBackView;
@property (nonatomic , strong) AMCourseModel *courseModel;
@property (nonatomic , strong) VideoReplayModel *videoReplayModel;//视频回放地址Model
@property (weak, nonatomic) IBOutlet UIView *navgationView;
@property (nonatomic, strong) SJVideoPlayer *player;

@end

@implementation VideoReplayListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navgationView.hidden = YES;
    [self setTableView];
    [self loadData];
    [self selectPlaybackAddressByChapterId];
}
- (void)selectPlaybackAddressByChapterId{
    //请求新的播放地址
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"chapterId"] = self.chapterModel.chapterId;
    [ApiUtil getWithParent:self url:[ApiUtilHeader selectPlaybackAddressByChapterId] params:dic success:^(NSInteger code, id  _Nullable response) {
        self.videoReplayModel = [VideoReplayModel yy_modelWithDictionary:response[@"data"]];
        [self creatPlayer];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        
    }];
}
- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}
//创建播放器
- (void)creatPlayer{
    _player = [SJVideoPlayer player];
    if (isiOS14) {
        _player.defaultEdgeControlLayer.automaticallyShowsPictureInPictureItem = NO;
    }
    _player.controlLayerDelegate = self;
    _player.defaultEdgeControlLayer.showResidentBackButton = YES;
    _player.pausedToKeepAppearState = YES;
    _player.controlLayerAppearManager.interval = 5; // 设置控制层隐藏间隔
    _player.resumePlaybackWhenAppDidEnterForeground = YES;
    _player.showMoreItemToTopControlLayer = NO;
    NSURL *videoUrl = [NSURL URLWithString:self.videoReplayModel.videoSourceId];
    SJVideoPlayerURLAsset *asset = [[SJVideoPlayerURLAsset alloc] initWithURL:videoUrl];
    asset.startPosition = 0;
//    asset.trialEndPosition = 30; // 试看30秒
    asset.attributedTitle = [NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
        make.append(self.chapterModel.chapterTitle);
        make.textColor(UIColor.whiteColor);
    }];
    _player.URLAsset = asset;
    [self.videoBackView addSubview:_player.view];
    [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    __weak typeof(self) _self = self;
    _player.rotationObserver.rotationDidStartExeBlock = ^(id<SJRotationManager>  _Nonnull mgr) {
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
#ifdef DEBUG
        NSLog(@"%d \t %s", (int)__LINE__, __func__);
#endif
    };
}
- (void)setTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsMake(15, 0, 15, 0);
    self.tableView.separatorColor = RGB(230, 230, 230);
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([VideoListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([VideoListCell class])];
}
- (void)loadData{
    [ApiUtil getWithParent:self url:[ApiUtilHeader selectPlaybackCourseChapterList:self.chapterModel.courseId] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response) {
        self.courseModel = [AMCourseModel yy_modelWithDictionary:response[@"data"]];
//        [self.courseModel.courseChapters enumerateObjectsUsingBlock:^(AMCourseChapterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if ([self.chapterId isEqualToString:obj.chapterId]) {
//                self.chapterModel = obj;
//            }
//        }];
        [self.tableView reloadData];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        
    }];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_player vc_viewDidAppear];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [_player vc_viewWillDisappear];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_player vc_viewDidDisappear];
}


- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark - UITableViewDelegate , UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VideoListCell class]) forIndexPath:indexPath];
    cell.courseModel = self.courseModel;
    cell.model = self.courseModel.courseChapters[indexPath.row];
    cell.chapterId = self.chapterModel.chapterId;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.courseModel.courseChapters.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AMCourseChapterModel *model = self.courseModel.courseChapters[indexPath.row];
//    self.chapterId = self.courseModel.courseChapters[indexPath.row].chapterId;
    
    if ([model.liveStatus isEqualToString:@"6"]) {
        self.chapterModel = model;
        //请求新的播放地址
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"chapterId"] = self.courseModel.courseChapters[indexPath.row].chapterId;
        NSLog(@"%@",dic);
        [ApiUtil getWithParent:self url:[ApiUtilHeader selectPlaybackAddressByChapterId] params:dic success:^(NSInteger code, id  _Nullable response) {
            self.videoReplayModel = [VideoReplayModel yy_modelWithDictionary:response[@"data"]];
            [self.tableView reloadData];
        } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
            
        }];
    }
}

#pragma mark - SET
- (void)setVideoReplayModel:(VideoReplayModel *)videoReplayModel{
    _videoReplayModel = videoReplayModel;
    self.player.assetURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",videoReplayModel.videoSourceId]];
//    self.player.assetURL = [NSURL URLWithString:@"http://1500002187.vod2.myqcloud.com/6c988edavodcq1500002187/70a64a705285890808635681531/e53836b706a27c7a1d16bb27.mp4"];
    self.player.URLAsset.attributedTitle = [[NSAttributedString alloc] initWithString:self.chapterModel.chapterTitle];
}


#pragma mark - SJVideoPlayerControlLayerDelegate

/// Call it when player will rotate, `isFull` if YES, then full screen.
/// 当播放器将要旋转的时候, 会回调这个方法
/// isFull 标识是否是全屏
- (void)videoPlayer:(__kindof SJBaseVideoPlayer *)videoPlayer willRotateView:(BOOL)isFull{
    NSLog(@"%d",isFull);
}

/// When rotated player, this method will be called.
/// 当播放器旋转完成的时候, 会回调这个方法
/// isFull 标识是否是全屏
- (void)videoPlayer:(__kindof SJBaseVideoPlayer *)videoPlayer didEndRotation:(BOOL)isFull{
    NSLog(@"%d",isFull);
}

///  When `fitOnScreen` of player will change, this method will be called;
/// 当播放器即将全屏(但不旋转)时, 这个方法将会被调用
- (void)videoPlayer:(__kindof SJBaseVideoPlayer *)videoPlayer willFitOnScreen:(BOOL)isFitOnScreen{

}
- (void)videoPlayer:(__kindof SJBaseVideoPlayer *)videoPlayer didCompleteFitOnScreen:(BOOL)isFitOnScreen{

}


@end
