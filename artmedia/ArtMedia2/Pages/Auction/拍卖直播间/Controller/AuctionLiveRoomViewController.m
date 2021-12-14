//
//  AuctionLiveRoomViewController.m
//  ArtMedia2
//
//  Created by LY on 2020/11/13.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AuctionLiveRoomViewController.h"
#import "AuctionItemDetailViewController.h"
#import "MyAuctionMoneyController.h"
#import "FKAlertSingleController.h"
#import "AuctionApplyNumberPlateSuccessController.h"
#import "AuctionApplyNumberPlateController.h"
#import "ReportAlertController.h"
#import "AMOfferPriceListViewController.h"


#import "TRTCLiveRoom.h"
#import "AuctionItemModel.h"
#import "AuctionLiveMessageCell.h"
#import "AMLiveMsgModel.h"
#import "PlateNumberModel.h"
#import "AMNextPriceModel.h"


@interface AuctionLiveRoomViewController ()<UITableViewDelegate , UITableViewDataSource , TRTCLiveRoomDelegate ,AMOfferPriceListDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *statusIV;

@property (weak, nonatomic) IBOutlet UIView *pusherView;
@property (weak, nonatomic) IBOutlet AMButton *detailButton;
@property (weak, nonatomic) IBOutlet AMButton *nowBidButton;//立即出价按钮

@property (weak, nonatomic) IBOutlet BaseTableView *messageListTableView;
@property (nonatomic , strong) TRTCLiveRoom *liveRoom;
@property (nonatomic , copy) NSString *roomID;
@property (nonatomic , strong) NSMutableArray <AMLiveMsgModel *>*msgListData;

@property (nonatomic , strong) AuctionItemModel *auctionGoodModel;
@property (nonatomic , strong) PlateNumberModel *plateNumberModel;
//@property (nonatomic , copy) NSString *nextOfferPrice;//下一口价
@property (nonatomic , strong) AMNextPriceModel *nextPriceModel;
@property (weak, nonatomic) IBOutlet UILabel *nextPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *upcomingBidLabel;//即将出价Label


@property (weak, nonatomic) IBOutlet UIImageView *goodLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *lotNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodTitleLabel;
@property (weak, nonatomic) IBOutlet UIStackView *infoStackView;
@property (weak, nonatomic) IBOutlet UIView *goodsBackView;


@property (weak, nonatomic) IBOutlet UIView *noneView;
@property (weak, nonatomic) IBOutlet UILabel *expectedStartLiveTimeLabel;//预计开播时间label



@end

@implementation AuctionLiveRoomViewController
- (NSMutableArray *)msgListData{
    if (!_msgListData) {
        _msgListData = [[NSMutableArray alloc] init];
    }
    return _msgListData;
}
- (TRTCLiveRoom *)liveRoom{
    if (!_liveRoom) {
        _liveRoom = [TRTCLiveRoom shareInstance];
        _liveRoom.delegate = self;
    }
    return _liveRoom;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IMOffline) name:@"IMOffline" object:nil];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goDetailClick:)];
    [self.lotNumberLabel addGestureRecognizer:tap];
    [self.goodTitleLabel addGestureRecognizer:tap];
    [self.goodLogoImageView addGestureRecognizer:tap];

    self.lotNumberLabel.userInteractionEnabled = YES;
    self.goodTitleLabel.userInteractionEnabled = YES;
    self.goodLogoImageView.userInteractionEnabled = YES;
    
    self.messageListTableView.hidden = YES;
    if ([self.auctionModel.fieldStatus isEqualToString:@"6"]) {
        self.noneView.hidden = YES;
    }else{
        self.noneView.hidden = NO;
        self.expectedStartLiveTimeLabel.text = [NSString stringWithFormat:@"预计 %@ 开播",self.auctionModel.startLiveTime];
    }
    
    [self removePreviousViewController:[AuctionApplyNumberPlateSuccessController class]];
    
    
    [self setTableView];
    [self.detailButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [self.detailButton setImageEdgeInsets:UIEdgeInsetsMake(0, 70, 0, 0)];
    if ([self.auctionModel.fieldStatus isEqualToString:@"6"]) {
        [self getPalyUrlOfAuctionField];
        [self selectLivingAuctionGoodsIdByAuctionFieldId];
    }
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if ([self.auctionModel.fieldStatus isEqualToString:@"6"]) {
        [self selectAuctionUserPlateNumberByCurrentUser];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


- (void)setAuctionGoodModel:(AuctionItemModel *)auctionGoodModel{
    _auctionGoodModel = auctionGoodModel;
    if (auctionGoodModel.auctionGoodId.length > 0) {
        self.goodsBackView.hidden = NO;
        [self.goodLogoImageView am_setImageWithURL:auctionGoodModel.opusCoverImage placeholderImage:[UIImage imageNamed:@"logo"] contentMode:UIViewContentModeScaleAspectFit];
        
        NSString *string = [ToolUtil getNetImageURLStringWith:auctionGoodModel.opusCoverImage];
        NSString *url = [NSString stringWithFormat:@"%@_200x200.%@",[string stringByDeletingPathExtension],[string pathExtension]];
        NSLog(@"%@",url);
        [self.goodLogoImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"logo"]];
        
        self.goodTitleLabel.text = auctionGoodModel.opusTitle;
        self.lotNumberLabel.text = [NSString stringWithFormat:@"LOT %04ld",auctionGoodModel.goodNumber.integerValue];
        if ([auctionGoodModel.auctionGoodStatus isEqualToString:@"2"]) {//拍品状态，1：未开拍，2：竞价中，3：已结拍，4：流拍
            self.nowBidButton.enabled = YES;
            [self.nowBidButton setBackgroundImage:[UIImage imageWithColor:RGB(224, 82, 39)] forState:UIControlStateNormal];
            [self.nowBidButton setTitle:@"立即出价" forState:UIControlStateNormal];
        }else if ([auctionGoodModel.auctionGoodStatus isEqualToString:@"3"]){
            self.nowBidButton.enabled = NO;
            [self.nowBidButton setTitle:@"已成交" forState:UIControlStateDisabled];
            [self.nowBidButton setBackgroundImage:[UIImage imageWithColor:RGB(153, 153, 153)] forState:UIControlStateDisabled];
        }else if ([auctionGoodModel.auctionGoodStatus isEqualToString:@"4"]){
            self.nowBidButton.enabled = NO;
            [self.nowBidButton setTitle:@"已流拍" forState:UIControlStateDisabled];
            [self.nowBidButton setBackgroundImage:[UIImage imageWithColor:RGB(153, 153, 153)] forState:UIControlStateDisabled];
        }
        
        if ([auctionGoodModel.auctionGoodStatus isEqualToString:@"3"]) {
            self.upcomingBidLabel.text = @"落锤价";
        }else if ([auctionGoodModel.auctionGoodStatus isEqualToString:@"2"]){
            self.upcomingBidLabel.text = @"即将出价";
        }else if ([auctionGoodModel.auctionGoodStatus isEqualToString:@"4"]){
            self.upcomingBidLabel.text = @"无人出价";
        }
    }else{
        self.goodsBackView.hidden = YES;
    }
    
}

/// 获取专场正在直播的拍品
- (void)selectLivingAuctionGoodsIdByAuctionFieldId{
    [ApiUtil getWithParent:self url:[ApiUtilHeader selectLivingAuctionGoodsIdByAuctionFieldId:self.auctionModel.auctionFieldId] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response) {
        if (response) {
            self.auctionGoodModel = [AuctionItemModel yy_modelWithDictionary:response[@"data"]];
            [self selectNextOfferPriceByAuctionGoodId];
        }
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        
    }];
}


/// 获取当前拍品的下一口价
- (void)selectNextOfferPriceByAuctionGoodId{
    if (self.auctionGoodModel.auctionGoodId.length > 0) {
        [ApiUtil getWithParent:self url:[ApiUtilHeader selectNextOfferPriceByAuctionGoodId:self.auctionGoodModel.auctionGoodId] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response) {
            if (response) {
                self.nextPriceModel = [AMNextPriceModel yy_modelWithDictionary: response[@"data"]];
            }
        } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
            
        }];
    }
}

- (void)setNextPriceModel:(AMNextPriceModel *)nextPriceModel{
    _nextPriceModel = nextPriceModel;
    if ([self.auctionGoodModel.auctionGoodStatus isEqualToString:@"2"]) {
        self.nextPriceLabel.text = [NSString stringWithFormat:@"￥%@",[ToolUtil stringToDealMoneyString:nextPriceModel.nextOfferPrice]];
    }else if ([self.auctionGoodModel.auctionGoodStatus isEqualToString:@"3"]){
        self.nextPriceLabel.text = [NSString stringWithFormat:@"￥%@",[ToolUtil stringToDealMoneyString:self.auctionGoodModel.dealPrice]];
    }else{
        self.nextPriceLabel.text = [NSString stringWithFormat:@"￥%@",[ToolUtil stringToDealMoneyString:nextPriceModel.nextOfferPrice]];
    }
}


/// 获取拉流房间号roomID
- (void)getPalyUrlOfAuctionField{
    [ApiUtil getWithParent:self url:[ApiUtilHeader getPalyUrlOfAuctionField:self.auctionModel.auctionFieldId] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response) {
        if (response) {
            self.roomID = response[@"data"][@"roomId"];
            [self loginTRTCRoom];
        }
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        
    }];
}


/// 登录房间和IM
- (void)loginTRTCRoom{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"timeout"] = @"1000";
    dic[@"userId"] = [UserInfoManager shareManager].uid;
    [ApiUtil postWithParent:self url:[ApiUtilHeader sigApi] needHUD:NO params:dic success:^(NSInteger code, id  _Nullable response) {
        if (response) {
            TRTCLiveRoomConfig *config = [[TRTCLiveRoomConfig alloc] init];
            config.useCDNFirst = NO;
            [self.liveRoom loginWithSdkAppID:AM_SDKAppID userID:[UserInfoManager shareManager].uid userSig:response[@"data"][@"sig"] config:config callback:^(int code, NSString * _Nullable message) {
                NSLog(@"loginWithSdkAppID  %d   %@",code,message);
                [self.liveRoom enterRoomWithRoomID:[self.roomID intValue] callback:^(int code, NSString * _Nullable message) {
                    
                    NSLog(@"enterRoomWithRoomID  %d  %@",code , message);
                    
//                    if ([self.auctionModel.fieldStatus isEqualToString:@"6"]) {
//                        [self.liveRoom startPlayWithUserID:self.auctionModel.createUserId view:self.pusherView callback:^(int code, NSString * _Nullable message) {
//                            NSLog(@"startPlayWithUserID %d  %@",code , message);
//                        }];
//                    }
                }];
                
            }];
        }
    } fail:nil];
}
/// 查询用户号牌详情
- (void)selectAuctionUserPlateNumberByCurrentUser {
    [ApiUtil getWithParent:self url:[ApiUtilHeader selectAuctionUserPlateNumberByCurrentUser:self.auctionModel.auctionFieldId] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response) {
        if (response) {
            self.plateNumberModel = [PlateNumberModel yy_modelWithDictionary:response[@"data"]];
        }
        [self.messageListTableView reloadData];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        
    }];
}


- (void)setTableView{
    
    [self.messageListTableView addRoundedCorners:(UIRectCornerTopRight | UIRectCornerTopLeft) withRadii:CGSizeMake(8.0, 8.0)];
    self.messageListTableView.backgroundColor = [Color_Black colorWithAlphaComponent:0.35];
    self.messageListTableView.delegate = self;
    self.messageListTableView.dataSource = self;
    [self.messageListTableView registerNib:[UINib nibWithNibName:NSStringFromClass([AuctionLiveMessageCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AuctionLiveMessageCell class])];
}

// 拍品详情
- (IBAction)goDetailClick:(UIButton *)sender {
    AuctionItemDetailViewController *vc = [[AuctionItemDetailViewController alloc] init];
    vc.auctionGoodId = self.auctionGoodModel.auctionGoodId;
    [self.navigationController pushViewController:vc animated:YES];
}
//出价
- (IBAction)offerPrice:(UIButton *)sender {
    if ([self.plateNumberModel.isValid isEqualToString:@"2"]) {//号牌已生效
        if ([self.auctionGoodModel.auctionGoodStatus isEqualToString:@"2"]) {
//            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//            dic[@"auctionGoodId"] = self.auctionGoodModel.auctionGoodId;
//            dic[@"auctionUserOfferPrice"] = self.nextPriceModel.nextOfferPrice;
//            [ApiUtil postWithParent:self url:[ApiUtilHeader addOfferPriceToAuctionGoodsOfCurrentUser] needHUD:YES params:dic success:^(NSInteger code, id  _Nullable response) {
//                if (response) {
//                    [SVProgressHUD showSuccess:@"出价成功"];
//
//                }
//            } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
//
//            }];
            AMOfferPriceListViewController *vc = [[AMOfferPriceListViewController alloc] init];
            vc.delegate = self;
            vc.auctionGoodId = self.auctionGoodModel.auctionGoodId;
            [vc showWithController:self];
            
            
        }else{
            [SVProgressHUD showError:@"该拍品已成交，出价失败"];
        }
        
    }else{
        AuctionApplyNumberPlateController *vc = [[AuctionApplyNumberPlateController alloc] init];
        vc.auctionFieldId = self.auctionModel.auctionFieldId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)priceListOfferPrice:(NSString *)price{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"auctionGoodId"] = self.auctionGoodModel.auctionGoodId;
    dic[@"auctionUserOfferPrice"] = price;
    [ApiUtil postWithParent:self url:[ApiUtilHeader addOfferPriceToAuctionGoodsOfCurrentUser] needHUD:YES params:dic success:^(NSInteger code, id  _Nullable response) {
        if (response) {
            [SVProgressHUD showSuccess:@"出价成功"];

        }
    } fail:nil];
}


//退出
- (IBAction)clickToBack:(id)sender {
    [self.liveRoom exitRoom:^(int code, NSString * _Nullable message) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

- (IBAction)clickToMore:(id)sender {
    ReportAlertController *alert = [[ReportAlertController alloc] init];
    [alert showAlertWithController:self sureClickBlock:^{
        [SVProgressHUD showSuccess:@"举报成功！"];
    }];
}
- (IBAction)clickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/// 消息列表滚到底部
- (void)msgTableScrollToBottom{
    NSUInteger n = MIN(self.msgListData.count, [self.messageListTableView numberOfRowsInSection:0]);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), ^{
        [self.messageListTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:n-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    });
    
}
/// 消息列表滚到顶部
- (void)msgTableScrollToTop{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), ^{
        [self.messageListTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    });
    
}
#pragma mark - UITableViewDelegate , UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AuctionLiveMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AuctionLiveMessageCell class]) forIndexPath:indexPath];
    cell.model = self.msgListData[indexPath.row];
    cell.plateModel = self.plateNumberModel;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.msgListData.count;
}

/// 收到消息
- (void)AM_trtcLiveRoom:(TRTCLiveRoom *)trtcLiveRoom onRecvRoomCustomMsgWithJson:(NSDictionary *)json fromUser:(TRTCLiveUserInfo *)user{
    self.messageListTableView.hidden = NO;
    AMLiveMsgModel *model = [AMLiveMsgModel yy_modelWithDictionary:json];
    if (model.messageType == AMLiveMsgUserTypeAuctionBidMsg) {//出价消息
        [self selectNextOfferPriceByAuctionGoodId];
    }else if (model.messageType == AMLiveMsgUserTypeEndAuctionMsg){//结拍消息
        [self selectLivingAuctionGoodsIdByAuctionFieldId];
    }else if (model.messageType == AMLiveMsgUserTypeChangeAuctonMsg){//切换拍品消息
        [self selectLivingAuctionGoodsIdByAuctionFieldId];
    }else if (model.messageType == AMLiveMsgUserTypeCancelBidMsg){//出价作废消息
        [self selectLivingAuctionGoodsIdByAuctionFieldId];
    }
    
    [self.msgListData addObject:model];
    
    //显示起拍价
    if (model.messageType == AMLiveMsgUserTypeChangeAuctonMsg){
        NSDictionary *dic = @{
            @"messageType":@(AMLiveMsgUserTypeChangeAuctonShowStartPriceMsg),
            @"userData":@{
                    @"userType":@(1),//发言人类型，0官方发言，1房主发言，2管理员发言，3普通用户发言
                    @"userId":model.userData.userId,
                    @"userName":model.userData.userName,
                    @"userHeadImg":model.userData.userHeadImg,
            },
            @"messageBody":@{
                    @"auctionId":model.messageBody.auctionId, //拍品ID
                    @"auctionLot":model.messageBody.auctionLot, //拍品图录号
                    @"auctionTitle":model.messageBody.auctionTitle, //拍品标题
                    @"auctionImageUrl":model.messageBody.auctionImageUrl, //拍品封面图片地址
                    @"bidPrice":model.messageBody.bidPrice, //该拍品之前有人出价时取出价价格，无人出价过取起拍价格
                    @"nextBidPrice":model.messageBody.nextBidPrice, //下一手出价的价格
                    @"time":model.messageBody.time, //切换到该拍品的时间
            }
        };
        AMLiveMsgModel *model2 = [AMLiveMsgModel yy_modelWithDictionary:dic];
        [self.msgListData addObject:model2];
    }
    
    [self.messageListTableView reloadData];
    [self msgTableScrollToBottom];
}
/// 主播进房回调
/// - Note: 主播包括房间大主播、连麦观众和跨房PK主播
- (void)trtcLiveRoom:(TRTCLiveRoom *)trtcLiveRoom
       onAnchorEnter:(NSString *)userID{
    NSLog(@"%@",userID);
    if ([self.auctionModel.fieldStatus isEqualToString:@"6"]) {
        [self.liveRoom startPlayWithUserID:userID view:self.pusherView callback:^(int code, NSString * _Nullable message) {
            NSLog(@"startPlayWithUserID %d  %@",code , message);
        }];
    }
    
}
/// 房间销毁回调
- (void)trtcLiveRoom:(TRTCLiveRoom *)trtcLiveRoom
       onRoomDestroy:(NSString *)roomID{
    
    FKAlertSingleController *alert = [[FKAlertSingleController alloc] init];
    [alert showAlertWithController:self title:@"提示" content:@"专场直播已结束" sureClickBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    } sureCompletion:^{
        
    }];
}
/// 主播离开回调
/// - Note: 主播包括房间大主播、连麦观众和跨房PK主播
- (void)trtcLiveRoom:(TRTCLiveRoom *)trtcLiveRoom
        onAnchorExit:(NSString *)userID{
//    FKAlertSingleController *alert = [[FKAlertSingleController alloc] init];
//    [alert showAlertWithController:self title:@"提示" content:@"主播暂时离开" sureClickBlock:^{
//    } sureCompletion:^{
//
//    }];
}
/// 出错回调
- (void)trtcLiveRoom:(TRTCLiveRoom *)trtcLiveRoom
             onError:(NSInteger)code
             message:(NSString  *)message{
    NSLog(@"房间报错 %@",message);
}

- (void)IMOffline{
    [self.liveRoom exitRoom:^(int code, NSString * _Nullable message) {
        FKAlertSingleController *alert = [[FKAlertSingleController alloc] init];
        [alert showAlertWithController:self title:@"提示" content:@"您已被强制踢出直播间" sureClickBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
            
        } sureCompletion:^{
            
        }];
    }];
    
}

@end
