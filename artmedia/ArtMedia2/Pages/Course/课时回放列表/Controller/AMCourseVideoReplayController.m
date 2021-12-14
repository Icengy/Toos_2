//
//  AMCourseVideoReplayController.m
//  ArtMedia2
//
//  Created by LY on 2020/12/15.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMCourseVideoReplayController.h"
#import "AMCourseVideoListController.h"

#import <SJVideoPlayer/SJVideoPlayer.h>
#import <Masonry/Masonry.h>
#import <SJUIKit/NSAttributedString+SJMake.h>
#import "AMCourseModel.h"
#import "VideoReplayModel.h"


//#import "SJSourceURLs.h"
//#import "SJCustomControlLayerViewController.h"

static SJEdgeControlButtonItemTag SJTestEdgeControlButtonItemTag = 101;
static SJControlLayerIdentifier SJTestControlLayerIdentifier = 101;


@interface AMCourseVideoReplayController ()<AMCourseVideoListDelegate>

@property (nonatomic, strong) SJVideoPlayer *player;
@property (nonatomic , strong) VideoReplayModel *videoReplayModel;//视频回放地址Model
@property (nonatomic , strong) AMCourseModel *courseModel;
@property (nonatomic , strong) UILabel *titleLabel;
@end

@implementation AMCourseVideoReplayController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self selectPlaybackAddressByChapterId];
    [self selectPlaybackCourseChapterList];
//    [self _setupViews];
    
    // Do any additional setup after loading the view from its nib.
}

///
/// 添加控制层到切换器中
///     只需添加一次, 之后直接切换即可.
///
//- (void)_addCustomControlLayerToSwitcher {
//    __weak typeof(self) _self = self;
//    [_player.switcher addControlLayerForIdentifier:SJTestControlLayerIdentifier lazyLoading:^id<SJControlLayer> _Nonnull(SJControlLayerIdentifier identifier) {
//        __strong typeof(_self) self = _self;
//        if ( !self ) return nil;
//        SJCustomControlLayerViewController *vc = SJCustomControlLayerViewController.new;
//        vc.delegate = self;
//        return vc;
//    }];
//}

///
/// 切换控制层
///
- (void)switchControlLayer {
    if ( _player.isFullScreen == NO ) {
        [_player rotate:SJOrientation_LandscapeLeft animated:YES completion:^(SJVideoPlayer * _Nonnull player) {
           [player.switcher switchControlLayerForIdentitfier:SJTestControlLayerIdentifier];
        }];
    }
    else {
        [self.player.switcher switchControlLayerForIdentitfier:SJTestControlLayerIdentifier];
    }
}

///
/// 点击空白区域, 切换回旧控制层
///
- (void)tappedBlankAreaOnTheControlLayer:(id<SJControlLayer>)controlLayer {
    [self.player.switcher switchControlLayerForIdentitfier:SJControlLayer_Edge];
}

#pragma mark -

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
 
- (void)_setupViews {
    _player = [SJVideoPlayer player];
    if (isiOS14) {
        _player.defaultEdgeControlLayer.automaticallyShowsPictureInPictureItem = NO;
    }
    
    [self _removeExtraItems];
//    [self _addSwitchItem];
//    [self _addCustomControlLayerToSwitcher];
    NSURL *videoUrl = [NSURL URLWithString:self.videoReplayModel.videoSourceId];
    _player.URLAsset = [SJVideoPlayerURLAsset.alloc initWithURL:videoUrl];
    [self.view addSubview:_player.view];
    [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"icon-liveShowdet-listIOS"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showVideoList) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.x = K_Width - button.width - 15;
    button.y = 50;
    [self.player.view addSubview:button];
    
    UIButton *backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backbutton setBackgroundImage:[UIImage imageNamed:@"backwhite"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backbutton sizeToFit];
    backbutton.x = 15;
    backbutton.y = 50;
    [self.player.view addSubview:backbutton];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = self.chapterModel.chapterTitle;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [titleLabel sizeToFit];
    titleLabel.x = CGRectGetMaxX(backbutton.frame) + 10;
    titleLabel.centerY = backbutton.centerY;
    titleLabel.width = K_Width - 30 -button.width - backbutton.width - 10;
    self.titleLabel = titleLabel;
    [self.player.view addSubview:titleLabel];
    
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)showVideoList{
    AMCourseVideoListController *vc = [[AMCourseVideoListController alloc] init];
    vc.delegate = self;
    vc.courseModel = self.courseModel;
    vc.chapterModel = self.chapterModel;
    [vc showWithController:self];
}


- (void)selectPlaybackAddressByChapterId{
    //请求新的播放地址
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"chapterId"] = self.chapterModel.chapterId;
    [ApiUtil getWithParent:self url:[ApiUtilHeader selectPlaybackAddressByChapterId] params:dic success:^(NSInteger code, id  _Nullable response) {
        self.videoReplayModel = [VideoReplayModel yy_modelWithDictionary:response[@"data"]];
        [self _setupViews];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        
    }];
}
- (void)selectPlaybackCourseChapterList{
    [ApiUtil getWithParent:self url:[ApiUtilHeader selectPlaybackCourseChapterList:self.chapterModel.courseId] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response) {
        if (response) {
            self.courseModel = [AMCourseModel yy_modelWithDictionary:response[@"data"]];
        }

    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        
    }];
    
    
}



- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

///
/// 删除当前demo不需要的item
///
- (void)_removeExtraItems {
    [_player.defaultEdgeControlLayer.bottomAdapter removeItemForTag:SJEdgeControlLayerBottomItem_FullBtn];
    [_player.defaultEdgeControlLayer.topAdapter removeItemForTag:SJEdgeControlLayerTopItem_Back];
//    [_player.defaultEdgeControlLayer.bottomAdapter removeItemForTag:SJEdgeControlLayerBottomItem_Separator];
//    [_player.defaultEdgeControlLayer.bottomAdapter exchangeItemForTag:SJEdgeControlLayerBottomItem_DurationTime withItemForTag:SJEdgeControlLayerBottomItem_Progress];
//    SJEdgeControlButtonItem *durationItem = [_player.defaultEdgeControlLayer.bottomAdapter itemForTag:SJEdgeControlLayerBottomItem_DurationTime];
//    durationItem.insets = SJEdgeInsetsMake(8, 16);
//    _player.defaultEdgeControlLayer.bottomContainerView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.6];
//    _player.defaultEdgeControlLayer.topContainerView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.6];
//    [_player.defaultEdgeControlLayer.bottomAdapter reload];
}

///
/// 添加一个切换控制层的item(在右侧)
///
- (void)_addSwitchItem {
    _player.defaultEdgeControlLayer.rightMargin = 12; // 距离右边屏幕的间隔
    
    SJEdgeControlButtonItem *switchItem = [SJEdgeControlButtonItem.alloc initWithImage:[UIImage imageNamed:@"2"] target:self action:@selector(switchControlLayer) tag:SJTestEdgeControlButtonItemTag];
    [_player.defaultEdgeControlLayer.rightAdapter addItem:switchItem];
    [_player.defaultEdgeControlLayer.rightAdapter reload];

}
- (void)setVideoReplayModel:(VideoReplayModel *)videoReplayModel{
    _videoReplayModel = videoReplayModel;
    self.player.assetURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",videoReplayModel.videoSourceId]];
//    self.player.assetURL = [NSURL URLWithString:@"http://1500002187.vod2.myqcloud.com/6c988edavodcq1500002187/70a64a705285890808635681531/e53836b706a27c7a1d16bb27.mp4"];
    self.player.URLAsset.attributedTitle = [[NSAttributedString alloc] initWithString:self.chapterModel.chapterTitle];
}
#pragma mark - AMCourseVideoListDelegate
- (void)videoListSelect:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath model:(AMCourseChapterModel *)model{
//    AMCourseChapterModel *model = self.courseModel.courseChapters[indexPath.row];
//    self.chapterId = self.courseModel.courseChapters[indexPath.row].chapterId;
    if (![model.chapterId isEqualToString:self.chapterModel.chapterId]) {
        if ([model.liveStatus isEqualToString:@"6"]) {
            self.chapterModel = model;
            self.titleLabel.text = self.chapterModel.chapterTitle;
            //请求新的播放地址
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"chapterId"] = self.courseModel.courseChapters[indexPath.row].chapterId;
            NSLog(@"%@",dic);
            [ApiUtil getWithParent:self url:[ApiUtilHeader selectPlaybackAddressByChapterId] params:dic success:^(NSInteger code, id  _Nullable response) {
                self.videoReplayModel = [VideoReplayModel yy_modelWithDictionary:response[@"data"]];
              
            } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
                
            }];
        }
    }
    
    
    
    
}
@end
