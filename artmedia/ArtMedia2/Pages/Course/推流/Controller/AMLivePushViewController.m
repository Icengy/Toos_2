//
//  AMLivePushViewController.m
//  ArtMedia2
//
//  Created by LY on 2020/10/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMLivePushViewController.h"
#import "FKAlertProtocolController.h"
#import "FKAlertController.h"
#import "FKAlertSingleController.h"

#import "UIView+Additions.h"
#import "TXLiveSDKTypeDef.h"
#import <AVFoundation/AVFoundation.h>
#import "ColorMacro.h"
#import "ThemeConfigurator.h"
#import "UIViewController+BackButtonHandler.h"
#import "LiveRoomAccPlayerView.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "GenerateTestUserSig.h"

#import "AMLiveRoomMsgCell.h"

#import "AMLivePushModel.h"
#import "AMLiveMsgModel.h"

#if DEBUG
#  define Log NSLog
#else
#  define Log(...)
#endif

@interface AMLivePushViewController ()<MLVBLiveRoomDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    CGPoint                  _touchBeginLocation;
}
@property (nonatomic, weak)    MLVBLiveRoom* liveRoom;//房间
//艺术家/老师 head
@property (weak, nonatomic) IBOutlet UIImageView *teacherHeadImageView;
@property (weak, nonatomic) IBOutlet UILabel *teacherNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *onLineNumberLabel;


//推流相关
@property (weak, nonatomic) IBOutlet UIView *pusherView;//推流背景
@property (nonatomic , strong) AMLivePushModel *pushModel;//推流模型，里面放着从接口获取的推流地址
@property (weak, nonatomic) IBOutlet UIButton *startPushButton;

//课程信息相关
@property (weak, nonatomic) IBOutlet UIView *classInfoView;
@property (weak, nonatomic) IBOutlet UILabel *courseTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *chapterTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;


//消息相关
@property (weak, nonatomic) IBOutlet UIButton *showMessageFieldButton;
@property (weak, nonatomic) IBOutlet UITableView *msgTableView;//消息列表
@property (weak, nonatomic) IBOutlet UIView *msgInputView;//输入框背景
@property (weak, nonatomic) IBOutlet AMTextField *msgInputTextField;//输入框
@property (nonatomic , strong) NSMutableArray <AMLiveMsgModel *>*msgList;//消息数组
@property (nonatomic , assign) NSInteger page;

@property (nonatomic , assign) BOOL loginRoomIMSuccess;
//@property (nonatomic , strong) NSTimer *timer;
@property (nonatomic , copy) NSString *topTimeString;//刚刚进入这个页面时候的时间，用来查询聊天记录
@property (weak, nonatomic) IBOutlet UILabel *memberJoinTipsLabel;
@property (weak, nonatomic) IBOutlet UIView *memberJoinTipsBackView;

@end

@implementation AMLivePushViewController

#pragma mark - 懒加载
- (MLVBLiveRoom *)liveRoom{
    if (!_liveRoom) {
        _liveRoom = [MLVBLiveRoom sharedInstance];
        [_liveRoom setCameraMuteImage:[UIImage imageNamed:@"logo"]];
        [_liveRoom setMirror:NO];
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
    //创建房间
    if ([self.chapterModel.liveStatus isEqualToString:@"2"]) {
        [self creatRoom];
    }
}

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IMOffline) name:@"IMOffline" object:nil];
    self.topTimeString = [TimeTool getCurrentDateStr];
    self.msgInputTextField.charCount = 80;
    self.msgInputTextField.placeholder = @"请输入要发送的消息";
    self.page = 1;
    [self loginRoomAndIM];
    self.loginRoomIMSuccess = NO;
    [self setMsgTableView];
    //获取推拉流地址
//    [self getPushPullStreamAddr];
    
    [self startCamerPreview];//开启前置摄像头预览
    [self updateUI];
    [self addAlertMsg];
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
    
    if (_liveRoom) {
        // 正在PK中就结束PK
//        if (_pkStatus == PKStatus_BEING) {
//            [_liveRoom quitRoomPK:nil];
//        }

        [_liveRoom exitRoom:^(int errCode, NSString *errMsg) {
            NSLog(@"exitRoom: errCode[%d] errMsg[%@]", errCode, errMsg);
        }];
    }
    
    // 美颜初始化为默认值
//    [_vBeauty resetAndApplyValues];

}

- (void)dealloc{
    NSLog(@"房间销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [MLVBLiveRoom destorySharedInstance];
//    [self.liveRoom logout];
    
}

- (void)IMOffline{
    [self.liveRoom.livePusher pausePush];
    [self.liveRoom.livePusher stopPush];
//    [MLVBLiveRoom destorySharedInstance];
//    self.liveRoom.delegate = nil;
    FKAlertSingleController *alert = [[FKAlertSingleController alloc] init];
    [alert showAlertWithController:self title:@"提示" content:@"您的账号正在其他设备登录，如果不是本人操作，请重新登录并注意账号安全" sureClickBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    } sureCompletion:^{
        
    }];
}


#pragma mark - 刷新UI
- (void)updateUI{
    ////直播状态 1:未直播  2:直播中  3:直播中讲师离开直播间  4:直播已结束=回放视频
    if ([self.chapterModel.liveStatus isEqualToString:@"1"]) {
        if ([self.courseModel.isMySelf isEqualToString:@"1"]) {
            self.classInfoView.hidden = YES;
            self.startPushButton.hidden = NO;
        }else{
            self.classInfoView.hidden = NO;
            self.startPushButton.hidden = YES;
        }
    }else if ([self.chapterModel.liveStatus isEqualToString:@"2"] || [self.chapterModel.liveStatus isEqualToString:@"3"]){
        self.classInfoView.hidden = YES;
        self.startPushButton.hidden = YES;
        if ([self.chapterModel.liveStatus isEqualToString:@"3"]) {
            self.startPushButton.hidden = NO;
            [self.startPushButton setTitle:@"继续直播" forState:UIControlStateNormal];
        }
    }else if ([self.chapterModel.liveStatus isEqualToString:@"4"]){
        
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
    [ApiUtil postWithParent:self url:[ApiUtilHeader getPushStreamAddr] needHUD:YES params:dic success:^(NSInteger code, id  _Nullable response) {
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
//            NSMutableArray *indexArray = [NSMutableArray array];
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
#pragma mark - UITableView滚动到底部
- (void)scrollTableToFoot:(BOOL)animated
{
    NSInteger s = [self.msgTableView numberOfSections];  //有多少组
    if (s<1) return;  //无数据时不执行 要不会crash
    NSInteger r = [self.msgTableView numberOfRowsInSection:s-1]; //最后一组有多少行
    if (r<1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];  //取最后一行数据
    [self.msgTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated]; //滚动到最后一行
}



#pragma mark -  登录房间和IM功能，在一进到这个页面就进行，推流可以在点击开始直播按钮之后再开始推
- (void)loginRoomAndIM{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"timeout"] = @"1000";
    dic[@"userId"] = [UserInfoManager shareManager].uid;
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader sigApi] needHUD:NO params:dic success:^(NSInteger code, id  _Nullable response) {
        if (response) {
            MLVBLoginInfo *loginInfo = [MLVBLoginInfo new];
            loginInfo.sdkAppID = AM_SDKAppID;
            loginInfo.userID = [UserInfoManager shareManager].uid;
            loginInfo.userName = [UserInfoManager shareManager].model.username;
            loginInfo.userAvatar =[UserInfoManager shareManager].model.headimg;//用户头像地址
            loginInfo.userSig = response[@"data"][@"sig"];
            // 初始化LiveRoom

            __weak __typeof(self) weakSelf = self;
            [self.liveRoom loginWithInfo:loginInfo completion:^(int errCode, NSString *errMsg) {
                __strong __typeof(weakSelf) self = weakSelf; if (nil == self) return;
                if (errCode == 0) {//创建成功
                    weakSelf.loginRoomIMSuccess = YES;
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
- (void)pusherEnterRoom{
    [self.liveRoom pusherEnterRoom:self.pushModel.roomId completion:^(int errCode, NSString *errMsg) {
        if (errCode == 0) {
            [self updateOnlineMemberNum:nil];
            //开启推流
            if ([self.chapterModel.liveStatus isEqualToString:@"2"]){
                [self.liveRoom.livePusher startPush:self.pushModel.pushUrl];
            }
        }
    }];
}



- (void)creatRoom{
    [self.liveRoom createRoom:self.pushModel.roomId roomInfo:self.pushModel.chapterTitle completion:^(int errCode, NSString *errMsg) {
        NSLog(@"createRoom: errCode[%d] errMsg[%@]", errCode, errMsg);
        

        dispatch_async(dispatch_get_main_queue(), ^{
            if (errCode == 0) {
                [self updateOnlineMemberNum:nil];
//                [self enterRoomSendMessage];
//                [self appendSystemMsg:@"连接成功"];
                //开启推流
//                if ([self.chapterModel.liveStatus isEqualToString:@"2"] || [self.chapterModel.liveStatus isEqualToString:@"2"]){
//                    int a = [self.liveRoom.livePusher startPush:self.pushModel.pushUrl];
//                    NSLog(@"%d",a);
//                }
                [self.liveRoom.livePusher startPush:self.pushModel.pushUrl];
            }else if (errCode == 10036) {
                [self IMOpenAlert];
            } else {
                [self alertTips:@"创建直播间失败" msg:errMsg completion:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
        });

    }];

}

- (void)IMOpenAlert{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"您当前使用的云通讯账号未开通音视频聊天室功能，创建聊天室数量超过限额，请前往腾讯云官网开通【IM音视频聊天室】"
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"去开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://buy.cloud.tencent.com/avc"]];
    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [controller addAction:action];
    [controller addAction:confirm];
    [self presentViewController:controller animated:YES completion:nil];
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

- (IBAction)changeCamera:(UIButton *)sender {
    [self.liveRoom switchCamera];
}


//弹出键盘
- (IBAction)startSendMessage:(UIButton *)sender {
    
    [self.msgInputTextField becomeFirstResponder];
}


//离开房间
- (IBAction)leaveRoom:(UIButton *)sender {
    if ([self.chapterModel.liveStatus isEqualToString:@"2"] ) {
        
        FKAlertProtocolController *alert = [[FKAlertProtocolController alloc] init];
        [alert showAlertWithController:self title:@"确定退出直播间么？" content:@"退出后学员将收不到直播间画面" protocolText:@"是否结束当前课时的直播？" sureClickBlock:^(BOOL selectProtocol) {
            NSLog(@"%d",selectProtocol);
//            [self.timer invalidate];
//            self.timer = nil;
//            [self.liveRoom exitRoom:^(int errCode, NSString *errMsg) {
//
//            }];
            [self.liveRoom.livePusher pausePush];
            [self.liveRoom.livePusher stopPush];
            [self.liveRoom.msgMgr logout:^(int errCode, NSString *errMsg) {
//                [self.navigationController popViewControllerAnimated:YES];
                if (selectProtocol) {
                    [SVProgressHUD show];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                        dic[@"courseId"] = self.courseModel.courseId;
                        dic[@"chapterId"] = self.chapterModel.chapterId;
                        [ApiUtil postWithParent:self url:[ApiUtilHeader stopLiveCourseChapter] needHUD:YES params:dic success:^(NSInteger code, id  _Nullable response) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.navigationController popViewControllerAnimated:YES];
                            });
                        } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
                            [SVProgressHUD dismiss];
                        }];
                    });

                    
                }else{
                    [self teacherLeaveSendMessage];
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    dic[@"courseId"] = self.courseModel.courseId;
                    dic[@"chapterId"] = self.chapterModel.chapterId;
                    [ApiUtil postWithParent:self url:[ApiUtilHeader quitLiveRoomOfLiveCourseChapter] needHUD:YES params:dic success:^(NSInteger code, id  _Nullable response) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                        
                    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
                        
                    }];

                }
            }];
            
        } sureCompletion:^{
            
        }];
        
    }else if ([self.chapterModel.liveStatus isEqualToString:@"3"]){
        [self.navigationController popViewControllerAnimated:YES];
    } else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//开始直播
- (IBAction)startLive:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"开始直播"]) {
        FKAlertController *alert = [[FKAlertController alloc] init];
        [alert showAlertWithController:self title:@"确定开始直播吗？" content:[NSString stringWithFormat:@"直播课时%@：%@\n原定开播时间：%@\n开播后，所有学员即可进入直播间观看",self.chapterModel.chapterSort,self.chapterModel.chapterTitle,self.chapterModel.liveStartTime] sureClickBlock:^{
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"courseId"] = self.courseModel.courseId;
            dic[@"chapterId"] = self.chapterModel.chapterId;
            [ApiUtil postWithParent:self url:[ApiUtilHeader startLiveCourseChapter] needHUD:YES params:dic success:^(NSInteger code, id  _Nullable response) {
                self.pushModel = [AMLivePushModel yy_modelWithDictionary:response[@"data"]];
                self.chapterModel.liveStatus = @"2";
                if (self.pushModel.pushUrl.length > 0) {
                    //  [self.liveRoom.livePusher startPush:self.pushModel.pushUrl];
                    self.startPushButton.hidden = YES;
                }
                [self creatRoom];
            } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
                
            }];
        } sureCompletion:^{
            
        }];
        
        
    }else if([sender.titleLabel.text isEqualToString:@"继续直播"]){
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"chapterId"] = self.chapterModel.chapterId;
        dic[@"courseId"] = self.courseModel.courseId;
        [ApiUtil postWithParent:self url:[ApiUtilHeader restartLiveCourseChapter] needHUD:YES params:dic success:^(NSInteger code, id  _Nullable response) {
            self.pushModel = [AMLivePushModel yy_modelWithDictionary:response[@"data"]];
            self.chapterModel.liveStatus = @"2";
            self.startPushButton.hidden = YES;
            if (response) {
//                [self.liveRoom.livePusher startPush:self.pushModel.pushUrl];
            }
            [self creatRoom];
            
        } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
            
        }];
    }
        
}
- (IBAction)sendMsgClick:(UIButton *)sender {
    [self textFieldShouldReturn:_msgInputTextField];
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
    if (textMsg.length > 160) {
        textField.text = @"";
        [self alertTips:@"提示" msg:@"最多可输入80个汉字" completion:nil];
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
#pragma mark - 进入房间发送通知
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

/// 老师暂离直播间发送
- (void)teacherLeaveSendMessage{
    AMLiveMsgModel *sendModel = [[AMLiveMsgModel alloc] init];
    NSLog(@"%@",sendModel.userData);
    sendModel.messageType = AMLiveMsgUserTypeTeacherLeave;
//    sendModel.userData.userType = AMLiveMsgUserTypeManager;
    sendModel.userData.userName = [UserInfoManager shareManager].model.username;
    sendModel.userData.userId = [UserInfoManager shareManager].uid;
    sendModel.userData.userHeadImg = @"xxxxxxx";
    sendModel.messageBody.messageText = @"";
    sendModel.guid = [self getUniqueStrByUUID];
    sendModel.timespan = [TimeTool getCurrentTimestamp];
    [self.liveRoom sendAMCustomRoomTextMsgWithModel:sendModel textMsg:@"" completion:^(AMLiveMsgModel *model, int errCode, NSString *errMsg) {
       
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
    NSLog(@"%f",_touchBeginLocation.x);
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[[event allTouches] anyObject] locationInView:self.pusherView];
    [self endMove:location.x - _touchBeginLocation.x];
    NSLog(@"%f",location.x - _touchBeginLocation.x);
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
    }
    [self msgTableScrollToBottom];
}
- (void)showMemberTips:(MLVBAudienceInfo *)audienceInfo{
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
@end
