//
//  AuctionApplyNumberPlateController.m
//  ArtMedia2
//
//  Created by LY on 2020/11/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AuctionApplyNumberPlateController.h"
#import "AuctionApplyNumberPlateSuccessController.h"
#import "AMPayViewController.h"
#import "AMAuctionPayResultViewController.h"
#import "WebViewURLViewController.h"

#import "AuctionApplyNumberTipsCell.h"
#import "AuctionApplyNumberNomarlCell.h"
#import "AMAuctionGoodsPartWebTableCell.h"

#import "AMPayManager.h"

#import "AuctionModel.h"
#import "PlateNumberModel.h"
#import "DepositOrderModel.h"
//#import <WebKit/WebKit.h>

#import "FaceRecognitionViewController.h"
#import "PhoneAuthViewController.h"
#import "AMDialogView.h"

@interface AuctionApplyNumberPlateController ()<UITableViewDelegate , UITableViewDataSource,AMPayDelegate,AMPayManagerDelagate ,AMAuctionGoodsPartWebDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet AMButton *checkBoxButton;
@property (weak, nonatomic) IBOutlet AMButton *rulerButton;
@property (weak, nonatomic) IBOutlet AMButton *sureButton;
@property (nonatomic , strong) PlateNumberModel *plateNumberModel;//号牌模型
@property (nonatomic , strong) DepositOrderModel *depositOrderModel;//保证金订单模型
@property (nonatomic , strong) AuctionModel *auctionModel;
@property (nonatomic , assign) CGFloat webViewHeight;
//@property (nonatomic , strong) WKWebView *webView;
@end

@implementation AuctionApplyNumberPlateController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addAuctionUserPlateNumberOfOnline];
    [self selectAuctionFieldInfoById];
    self.title = @"办理号牌";
    [self setTableView];
    self.checkBoxButton.selected = NO;
    self.sureButton.enabled = NO;
    [self.sureButton setBackgroundImage:[UIImage imageWithColor:RGB(224, 82, 39)] forState:UIControlStateNormal];
    [self.sureButton setBackgroundImage:[UIImage imageWithColor:RGB(239, 239, 239)] forState:UIControlStateDisabled];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)addAuctionUserPlateNumberOfOnline{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"auctionFieldId"] = self.auctionFieldId;
    [ApiUtil postWithParent:self url:[ApiUtilHeader addAuctionUserPlateNumberOfOnline] needHUD:YES params:dic success:^(NSInteger code, id  _Nullable response) {
        if (response) {
            self.plateNumberModel = [PlateNumberModel yy_modelWithDictionary:response[@"data"]];
            [self.tableView reloadData];
        }
    } fail:nil];
}

/// 专场详情
- (void)selectAuctionFieldInfoById{
    [ApiUtil getWithParent:self url:[ApiUtilHeader selectAuctionFieldInfoById:self.auctionFieldId] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response) {
        if (response) {
            self.auctionModel = [AuctionModel yy_modelWithDictionary:response[@"data"]];
        }
    } fail:nil];
}



#pragma mark - tableView Set
- (void)setTableView{
    _webViewHeight = K_Height;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AuctionApplyNumberNomarlCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AuctionApplyNumberNomarlCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AuctionApplyNumberTipsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AuctionApplyNumberTipsCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMAuctionGoodsPartWebTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMAuctionGoodsPartWebTableCell class])];
    
}



- (IBAction)checkBoxClick:(AMButton *)sender {
    sender.selected = !sender.selected;
    self.sureButton.enabled = sender.isSelected;
}

- (IBAction)sureClick:(UIButton *)sender {
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"plateNumberLogId"] = self.plateNumberModel.plateNumberLogId;
    [ApiUtil postWithParent:nil url:[ApiUtilHeader addAuctionUserDepositOrderByPlateNumberLogId] params:params success:^(NSInteger code, id  _Nullable response) {
        if (response) {
            self.depositOrderModel = [DepositOrderModel yy_modelWithDictionary:response[@"data"]];
        }
     
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        if (errorCode == 500) {
            if ([UserInfoManager shareManager].isAuthed) {
                AuctionApplyNumberPlateController *vc = [[AuctionApplyNumberPlateController alloc] init];
                vc.auctionFieldId = self.auctionFieldId;
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
            
            //未实名
            AMAuthDialogView *dialogView = [AMAuthDialogView shareInstance];
            @weakify(dialogView);
            dialogView.imageSelectedBlock = ^(AMImageSelectedMeidaType meidaType) {
                @strongify(dialogView);
                [dialogView hide];
                if (meidaType) {
                    PhoneAuthViewController *authVC = [[PhoneAuthViewController alloc] init];
                    authVC.isFromArtistAuth = YES;
                    [self.navigationController pushViewController:authVC animated:YES];
                }else {
                    FaceRecognitionViewController *faceVC = [[FaceRecognitionViewController alloc] init];
                    faceVC.isFromArtistAuth = YES;
                    [self.navigationController pushViewController:faceVC animated:YES];
                }
            };
            [dialogView show];
        }
    }];
}

- (void)setDepositOrderModel:(DepositOrderModel *)depositOrderModel{
    _depositOrderModel = depositOrderModel;
    if ([self.auctionModel.isNeedDeposit isEqualToString:@"1"]) {//不需要保证金
        AuctionApplyNumberPlateSuccessController *vc = [[AuctionApplyNumberPlateSuccessController alloc] init];
        vc.auctionModel = self.auctionModel;
        vc.payWay = AMPayWayWX;//不需要保证金的情况下，只要不传线下保证金就行
        [self.navigationController pushViewController:vc animated:YES];
    }else{//需要保证金
        AMPayViewController *payVC = [[AMPayViewController alloc] init];
        payVC.delegate = self;
        payVC.priceStr = self.plateNumberModel.depositAmount;//正式上线修改为
        payVC.payStyle = AMAwakenPayStyleAuction;
        [self.navigationController presentViewController:payVC animated:YES completion:nil];
    }
}

- (IBAction)protocolClick:(AMButton *)sender {
    WebViewURLViewController *webVC = [[WebViewURLViewController alloc] initWithUrlString:[ApiUtil_H5Header h5_agreement:@"YSRMTZBPMJPXY"]];
    webVC.navigationBarTitle = @"艺术融媒体直播拍卖竞拍协议";
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - UITableViewDelegate , UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        AuctionApplyNumberNomarlCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AuctionApplyNumberNomarlCell class]) forIndexPath:indexPath];
        cell.titleLabel.text = @"我的号牌：";
        cell.numberLabel.text = self.plateNumberModel.auctionFieldPlateNumber;
        cell.tipsLabel.text = @"（支付后生效）";
        return cell;
    }else if (indexPath.row == 1){
        AuctionApplyNumberNomarlCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AuctionApplyNumberNomarlCell class]) forIndexPath:indexPath];
        cell.titleLabel.text = @"保证金：";
        cell.numberLabel.text = [NSString stringWithFormat:@"￥%@",self.plateNumberModel.depositAmount];
        cell.tipsLabel.text = @"（拍卖结束可退）";
        return cell;
    }else{
        AMAuctionGoodsPartWebTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMAuctionGoodsPartWebTableCell class]) forIndexPath:indexPath];
        cell.delegate = self;
        cell.webUrl = [ApiUtil_H5Header h5_agreement:@"BZJSM"];
        return cell;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) return _webViewHeight;
    return UITableViewAutomaticDimension;
}

#pragma mark - AMPayDelegate
- (void)payViewController:(BaseViewController *)payViewController didSelectPayForWay:(AMPayWay)payWay{
    if (payWay == AMPayWayDefault) {
        [payViewController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    [payViewController dismissViewControllerAnimated:YES completion:^{
        switch (payWay) {
            case AMPayWayWX:///微信支付
                [[AMPayManager shareManager] payCommonWithRelevanceMap:@[self.depositOrderModel.depositOrderId] withPayType:4 byChannel:2 delegate:self];
                break;
            case AMPayWayAlipay:///支付宝支付
                [[AMPayManager shareManager] payCommonWithRelevanceMap:@[self.depositOrderModel.depositOrderId] withPayType:4 byChannel:1 delegate:self];
                break;
            case AMPayWayOffline: {/// 线下支付
                [[AMPayManager shareManager] payCommonWithRelevanceMap:@[self.depositOrderModel.depositOrderId] withPayType:4 byChannel:4 delegate:self];
                break;
            }
            default:
                break;
        }
    }];
}

/// 返回支付宝支付结果
- (void)getAlipayPayResult:(BOOL)isSuccess{
    if (isSuccess) {
        AuctionApplyNumberPlateSuccessController *vc = [[AuctionApplyNumberPlateSuccessController alloc] init];
        vc.auctionModel = self.auctionModel;
        vc.payWay = AMPayWayAlipay;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/// 返回微信支付结果
/// @param isSuccess YES：支付成功 NO：支付失败/取消
- (void)getWXPayResult:(BOOL)isSuccess{
    NSLog(@"%d",isSuccess);
    if (isSuccess) {
        AuctionApplyNumberPlateSuccessController *vc = [[AuctionApplyNumberPlateSuccessController alloc] init];
        vc.auctionModel = self.auctionModel;
        vc.payWay = AMPayWayWX;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/// 返回线下支付结果
/// @param offlineTradeNo 商务订单号
- (void)getOfflinePayResult:(BOOL)isSuccess offlineTradeNo:(NSString *)offlineTradeNo{
    NSLog(@"%@",offlineTradeNo);
    if (isSuccess) {
        AuctionApplyNumberPlateSuccessController *vc = [[AuctionApplyNumberPlateSuccessController alloc] init];
        vc.auctionModel = self.auctionModel;
        vc.payWay = AMPayWayOffline;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)webCell:(AMAuctionGoodsPartWebTableCell *)webCell didFinishLoadWithScrollHeight:(CGFloat)scrollHeight{
    if (_webViewHeight != scrollHeight) {
        _webViewHeight = scrollHeight;
        [self.tableView reloadData];
    }
}
@end
