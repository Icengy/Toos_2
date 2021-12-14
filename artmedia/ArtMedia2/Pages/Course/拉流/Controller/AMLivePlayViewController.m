//
//  AMLivePlayViewController.m
//  ArtMedia2
//
//  Created by LY on 2020/10/28.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMLivePlayViewController.h"
#import "FKAlertProtocolController.h"
#import "FKAlertSingleController.h"
#import "AMBaseUserHomepageViewController.h"

#import "UIView+Additions.h"
#import "TXLiveSDKTypeDef.h"
#import <AVFoundation/AVFoundation.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "ColorMacro.h"
#import "ThemeConfigurator.h"
#import "UIViewController+BackButtonHandler.h"
#import "GenerateTestUserSig.h"

#import "LiveRoomAccPlayerView.h"
#import "AMLiveRoomMsgCell.h"

#import "AMLivePushModel.h"
#import "AMLiveMsgModel.h"
#import "CustomPersonalModel.h"

#import "MLVBLiveRoom.h"
#import "IMMsgManager.h"
@interface AMLivePlayViewController ()<MLVBLiveRoomDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource ,IRoomLivePlayListener >
{
    CGPoint                  _touchBeginLocation;
}
@property (nonatomic , strong) TXLivePlayer *player;


@property (nonatomic, weak)    MLVBLiveRoom* liveRoom;//房间
@property (nonatomic , strong) CustomPersonalModel *userModel;

//艺术家/老师 head
@property (weak, nonatomic) IBOutlet UIImageView *teacherHeadImageView;
@property (weak, nonatomic) IBOutlet UILabel *teacherNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *onLineNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *focusButton;


//推流相关
@property (weak, nonatomic) IBOutlet UIView *pusherView;//推流背景
@property (nonatomic , strong) AMLivePushModel *pushModel;//推流模型，里面放着从接口获取的推流地址

//课程信息相关
@property (weak, nonatomic) IBOutlet UIView *classInfoView;
@property (weak, nonatomic) IBOutlet UILabel *courseTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *chapterTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherLeaveLabel;//老师暂离的提示



//消息相关
@property (weak, nonatomic) IBOutlet UIButton *showMessageFieldButton;

@property (weak, nonatomic) IBOutlet UITableView *msgTableView;//消息列表
@property (weak, nonatomic) IBOutlet UIView *msgInputView;//输入框背景
@property (weak, nonatomic) IBOutlet AMTextField *msgInputTextField;//输入框
@property (nonatomic , strong) NSMutableArray <AMLiveMsgModel *>*msgList;//消息数组
@property (nonatomic , assign) NSInteger page;
//@property (nonatomic , strong) NSTimer *timer;
@property (nonatomic , copy) NSString *topTimeString;
@property (weak, nonatomic) IBOutlet UILabel *memberJoinTipsLabel;
@property (weak, nonatomic) IBOutlet UIView *memberJoinTipsBackView;

@property (nonatomic , copy) NSString *otherUserID;//老师看自己直播新生成的userid


@end

@implementation AMLivePlayViewController
#pragma mark - 懒加载
- (MLVBLiveRoom *)liveRoom{
    if (!_liveRoom) {
        _liveRoom = [MLVBLiveRoom sharedInstance];
        [_liveRoom setCameraMuteImage:[UIImage imageNamed:@"pause_publish.jpg"]];
        _liveRoom.delegate = self;
    }
    return _liveRoom;
}
- (NSMutableArray<AMLiveMsgModel *> *)msgList{
    if (!_msgList) {
        _msgList = [[NSMutableArray alloc] init];
    }
    return _msgList;
}
#pragma mark - SET
-(void)setPushModel:(AMLivePushModel *)pushModel{
    _pushModel = pushModel;
    [self enterRoom];
}

- (void)setUserModel:(CustomPersonalModel *)userModel{
    _userModel = userModel;
    if (userModel.userData.is_collect) {
        [self.focusButton setTitle:@"已关注" forState:UIControlStateNormal];
        self.focusButton.hidden = YES;
    }else{
        [self.focusButton setTitle:@"+ 关注" forState:UIControlStateNormal];
    }
}
-(int)getRandomNumber{
    return (int)(10 + (arc4random() % (100 - 10 + 1)));
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IMOffline) name:@"IMOffline" object:nil];
    if ([[UserInfoManager shareManager].uid isEqualToString:self.chapterModel.teacherId]) {
        self.focusButton.hidden = YES;
        self.otherUserID = [NSString stringWithFormat:@"teacher_%@_%d",[UserInfoManager shareManager].uid , [self getRandomNumber]];
        NSLog(@"%@",self.otherUserID);
    }else{
        self.otherUserID = [UserInfoManager shareManager].uid;
    }
    
    self.topTimeString = [TimeTool getCurrentDateStr];
    self.msgInputTextField.charCount = 80;
    self.msgInputTextField.placeholder = @"请输入要发送的消息";
    self.page = 1;
    [self loginRoomAndIM];
    [self setMsgTableView];
    //获取推拉流地址
//    [self getPushPullStreamAddr];
    [self updateUI];
    [self addAlertMsg];
    [self getOtherUserInfo];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [UIApplication sharedApplication].idleTimerDisabled =YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidEnterBackGround:) name:UIApplicationDidEnterBackgroundNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameDidChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [UIApplication sharedApplication].idleTimerDisabled =NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // 美颜初始化为默认值
//    [_vBeauty resetAndApplyValues];
    
    
}
- (void)dealloc{
    NSLog(@"房间已销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [self.liveRoom logout];
//    [MLVBLiveRoom destorySharedInstance];
}

#pragma mark - 刷新UI
- (void)updateUI{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoArtistHome)];
    [self.teacherHeadImageView addGestureRecognizer:tap];
    self.teacherHeadImageView.userInteractionEnabled = YES;
    
    
    ////直播状态 1:未直播  2:直播中  3:直播中讲师离开直播间  4:直播已结束=回放视频
    if ([self.chapterModel.liveStatus isEqualToString:@"1"]) {
        if ([self.courseModel.isMySelf isEqualToString:@"1"]) {
            self.classInfoView.hidden = YES;
        }else{
            self.classInfoView.hidden = NO;
        }
    }else if ([self.chapterModel.liveStatus isEqualToString:@"2"] || [self.chapterModel.liveStatus isEqualToString:@"3"]){
        self.classInfoView.hidden = YES;
        if ([self.chapterModel.liveStatus isEqualToString:@"3"]) {
            self.teacherLeaveLabel.hidden = NO;
        }
    }else if ([self.chapterModel.liveStatus isEqualToString:@"4"]){
        
    }
    if ([self.courseModel.isMySelf isEqualToString:@"1"]) {
        self.focusButton.hidden = YES;
    }
    
    //艺术家头信息展示
    self.teacherNameLabel.text = self.courseModel.teacherName;
    [self.teacherHeadImageView am_setImageWithURL:self.courseModel.headimg];
//    self.onLineNumberLabel.text = @"接口获取";
    
    //课程信息展示
    self.courseTitleLabel.text = self.courseModel.courseTitle;
    self.chapterTitleLabel.text = [NSString stringWithFormat:@"课时%@：%@",self.chapterModel.chapterSort , self.chapterModel.chapterTitle];
    self.startTimeLabel.text = [NSString stringWithFormat:@"%@开播",self.chapterModel.liveStartTime];
}
- (void)gotoArtistHome{
    AMBaseUserHomepageViewController *vc = [[AMBaseUserHomepageViewController alloc] init];
    vc.artuid = self.chapterModel.teacherId;
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - 键盘相关
// 监听键盘高度变化
- (void)keyboardFrameDidChange:(NSNotification *)notice {

    NSDictionary * userInfo = notice.userInfo;
    NSValue * endFrameValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endFrame = endFrameValue.CGRectValue;
    [UIView animateWithDuration:0.25 animations:^{
        if (endFrame.origin.y == self.view.height) {
            self.msgInputView.y = endFrame.origin.y;
        } else {
            self.msgInputView.y =  endFrame.origin.y - self.msgInputView.height;
        }
    }];
}

/// 开启预览
- (void)startCamerPreview{
    [self.liveRoom startLocalPreview:YES view:_pusherView];
}


//初始化消息TableView
- (void)setMsgTableView{
    self.msgTableView.delegate = self;
    self.msgTableView.dataSource = self;
    [self.msgTableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMLiveRoomMsgCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMLiveRoomMsgCell class])];
    [self.msgTableView addRefreshHeaderWithTarget:self action:@selector(queryPageLiveCourseChapterMsg)];
}


#pragma mark - 网络请求

/// 获取 推/拉 流地址
- (void)getPushPullStreamAddr{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"chapterId"] = self.chapterModel.chapterId;
    [ApiUtil getWithParent:self url:[ApiUtilHeader getPullStreamAddr] needHUD:NO params:dic success:^(NSInteger code, id  _Nullable response) {
        if (response && response[@"data"]) {
            self.pushModel = [AMLivePushModel yy_modelWithDictionary:response[@"data"]];
        }
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        
    }];
    
}

//更新在线人数
- (void)updateOnlineMemberNum:(void(^)(void))complain{
    [ApiUtil getWithParent:self url:[ApiUtilHeader updateOnlineMemberNum:self.pushModel.roomId] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response) {
        if (complain) {
            complain();
        }
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        
    }];
}


/// 保存聊天记录
/// @param model 消息体模型
- (void)saveTheMsgToServer:(AMLiveMsgModel *)model{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"chapterId"] = self.chapterModel.chapterId;
    dic[@"memberId"] = [UserInfoManager shareManager].uid;
    dic[@"memberName"] = [UserInfoManager shareManager].model.username;
    dic[@"liveId"] = self.pushModel.roomId;
    dic[@"msgBody"] = [self dictionary2JsonData:[model yy_modelToJSONObject]];
    [ApiUtil postWithParent:self url:[ApiUtilHeader addLiveCourseChapterMsg] needHUD:NO params:dic success:^(NSInteger code, id  _Nullable response) {
        
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        
    }];
}
- (NSString *)dictionary2JsonData:(NSDictionary *)dict {
    NSError *parseError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
    if (parseError) {
      //解析出错
    }
    NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return str;
}
/// 查询聊天记录
- (void)queryPageLiveCourseChapterMsg{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"chapterId"] = self.chapterModel.chapterId;
    dic[@"liveId"] = self.pushModel.roomId;
    dic[@"current"] = @(self.page);
    dic[@"size"] = @(10);
    dic[@"currentTime"] = self.topTimeString;
    [ApiUtil postWithParent:self url:[ApiUtilHeader queryPageLiveCourseChapterMsg] needHUD:NO params:dic success:^(NSInteger code, id  _Nullable response) {
        if (response && response[@"data"] && response[@"data"][@"records"] ) {
            NSArray <NSDictionary *>*array = (NSArray *)response[@"data"][@"records"];
            if (array.count != MaxListCount) {
                self.msgTableView.mj_header = nil;
            }else{
                self.page ++ ;
                
            }
            [array enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *json = obj[@"msgBody"];
                AMLiveMsgModel *sendModel = [AMLiveMsgModel yy_modelWithJSON:json];
                if (sendModel) {
                    [self.msgList insertObject:sendModel atIndex:1];
                }
            }];
            if (self.msgList.count > 100) {
                self.msgTableView.mj_header = nil;
            }
            [self.msgTableView reloadData];
            [self.msgTableView.mj_header endRefreshing];
            [self msgTableScrollToTop];
        }
        
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        
    }];
}



/// 关注艺术家
- (void)focusArtist{
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"uid"] = [UserInfoManager shareManager].uid;
    params[@"collect_uid"] = self.courseModel.teacherId;
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader collectUser] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [self getOtherUserInfo];
    } fail:nil];
}

/// 获取是否关注了艺术家的状态
- (void)getOtherUserInfo{
    NSMutableDictionary *param = [NSMutableDictionary new];
    param[@"uid"] = [UserInfoManager shareManager].uid;
    param[@"artuid"] = self.courseModel.teacherId;
    [ApiUtil postWithParent:self url:[ApiUtilHeader getOtherUserInfo] needHUD:NO params:param.copy success:^(NSInteger code, id  _Nullable response) {
        
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            self.userModel = [CustomPersonalModel yy_modelWithDictionary:data];
        }
        
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
    }];
}





#pragma mark -  登录房间和IM功能，在一进到这个页面就进行，推流可以在点击开始直播按钮之后再开始推
- (void)loginRoomAndIM{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"timeout"] = @"1000";
    dic[@"userId"] = self.otherUserID;
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader sigApi] needHUD:NO params:dic success:^(NSInteger code, id  _Nullable response) {
        if (response) {
            MLVBLoginInfo *loginInfo = [MLVBLoginInfo new];
            loginInfo.sdkAppID = AM_SDKAppID;
            loginInfo.userID = self.otherUserID;
            loginInfo.userName = [UserInfoManager shareManager].model.username;
            loginInfo.userAvatar = [UserInfoManager shareManager].model.headimg;//用户头像地址
            loginInfo.userSig = response[@"data"][@"sig"];
            // 初始化LiveRoom
            NSLog(@"%@",loginInfo.userName);
            __weak __typeof(self) weakSelf = self;
            [self.liveRoom loginWithInfo:loginInfo completion:^(int errCode, NSString *errMsg) {
                __strong __typeof(weakSelf) self = weakSelf; if (nil == self) return;
                if (errCode == 0) {//创建成功
                    [self getPushPullStreamAddr];
                    
                } else {//创建失败
                    [weakSelf alertTips:@"LiveRoom init失败" msg:errMsg];
                }
            }];
        }
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        
    }];
}

#pragma mark - 进入房间
- (void)enterRoom{
    [self.liveRoom enterRoom:self.pushModel.roomId view:self.pusherView completion:^(int errCode, NSString *errMsg) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (errCode == 0) {
                [self updateOnlineMemberNum:nil];
//                [self enterRoomSendMessage];
                [self startPullStream];
            } else {
                [self alertTips:@"进入直播间失败" msg:errMsg completion:^{
//                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
        });
    }];
}


#pragma mark - 开启拉流
- (void)startPullStream{
    // 播放房间混流地址，注意这里是按直播模式播放
    RoomLivePlayerWrapper *playerWrapper = [self playerWrapperForUserID:self.courseModel.teacherId];
    playerWrapper.playErrorBlock = ^(int event, NSString *msg) {
        dispatch_async(self.liveRoom.delegateQueue, ^{
            [self.liveRoom.delegate onError:event errMsg:@"播放地址无效或者当前没有数据" extraInfo:nil];
        });
    };
  
    self.player = playerWrapper.player;
//    self.player.delegate = self;

    dispatch_async(dispatch_get_main_queue(), ^{
        TXLivePlayConfig *playConfig = [[TXLivePlayConfig alloc] init];
        playConfig.bAutoAdjustCacheTime = YES;
        playConfig.minAutoAdjustCacheTime = 2.0f;
        playConfig.maxAutoAdjustCacheTime = 2.0f;
        playConfig.connectRetryCount = 10;
        playConfig.connectRetryInterval = 10;
        [self.player setupVideoWidget:CGRectZero containView:self.pusherView insertIndex:0];
        [self.player setConfig:playConfig];
        [self.player startPlay:self.pushModel.playUrl type:PLAY_TYPE_LIVE_FLV];
//        NSLog(@"%@",self.roomInfo.mixedPlayURL);
        [self.player setLogViewMargin:UIEdgeInsetsMake(120, 10, 60, 10)];
    });
}
- (RoomLivePlayerWrapper *)playerWrapperForUserID:(NSString *)userID {
    RoomLivePlayerWrapper *playerWrapper = [[RoomLivePlayerWrapper alloc] init];;
    playerWrapper.userID = self.otherUserID;
//    playerWrapper.delegate = self;
    [playerWrapper.player setRenderMode:RENDER_MODE_FILL_EDGE];
    
    
    return playerWrapper;
}
-(void)onLivePlayNetStatus:(NSString*) userID withParam: (NSDictionary*) param{
    NSLog(@"%@",param);
    
}
- (void)onPlayEvent:(int)EvtID withParam:(NSDictionary *)param{
    NSLog(@"%@",param);
}

#pragma mark - 工具方法
- (void)alertTips:(NSString *)title msg:(NSString *)msg {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        
        [self.navigationController presentViewController:alertController animated:YES completion:nil];
    });
}

- (void)alertTips:(NSString *)title msg:(NSString *)msg completion:(void(^)(void))completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (completion) {
                completion();
            }
        }]];
        
        [self.navigationController presentViewController:alertController animated:YES completion:nil];
    });
}
#pragma mark - UITableView滚动到顶部或底部
/// 消息列表滚到底部
- (void)msgTableScrollToBottom{
    NSUInteger n = MIN(self.msgList.count, [self.msgTableView numberOfSections]);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), ^{
        [self.msgTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:n - 1] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    });
    
}
/// 消息列表滚到顶部
- (void)msgTableScrollToTop{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), ^{
        [self.msgTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    });
}

#pragma mark - UIButton Click
//弹出键盘
- (IBAction)startSendMessage:(UIButton *)sender {
    
    [self.msgInputTextField becomeFirstResponder];
}

- (IBAction)sendMsgClick:(UIButton *)sender {
    [self textFieldShouldReturn:_msgInputTextField];
}
//离开房间
- (IBAction)leaveRoom:(UIButton *)sender {
    [self.player stopPlay];
//    [self.liveRoom.msgMgr logout:^(int errCode, NSString *errMsg) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }];

    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)focusClick:(UIButton *)sender {
    [self focusArtist];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AMLiveRoomMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMLiveRoomMsgCell class]) forIndexPath:indexPath];
    cell.model = self.msgList[indexPath.section];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [tableView setContentOffset:CGPointMake(0, tableView.contentSize.height - tableView.frame.size.height) animated:NO];
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    [self msgTableScrollToBottom];
    return self.msgList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;;
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _msgInputTextField.text = @"";
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _msgInputTextField.text = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *textMsg = [textField.text stringByTrimmingCharactersInSet:[NSMutableCharacterSet whitespaceCharacterSet]];
    if (textMsg.length <= 0) {
        textField.text = @"";
        [self alertTips:@"提示" msg:@"消息不能为空" completion:nil];
        return YES;
    }

    _msgInputTextField.text = @"";
    [_msgInputTextField resignFirstResponder];

    // 发送
    [self sendMessage:textMsg];
    
    return YES;
}

#pragma mark - 发送消息
- (void)sendMessage:(NSString *)message{
    [self cleanSomeMessage];
    AMLiveMsgModel *sendModel = [[AMLiveMsgModel alloc] init];
    NSLog(@"%@",sendModel.userData);
    sendModel.messageType = 0;
    sendModel.userData.userType = [self.courseModel.isMySelf isEqualToString:@"1"]? AMLiveMsgUserTypeTeacher : AMLiveMsgUserTypeMember;
    sendModel.userData.userName = [UserInfoManager shareManager].model.username;
    sendModel.userData.userId = [UserInfoManager shareManager].uid;
    sendModel.userData.userHeadImg = @"xxxxxxx";
    sendModel.messageBody.messageText = message;
    sendModel.guid = [self getUniqueStrByUUID];
    sendModel.timespan = [TimeTool getCurrentTimestamp];
    [self.liveRoom sendAMCustomRoomTextMsgWithModel:sendModel textMsg:message completion:^(AMLiveMsgModel *model, int errCode, NSString *errMsg) {
        NSLog(@"%d",errCode);
        if (errCode == 0) {
            
            [self.msgList addObject:sendModel];
            [self.msgTableView reloadData];
            
            [self saveTheMsgToServer:model];
            [self msgTableScrollToBottom];
        }else{
            [self alertTips:@"提示" msg:errMsg completion:nil];
        }
    }];
    
}
- (void)enterRoomSendMessage{
    AMLiveMsgModel *sendModel = [[AMLiveMsgModel alloc] init];
    NSLog(@"%@",sendModel.userData);
    sendModel.messageType = AMLiveMsgUserTypeMemberJoin;
//    sendModel.userData.userType = AMLiveMsgUserTypeManager;
    sendModel.userData.userName = [UserInfoManager shareManager].model.username;
    sendModel.userData.userId = [UserInfoManager shareManager].uid;
    sendModel.userData.userHeadImg = @"xxxxxxx";
    sendModel.messageBody.messageText = @"";
    sendModel.guid = [self getUniqueStrByUUID];
    sendModel.timespan = [TimeTool getCurrentTimestamp];
    [self.liveRoom sendAMCustomRoomTextMsgWithModel:sendModel textMsg:@"" completion:^(AMLiveMsgModel *model, int errCode, NSString *errMsg) {
        NSLog(@"%d",errCode);
        if (errCode == 0) {
//            [self.msgList addObject:sendModel];
//            [self.msgTableView reloadData];
//            [self msgTableScrollToBottom];
        }else{
            [self alertTips:@"提示" msg:errMsg completion:nil];
        }
    }];
}
#pragma mark - 添加警示消息
- (void)addAlertMsg{

//    self.timer =[NSTimer scheduledTimerWithTimeInterval:600 repeats:YES block:^(NSTimer * _Nonnull timer) {
        AMLiveMsgModel *sendModel = [[AMLiveMsgModel alloc] init];
        sendModel.messageType = AMLiveMsgUserTypeAlet;
        sendModel.userData.userName = [UserInfoManager shareManager].model.username;
        sendModel.userData.userId = [UserInfoManager shareManager].uid;
        sendModel.userData.userHeadImg = @"xxxxxxx";
        sendModel.messageBody.messageText = @"艺术融媒体倡导文明直播，诚信交易，平台会对内容进行24小时在线巡检。任何传播违法/低俗等不良信息都将封号 。";
        sendModel.guid = [self getUniqueStrByUUID];
        sendModel.timespan = [TimeTool getCurrentTimestamp];
        [self.msgList addObject:sendModel];
        [self.msgTableView reloadData];
//    }];
//    [self.timer fire];
    
}

#pragma mark - 获取 UID
- (NSString *)getUniqueStrByUUID
{
    CFUUIDRef uuidObj = CFUUIDCreate(nil);//create a new UUID
    
    //get the string representation of the UUID
    
    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
    
    CFRelease(uuidObj);
    return uuidString ;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_msgInputTextField resignFirstResponder];
    
    _touchBeginLocation = [[[event allTouches] anyObject] locationInView:self.pusherView];
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[[event allTouches] anyObject] locationInView:self.pusherView];
    [self endMove:location.x - _touchBeginLocation.x];
}

// 滑动隐藏UI控件

- (void)endMove:(CGFloat)moveX {
    // 目前只需要隐藏消息列表控件
    [UIView animateWithDuration:0.2 animations:^{
        if (moveX > 10) {
            for (UIView *view in self.pusherView.subviews) {
                if (![view isEqual:self.msgTableView]) {
                    continue;
                }

                CGRect rect = view.frame;
                if (rect.origin.x < [UIScreen mainScreen].bounds.size.width - 50) {
                    rect = CGRectOffset(rect, self.view.width, 0);
                    view.frame = rect;
                }
            }
            self.showMessageFieldButton.hidden = YES;
        } else if (moveX < -10) {
            for (UIView *view in self.pusherView.subviews) {
                if (![view isEqual:self.msgTableView]) {
                    continue;
                }

                CGRect rect = view.frame;
                if (rect.origin.x >= [UIScreen mainScreen].bounds.size.width - 50) {
                    rect = CGRectOffset(rect, -self.view.width, 0);
                    view.frame = rect;
                }
            }
            self.showMessageFieldButton.hidden = NO;
        }else{
            NSLog(@"没反应");
        }
    }];
}






#pragma mark - 消息过多的时候删除一些消息
- (void)cleanSomeMessage{
    if (self.msgList.count > 100) {
        [self.msgList removeObjectsInRange:NSMakeRange(0, 1)];
    }
}

#pragma mark - MLVBLiveRoomDelegate

- (void)AMonRecvRoomTextMsgWithModel:(AMLiveMsgModel *)model roomID:(NSString *)roomID userID:(NSString *)userID userName:(NSString *)userName userAvatar:(NSString *)userAvatar message:(NSString *)message{
    
    if (model.messageType == AMLiveMsgUserTypeChatTextMsg) {
        if (model.messageBody.messageText.length > 0) {
            [self cleanSomeMessage];
            [self.msgList addObject:model];
            [self.msgTableView reloadData];
        }
    }else if (model.messageType == AMLiveMsgUserTypeOnLineNumMsg){
        //刷新在线人数
        self.onLineNumberLabel.text = [NSString stringWithFormat:@"%@人观看",model.messageBody.messageText];
    }else if (model.messageType == AMLiveMsgUserTypeMemberJoin){
//        [self.msgList addObject:model];
//        [self.msgTableView reloadData];
//        [self cleanSomeMessage];
//        [self showMemberTips:model];
//        if ([model.userData.userId isEqualToString:self.courseModel.teacherId]) {//如果是老师进入房间，那就重新开始拉流
//            self.teacherLeaveLabel.hidden = YES;
//            [self.player startPlay:self.pushModel.playUrl type:PLAY_TYPE_LIVE_FLV];
//        }
    }else if(model.messageType == AMLiveMsgUserTypeTeacherLeave){
        self.teacherLeaveLabel.hidden = YES;
    }
    [self msgTableScrollToBottom];
}
- (void)showMemberTips:(MLVBAudienceInfo *)audienceInfo{
    if ([audienceInfo.userID isEqualToString:self.courseModel.teacherId]) {
        self.teacherLeaveLabel.hidden = YES;
        [self.player startPlay:self.pushModel.playUrl type:PLAY_TYPE_LIVE_FLV];
    }
    self.memberJoinTipsBackView.hidden = NO;
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"欢迎%@进入直播间",audienceInfo.userName]];
    [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange(2, audienceInfo.userName.length)];
    self.memberJoinTipsLabel.attributedText = attStr;
    [self performSelector:@selector(hidememberJoinTipsLabel) withObject:nil afterDelay:10];
}
- (void)hidememberJoinTipsLabel{
    
    self.memberJoinTipsBackView.hidden = YES;
}


/**
 * 收到主播退房通知
 *
 * 房间内的主播（和连麦中的观众）会收到新主播的退房事件，您可以调用 MLVBLiveRoom#stopRemoteView: 关闭该主播的视频画面。
 *
 * @param anchorInfo 退房用户信息
 *
 * @note 直播间里的普通观众不会收到主播加入和推出的通知。
 */
- (void)onAnchorExit:(MLVBAnchorInfo *)anchorInfo{
    NSLog(@"%@",anchorInfo);
}

/**
 * 收到观众进房通知
 *
 * @param audienceInfo 进房观众信息
 */
- (void)onAudienceEnter:(MLVBAudienceInfo *)audienceInfo{
    [self showMemberTips:audienceInfo];
}

/**
 * 收到观众退房通知
 *
 * @param audienceInfo 退房观众信息
 */
- (void)onAudienceExit:(MLVBAudienceInfo *)audienceInfo{
    [self updateOnlineMemberNum:^{
        
    }];
}




- (void)IMOffline{
    [MLVBLiveRoom destorySharedInstance];
    [self.liveRoom logout];
    self.liveRoom.delegate = nil;
    
    FKAlertSingleController *alert = [[FKAlertSingleController alloc] init];
    [alert showAlertWithController:self title:@"提示" content:@"您的账号正在其他设备登录，如果不是本人操作，请重新登录并注意账号安全" sureClickBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    } sureCompletion:^{
        
    }];
}


/// @name 通用事件回调
/// @{
/**
 * 错误回调
 *
 * SDK 不可恢复的错误，一定要监听，并分情况给用户适当的界面提示
 *
 * @param errCode     错误码
 * @param errMsg     错误信息
 * @param extraInfo 额外信息，如错误发生的用户，一般不需要关注，默认是本地错误
 */
- (void)onError:(int)errCode errMsg:(NSString*)errMsg extraInfo:(NSDictionary *)extraInfo{
    
    
    
}

- (void)onRoomDestroy:(NSString *)roomID {
    NSLog(@"房间被销毁");
    FKAlertSingleController *alert = [[FKAlertSingleController alloc] init];
    [alert showAlertWithController:self title:@"提示" content:@"当前课时已结束直播，您将退出直播间" sureClickBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    } sureCompletion:^{
        
    }];
}

/**
 * 收到观众进房通知
 *
 * @param audienceInfo 进房观众信息
 */
//- (void)onAudienceEnter:(MLVBAudienceInfo *)audienceInfo{
//    NSLog(@"%@ %@ %@ %@",audienceInfo.userID ,audienceInfo.userAvatar ,audienceInfo.userName ,audienceInfo.userInfo  );
//    if ([self.courseModel.isMySelf isEqualToString:@"1"]) {
//        AMLiveMsgModel *sendModel = [[AMLiveMsgModel alloc] init];
//        NSLog(@"%@",sendModel.userData);
//        sendModel.messageType = 0;
//        sendModel.userData.userType = AMLiveMsgUserTypeManager;
//        sendModel.userData.userName = audienceInfo.userName;
//        sendModel.userData.userId = audienceInfo.userID;
//        sendModel.userData.userHeadImg = @"xxxxxxx";
//        sendModel.messageBody.messageText = @"";
//        sendModel.guid = [self getUniqueStrByUUID];
//        sendModel.timespan = [TimeTool getCurrentTimestamp];
//        [self.liveRoom sendAMCustomRoomTextMsgWithModel:sendModel textMsg:@"" completion:^(AMLiveMsgModel *model, int errCode, NSString *errMsg) {
//            NSLog(@"%d",errCode);
//            if (errCode == 0) {
//                [self.msgList addObject:sendModel];
//                [self.msgTableView reloadData];
//            }else{
//                [self alertTips:@"提示" msg:errMsg completion:nil];
//            }
//        }];
//    }
//}
@end
