//
//  ECoinRechargeViewController.m
//  ArtMedia2
//
//  Created by LY on 2020/10/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "ECoinRechargeViewController.h"
#import "FKAlertSingleController.h"
#import "WebViewURLViewController.h"

#import "ECoinCollectionCell.h"

#import "ECoinRechargeMoneyModel.h"
#import "ECoinModel.h"
#import "TimeTool.h"
#import "AMInAppPerchaseTool.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface ECoinRechargeViewController ()<UICollectionViewDelegate , UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeight;
@property (nonatomic , strong) NSMutableArray <ECoinRechargeMoneyModel *>*listData;
@property (weak, nonatomic) IBOutlet UIButton *protocolButton;
@property (nonatomic , strong) ECoinRechargeMoneyModel *rechargeModel;
@property (weak, nonatomic) IBOutlet UIButton *payButton;

@property (nonatomic , strong) AMInAppPerchaseTool *inAppPerchaseTool;
@property (nonatomic , strong) ECoinModel *model;

@property (nonatomic , copy) NSString *goldOrderId;//自己后台生成的订单ID
@property (nonatomic , copy) NSString *transaction_id;//Apple内购订单ID
@end

@implementation ECoinRechargeViewController
- (AMInAppPerchaseTool *)inAppPerchaseTool{
    if (!_inAppPerchaseTool) {
        _inAppPerchaseTool = [[AMInAppPerchaseTool alloc] init];
    }
    return _inAppPerchaseTool;
}
- (NSMutableArray *)listData{
    if (!_listData) {
        _listData = [[NSMutableArray alloc] init];
        [_listData addObjectsFromArray:[NSMutableArray yy_modelArrayWithClass:[ECoinRechargeMoneyModel class] json:@[
            @{
                @"moneyShow":@"42",
                @"moneyValue":@"6.00",
                @"inAppPerchaseID":@"com.mscm.artvideo.01"
            },
            @{
                @"moneyShow":@"126",
                @"moneyValue":@"18.00",
                @"inAppPerchaseID":@"com.mscm.artvideo.02"
            },
            @{
                @"moneyShow":@"476",
                @"moneyValue":@"68.00",
                @"inAppPerchaseID":@"com.mscm.artvideo.03"
            },
            @{
                @"moneyShow":@"896",
                @"moneyValue":@"128.00",
                @"inAppPerchaseID":@"com.mscm.artvideo.04"
            },
            @{
                @"moneyShow":@"1806",
                @"moneyValue":@"258.00",
                @"inAppPerchaseID":@"com.mscm.artvideo.05"
            },
            @{
                @"moneyShow":@"4536",
                @"moneyValue":@"648.00",
                @"inAppPerchaseID":@"com.mscm.artvideo.06"
            }
        ] ]];
        [_listData enumerateObjectsUsingBlock:^(ECoinRechargeMoneyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 0) {
                obj.select = YES;
                self.rechargeModel = obj;
            }
        }];
    }
    return _listData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCollectionView];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHUD) name:@"IAPShowHUD" object:nil];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"支付即同意《艺术融媒体充值服务协议》"];
    [attString addAttributes:@{NSForegroundColorAttributeName :RGB(54, 152, 214) } range:NSMakeRange(5, attString.length - 5)];
    [self.protocolButton setAttributedTitle:attString forState:UIControlStateNormal];
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    [self loadData];
//    [self selectBasicRmbVmoneyRatioList];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"艺币充值";
    [self addRightNaviBarItem];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)showHUD{
    [SVProgressHUD show];
}


- (void)loadData{
    [ApiUtil getWithParent:self url:[ApiUtilHeader selectUserWalletByUserId] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response) {
        self.model = [ECoinModel yy_modelWithDictionary:response[@"data"]];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        
    }];
}

- (void)selectBasicRmbVmoneyRatioList{
    [ApiUtil getWithParent:self url:[ApiUtilHeader selectBasicRmbVmoneyRatioList] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response) {
        [self.listData addObjectsFromArray: [NSArray yy_modelArrayWithClass:[ECoinRechargeMoneyModel class] json:response[@"data"] ]];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        
    }];
}

- (void)setModel:(ECoinModel *)model{
    _model = model;
    self.balanceLabel.text = [NSString stringWithFormat:@"%@艺币",model.nowVirtualMoney];
}

- (void)setCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 12;
    flowLayout.itemSize = CGSizeMake((K_Width - 36 - 12*2)/3 , 70);
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ECoinCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([ECoinCollectionCell class])];
    [self.collectionView reloadData];
    self.collectionHeight.constant = ceilf(self.listData.count/3 + 1)*70 + (ceilf(self.listData.count/3))*10;
}

- (void)addRightNaviBarItem {
    AMButton *rightBtn = [AMButton buttonWithType:UIButtonTypeCustom];
    rightBtn.width = 44;
    rightBtn.height = 44;
    [rightBtn setImage:[UIImage imageNamed:@"wenhao_black"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(questionClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}
- (void)questionClick{
    WebViewURLViewController *webView = [[WebViewURLViewController alloc] initWithUrlString:[ApiUtil_H5Header h5_YBSM]];
    webView.navigationBarTitle = @"艺币说明";
    [self.navigationController pushViewController:webView animated:YES];
}
- (IBAction)gotoProtocolClick:(UIButton *)sender {
    WebViewURLViewController *webView = [[WebViewURLViewController alloc] initWithUrlString:[ApiUtil_H5Header h5_YSRMTCZFWXY]];
    webView.navigationBarTitle = @"充值服务协议";
    [self.navigationController pushViewController:webView animated:YES];
}
- (void)setGoldOrderId:(NSString *)goldOrderId{
    _goldOrderId = goldOrderId;
//    [SVProgressHUD show];
    //调起苹果支付

    [self.inAppPerchaseTool startPurchWithID:self.rechargeModel.inAppPerchaseID completeHandle:^(IAPPurchType type, NSData * _Nonnull data, NSDictionary * _Nonnull response) {
        if (type == KIAPPurchVerSuccess) {
            NSLog(@"内购验证成功");
            NSLog(@"%@",response);
            NSArray *array = response[@"receipt"][@"in_app"];
            NSDictionary *dic = array[0];
            NSLog(@"transaction_id == %@",dic[@"transaction_id"]);
            self.transaction_id = dic[@"transaction_id"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            });
            
        }else if(type == kIAPPurchSuccess){
            NSLog(@"内购付款成功");
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            });
        }
        
    }];
}
//统一支付，告诉服务器苹果生成的订单号
- (void)payTeaOrder:(NSString *)transactionId{
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"relevanceId"] = self.goldOrderId;
    params[@"relevanceType"] = @"2";
    params[@"tradingChannel"] = @"3";
    params[@"transactionId"] = transactionId;
    
    [ApiUtil postWithParent:nil url:[ApiUtilHeader payTeaOrder] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        NSLog(@"%@",response);
        [self applePayNotify_applePayAmount:response[@"data"][@"applePayAmount"] applePayTradeNo:response[@"data"][@"applePayTradeNo"]];
    } fail:nil];
}
- (void)applePayNotify_applePayAmount:(NSString *)applePayAmount applePayTradeNo:(NSString *)applePayTradeNo{
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"payStatus"] = @"success";
    params[@"totalAmount"] = applePayAmount;
    params[@"tradeNo"] = applePayTradeNo;
    params[@"payTime"] = [TimeTool getCurrentDateStr];
//    params[@"receiptData"] = @"";
    [ApiUtil postWithParent:nil url:[ApiUtilHeader applePayNotify] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [self loadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccess:@"充值艺币成功！"];
        });
        
    } fail:nil];
}

//调起苹果内购
- (IBAction)payClick:(UIButton *)sender {
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"payEquipment"] = @"1";
    dic[@"virtualGoldPrice"] = self.rechargeModel.moneyShow;
    dic[@"orderPrice"] = self.rechargeModel.moneyValue;
    [ApiUtil postWithParent:self url:[ApiUtilHeader addLiveVrtualGoldOrder] needHUD:YES params:dic success:^(NSInteger code, id  _Nullable response) {
        if (response && response[@"data"]) {
            self.goldOrderId = response[@"data"][@"goldOrderId"];
        }
        
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [SVProgressHUD showError:errorMsg];
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
    
    
}
- (void)setTransaction_id:(NSString *)transaction_id{
    _transaction_id = transaction_id;
    if (transaction_id.length > 0) {
        [self payTeaOrder:transaction_id];
    }else{
        [SVProgressHUD showError:@"内购失败"];
    }
}
- (void)setRechargeModel:(ECoinRechargeMoneyModel *)rechargeModel{
    _rechargeModel = rechargeModel;
    
    [self.payButton setTitle:[NSString stringWithFormat:@"立即支付 ￥%@",rechargeModel.moneyValue] forState:UIControlStateNormal];
}


#pragma mark - UICollectionViewDelegate , UICollectionViewDataSource
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ECoinCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ECoinCollectionCell class]) forIndexPath:indexPath];
    cell.model = self.listData[indexPath.row];
  
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.listData.count;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.rechargeModel = self.listData[indexPath.row];
    ECoinRechargeMoneyModel *model = self.listData[indexPath.row];
    [self.listData enumerateObjectsUsingBlock:^(ECoinRechargeMoneyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (model == obj) {
            obj.select = YES;
            
        }else{
            obj.select = NO;
        }
    }];
    [collectionView reloadData];
}

@end
