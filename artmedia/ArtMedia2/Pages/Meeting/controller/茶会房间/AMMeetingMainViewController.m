/*
 * Module:   AMMeetingMainViewController
 *
 * Function: 使用TRTC SDK完成 1v1 和 1vn 的视频通话功能
 *
 *    1. 支持九宫格平铺和前后叠加两种不同的视频画面布局方式，该部分由 TRTCVideoViewLayout 来计算每个视频画面的位置排布和大小尺寸
 *
 *    2. 支持对视频通话的视频、音频等功能进行设置，该部分在 TRTCFeatureContainerViewController 中实现
 *       支持添加播放BGM和多种音效，该部分在 TRTCBgmContainerViewController 中实现
 *       支持对其它用户音视频的播放进行控制，该部分在 TRTCRemoteUserListViewController 中实现
 *
 *    3. 创建或者加入某一个通话房间，需要先指定 roomid 和 userid，这部分由 TRTCNewViewController 来实现
 *
 *    4. 对TRTC Engine的调用以及参数记录，定义在Settings/SDKManager目录中
 */

#import <AVFoundation/AVFoundation.h>
#import "AMMeetingMainViewController.h"
#import "UIView+Extension.h"
#import "TRTCCloudDelegate.h"
#import "TRTCVideoViewLayout.h"
#import "AMTRTCVideoView.h"
#import "TXLivePlayer.h"
#import "TRTCCloudDef.h"
#import <TCBeautyPanel/TCBeautyPanel.h>

#import "AMMeetingMemberViewController.h"

#import "UIViewController+BackButtonHandler.h"
#import "UIButton+TRTC.h"
#import "Masonry.h"
#import "AMMeetingRoomMemberModel.h"

///
/** TRTC的bizid的appid用于转推直播流，https://console.cloud.tencent.com/rav 点击【应用】【帐号信息】
 * 在【直播信息】中可以看到bizid和appid，分别填到下面这两个符号
 */
#define TX_BIZID 51944
#define TX_APPID 1259188522

/// 音视频操作CmdID
#define onOperationAudioCloseCmdID 5
#define onOperationAudioOpenCmdID 6
#define onOperationVideoCloseCmdID 7
#define onOperationVideoOpenCmdID 8
#define onOperationFinishedCmdID 9

@interface AMMeetingMainViewController() <
    TRTCCloudDelegate,
    AMTRTCVideoViewDelegate,
    BeautyLoadPituDelegate,
    TRTCCloudManagerDelegate,
    TXLivePlayListener,
    UINavigationBarDelegate,
    UIGestureRecognizerDelegate,
    TRTCVideoViewLayoutDelegate,
    AMMeetingMemberControllerDelegate> {
    
        NSString                 *_mainViewUserId;     //视频画面支持点击切换，需要用一个变量记录当前哪一路画面是全屏状态的
    
        TRTCVideoViewLayout      *_layoutEngine;
        NSMutableDictionary        <NSString *, AMTRTCVideoView *>*_remoteViewDic;      //一个或者多个远程画面的view
        
        BOOL                     _isHideSubViews;
        CGFloat                  _dashboardTopMargin;
        NSMutableArray                 <AMMeetingRoomMemberModel *>*_members;
        double _timeNum;
}

@property (weak, nonatomic) IBOutlet UIView *holderView;
@property (weak, nonatomic) IBOutlet TCBeautyPanel *beautyPanel;

@property (weak, nonatomic) IBOutlet UIStackView *toastStackView;

@property (strong, nonatomic) UIBarButtonItem *backItem; //返回按钮
@property (strong, nonatomic) UIBarButtonItem *back2Item; //返回主页面按钮
@property (strong, nonatomic) AMButton *rightBtn; //导航栏右边按钮

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolsStack_trailing_constraint;
@property (weak, nonatomic) IBOutlet UIStackView *toolsStackView;

@property (weak, nonatomic) IBOutlet UIView *timingView;
@property (weak, nonatomic) IBOutlet UILabel *timingLabel;


@property (weak, nonatomic) IBOutlet AMButton *layoutButton; //布局切换（九宫格 OR 前后叠加）
@property (weak, nonatomic) IBOutlet AMButton *memberButton; //成员列表
@property (weak, nonatomic) IBOutlet AMButton *beautyButton; //美颜开关
@property (weak, nonatomic) IBOutlet AMButton *cameraButton; //前后摄像头切换
@property (weak, nonatomic) IBOutlet AMButton *muteButton; //音频上行静音开关
@property (weak, nonatomic) IBOutlet AMButton *managerButton; //管理

@property (strong, nonatomic) AMTRTCVideoView* localView; //本地画面的view

@property (strong, nonatomic) TRTCCloud *trtc;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation AMMeetingMainViewController

#pragma mark - privte
+ (AMMeetingMainViewController *)shareInstance:(LS_TRTCParams *)param {
    
    TRTCVideoEncParam *encParams = [[TRTCVideoEncParam alloc] init];
    encParams.resMode = TRTCVideoResolutionModePortrait;
    
    BOOL isMaster = [ToolUtil isEqualOwner:param.ownerID];
    encParams.videoResolution = isMaster?TRTCVideoResolution_960_540:TRTCVideoResolution_640_360;
    
    TRTCCloud *trtc = [TRTCCloud sharedInstance];
    [trtc setVideoEncoderParam:encParams];
    
    TRTCRemoteUserManager *remoteManager = [[TRTCRemoteUserManager alloc] initWithTrtc:trtc];
    [remoteManager enableAutoReceiveAudio:YES autoReceiveVideo:YES];
    
    TRTCCloudManager *manager = [[TRTCCloudManager alloc] initWithTrtc:trtc
                                                                params:param
                                                                 scene:TRTCAppSceneLIVE
                                                                 appId:TX_APPID
                                                                 bizId:TX_BIZID];
    manager.remoteUserManager = remoteManager;
    
    AMMeetingMainViewController *mainVC = [[UIStoryboard storyboardWithName:@"TRTC" bundle:nil] instantiateViewControllerWithIdentifier:@"AMMeetingMainViewController"];
    mainVC.settingsManager = manager;
    mainVC.remoteUserManager = remoteManager;
    mainVC.param = param;
    mainVC.appScene = TRTCAppSceneLIVE;
    
    return mainVC;
}

+ (NSString *)getNowTimeStamp {
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", timeInterval];
    return timeString;
}

+ (NSString *)md5StringWith:(NSDictionary *)dic {
    NSString *string = [NSString stringWithFormat:@"%@%@",dic[@"uid"], dic[@"timespan"]];
    return [string md5];
}

#pragma mark -
- (UIBarButtonItem *)backItem {
    if (!_backItem) {
        AMButton *backBtn = [AMButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 0, 44.0, 44.0);
        backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [backBtn setImage:ImageNamed(@"backwhite") forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(onClickToBack:) forControlEvents:UIControlEventTouchUpInside];
        _backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        
    }return _backItem;
}

- (AMButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [AMButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:ImageNamed(@"meetingroom-信号-1") forState:UIControlStateNormal];
        
    }return _rightBtn;
}

- (UIBarButtonItem *)back2Item {
    if (!_back2Item) {
        AMButton *back2Btn = [AMButton buttonWithType:UIButtonTypeCustom];
        [back2Btn setImage:ImageNamed(@"backwhite") forState:UIControlStateNormal];
        [back2Btn setImage:ImageNamed(@"backwhite") forState:UIControlStateHighlighted];
        [back2Btn setTitle:@"返回主界面" forState:UIControlStateNormal];
        [back2Btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        back2Btn.titleLabel.font = [UIFont addHanSanSC:18.0f fontType:0];
        [back2Btn addTarget:self action:@selector(onClickGird:) forControlEvents:UIControlEventTouchUpInside];
        back2Btn.tag = 2018;
        
        _back2Item = [[UIBarButtonItem alloc] initWithCustomView:back2Btn];
    }return _back2Item;
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerCountDown:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }return _timer;
}

- (instancetype) initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        _members = @[].mutableCopy;
    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = self.backItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    self.view.userInteractionEnabled = NO;
    
    _isHideSubViews = YES;
    
    _dashboardTopMargin = 0.15;
    _trtc = [TRTCCloud sharedInstance];
    [_trtc setDelegate:self];

    self.beautyPanel.actionPerformer = [TCBeautyPanelActionProxy proxyWithSDKObject:_trtc];

    _remoteViewDic = [[NSMutableDictionary alloc] init];
    _mainViewUserId = self.param.userId;

    // 初始化 UI 控件
    [self initUI];
    
    /// 加载用户数据
    [self loadMemberData:nil isSingle:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.barStyle = UIStatusBarStyleLightContent;
    self.navigationBarStyle = AMNavigationBarStyleTransparent;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    _dashboardTopMargin = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
    [self relayout];
    
    self.view.userInteractionEnabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
    self.barStyle = UIStatusBarStyleDefault;
    self.navigationBarStyle = AMNavigationBarStyleDetault;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)dealloc {
    [self.settingsManager exitRoom];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
         //需要注意的是self.isViewLoaded是必不可少的，其他方式访问视图会导致它加载 ，在WWDC视频也忽视这一点。
        if (self.isViewLoaded && !self.view.window) {// 是否是正在使用的视图
               //code
            self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
         }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_layoutEngine.type == TC_Gird) return;
    
    _isHideSubViews = !_isHideSubViews;
    [self hideSubViews];
}

- (void)initUI {
    if ([ToolUtil isEqualToNonNull:self.param.ownerName]) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@的会客", self.param.ownerName];
    }
    
    _timingView.backgroundColor = [Color_Black colorWithAlphaComponent:0.2];
    _timeNum = [TimeTool getDifferenceSinceDate:self.param.teaEndTime toDate:self.param.currentTime];
    [self.timer setFireDate:[NSDate distantPast]];/// 开启定时器
    
    // 布局工具栏
    [self relayoutRightToolsBar];
    
    // 本地预览view
    _localView = [AMTRTCVideoView newVideoViewWithType:VideoViewType_Local userId:self.param.userId];
    _localView.delegate = self;
    self.settingsManager.videoView = _localView;
    
    _layoutEngine = [[TRTCVideoViewLayout alloc] init];
    _layoutEngine.delegate = self;
    _layoutEngine.view = self.holderView;

    _beautyPanel.pituDelegate = self;
}

- (void)relayoutRightToolsBar {
    
    self.layoutButton.hidden = NO;
    self.beautyButton.hidden = NO;
    self.cameraButton.hidden = NO;
    self.muteButton.hidden = NO;
    self.managerButton.hidden = YES;
}

- (void)hideSubViews {
    self.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.25 animations:^{
//        [self animateToolsStackWith:!_isHideSubViews];
//        [_layoutEngine hideWith:!_isHideSubViews];
    } completion:^(BOOL finished) {
        _toolsStackView.hidden = !_isHideSubViews;
        _layoutEngine.list.hidden = !_isHideSubViews;
        if (_remoteViewDic.count) _layoutEngine.label.hidden = !_isHideSubViews;
        _beautyPanel.hidden = YES;
        self.view.userInteractionEnabled = YES;
    }];
}

- (void)animateToolsStackWith:(BOOL)hidden {
    CGFloat offsetX = 40.0f;
    if (hidden) {
        _toolsStack_trailing_constraint.constant -= offsetX;
    }else {
        _toolsStack_trailing_constraint.constant += offsetX;
    }
}

/**
 * 视频窗口排布函数，此处代码用于调整界面上数个视频画面的大小和位置
 */
- (void)relayout {
    
    NSMutableArray <AMTRTCVideoView *>*views = @[].mutableCopy;
    
    if ([_mainViewUserId isEqual:@""] || [_mainViewUserId isEqual:self.param.userId]) {
        [views addObject:_localView];
    } else if([_remoteViewDic objectForKey:_mainViewUserId] != nil) {
        [views addObject:_remoteViewDic[_mainViewUserId]];
    }
    for (id userID in _remoteViewDic) {
        AMTRTCVideoView *playerView = [_remoteViewDic objectForKey:userID];
        if ([_mainViewUserId isEqual:userID]) {
            if (_layoutEngine.type == TC_Float) {
                [playerView hiddenTag:YES];
            }
            [views addObject:_localView];
        } else {
            [views addObject:playerView];
        }
    }
    
    [_layoutEngine relayout:views];
    
    //观众角色隐藏预览view
     _localView.hidden = NO;
     if (_appScene == TRTCAppSceneLIVE && _param.role == TRTCRoleAudience)
         _localView.hidden = YES;
    
    // 更新 dashboard 边距
    UIEdgeInsets margin = UIEdgeInsetsMake(_dashboardTopMargin,  0, 0, 0);
    if (_remoteViewDic.count == 0) {
        [_trtc setDebugViewMargin:self.param.userId margin:margin];
    } else {
        NSMutableArray *uids = [NSMutableArray arrayWithObject:self.param.userId];
        [uids addObjectsFromArray:[_remoteViewDic allKeys]];
        [uids removeObject:_mainViewUserId];
        for (NSString *uid in uids) {
            [_trtc setDebugViewMargin:uid margin:UIEdgeInsetsZero];
        }
        
        [_trtc setDebugViewMargin:_mainViewUserId margin:(_layoutEngine.type == TC_Float || _remoteViewDic.count == 0) ? margin : UIEdgeInsetsZero];
    }
}

- (void)enterRoom {
    [self toastTip:@"开始进房"];
    [self.settingsManager enterRoom];
    [_beautyPanel resetAndApplyValues];
}

- (void)exitRoom {
    [self.settingsManager exitRoom];
}

- (void)configBeautyPanelTheme {
    TCBeautyPanelTheme *theme = [[TCBeautyPanelTheme alloc] init];
    theme.beautyPanelSelectionColor = [UIColor colorWithRed:0
                                                      green:109/255.0
                                                       blue:1.0
                                                      alpha:1.0];
    theme.sliderValueColor = theme.beautyPanelSelectionColor;
    theme.beautyPanelMenuSelectionBackgroundImage = [UIImage imageNamed:@"beautyPanelMenuSelectionBackgroundImage"];
    theme.sliderThumbImage = [UIImage imageNamed:@"slider"];
    self.beautyPanel.theme = theme;
}

#pragma mark - Actions
- (void)timerCountDown:(NSTimer *)timer {
//    NSLog(@"timerCountDown = %@",@(_timeNum));
    _timeNum --;
    if (_timeNum > 0) {
        if (_timeNum < (60 *10) && _layoutEngine.type == TC_Float) {/// 倒计时10分钟
            _timingView.hidden = NO;
            _timingLabel.text = [NSString stringWithFormat:@"剩余时间：%@",[TimeTool timeFormatted:_timeNum withFormater:AMDataFormatter4]];
        }else {
            _timingView.hidden = YES;
        }
    }else {
        _timingView.hidden = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)onClickToBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickGird:(AMButton *)button {
    if (button.tag == 2018) {/// 切换至平铺模式
        _layoutEngine.type = TC_Float;
        [self toolsViewHidden:NO];
        
    }else {/// 切换至九宫格模式
        if (!_remoteViewDic.count) return;
        
        _layoutEngine.type = TC_Gird;
        [self toolsViewHidden:YES];
        
        _beautyPanel.hidden = YES;
    }
    [self relayout];
}

- (void)toolsViewHidden:(BOOL)hidden {
    self.navigationItem.leftBarButtonItem = hidden?self.back2Item:self.backItem;
    _toastStackView.hidden = hidden;
    _toolsStackView.hidden = hidden;
}

- (IBAction)onClickBeautyButton:(AMButton *)button {
    _beautyPanel.hidden = !_beautyPanel.hidden;
    _isHideSubViews = NO;
//    [_layoutEngine hideWith:!_isHideSubViews];
    _toolsStackView.hidden = !_isHideSubViews;
    _layoutEngine.list.hidden = !_isHideSubViews;
    _layoutEngine.label.hidden = !_isHideSubViews;
}

- (IBAction)onClickSwitchCameraButton:(AMButton *)button {
    [self.settingsManager switchCamera];
}

- (IBAction)onClickMuteButton:(AMButton *)button {
    button.selected = !button.selected;
    AMTRTCVideoView *view = nil;
    if ([ToolUtil isEqualOwner:_localView.userId]) {
        view = _localView;
    }else {
        view = [_remoteViewDic objectForKey:[UserInfoManager shareManager].uid];
    }
    [self updateAudioStateWithView:view stateChanged:button.selected];
}

- (IBAction)onClickMemberButton:(AMButton *)sender {
    AMMeetingMemberViewController *memberVC = [[AMMeetingMemberViewController alloc] init];
    memberVC.delegate = self;
    memberVC.style = AMMeetingMemberStyleNormal;
    
    memberVC.params = self.param;
    memberVC.totalMembers = [self getExistMembers].copy;
    
    [self.navigationController presentViewController:memberVC animated:YES completion:nil];
}

- (IBAction)onClickManagerButton:(AMButton *)sender {
    
    AMMeetingMemberViewController *memberVC = [[AMMeetingMemberViewController alloc] init];
    memberVC.delegate = self;
    memberVC.style = AMMeetingMemberStyleManager;
    
    memberVC.params = self.param;
    memberVC.totalMembers = [self getExistMembers].copy;
    
    [self.navigationController presentViewController:memberVC animated:YES completion:nil];
}

#pragma mark - TRTCVideoViewDelegate
- (void)reloadUserStateWithModel:(AMMeetingRoomMemberModel *)model {
    
    NSLog(@"reloadUserStateWithModel - model.userId = %@ - model.isForbidVideo_Manager = %@ - model.isForbidAudio_Manager = %@ - model.isForbidVideo_Normal = %@ - model.isForbidAudio_Normal = %@", model.userId, @(model.isForbidVideo_Manager), @(model.isForbidAudio_Manager), @(model.isForbidVideo_Normal), @(model.isForbidAudio_Normal));
    
    /// 暂停/恢复推送本地的音视频数据
    /// mute YES：暂停；NO：恢复
    if ([model.userId isEqualToString:[UserInfoManager shareManager].uid]) {
        [self.trtc muteLocalVideo:model.isForbidVideo_Normal];
        [self.trtc muteLocalAudio:model.isForbidAudio_Normal];
    }
    
    /// 设置接收远端音视频流
    /// YES：静音；NO：取消静音
    [self.remoteUserManager setUser:model.userId isVideoMuted:model.isForbidVideo_Normal];
    [self.remoteUserManager setUser:model.userId isAudioMuted:model.isForbidAudio_Normal];
}

/// 是否接收他人的远端视频流 （修改model.isForbidVideo_Normal）重新加载
- (void)onMuteVideoBtnClick:(AMTRTCVideoView *)view stateChanged:(BOOL)stateChanged {
    [self updateVideoStateWithView:view stateChanged:stateChanged];
}
/// 是否接收他人的远端音频流 （修改model.isForbidAudio_Normal）重新加载
- (void)onMuteAudioBtnClick:(AMTRTCVideoView *)view stateChanged:(BOOL)stateChanged {
    if ([ToolUtil isEqualOwner:view.userId]) {
        self.muteButton.selected = stateChanged;
    }
    [self updateAudioStateWithView:view stateChanged:stateChanged];
}

- (void)onViewTap:(AMTRTCVideoView *)view touchCount:(NSInteger)touchCount {
    if (_layoutEngine.type == TC_Gird) {
        return;
    }
    if (view == _localView) {
        _mainViewUserId = self.param.userId;
    } else {
        for (id userID in _remoteViewDic) {
            UIView *pw = [_remoteViewDic objectForKey:userID];
            if (view == pw ) {
                _mainViewUserId = userID;
            }
        }
    }
    [self relayout];
}

#pragma mark - TRTCCloudDelegate

/**
 * WARNING 大多是一些可以忽略的事件通知，SDK内部会启动一定的补救机制
 */
- (void)onWarning:(TXLiteAVWarning)warningCode warningMsg:(NSString *)warningMsg {
    
}

/**
 * 大多是不可恢复的错误，需要通过 UI 提示用户
 */
- (void)onError:(TXLiteAVError)errCode errMsg:(NSString *)errMsg extInfo:(nullable NSDictionary *)extInfo {
    // 有些手机在后台时无法启动音频，这种情况下，TRTC会在恢复到前台后尝试重启音频，不应调用exitRoom。
    BOOL isStartingRecordInBackgroundError =
        errCode == ERR_MIC_START_FAIL &&
        [UIApplication sharedApplication].applicationState != UIApplicationStateActive;
    
    if (!isStartingRecordInBackgroundError) {
        NSString *msg = [NSString stringWithFormat:@"发生错误: %@ [%d]", errMsg, errCode];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"已退房"
                                                                                 message:msg
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
            [self exitRoom];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)onEnterRoom:(NSInteger)result {
    if (result >= 0) {
        [self toastTip:[NSString stringWithFormat:@"进房成功：[%@]",@(self.param.roomId)]];
        [self recordRoomMemberState:1];
    } else {
        [self exitRoom];
        [self toastTip:[NSString stringWithFormat:@"进房失败: [%ld]", (long)result]];
    }
}

- (void)onExitRoom:(NSInteger)reason {
    NSString *msg = [NSString stringWithFormat:@"离开房间[%@]: reason[%ld]", @(self.param.roomId), (long)reason];
    [self toastTip:msg];
}

- (void)onSwitchRole:(TXLiteAVError)errCode errMsg:(NSString *)errMsg {
}

- (void)onConnectOtherRoom:(NSString *)userId errCode:(TXLiteAVError)errCode errMsg:(NSString *)errMsg {
}

/**
 * 有新的用户加入了当前视频房间
 */
- (void)onRemoteUserEnterRoom:(NSString *)userId {
    NSLog(@"onRemoteUserEnterRoom: %@", userId);
    if (userId == nil) return;
    [self.remoteUserManager addUser:userId roomId:[NSString stringWithFormat:@"%@", @(self.param.roomId)]];
}
/**
 * 有用户离开了当前视频房间
 */
- (void)onRemoteUserLeaveRoom:(NSString *)userId reason:(NSInteger)reason {
    NSLog(@"onRemoteUserLeaveRoom: %@", userId);
    if (userId == nil) return;
    [self.remoteUserManager removeUser:userId];
    
    // 更新UI
    UIView *playerView = [_remoteViewDic objectForKey:userId];
    [playerView removeFromSuperview];
    [_remoteViewDic removeObjectForKey:userId];

    NSString* subViewId = [NSString stringWithFormat:@"%@-sub", userId];
    UIView *subStreamPlayerView = [_remoteViewDic objectForKey:subViewId];
    [subStreamPlayerView removeFromSuperview];
    [_remoteViewDic removeObjectForKey:subViewId];

    // 如果该成员是大画面，则当其离开后，大画面设置为本地推流画面
    if ([userId isEqual:_mainViewUserId] || [subViewId isEqualToString:_mainViewUserId]) {
        _mainViewUserId = self.param.userId;
    }
    
    if (_remoteViewDic.count) {
        _layoutEngine.type = TC_Float;
        [self toolsViewHidden:NO];
    }
    [self relayout];
    [self.settingsManager updateCloudMixtureParams];
}

#pragma mark -
- (void)onUserAudioAvailable:(NSString *)userId available:(BOOL)available {
    NSLog(@"onUserAudioAvailable:userId:%@ available:%u", userId, available);
    if (userId == nil) return;
//    [self.remoteUserManager setUser:userId isAudioMuted:available];
    [self.remoteUserManager updateUser:userId isAudioEnabled:available];
}

- (void)onUserVideoAvailable:(NSString *)userId available:(BOOL)available {
    NSLog(@"onUserVideoAvailable:userId:%@ available:%u", userId, available);
    if (userId == nil) return;
    
    [self.remoteUserManager updateUser:userId isVideoEnabled:available];
    
    AMMeetingRoomMemberModel *model = [self getMemberModelWithUserId:userId];
    AMTRTCVideoView *remoteView = [_remoteViewDic objectForKey:userId];
    if (model) {
        if(remoteView == nil) {
            // 创建一个新的 View 用来显示新的一路画面
            remoteView = [AMTRTCVideoView newVideoViewWithType:VideoViewType_Remote userId:userId];
            remoteView.delegate = self;
            [_remoteViewDic setObject:remoteView forKey:userId];
            
            [self relayout];
            [self.settingsManager updateCloudMixtureParams];
            [self.trtc setRemoteViewFillMode:userId mode:TRTCVideoFillMode_Fit];
        }
        remoteView.userModel = model;
        
        if (!available) {
            [self.trtc stopRemoteView:userId];
            if ([userId isEqual:_mainViewUserId]) {
                _mainViewUserId = self.param.userId;
            }
        }else {
            [self.trtc startRemoteView:userId view:remoteView];
        }
    }
}

- (void)onUserSubStreamAvailable:(NSString *)userId available:(BOOL)available {
    NSLog(@"onUserSubStreamAvailable:userId:%@ available:%u", userId, available);
    if (userId == nil) return;
    NSString* viewId = [NSString stringWithFormat:@"%@-sub", userId];
    if (available) {
        AMTRTCVideoView *remoteView = [AMTRTCVideoView newVideoViewWithType:VideoViewType_Remote userId:userId];
        remoteView.delegate = self;
        [self.view addSubview:remoteView];
        [_remoteViewDic setObject:remoteView forKey:viewId];

        [_trtc startRemoteSubStreamView:userId view:remoteView];
        [_trtc setRemoteSubStreamViewFillMode:userId mode:TRTCVideoFillMode_Fit];
    }else {
        UIView *playerView = [_remoteViewDic objectForKey:viewId];
        [playerView removeFromSuperview];
        [_remoteViewDic removeObjectForKey:viewId];
        [_trtc stopRemoteSubStreamView:userId];

        if ([viewId isEqual:_mainViewUserId]) {
            _mainViewUserId = self.param.userId;
        }
    }
    [self relayout];
}

- (void)onFirstVideoFrame:(NSString *)userId streamType:(TRTCVideoStreamType)streamType width:(int)width height:(int)height {
    NSLog(@"onFirstVideoFrame userId:%@ streamType:%@ width:%d height:%d", userId, @(streamType), width, height);
    /// 开始渲染视频的第一帧
    if ([ToolUtil isEqualToNonNull:userId]) {///本地视频
        _localView.isShowGradinent = NO;
    }else {
        AMTRTCVideoView *videoView = [_remoteViewDic objectForKey:userId];
        if (videoView) videoView.isShowGradinent = NO;
    }
}

#pragma mark -
- (void)onNetworkQuality:(TRTCQualityInfo *)localQuality remoteQuality:(NSArray<TRTCQualityInfo *> *)remoteQuality {
    
    if (_layoutEngine.type == TC_Gird) {
        self.navigationItem.rightBarButtonItem = nil;
    }else {
        [self.rightBtn setImage:[self imageForNetworkQuality:localQuality.quality] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    }
    
    [_localView setNetworkIndicatorImage:[self imageForNetworkQuality:localQuality.quality]];
    for (TRTCQualityInfo* qualityInfo in remoteQuality) {
        AMTRTCVideoView* remoteVideoView = [_remoteViewDic objectForKey:qualityInfo.userId];
        [remoteVideoView setNetworkIndicatorImage:[self imageForNetworkQuality:qualityInfo.quality]];
    }
}

- (void)onStatistics:(TRTCStatistics *)statistics {

}

- (void)onAudioRouteChanged:(TRTCAudioRoute)route fromRoute:(TRTCAudioRoute)fromRoute {
    NSLog(@"TRTC onAudioRouteChanged %@ -> %@", @(fromRoute), @(route));
}

#pragma mark - 接收自定义消息
- (void)onRecvCustomCmdMsgUserId:(NSString *)userId cmdID:(NSInteger)cmdID seq:(UInt32)seq message:(NSData *)message {
//    NSString *msg = [[NSString alloc] initWithData:message encoding:NSUTF8StringEncoding];
//    [self toastTip:[NSString stringWithFormat:@"%@: %@", userId, msg]];
    
    /*
     发送自定义消息的json

     userId: 字符型 传用户名
     isBlock: 布尔型 是否屏蔽 1:屏蔽 0:不屏蔽
     type: 整型 要屏蔽的类型(1: 麦克风 2:摄像头)

     例子
     {"userId": "陈振濂", "isBlock": true, "type": 1}
     */
    // 接收到 userId 发送的消息
    NSDictionary *data = [self dictionaryForJsonData:message];
    NSLog(@"onRecvCustomCmdMsgUserId = %@ - %@",userId, data);
    if (data && data.count) {
        if ([[data objectForKey:@"type"] integerValue] == 3) {/// 完成回调
            [self loadMemberData:userId isSingle:YES];
        }else {/// 音视频操作
            [self operationByUserID:userId withData:data];
        }
    }
}

/// 音视频操作
/// @param userId 操作人ID
/// @param data 操作数据
- (void)operationByUserID:(NSString *)userId withData:(NSDictionary *)data {
    /// 被操作人
    NSString *beOperatedUserID = [ToolUtil isEqualToNonNullKong:[data objectForKey:@"userId"]];
    /// 被操作人不是自己，不进行操作
    if (!beOperatedUserID.length || ![beOperatedUserID isEqualToString:[UserInfoManager shareManager].uid]) {
        return;
    }
    /// 查询处被操作人的model和index
    AMMeetingRoomMemberModel *memberModel = _localView.userModel;
    __block NSInteger index;
    [_members enumerateObjectsUsingBlock:^(AMMeetingRoomMemberModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([StringWithFormat(obj.userId) isEqualToString:memberModel.userId]) {
            index = idx;
        }
    }];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"teaAboutInfoId"] = @(self.param.roomId);
    params[@"operatedUser"] = [ToolUtil isEqualToNonNullKong:self.param.ownerID];
    params[@"beOperatedUser"] = beOperatedUserID;
    params[@"operationId"] = [ToolUtil isEqualToNonNullKong:memberModel.operationId];
    
    /// 1: 麦克风 2:摄像头
    NSInteger type = [[data objectForKey:@"type"] integerValue];
    /// 是否屏蔽 1:屏蔽 0:不屏蔽
    BOOL state = [[data objectForKey:@"isBlock"] boolValue];
    
    /// 得到model中存储的被操作用户的状态
    NSArray *operatedArray = [memberModel.operation componentsSeparatedByString:@","];
    ///逗号分割的字符串  1:禁言|2:不禁言,3:禁视频|4:不禁视频 默认2，4
    NSString *operatedType, *operatedAudio = @"2", *operatedVideo = @"4";
    if (operatedArray && operatedArray.count == 2) {
        operatedAudio = operatedArray.firstObject;
        operatedVideo = operatedArray.lastObject;
    }
    if (type == 1) {// 音频
        operatedAudio = state?@"2":@"1";
    }else{// 视频
        operatedVideo = state?@"4":@"3";
    }
    
    operatedType = [NSString stringWithFormat:@"%@,%@", operatedAudio, operatedVideo];
        params[@"operatedType"] = operatedType;
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader uploadRoomMemberStatus] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            AMMeetingRoomMemberModel *model = [AMMeetingRoomMemberModel yy_modelWithDictionary:data];
            model.isForbidVideo_Normal = memberModel.isForbidVideo_Normal;
            model.isForbidAudio_Normal = memberModel.isForbidAudio_Normal;
            [_members replaceObjectAtIndex:index withObject:model];
            /// 重载被操作人model
            _localView.userModel = model;
        }
        /// 通知操作人操作完成
        [self sendHello:onOperationFinishedCmdID userId:self.param.ownerID];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) { }];
}

- (void)onRecvSEIMsg:(NSString *)userId message:(NSData*)message {
    
}

#pragma mark -
- (void)onSetMixTranscodingConfig:(int)err errMsg:(NSString *)errMsg {
    NSLog(@"onSetMixTranscodingConfig err:%d errMsg:%@", err, errMsg);
}

- (void)onAudioEffectFinished:(int)effectId code:(int)code {
    
}

- (UIImage*)imageForNetworkQuality:(TRTCQuality)quality
{
    UIImage* image = nil;
    switch (quality) {
        case TRTCQuality_Down:
        case TRTCQuality_Vbad:
            image = [UIImage imageNamed:@"meetingroom-信号-4"];
            break;
        case TRTCQuality_Bad:
            image = [UIImage imageNamed:@"meetingroom-信号-3"];
            break;
        case TRTCQuality_Poor:
        case TRTCQuality_Good:
            image = [UIImage imageNamed:@"meetingroom-信号-2"];
            break;
        case TRTCQuality_Excellent:
            image = [UIImage imageNamed:@"meetingroom-信号-1"];
            break;
        default:
            break;
    }
    
    return image;
}

- (void)toastTip:(NSString *)toastInfo {
    __block UITextView *toastView = [[UITextView alloc] init];
    
    toastView.userInteractionEnabled = NO;
    toastView.scrollEnabled = NO;
    toastView.text = toastInfo;
    toastView.backgroundColor = [UIColor whiteColor];
    toastView.alpha = 0.5;

    [self.toastStackView addArrangedSubview:toastView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toastView removeFromSuperview];
    });
}

#pragma mark - BeautyLoadPituDelegate
- (void)onLoadPituStart
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self toastTip:@"开始加载资源"];
    });
}
- (void)onLoadPituProgress:(CGFloat)progress
{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self toastTip:[NSString stringWithFormat:@"正在加载资源%d %%",(int)(progress * 100)]];
//    });
}
- (void)onLoadPituFinished
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self toastTip:@"资源加载成功"];
    });
}
- (void)onLoadPituFailed
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self toastTip:@"资源加载失败"];
    });
}

#pragma mark - TXLivePlayListener

- (void)onPlayEvent:(int)EvtID withParam:(NSDictionary *)param {
    if (EvtID == PLAY_ERR_NET_DISCONNECT) {
//        [self toggleCdnPlay];
//        [self toastTip:(NSString *) param[EVT_MSG]];
    } else if (EvtID == PLAY_EVT_PLAY_END) {
//        [self toggleCdnPlay];
    }
}

- (void)onNetStatus:(NSDictionary *)param {
    NSLog(@"onNetStatus = %@",param);
}

#pragma mark - TRTCCloudManagerDelegate
- (void)roomSettingsManager:(TRTCCloudManager *)manager didSetVolumeEvaluation:(BOOL)isEnabled {
//    for (AMTRTCVideoView* videoView in _remoteViewDic.allValues) {
//        [videoView showAudioVolume:isEnabled];
//    }
}

#pragma mark - TRTCVideoViewLayoutDelegate
- (void)trtcVideoForVisibleSupplementary:(NSArray<NSString *> *)videoArray {
    if (videoArray.count) {
        [_remoteViewDic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, AMTRTCVideoView * _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:[UserInfoManager shareManager].uid] || [videoArray containsObject:key]) {
                [self.remoteUserManager setUser:obj.userModel.userId isVideoMuted:obj.userModel.isForbidVideo_Normal];
                [self.remoteUserManager setUser:obj.userModel.userId isAudioMuted:obj.userModel.isForbidAudio_Normal];
            }else {
                [_trtc muteRemoteVideoStream:obj.userId mute:YES];
            }
        }];
    }
}

#pragma mark - UINavigationBarDelegate-BackButtonHandlerProtocol
///捕捉返回按钮事件
- (BOOL)navigationShouldPopOnBackButton {
    [self recordRoomMemberState:0];
    return YES;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return NO;
}

#pragma mark - AMMeetingMemberControllerDelegate
- (void)memberController:(AMMeetingMemberViewController *)memberController didSelected:(nonnull AMButton *)sender onVideoWithModel:(nonnull AMMeetingRoomMemberModel *)model {
    if (memberController.style == AMMeetingMemberStyleManager) {/// 管理模式
        [self sendHello:sender.selected?onOperationVideoOpenCmdID:onOperationVideoCloseCmdID userId:model.userId];
    }else {/// 普通成员列表
        AMTRTCVideoView *view = nil;
        if ([_localView.userId isEqualToString:model.userId]) {
            view = _localView;
        }else {
            view = [_remoteViewDic objectForKey:model.userId];
        }
        [self updateVideoStateWithView:view stateChanged:sender.selected];
    }
}

- (void)memberController:(AMMeetingMemberViewController *)memberController didSelected:(nonnull AMButton *)sender onAudioWithModel:(nonnull AMMeetingRoomMemberModel *)model {
    if (memberController.style == AMMeetingMemberStyleManager) {/// 管理列表
        [self sendHello:sender.selected?onOperationAudioOpenCmdID:onOperationAudioCloseCmdID userId:model.userId];
    }else {/// 普通成员列表
        /// 更新model状态
        
        AMTRTCVideoView *view = nil;
        if ([_localView.userId isEqualToString:model.userId]) {
            view = _localView;
        }else {
            view = [_remoteViewDic objectForKey:model.userId];
        }
        if ([ToolUtil isEqualOwner:view.userId]) {
            self.muteButton.selected = sender.selected;
        }
        [self updateAudioStateWithView:view stateChanged:sender.selected];
    }
}


/// 发送自定义消息
/// @param cmdID cmdID
/// @param userId 被操作人ID
- (void)sendHello:(NSInteger)cmdID userId:(NSString *)userId {
    // 自定义消息命令字, 这里需要根据业务定制一套规则，这里以0x1代表发送文字广播消息为例
    NSMutableDictionary *json = @{}.mutableCopy;
    [json setObject:[ToolUtil isEqualToNonNullKong:userId] forKey:@"userId"];
    /*
     发送自定义消息的json

     userId: 字符型 传用户名
     isBlock: 布尔型 是否屏蔽 1:屏蔽 0:不屏蔽
     type: 整型 要屏蔽的类型(1: 麦克风 2:摄像头 3:完成回调)

     例子
     {"userId": "陈振濂", "isBlock": true, "type": 1}
     */
    
    switch (cmdID) {
        case onOperationAudioCloseCmdID: {/// 音频关
            [json setObject:@(1) forKey:@"type"];
            [json setObject:@(YES) forKey:@"isBlock"];
            break;
        }
        case onOperationAudioOpenCmdID: {/// 音频开
            [json setObject:@(1) forKey:@"type"];
            [json setObject:@(NO) forKey:@"isBlock"];
            break;
        }
        case onOperationVideoCloseCmdID: {/// 视频关
            [json setObject:@(2) forKey:@"type"];
            [json setObject:@(YES) forKey:@"isBlock"];
            break;
        }
        case onOperationVideoOpenCmdID: {/// 视频开
            [json setObject:@(2) forKey:@"type"];
            [json setObject:@(NO) forKey:@"isBlock"];
            break;
        }
        case onOperationFinishedCmdID: {/// 操作完成，被操作者返回的回调
            [json setObject:@(3) forKey:@"type"];
            [json setValue:@(YES) forKey:@"finished"];
            break;
        }
            
        default:
            break;
    }
    NSData *data = [json.copy yy_modelToJSONData];
    // reliable 和 ordered 目前需要一致，这里以需要保证消息按发送顺序到达为例
    if (data) {
        [self.trtc sendCustomCmdMsg:cmdID data:data reliable:YES ordered:YES];
    }
}

#pragma mark -
- (void)updateVideoStateWithView:(AMTRTCVideoView *)videoView stateChanged:(BOOL)stateChanged {
    if (!videoView)  return;
    /// 更新model状态
    AMMeetingRoomMemberModel *model = videoView.userModel;
//    if ([model.userId isEqualToString:[UserInfoManager shareManager].uid]) {
//        model.isForbidVideo_Manager = stateChanged;
//    }else
    model.isForbidVideo_Normal = stateChanged;
    
    videoView.userModel = model;
    /// 更新本地数组数据
    [_members enumerateObjectsUsingBlock:^(AMMeetingRoomMemberModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.userId isEqualToString:obj.userId]) {
            [_members replaceObjectAtIndex:idx withObject:model];
        }
    }];
}

- (void)updateAudioStateWithView:(AMTRTCVideoView *)videoView stateChanged:(BOOL)stateChanged {
    if (!videoView)  return;
    /// 更新model状态
    AMMeetingRoomMemberModel *model = videoView.userModel;
//    if ([model.userId isEqualToString:[UserInfoManager shareManager].uid]) {
//        model.isForbidAudio_Manager = stateChanged;
//    }else
    model.isForbidAudio_Normal = stateChanged;
    videoView.userModel = model;
    /// 更新本地数组数据
    [_members enumerateObjectsUsingBlock:^(AMMeetingRoomMemberModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.userId isEqualToString:obj.userId]) {
            [_members replaceObjectAtIndex:idx withObject:model];
        }
    }];
}

#pragma mark -
/// 记录房间用户状态
/// @param state 0 离开 1 进入
- (void)recordRoomMemberState:(NSInteger)state {
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"userId"] = [UserInfoManager shareManager].uid;
    params[@"teaAboutInfoId"] = StringWithFormat(@(self.param.roomId));
    params[@"inOut"] = (state%2)?@"1":@"2";
    
    [ApiUtil postWithParent:nil url:[ApiUtilHeader postRoomStatistics] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {}];
}

- (NSDictionary *)dictionaryForJsonData:(NSData *)jsonData {
    if (![jsonData isKindOfClass:[NSData class]] || jsonData.length < 1) return nil;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    if (![jsonObj isKindOfClass:[NSDictionary class]]) return nil;
    return [NSDictionary dictionaryWithDictionary:(NSDictionary *)jsonObj];
}

- (void)loadMemberData:(NSString *_Nullable)uid isSingle:(BOOL)isSingle {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"teaAboutInfoId"] = StringWithFormat(@(self.param.roomId));
    params[@"size"] = @"1000000000";
    if (isSingle) params[@"uid"] = uid;
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader getRoomMemberList] needHUD:NO params:params.copy success:^(NSInteger code, id  _Nullable response) {
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            NSArray *records = (NSArray *)[data objectForKey:@"records"];
            if (records && records.count) {
                if (isSingle) {
                    __block AMMeetingRoomMemberModel *model = [AMMeetingRoomMemberModel yy_modelWithJSON:records.lastObject];
                    [_members enumerateObjectsUsingBlock:^(AMMeetingRoomMemberModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj.userId isEqualToString:model.userId]) {
                            model.isForbidVideo_Normal = obj.isForbidVideo_Normal;
                            model.isForbidAudio_Normal = obj.isForbidAudio_Normal;
                            
                            [_members replaceObjectAtIndex:idx withObject:model];
                            *stop = YES;
                        }
                    }];
                }else {
                    _members = [NSArray yy_modelArrayWithClass:[AMMeetingRoomMemberModel class] json:records].mutableCopy;
                }
            }
        }
        
        [self loadMeetingState];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_members.count && !isSingle) {
                // 开始登录、进房
                [self enterRoom];
            }
        });
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        if (isSingle) return;
        [SVProgressHUD showError:@"获取成员数据失败，无法进房，请重试" completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

/// 重载用户model
- (void)loadMeetingState {
    [_members enumerateObjectsUsingBlock:^(AMMeetingRoomMemberModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        /// 重载房间内所有成员的View的model数据
        AMTRTCVideoView *remoteView = nil;
        if ([obj.userId isEqualToString:_localView.userId]) {
            remoteView = _localView;
        }else {
            if (_remoteViewDic && _remoteViewDic.count) {
                remoteView = [_remoteViewDic objectForKey:obj.userId];
            }
        }
        if (remoteView) {
            remoteView.userModel = obj;
        }
        NSLog(@"obj.userId = %@ - remoteView = %@",obj.userId, remoteView);
    }];
    
}

- (void)updateUserAudioAvailable:(NSString *)userId available:(BOOL)available {
    if (![ToolUtil isEqualToNonNull:userId]) return;
    self.muteButton.enabled = available;
    if (available) {
        [self.trtc startLocalAudio];
    }else {
        [self.trtc stopLocalAudio];
    }
}

- (AMMeetingRoomMemberModel *)getMemberModelWithUserId:(NSString *)userId {
    __block AMMeetingRoomMemberModel *model = nil;
    [_members enumerateObjectsUsingBlock:^(AMMeetingRoomMemberModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.userId isEqualToString:userId]) {
            model = obj;
            *stop = YES;
        }
    }];
    return model;
}

- (NSArray *)getExistMembers {
    NSMutableArray <AMMeetingRoomMemberModel *>*existArray = @[].mutableCopy;
    [existArray addObject:[self getMemberModelWithUserId:[UserInfoManager shareManager].uid]];
    
    [self.remoteUserManager.remoteUsers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, TRTCRemoteUserConfig * _Nonnull obj1, BOOL * _Nonnull stop1) {
        [_members enumerateObjectsUsingBlock:^(AMMeetingRoomMemberModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.userId isEqualToString:key]) {
                [existArray addObject:obj];
                *stop = YES;
            }
        }];
    }];

    return existArray.copy;
}

@end
