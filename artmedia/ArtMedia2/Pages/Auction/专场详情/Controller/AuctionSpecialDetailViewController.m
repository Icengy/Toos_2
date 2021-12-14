//
//  AuctionSpecialDetailViewController.m
//  ArtMedia2
//
//  Created by LY on 2020/11/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AuctionSpecialDetailViewController.h"
#import "AuctionApplyNumberPlateController.h"
#import "AuctionLiveRoomViewController.h"
#import "AuctionItemDetailViewController.h"
#import "FKAlertSingleController.h"
#import "WebViewURLViewController.h"
#import "AMBaseUserHomepageViewController.h"
#import "FaceRecognitionViewController.h"
#import "PhoneAuthViewController.h"
#import "AMDialogView.h"

#import "AuctionSpecialDetailHeadImageCell.h"
#import "AuctionSpecialDetailInfoCell.h"
#import "AuctionSpecialDetailArtistCell.h"
#import "AuctionItemCell.h"
#import "AuctionItemHeadView.h"
#import "AMShareView.h"

#import "AuctionModel.h"
#import "AuctionItemModel.h"
#import "PlateNumberModel.h"

@interface AuctionSpecialDetailViewController ()<UITableViewDelegate ,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet AMButton *applyNumberPlateButton;
@property (weak, nonatomic) IBOutlet UILabel *applyNumberPlateLabel;
@property (nonatomic , strong) PlateNumberModel *plateNumberModel;
@property (nonatomic , strong) AuctionModel *auctionModel;
@property (nonatomic , strong) NSMutableArray <AuctionItemModel *>*listData;
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , copy) NSString *auctionGoodTotalAmount;//拍品数
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic, strong) NSString *nameInputStr;
@end

@implementation AuctionSpecialDetailViewController
- (NSMutableArray<AuctionItemModel *> *)listData{
    if (!_listData) {
        _listData = [[NSMutableArray alloc] init];
    }
    return _listData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"专场详情";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData:) name:AMLoginSuccess object:nil];
    [self loadData:nil];
    [self setTableView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self selectAuctionUserPlateNumberByCurrentUser];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)initRightNaviBar {
    AMButton *rightBtn = [AMButton buttonWithType:UIButtonTypeCustom];
    
    [rightBtn setImage:ImageNamed(@"icon-navHead-share") forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickToShare:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (void)setTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = RGB(247, 247, 247);
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AuctionSpecialDetailHeadImageCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AuctionSpecialDetailHeadImageCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AuctionSpecialDetailInfoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AuctionSpecialDetailInfoCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AuctionSpecialDetailArtistCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AuctionSpecialDetailArtistCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AuctionItemCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AuctionItemCell class])];
    [self.tableView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
    [self.tableView addRefreshFooterWithTarget:self action:@selector(selectAuctionGoodsListByAuctionFieldId:)];

}
#pragma mark - 网络请求
/// 专场详情
- (void)loadData:(id _Nullable)sender{
    [ApiUtil getWithParent:self url:[ApiUtilHeader selectAuctionFieldInfoById:self.auctionFieldId] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response) {
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            self.auctionModel = [AuctionModel yy_modelWithDictionary:data];
            
            [self initRightNaviBar];
            [self getArtistBaseInfo:sender];
            [self selectAuctionGoodsListByAuctionFieldId:sender];
        }else
            [self.tableView endAllFreshing];
        
        [self.tableView reloadData];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [self.tableView endAllFreshing];
    }];
}

/// 拍品列表
- (void)selectAuctionGoodsListByAuctionFieldId:(id _Nullable)sender{
    NSLog(@"sender相关%@",sender);
    if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
        [SVProgressHUD show];
    }
    if (sender && [sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        self.page ++;
    }else {
        self.page = 1;
        if (self.listData.count) [self.listData removeAllObjects];
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"current"] = @(self.page);
    dic[@"size"] = @"10";
    dic[@"auctionFieldId"] = self.auctionFieldId;
    if (self.nameInputStr.length) {
        dic[@"keyword"] = self.nameInputStr;
    }
    [ApiUtil postWithParent:self url:[ApiUtilHeader selectAuctionGoodsListByAuctionFieldId] needHUD:NO params:dic success:^(NSInteger code, id  _Nullable response) {
        [self.tableView endAllFreshing];
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            self.auctionGoodTotalAmount = [ToolUtil isEqualToNonNull:[data objectForKey:@"total"] replace:@"0"];
            NSArray *records = (NSArray *)[data objectForKey:@"records"];
            if (records && records.count) {
                [self.listData addObjectsFromArray:[NSArray yy_modelArrayWithClass:[AuctionItemModel class] json:records]];
            }
            [self.tableView updataFreshFooter:(self.listData.count && records.count != MaxListCount)];
        }
        self.tableView.mj_footer.hidden = !self.listData.count;
        [self.tableView reloadData];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [self.tableView endAllFreshing];
        [SVProgressHUD showError:errorMsg];
    }];
}

/// 用户关注信息
- (void)getArtistBaseInfo:(id _Nullable)sender {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"artist_id"] = [ToolUtil isEqualToNonNullKong:self.auctionModel.hostUserId];
    params[@"user_id"] = [UserInfoManager shareManager].uid;
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader get_artist_base_info] needHUD:NO params:params success:^(NSInteger code, id  _Nullable response) {
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            self.auctionModel.is_collect = [ToolUtil isEqualToNonNull:[data objectForKey:@"is_collect"] replace:@"0"];
            self.auctionModel.artist_title = [[data objectForKey:@"user_info"] objectForKey:@"artist_title"];
            self.auctionModel.headimg = [[data objectForKey:@"user_info"] objectForKey:@"headimg"];
            self.auctionModel.utype = [[data objectForKey:@"user_info"] objectForKey:@"utype"];
        }
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        
    }];
//    [ApiUtil getWithParent:self url:[ApiUtilHeader get_artist_base_info] needHUD:NO params:params success:^(NSInteger code, id  _Nullable response) {
//        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
//        if (data && data.count) {
//            self.auctionModel.is_collect = [ToolUtil isEqualToNonNull:[data objectForKey:@"is_collect"] replace:@"0"];
//            self.artist_title = [[data objectForKey:@"user_info"] objectForKey:@"artist_title"];
//        }
//        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {}];
}

/// 查询用户号牌详情
- (void)selectAuctionUserPlateNumberByCurrentUser{
    [ApiUtil getWithParent:self url:[ApiUtilHeader selectAuctionUserPlateNumberByCurrentUser:self.auctionFieldId] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response) {
        if (response) {
            self.plateNumberModel = [PlateNumberModel yy_modelWithDictionary:response[@"data"]];
        }
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        
    }];
}


- (void)setPlateNumberModel:(PlateNumberModel *)plateNumberModel{
    _plateNumberModel = plateNumberModel;
    if ([plateNumberModel.isValid isEqualToString:@"2"]) {//号牌已生效
        self.applyNumberPlateButton.hidden = YES;
        self.applyNumberPlateLabel.text = [NSString stringWithFormat:@"我的号牌：%@",plateNumberModel.auctionFieldPlateNumber];
        self.applyNumberPlateLabel.hidden = NO;
    }else{
        self.applyNumberPlateButton.hidden = NO;
        self.applyNumberPlateLabel.hidden = YES;
    }
}

- (void)setAuctionModel:(AuctionModel *)auctionModel{
    _auctionModel = auctionModel;
    if ([auctionModel.fieldStatus isEqualToString:@"7"]) {
        self.bottomView.hidden = YES;
    }else{
        self.bottomView.hidden = NO;
    }
}
#pragma mark - Click
//办理号牌
- (IBAction)applyNumberPlateClick:(UIButton *)sender {
    AuctionApplyNumberPlateController *vc = [[AuctionApplyNumberPlateController alloc] init];
    vc.auctionFieldId = self.auctionFieldId;
    [self.navigationController pushViewController:vc animated:YES];
    
    

}

//进入专场
- (IBAction)goActionLiveRoom:(UIButton *)sender {
    AuctionLiveRoomViewController *vc = [[AuctionLiveRoomViewController alloc] init];
    vc.auctionModel = self.auctionModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickToRuler:(id)sender {
    WebViewURLViewController *webVC = [[WebViewURLViewController alloc] initWithUrlString:[ApiUtil_H5Header h5_agreement:@"YSRMTZBPMJJGZ"]];
    webVC.navigationBarTitle = @"艺术融媒体直播拍卖加价规则";
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)clickToFocus:(AMButton *)sender {
    if (![UserInfoManager shareManager].isLogin) {
        [self jumpToLoginWithBlock:nil];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];

    params[@"uid"] = [UserInfoManager shareManager].uid;
    params[@"collect_uid"] = [ToolUtil isEqualToNonNullKong:self.auctionModel.hostUserId];

    [ApiUtil postWithParent:self url:[ApiUtilHeader collectUser] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        
        BOOL is_collect = self.auctionModel.is_collect.boolValue;
        is_collect = !is_collect;
        if (is_collect) {
            [SVProgressHUD showSuccess:@"已关注" completion:^{
                sender.selected = is_collect;
                self.auctionModel.is_collect = StringWithFormat(@(is_collect));
            }];
        }else {
            sender.selected = is_collect;
            self.auctionModel.is_collect = StringWithFormat(@(is_collect));
        }
    } fail:nil];
}

- (void)clickToPersonal {
    if (![UserInfoManager shareManager].isLogin) {
        [self jumpToLoginWithBlock:nil];
        return;
    }
    AMBaseUserHomepageViewController * vc = [[AMBaseUserHomepageViewController alloc] init];
    vc.artuid = [ToolUtil isEqualToNonNullKong:self.auctionModel.hostUserId];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate ,UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            AuctionSpecialDetailHeadImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AuctionSpecialDetailHeadImageCell class]) forIndexPath:indexPath];
            cell.model = self.auctionModel;
            return cell;
        }else if(indexPath.row == 1){
            AuctionSpecialDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AuctionSpecialDetailInfoCell class]) forIndexPath:indexPath];
            cell.model = self.auctionModel;
            return cell;
        }else{//indexPath.row == 2
            AuctionSpecialDetailArtistCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AuctionSpecialDetailArtistCell class]) forIndexPath:indexPath];
            cell.model = self.auctionModel;
            @weakify(self);
            cell.focusBlock = ^(AMButton * _Nonnull sender) {
                @strongify(self);
                [self clickToFocus:sender];
            };
            cell.clickToPersonal = ^{
                @strongify(self);
                [self clickToPersonal];
            };
//            if ([self.auctionModel.createUserId isEqualToString:[UserInfoManager shareManager].uid]) {
//                cell.hidden = YES;
//            }else{
//                cell.hidden = NO;
//            }
            return cell;
        }
    }else{//section == 1
        AuctionItemCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AuctionItemCell class]) forIndexPath:indexPath];
        if (self.listData.count) cell.model = self.listData[indexPath.row];
        return cell;
    }
}

- (void)clickToShare:(id)sender {
    AMShareView *shareView = [AMShareView shareInstanceWithStyle:AMShareViewStyleInvite];
    shareView.params = @{@"title":[ToolUtil isEqualToNonNullKong:self.auctionModel.auctionFieldTitle],
                         @"des":[NSString stringWithFormat:@"By %@",[ToolUtil isEqualToNonNull:self.auctionModel.createUserName replace:@"潮流艺术家"]],
                         @"img":[ToolUtil getNetImageURLStringWith:self.auctionModel.auctionFieldImage],
                         @"url":[ApiUtil_H5Header h5_shareForspecOccas:self.auctionFieldId]};
    [shareView show];
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
        return self.listData.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        AuctionItemHeadView *head = [AuctionItemHeadView shareInstance];
//        head.totalAmount = self.auctionGoodTotalAmount;
        [head setup:self.auctionGoodTotalAmount nameTextF:self.nameInputStr];
        @weakify(self);
        head.clickToGoAnyDetail = ^(BOOL isNum, NSString * _Nullable inputString) {
            @strongify(self);
            if (isNum) {
                [self clickToSearchDetailWith:inputString];
            } else {
                self.nameInputStr = inputString;
                [self selectAuctionGoodsListByAuctionFieldId:self];
            }
        };
        return head;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 60;
    }else{
        return CGFLOAT_MIN;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }else{
        if (!self.listData.count) {
            return 178;
        }
        return CGFLOAT_MIN;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        if (!self.listData.count) {
            AMEmptyView *view = [AMEmptyView emptyViewWithImageStr:@"icon-hummer-current" titleStr:@"" detailStr:@"没有该拍品"];
            BaseView *baseV = [[BaseView alloc] init];
            [baseV addSubview:view];
            return baseV;
        }
    }
    return nil;;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0 && indexPath.row == 2) {
//        if ([self.auctionModel.createUserId isEqualToString:[UserInfoManager shareManager].uid]) {
//            return CGFLOAT_MIN;
//        }else{
//            return UITableViewAutomaticDimension;
//        }
//    }else{
//        return UITableViewAutomaticDimension;
//    }
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        AuctionItemDetailViewController *vc = [[AuctionItemDetailViewController alloc] init];
        vc.auctionGoodId = self.listData[indexPath.row].auctionGoodId;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.section == 0){
        if (indexPath.row == 2) {
            if (![UserInfoManager shareManager].isLogin) {
                [self jumpToLoginWithBlock:nil];
                return;
            }
            AMBaseUserHomepageViewController * vc = [[AMBaseUserHomepageViewController alloc] init];
            vc.artuid = [ToolUtil isEqualToNonNullKong:self.auctionModel.hostUserId];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark -
- (void)clickToSearchDetailWith:(NSString *)numStr {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"goodNumber"] = numStr;
    params[@"auctionFieldId"] = self.auctionFieldId;
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader selectAuctionGoodIdByGoodNumberAndFieldId] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            NSString *auctionGoodId = (NSString *)[data objectForKey:@"auctionGoodId"];
            if ([ToolUtil isEqualToNonNull:auctionGoodId]) {
                AuctionItemDetailViewController *vc = [[AuctionItemDetailViewController alloc] init];
                vc.auctionGoodId = auctionGoodId;
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
        }
        [SVProgressHUD showMsg:@"数据错误，请重试"];
    } fail:nil];
}

@end
