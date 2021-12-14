//
//  AMAuctionOrderFillViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/11/13.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMAuctionOrderFillViewController.h"
#import "AdressViewController.h"
#import "AddAdressViewController.h"
#import "AMPayViewController.h"
#import "AMAuctionPayResultViewController.h"
#import "AMAuctionOrderViewController.h"

#import "AMAuctionShoppingCartTableCell.h"
#import "AMAuctionShoppingCartHeaderTableCell.h"
#import "AMAuctionOrderAddressTableCell.h"
#import "AMAuctionOrderFillInfoTableCell.h"
#import "AMAuctionOrderNonAddressTableCell.h"

#import "AMAuctionOrderModel.h"

#import "AMPayManager.h"

@interface AMAuctionOrderFillViewController () <UITableViewDelegate, UITableViewDataSource, AMPayDelegate, AMPayManagerDelagate>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPirceLabel;
@property (weak, nonatomic) IBOutlet AMButton *submitBtn;

/// 发货信息
@property (nonatomic ,strong) MyAddressModel *addressModel;

@property (nonatomic ,strong) NSArray *orders;

@end

@implementation AMAuctionOrderFillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.submitBtn.titleLabel.font = [UIFont addHanSanSC:14.0 fontType:2];
    [self.submitBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xE05227)] forState:UIControlStateNormal];
    [self.submitBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0x9D9B98)] forState:UIControlStateDisabled];
    self.leftTitleLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
    self.totalPirceLabel.font = [UIFont addHanSanSC:16.0 fontType:2];
    self.totalPirceLabel.text = [NSString stringWithFormat:@"¥%.2f", [ToolUtil isEqualToNonNull:self.totalPrice replace:@"0"].doubleValue];
    
    self.tableView.bgColorStyle = AMBaseTableViewBackgroundColorStyleGray;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMAuctionShoppingCartTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMAuctionShoppingCartTableCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMAuctionShoppingCartHeaderTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMAuctionShoppingCartHeaderTableCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMAuctionOrderAddressTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMAuctionOrderAddressTableCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMAuctionOrderFillInfoTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMAuctionOrderFillInfoTableCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMAuctionOrderNonAddressTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMAuctionOrderNonAddressTableCell class])];
    
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"填写订单";
    
    [self loadData];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2 + self.lots.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == ([tableView numberOfSections] - 1)) {
        return 1;
    }
    return self.lots[section - 1].lots.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (!self.addressModel || ![ToolUtil isEqualToNonNull:self.addressModel.ID]) {
            AMAuctionOrderNonAddressTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMAuctionOrderNonAddressTableCell class]) forIndexPath:indexPath];
            
            return cell;
        }
        AMAuctionOrderAddressTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMAuctionOrderAddressTableCell class]) forIndexPath:indexPath];
        cell.addressModel = self.addressModel;
        
        return cell;
    }else if (indexPath.section == ([tableView numberOfSections] -1)) {
        AMAuctionOrderFillInfoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMAuctionOrderFillInfoTableCell class]) forIndexPath:indexPath];
        cell.priceStr = self.totalPirceLabel.text;
        
        return cell;
    }else {
        NSInteger index = indexPath.section - 1;
        if (indexPath.row) {
            AMAuctionShoppingCartTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMAuctionShoppingCartTableCell class]) forIndexPath:indexPath];
            
            cell.model = [self.lots[index].lots objectAtIndex:(indexPath.row - 1)];
            
            cell.hiddenBottomMargin = indexPath.row == 1;
            cell.insets = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0);
            if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
                cell.needCorner = YES;
                cell.rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
                cell.cornerRudis = 8.0f;
            }else
                cell.needCorner = NO;
            
            return cell;
        }else {
            AMAuctionShoppingCartHeaderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMAuctionShoppingCartHeaderTableCell class]) forIndexPath:indexPath];
            cell.model = self.lots[index];
            
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section?CGFLOAT_MIN:20.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        @weakify(self);
        if (self.addressModel && [ToolUtil isEqualToNonNull:self.addressModel.ID]) {/// 有地址时
            AdressViewController *addressVC = [[AdressViewController alloc]init];
            addressVC.style = 1;
            addressVC.chooseAdress = ^(MyAddressModel * _Nonnull adressModel) {
                self.addressModel = adressModel;
                @strongify(self);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.addressModel && [ToolUtil isEqualToNonNull:self.addressModel.ID]) {
                        self.submitBtn.enabled = YES;
                    }else
                        self.submitBtn.enabled = NO;
                    [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                });
            };
            [self.navigationController pushViewController:addressVC animated:YES];
        }else {/// 无地址时
            AddAdressViewController *addVC = [[AddAdressViewController alloc] init];
            addVC.type = 1;
            addVC.clickToNewAddress = ^(MyAddressModel * _Nonnull model) {
                @strongify(self);
                [self loadData];
            };
            [self.navigationController pushViewController:addVC animated:YES];
        }
    }
}

#pragma mark -
- (void)payViewController:(BaseViewController *)payViewController didSelectPayForWay:(AMPayWay)payWay {
    @weakify(self);
    if (payWay == AMPayWayDefault) {
        [payViewController dismissViewControllerAnimated:YES completion:^{
            @strongify(self);
            [self clickToOrderList];
        }];
        return;
    }
    [payViewController dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        switch (payWay) {
            case AMPayWayWX:///微信支付
                [[AMPayManager shareManager] payCommonWithRelevanceMap:self.orders withPayType:5 byChannel:2 delegate:self];
                break;
            case AMPayWayAlipay:///支付宝支付
                [[AMPayManager shareManager] payCommonWithRelevanceMap:self.orders withPayType:5 byChannel:1 delegate:self];
                break;
            case AMPayWayOffline: {/// 线下支付
                [[AMPayManager shareManager] payCommonWithRelevanceMap:self.orders withPayType:5 byChannel:4 delegate:self];
                break;
            }
            default:
                break;
        }
    }];
}

#pragma mark - AMPayManagerDelagate
- (void)getAlipayPayResult:(BOOL)isSuccess {
    if (isSuccess) [self clickToPayResult:AMPayWayAlipay];
    else [self clickToOrderList];
}

- (void)getWXPayResult:(BOOL)isSuccess {
    if (isSuccess) [self clickToPayResult:AMPayWayWX];
    else [self clickToOrderList];
}

- (void)getOfflinePayResult:(BOOL)isSuccess offlineTradeNo:(NSString *)offlineTradeNo {
    if (isSuccess) [self clickToPayResult:AMPayWayOffline];
    else [self clickToOrderList];
}

#pragma mark -
- (IBAction)clickToSubmit:(id)sender {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"reciverAddress"] = [NSString stringWithFormat:@"%@%@",[ToolUtil isEqualToNonNullKong:_addressModel.addrregion], [ToolUtil isEqualToNonNullKong:_addressModel.address]];
    params[@"reciverMobile"] = [ToolUtil isEqualToNonNullKong:_addressModel.phone];
    params[@"reciverName"] = [ToolUtil isEqualToNonNullKong:_addressModel.reciver];
    NSMutableArray *businesses = @[].mutableCopy;
    [self.lots enumerateObjectsUsingBlock:^(AMAuctionOrderBusinessModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *preOrder = @{}.mutableCopy;
        NSMutableArray *lots = @[].mutableCopy;
        [obj.lots enumerateObjectsUsingBlock:^(AMAuctionLotModel * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            [lots addObject:obj1.unsettledAuctionGoodsId];
        }];
        preOrder[@"unsettledGoodsList"] = lots;
        preOrder[@"hostUserId"] = [ToolUtil isEqualToNonNull:obj.hostUserId replace:@"0"];
        
        [businesses addObject:preOrder];
    }];
    params[@"preOrderList"] = businesses;
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader addAuctionGoodOrder] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        self.orders = (NSArray *)[response objectForKey:@"data"];
        if (self.orders && self.orders.count) {
            [self showPayView:nil];
        }else
            [SVProgressHUD showError:@"下单失败，请重试或联系客服"];
    } fail:nil];
    
}

#pragma mark -
- (void)loadData {
    [ApiUtil postWithParent:self url:[ApiUtilHeader getUserDefaultAddress] needHUD:NO params:@{@"uid":[UserInfoManager shareManager].uid} success:^(NSInteger code, id  _Nullable response) {
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            self.addressModel = [MyAddressModel yy_modelWithDictionary:data];
        }else
            self.addressModel = nil;
        
        self.submitBtn.enabled = NO;
        if (self.addressModel && [ToolUtil isEqualToNonNull:self.addressModel.ID])
            self.submitBtn.enabled = YES;
            
        [self.tableView reloadData];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        self.addressModel = nil;
        self.submitBtn.enabled = NO;
        [self.tableView reloadData];
    }];
}

- (void)showPayView:(NSString *)orderID {
    AMPayViewController *payVC = [[AMPayViewController alloc] init];
    payVC.delegate = self;
    payVC.priceStr = [self.totalPirceLabel.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
    payVC.payStyle = AMAwakenPayStyleAuction;
    [self.navigationController presentViewController:payVC animated:YES completion:nil];
}

- (void)clickToPayResult:(AMPayWay)payWay {
    AMAuctionPayResultViewController *resultVC = [[AMAuctionPayResultViewController alloc] init];
    resultVC.payWay = payWay;
    resultVC.priceStr = self.totalPrice;
    
    [self.navigationController pushViewController:resultVC animated:YES];
}

- (void)clickToOrderList {
    AMAuctionOrderViewController *listVC = [[AMAuctionOrderViewController alloc] init];
    listVC.needBackHome = YES;
    listVC.pageIndex = 1;
    [self.navigationController pushViewController:listVC animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
