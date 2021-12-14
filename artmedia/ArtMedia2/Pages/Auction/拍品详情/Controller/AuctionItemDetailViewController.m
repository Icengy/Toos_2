//
//  AuctionItemDetailViewController.m
//  ArtMedia2
//
//  Created by 刘洋 on 2020/11/23.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AuctionItemDetailViewController.h"
#import "AuctionLiveRoomViewController.h"
#import "FKAlertController.h"
#import "AuctionApplyNumberPlateController.h"
#import "WebViewURLViewController.h"
#import "AMOfferPriceListViewController.h"
#import "FKAlertSingleController.h"

#import "AuctionItemDetailCycleImageCell.h"
#import "AuctionItemDetailInfoCell.h"
#import "AuctionItemBidRecordCell.h"
#import "AMAuctionGoodsPartWebTableCell.h"
#import "AuctionItemBidRecordHeadView.h"
#import "AMShareView.h"

#import "AuctionItemDetailModel.h"
#import "AuctionOfferPriceRecordModel.h"
#import "PlateNumberModel.h"
#import "AuctionModel.h"
#import "AMNextPriceModel.h"

@interface AuctionItemDetailViewController ()<UITableViewDelegate , UITableViewDataSource , AMAuctionGoodsPartWebDelegate, AMShareViewDelegate , AMOfferPriceListDelegate>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (nonatomic , strong) NSMutableArray <AuctionOfferPriceRecordModel *>*OfferPriceList;
@property (nonatomic , strong) AuctionItemDetailModel *detailModel;

@property (weak, nonatomic) IBOutlet UILabel *bidPriceLabel;
@property (nonatomic , strong) PlateNumberModel *plateNumberModel;
@property (nonatomic , assign) CGFloat webViewHeight;
@property (weak, nonatomic) IBOutlet AMButton *bidBtn;
@property (nonatomic , strong) AuctionModel *auctionModel;
//@property (nonatomic , copy) NSString *nextOfferPrice;//下一口价
@property (weak, nonatomic) IBOutlet UIView *bottomView;//底部
@property (nonatomic , strong) AMNextPriceModel *nextPriceModel;//下一口价模型

//@property (nonatomic , copy) NSString *auctionFieldId;

@end

@implementation AuctionItemDetailViewController {
    NSInteger _bidTotalTimes;
}

- (NSMutableArray *)OfferPriceList{
    if (!_OfferPriceList) {
        _OfferPriceList = [[NSMutableArray alloc] init];
    }
    return _OfferPriceList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bidPriceLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
    self.bidBtn.titleLabel.font = [UIFont addHanSanSC:14.0 fontType:2];
    
    _webViewHeight = 0.0;
    _bidTotalTimes = 0;
    
    [self setTableView];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)setTableView {
    self.tableView.bgColorStyle = AMBaseTableViewBackgroundColorStyleGray;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AuctionItemDetailCycleImageCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AuctionItemDetailCycleImageCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AuctionItemDetailInfoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AuctionItemDetailInfoCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AuctionItemBidRecordCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AuctionItemBidRecordCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMAuctionGoodsPartWebTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMAuctionGoodsPartWebTableCell class])];
    
    [self.tableView addRefreshHeaderWithTarget:self action:@selector(loadData)];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}


//- (void)setDetailModel:(AuctionItemDetailModel *)detailModel{
//    _detailModel = detailModel;
//    if ([detailModel.auctionGoodStatus isEqualToString:@"3"]) {
//        self.bottomView.hidden = YES;
//    }else{
//        self.bottomView.hidden = NO;
//    }
//}
- (void)setAuctionModel:(AuctionModel *)auctionModel{
    _auctionModel = auctionModel;
    if (([auctionModel.fieldStatus isEqualToString:@"6"] || [auctionModel.fieldStatus isEqualToString:@"5"]) && [self.detailModel.auctionGoodStatus isEqualToString:@"2"]) {
        self.bottomView.hidden = NO;
    }else{
        self.bottomView.hidden = YES;
    }
}



- (void)setPlateNumberModel:(PlateNumberModel *)plateNumberModel{
    _plateNumberModel = plateNumberModel;
    if ([plateNumberModel.isValid isEqualToString:@"2"]) {//号牌已生效
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        dic[@"auctionGoodId"] = self.auctionGoodId;
//        dic[@"auctionUserOfferPrice"] = self.nextPriceModel.nextOfferPrice;
//        [ApiUtil postWithParent:self url:[ApiUtilHeader addOfferPriceToAuctionGoodsOfCurrentUser] needHUD:YES params:dic success:^(NSInteger code, id  _Nullable response) {
//            if (response) {
//                [SVProgressHUD showMsg:@"出价成功！" completion:^{
//                    [self loadData];
//                }];
//            }
//        } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
//            NSLog(@"出价失败");
//            [self selectNextOfferPriceByAuctionGoodId];
//            [self selectAuctionGoodsOfferPriceListByAuctionGoodId];
//        }];
        
        AMOfferPriceListViewController *vc = [[AMOfferPriceListViewController alloc] init];
        vc.delegate = self;
        vc.auctionGoodId = self.auctionGoodId;
        [vc showWithController:self];
    }else{//号牌未生效
        FKAlertController *alert = [[FKAlertController alloc] init];
        [alert showAlertWithController:self title:@"提示" content:@"参拍需要先办理号牌" sureClickBlock:^{
            AuctionApplyNumberPlateController *vc = [[AuctionApplyNumberPlateController alloc] init];
            vc.auctionFieldId = self.detailModel.auctionFieldId;
            [self.navigationController pushViewController:vc animated:YES];
        } sureCompletion:^{

        }];
    }
    

}
- (void)priceListOfferPrice:(NSString *)price{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"auctionGoodId"] = self.auctionGoodId;
    dic[@"auctionUserOfferPrice"] = price;
    [ApiUtil postWithParent:self url:[ApiUtilHeader addOfferPriceToAuctionGoodsOfCurrentUser] needHUD:YES params:dic success:^(NSInteger code, id  _Nullable response) {
        if (response) {
            [SVProgressHUD showMsg:@"出价成功！" completion:^{
                [self loadData];
            }];
        }
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
//        [SVProgressHUD showError:errorMsg];
        FKAlertSingleController *alert = [[FKAlertSingleController alloc] init];
        [alert showAlertWithController:self title:@"提示" content:errorMsg sureClickBlock:^{
            
        } sureCompletion:^{
            
        }];
        [self selectNextOfferPriceByAuctionGoodId];
        [self selectAuctionGoodsOfferPriceListByAuctionGoodId];
    }];
}



- (void)clickToShare {
    AMShareView *shareView = [AMShareView shareInstanceWithStyle:AMShareViewStyleInvite];
    shareView.params = @{@"title":[ToolUtil isEqualToNonNullKong:self.detailModel.opusTitle],
                         @"des":[NSString stringWithFormat:@"起拍价 ¥%@", [ToolUtil isEqualToNonNull:self.detailModel.auctionStartPrice replace:@"0"]],
                         @"img":[ToolUtil getNetImageURLStringWith:self.detailModel.opusCoverImage],
                         @"url":[ApiUtil_H5Header h5_shareForAuctionItems:self.auctionGoodId]};
    [shareView show];
}

- (IBAction)goBid:(UIButton *)sender {
    [self selectAuctionUserPlateNumberByCurrentUser];
}

#pragma mark - UITableViewDelegate , UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if(section == 1){
        return self.OfferPriceList.count;
    }
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) return _webViewHeight;
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            AuctionItemDetailCycleImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AuctionItemDetailCycleImageCell class]) forIndexPath:indexPath];
            cell.model = self.detailModel;
            @weakify(self);
            cell.backBlock = ^{
                @strongify(self);
                [self.navigationController popViewControllerAnimated:YES];
            };
            cell.shareBlock = ^{
                @strongify(self);
                [self clickToShare];
            };
            return cell;
        }else{
            AuctionItemDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AuctionItemDetailInfoCell class]) forIndexPath:indexPath];
            cell.model = self.detailModel;
            cell.auctionModel = self.auctionModel;
            cell.refreshPriceBlock = ^{
                [self loadData];
            };
            cell.gotoLiveRoomBlock = ^{
                AuctionLiveRoomViewController *vc = [[AuctionLiveRoomViewController alloc] init];
                vc.auctionModel = self.auctionModel;
                [self.navigationController pushViewController:vc animated:YES];
            };
            return cell;
        }
    }else if(indexPath.section == 1){
        AuctionItemBidRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AuctionItemBidRecordCell class]) forIndexPath:indexPath];
        if(self.OfferPriceList.count) cell.model = self.OfferPriceList[indexPath.row];
        return cell;
    }else{
        AMAuctionGoodsPartWebTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMAuctionGoodsPartWebTableCell class]) forIndexPath:indexPath];
        cell.delegate = self;
        cell.webUrl = [ApiUtil_H5Header h5_auctionGoodDetail:self.auctionGoodId];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1 && self.OfferPriceList.count) {
        AuctionItemBidRecordHeadView *head = [AuctionItemBidRecordHeadView shareInstance];
        head.bidTotalTimes = _bidTotalTimes;
        @weakify(self);
        head.clickToRulersBlock = ^{
            @strongify(self);
            WebViewURLViewController *webVC = [[WebViewURLViewController alloc] initWithUrlString:[ApiUtil_H5Header h5_agreement:@"YSRMTZBPMJJGZ"]];
            webVC.navigationBarTitle = @"艺术融媒体直播拍卖加价规则";
            [self.navigationController pushViewController:webVC animated:YES];
        };
        return head;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) return 1.0;
    return 10.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1 && self.OfferPriceList.count) return 50.0;
    return CGFLOAT_MIN;
}


#pragma mark - GoodsPartWebDelegate
- (void)webCell:(AMAuctionGoodsPartWebTableCell *)webCell didFinishLoadWithScrollHeight:(CGFloat)scrollHeight {
    if (_webViewHeight != scrollHeight) {
        _webViewHeight = scrollHeight;
        [self.tableView reloadData];
    }
}

#pragma mark - 网络请求
/// 专场详情
- (void)selectAuctionFieldInfoById {
    [ApiUtil getWithParent:self url:[ApiUtilHeader selectAuctionFieldInfoById:self.detailModel.auctionFieldId] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response) {
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
        
            self.auctionModel = [AuctionModel yy_modelWithDictionary:data];
        }
        [self.tableView reloadData];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        
    }];
}

/// 拍品详情
- (void)loadData {
    [ApiUtil getWithParent:self url:[ApiUtilHeader selectAuctionGoodsById:self.auctionGoodId] needHUD:YES params:nil success:^(NSInteger code, id  _Nullable response) {
        [self.tableView endAllFreshing];
        if (response) {
            self.detailModel = [AuctionItemDetailModel yy_modelWithDictionary:response[@"data"]];
            [self selectAuctionGoodsOfferPriceListByAuctionGoodId];
            [self selectNextOfferPriceByAuctionGoodId];
            [self selectAuctionFieldInfoById];
        }
        [self.tableView reloadData];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [self.tableView endAllFreshing];
    }];
}

/// 查询用户号牌详情
- (void)selectAuctionUserPlateNumberByCurrentUser {
    [ApiUtil getWithParent:self url:[ApiUtilHeader selectAuctionUserPlateNumberByCurrentUser:self.detailModel.auctionFieldId] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response) {
        if (response) {
            self.plateNumberModel = [PlateNumberModel yy_modelWithDictionary:response[@"data"]];
        }
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        
    }];
}

/// 查看拍品出价记录
- (void)selectAuctionGoodsOfferPriceListByAuctionGoodId {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"auctionGoodId"] = self.auctionGoodId;
    dic[@"current"] = @"1";
    dic[@"size"] = @"5";
    [ApiUtil postWithParent:self url:[ApiUtilHeader selectAuctionGoodsOfferPriceListByAuctionGoodId] needHUD:NO params:dic success:^(NSInteger code, id  _Nullable response) {
        _bidTotalTimes = 0;
        if (self.OfferPriceList.count) [self.OfferPriceList removeAllObjects];
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            _bidTotalTimes = [ToolUtil isEqualToNonNull:[data objectForKey:@"total"] replace:@"0"].integerValue;
            NSArray *records = (NSArray *)[data objectForKey:@"records"];
            if (records && records.count) {
                self.OfferPriceList = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[AuctionOfferPriceRecordModel class] json:records]];
            }
        }
        [self.tableView reloadData];
    } fail:nil];
}

/// 获取下一口价
- (void)selectNextOfferPriceByAuctionGoodId{
    [ApiUtil getWithParent:self url:[ApiUtilHeader selectNextOfferPriceByAuctionGoodId:self.auctionGoodId] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response){
        if (response) {
//            self.nextOfferPrice = response[@"data"][@"nextOfferPrice"];
            self.nextPriceModel = [AMNextPriceModel yy_modelWithDictionary:response[@"data"]];
        }
    } fail:nil];
}
- (void)setNextPriceModel:(AMNextPriceModel *)nextPriceModel{
    _nextPriceModel = nextPriceModel;
    NSString *string1 = @"即将出价 ";
    NSString *string2 = [NSString stringWithFormat:@"￥%@",[ToolUtil stringToDealMoneyString:nextPriceModel.nextOfferPrice]];
    NSMutableAttributedString *attstring = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",string1,string2]];
    [attstring addAttribute:NSForegroundColorAttributeName value:RGB(224, 82, 39) range:NSMakeRange(string1.length, string2.length)];
    [attstring addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(string1.length + 1, string2.length -1)];
    self.bidPriceLabel.attributedText = attstring;
}


@end
