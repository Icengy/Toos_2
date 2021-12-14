//
//  OrderFillViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/7.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "OrderFillViewController.h"

#import "AdressViewController.h"
#import "VideoPlayerViewController.h"
#import "AddAdressViewController.h"
#import "AMPayViewController.h"
#import "MyBuyViewController.h"

#import "VideoGoodsModel.h"
#import "MyAddressModel.h"

#import "OrderAddressSelectCell.h"
#import "OrderGoodsIntroCell.h"


@interface OrderFillViewController () <UITableViewDelegate ,UITableViewDataSource, AMPayDelegate, AMPayManagerDelagate>

@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (weak, nonatomic) IBOutlet AMButton *buyBtn;
@end

@implementation OrderFillViewController {
	MyAddressModel *_addressModel;
    NSString *_orderID;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
	NSString *price = [NSString stringWithFormat:@"¥ %.2f",[(NSString *)[ToolUtil isEqualToNonNullKong:_goodsModel.sellprice] doubleValue]]?:@"";
    [self.buyBtn setTitle:[NSString stringWithFormat:@"立即支付 %@", price] forState:UIControlStateNormal | UIControlStateDisabled];
    [self.buyBtn setBackgroundImage:[UIImage imageWithColor:Color_Black] forState:UIControlStateNormal];
    [self.buyBtn setBackgroundImage:[UIImage imageWithColor:Color_Grey] forState:UIControlStateDisabled];
	self.buyBtn.titleLabel.font = [UIFont addHanSanSC:18.0f fontType:1];
    
    self.buyBtn.enabled = NO;
    _addressModel = [MyAddressModel new];
	
    self.tableView.bgColorStyle = AMBaseTableViewBackgroundColorStyleGray;
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	
	self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	
	self.tableView.tableFooterView = [UIView new];
	self.tableView.sectionFooterHeight = ADAPTATIONRATIO;
	
	[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderAddressSelectCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([OrderAddressSelectCell class])];
	[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderGoodsIntroCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([OrderGoodsIntroCell class])];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	self.navigationItem.title = @"填写订单";
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 2)
		return 2;
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		OrderAddressSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderAddressSelectCell class]) forIndexPath:indexPath];
		
		cell.addressModel = _addressModel;
		
		return cell;
	}else if (indexPath.section == 1) {
		OrderGoodsIntroCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderGoodsIntroCell class]) forIndexPath:indexPath];
		
		cell.goodsModel = _goodsModel;
		
		return cell;
	}
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([UITableViewCell class])];
	}else
		[cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
	cell.selectionStyle = UITableViewCellSeparatorStyleNone;
	
	if (indexPath.row) {
		cell.textLabel.text = @"运费";
		cell.textLabel.font = [UIFont addHanSanSC:16.0f fontType:0];
		cell.textLabel.textColor = Color_Black;
		
		cell.detailTextLabel.text = @"包邮";
//		cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",_goodsModel.freeshipping?@"包邮":@"不包邮"];
		cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
		cell.detailTextLabel.textColor = Color_Black;
		cell.detailTextLabel.font = [UIFont addHanSanSC:16.0f fontType:2];
	}else {
		cell.textLabel.text = @"商品金额";
		cell.textLabel.font = [UIFont addHanSanSC:16.0f fontType:0];
		cell.textLabel.textColor = Color_Black;
		
		cell.detailTextLabel.text = [NSString stringWithFormat:@"¥ %.2f",[(NSString *)[ToolUtil isEqualToNonNullKong:_goodsModel.sellprice] doubleValue]];
		cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
		cell.detailTextLabel.textColor = Color_Red;
		cell.detailTextLabel.font = [UIFont addHanSanSC:16.0f fontType:2];
	}
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section)
		return ADAptationMargin;
	return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.section == 0) {
        @weakify(self);
        if (_addressModel && [ToolUtil isEqualToNonNull:_addressModel.ID]) {/// 有地址时
            AdressViewController *addressVC = [[AdressViewController alloc]init];
            addressVC.style = 1;
            addressVC.chooseAdress = ^(MyAddressModel * _Nonnull adressModel) {
                _addressModel = adressModel;
                @strongify(self);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (_addressModel && [ToolUtil isEqualToNonNull:_addressModel.ID]) {
                        self.buyBtn.enabled = YES;
                    }else
                        self.buyBtn.enabled = NO;
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
    if (payWay == AMPayWayDefault) {
        [payViewController dismissViewControllerAnimated:YES completion:^{
            [self clickToList];
        }];
        return;
    }
    @weakify(self);
    [payViewController dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        switch (payWay) {
            case AMPayWayWX:///微信支付
                [[AMPayManager shareManager] payOrderWithType:@"3" withOrderID:_orderID byChannel:2 delegate:self];
                break;
            case AMPayWayAlipay:///支付宝支付
                [[AMPayManager shareManager] payOrderWithType:@"3" withOrderID:_orderID byChannel:1 delegate:self];
                break;
                
            default:
                break;
        }
    }];
}

#pragma mark - AMPayManagerDelagate
- (void)getAlipayPayResult:(BOOL)isSuccess {
    [self optionForSuccess:isSuccess];
}

- (void)getWXPayResult:(BOOL)isSuccess {
    [self optionForSuccess:isSuccess];
}

- (void)optionForSuccess:(BOOL)isSuccess {
    if (isSuccess) {
        __block VideoPlayerViewController *playerVC = nil;
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[VideoPlayerViewController class]]) {
                playerVC = obj;
                *stop = YES;
            }
        }];
        if (playerVC) {
            [self.navigationController popToViewController:playerVC animated:YES];
        }else
            [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
        [self clickToList];
    }
}

- (void)clickToList {
    MyBuyViewController *buyVC  = [[MyBuyViewController alloc] init];
    buyVC.pageIndex = 1;
    buyVC.needBackHome = YES;
    [self.navigationController pushViewController:buyVC animated:YES];
}

#pragma mark -
- (IBAction)clickToPay:(AMButton *)sender {
	if (![ToolUtil isEqualToNonNull:_goodsModel.ID]) {
		[SVProgressHUD showError:@"商品信息错误"];
		return;
	}
	if (!(_addressModel && [ToolUtil isEqualToNonNull:_addressModel.ID])) {
		[SVProgressHUD showMsg:@"请选择地址"];
		return;
	}
	NSMutableDictionary *params = [NSMutableDictionary new];
    
	params[@"uid"] = [UserInfoManager shareManager].uid;
	params[@"good_id"] = [ToolUtil isEqualToNonNullKong:_goodsModel.ID];
	params[@"address_id"] = [ToolUtil isEqualToNonNullKong:_addressModel.ID];
	
    [ApiUtil postWithParent:self url:[ApiUtilHeader buildGoodsOrder] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [self showPayView:[response objectForKey:@"data"]];
    } fail:nil];
}

- (void)showPayView:(NSString *)orderID {
    _orderID = orderID;
    AMPayViewController *payVC = [[AMPayViewController alloc] init];
    payVC.delegate = self;
    payVC.priceStr = _goodsModel.sellprice;
    payVC.payStyle = AMAwakenPayStyleDefalut;
    [self.navigationController presentViewController:payVC animated:YES completion:nil];
}

- (void)loadData {
    [ApiUtil postWithParent:self url:[ApiUtilHeader getUserDefaultAddress] needHUD:NO params:@{@"uid":[UserInfoManager shareManager].uid} success:^(NSInteger code, id  _Nullable response) {
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            _addressModel = [MyAddressModel yy_modelWithDictionary:data];
        }else
            _addressModel = nil;
        if (_addressModel && [ToolUtil isEqualToNonNull:_addressModel.ID])
            self.buyBtn.enabled = YES;
            
        [self.tableView reloadData];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        _addressModel = nil;
        self.buyBtn.enabled = NO;
        [self.tableView reloadData];
    }];
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
