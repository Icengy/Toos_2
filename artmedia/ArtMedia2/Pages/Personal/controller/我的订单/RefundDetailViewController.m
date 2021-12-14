//
//  RefundDetailViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/12.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "RefundDetailViewController.h"

#import "MyOrderModel.h"

#import "ApplyRefundViewController.h"
#import "FillLogisticsViewController.h"
#import "AdressViewController.h"

#import "MyOrderDetailTableCell.h"

@interface RefundDetailViewController () <UITableViewDelegate ,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;

@property (weak, nonatomic) IBOutlet AMButton *refuseBtn;
@property (weak, nonatomic) IBOutlet AMButton *agreeBtn;
@property (weak, nonatomic) IBOutlet AMButton *logisticsBtn;

@end

@implementation RefundDetailViewController {
	NSInteger _refuneType;
    MyOrderModel *_model;
//	MyOrderWayType _wayType;
    MyOrderType _orderType;
    NSMutableArray <NSArray *>*_titleArray;
    NSMutableArray *_customArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _titleArray = @[].mutableCopy;
    _customArray = @[].mutableCopy;
    _refuneType = _model.oretapply.integerValue;
    
	_tableView.delegate = self;
	_tableView.dataSource = self;
	
    _tableView.estimatedRowHeight = 40.0f;
	_tableView.rowHeight = UITableViewAutomaticDimension;
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyOrderDetailTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MyOrderDetailTableCell class])];
    
    [self.logisticsBtn setBackgroundImage:[UIImage imageWithColor:Color_Black] forState:UIControlStateNormal];
    [self.logisticsBtn setTitleColor:Color_Whiter forState:UIControlStateNormal];
    [self.logisticsBtn setBackgroundImage:[UIImage imageWithColor:Color_Whiter] forState:UIControlStateDisabled];
    [self.logisticsBtn setTitleColor:RGB(135, 138, 153) forState:UIControlStateDisabled];
    
    self.logisticsBtn.titleLabel.font = [UIFont addHanSanSC:18.0 fontType:0];
    self.refuseBtn.titleLabel.font = [UIFont addHanSanSC:18.0 fontType:0];
    self.agreeBtn.titleLabel.font = [UIFont addHanSanSC:18.0 fontType:0];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self.navigationItem setTitle:@"退货详情"];
    
    [self loadData:nil];
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!_titleArray.count) return 0;
    NSArray *titleArray = [_titleArray objectAtIndex:section];
    return [titleArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return ADAptationMargin/2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [tableView numberOfSections] - 1)
        return ADAptationMargin/2;
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section  {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyOrderDetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyOrderDetailTableCell class]) forIndexPath:indexPath];
    
    if (!_titleArray.count)  return cell;
    
    NSArray *titleArray = _titleArray[indexPath.section];
    if (titleArray.count) {
        cell.titleLabel.text = titleArray[indexPath.row];
        cell.subTitleLabel.text = indexPath.row?[self detailText:cell.titleLabel.text]:nil;
        
        if ([cell.titleLabel.text isEqualToString:@"退款信息"] ||
            [cell.titleLabel.text isEqualToString:@"退货信息"] ||
            [cell.titleLabel.text isEqualToString:@"卖家处理结果"] ||
            [cell.titleLabel.text isEqualToString:@"处理结果"] ||
            [cell.titleLabel.text isEqualToString:@"卖家信息"] ||
            [cell.titleLabel.text isEqualToString:@"物流信息"] ||
            [cell.titleLabel.text isEqualToString:@"买家信息"] ||
            [cell.titleLabel.text isEqualToString:@"客服联系方式"]) {
            
            cell.titleLabel.textColor = RGB(122, 129, 153);
            cell.titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
        }else {
            cell.titleLabel.textColor = Color_Black;
            cell.titleLabel.font = [UIFont addHanSanSC:16.0f fontType:0];
        }
    }else {
        cell.titleLabel.textColor = Color_Black;
        cell.titleLabel.font = [UIFont addHanSanSC:16.0f fontType:0];
    }
    
    if ([cell.titleLabel.text isEqualToString:@"退款金额"] ||
        [cell.titleLabel.text isEqualToString:@"退货金额"]) {
        cell.subTitleLabel.textColor = Color_Red;
    }else
        cell.subTitleLabel.textColor = Color_Black;
    
    [cell.titleLabel sizeToFit];
    [cell.subTitleLabel sizeToFit];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (NSString *_Nullable)detailText:(NSString *)title {
    if ([title isEqualToString:@"退款金额"] ||
        [title isEqualToString:@"退货金额"]) {
        return [NSString stringWithFormat:@"¥ %.2f", [[ToolUtil isEqualToNonNull:_model.buyer_amount replace:@"0"] floatValue]];
    }
    if ([title isEqualToString:@"到账状态"]) {
        if (_model.state == MyOrderTypeYiTuiKuan)
            return @"已到账";
        return @"未到账";
    }
    if ([title isEqualToString:@"到账时间"]) {
        return ([ToolUtil isEqualToNonNull:_model.return_money_time] && _model.return_money_time.integerValue != 0)?[TimeTool getDateStringWithTimeStr:_model.return_money_time]:@"预计3天到账";
    }
    if ([title isEqualToString:@"退货原因"]) {
        return [ToolUtil isEqualToNonNullKong:_model.apply_reason];
    }
    if ([title isEqualToString:@"申请时间"]) {
        return [TimeTool getDateStringWithTimeStr:_model.oretapplydate];
    }
    if ([title isEqualToString:@"退货时间"]) {
        return [TimeTool getDateStringWithTimeStr:_model.return_delivery.delivery_time];
    }
    if ([title isEqualToString:@"完成时间"]) {
        return [TimeTool getDateStringWithTimeStr:_model.confirmtime];
    }
    if ([title isEqualToString:@"处理时间"]) {
        return [TimeTool getDateStringWithTimeStr:_model.oret_deal_date];
    }
    if ([title isEqualToString:@"商品名称"]) {
        return [ToolUtil isEqualToNonNullKong:_model.obj_name];
    }
    if ([title isEqualToString:@"申请人"]) {
        return [ToolUtil isEqualToNonNullKong:_model.buyer_name];
    }
    if ([title isEqualToString:@"退货结果"]) {
        return (_refuneType-2)?@"已拒绝":@"已同意";
    }
    if ([title isEqualToString:@"拒绝原因"]) {
        return [ToolUtil isEqualToNonNullKong:_model.refuse_remark];
    }
    
    if ([title isEqualToString:@"收货人"]) {
        return [ToolUtil isEqualToNonNullKong:_model.return_delivery.reciver];
    }
    if ([title isEqualToString:@"联系电话"]) {
        return [ToolUtil isEqualToNonNullKong:_model.return_delivery.phone];
    }
    if ([title isEqualToString:@"收货地址"]) {
        NSString *valueStr =  [NSString stringWithFormat:@"%@\n%@",[ToolUtil isEqualToNonNullKong:_model.return_delivery.addrregion], [ToolUtil isEqualToNonNullKong:_model.return_delivery.address]];
        if ([valueStr hasPrefix:@"\n"])
            valueStr = [valueStr substringFromIndex:1];
        if ([valueStr hasSuffix:@"\n"])
            valueStr = [valueStr substringToIndex:valueStr.length - 1];
        return [ToolUtil isEqualToNonNullKong:valueStr];
    }
    if ([title isEqualToString:@"物流公司"]) {
        return [ToolUtil isEqualToNonNullKong:_model.return_delivery.devlivery_comp];
    }
    if ([title isEqualToString:@"物流单号"]) {
        return [ToolUtil isEqualToNonNullKong:_model.return_delivery.devlivery_no];
    }
    
    if (_customArray.count) {
        for (NSDictionary *custom in _customArray) {
            if ([title isEqualToString:[custom objectForKey:@"name"]]) {
                return [ToolUtil isEqualToNonNullKong:[custom objectForKey:@"tel"]];
            }
        }
    }
    
    return [NSString stringWithFormat:@"测试待修改：%@", @(arc4random()%4444)];
}

#pragma mark -
- (void)updateContentUI:(NSDictionary *_Nullable) naviInfo {
    if (naviInfo && naviInfo.allValues.count) {
        AMButton *navBtn = [AMButton buttonWithType:UIButtonTypeCustom];
        navBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [navBtn setTitle:[naviInfo objectForKey:@"title"] forState:UIControlStateNormal];
        [navBtn setTitleColor:[naviInfo objectForKey:@"color"] forState:UIControlStateNormal];
        
        navBtn.titleLabel.font = [UIFont addHanSanSC:16.0f fontType:0];
        [navBtn.titleLabel sizeToFit];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navBtn];
    }
}

#pragma mark -
- (IBAction)bottomClick:(AMButton *)sender {
	NSInteger tag = sender.tag - 100010;
	if (!tag) {
		ApplyRefundViewController *refundVC = [[ApplyRefundViewController alloc] init];
		refundVC.orderModel = _model;
		refundVC.type = 1;
		refundVC.bottomClick2Block = ^(NSString * _Nullable textStr) {
			[self tuiHuoOpeationForDisagree:textStr];
		};
		[self.navigationController pushViewController:refundVC animated:YES];
	}else {
		AdressViewController *addressVC = [[AdressViewController alloc]init];
        addressVC.style = 2;
		addressVC.chooseAdress = ^(MyAddressModel * _Nonnull adressModel) {
			if (adressModel) {
                SingleAMAlertView *alertView = [SingleAMAlertView shareInstance];
                alertView.title = @"确定是否同意退货申请？";
                alertView.needCancelShow = YES;
                @weakify(self);
                alertView.confirmBlock = ^{
                    @strongify(self);
                    [self tuiHuoOpeationForAgree:[ToolUtil isEqualToNonNullKong:adressModel.ID]];
                };
                [alertView show];
			}
		};
		[self.navigationController pushViewController:addressVC animated:YES];
	}
}

- (void)tuiHuoOpeationForAgree:(NSString *)addressID {
	NSMutableDictionary *params = [NSMutableDictionary new];
	
	params[@"is_agree"] = @"2";
	params[@"address_id"] = addressID;
	
	[self tuiHuoOpeation:[params copy]];
}

- (void)tuiHuoOpeationForDisagree:(NSString *)refuse_remark {
	NSMutableDictionary *params = [NSMutableDictionary new];
	
	params[@"is_agree"] = @"3";
	params[@"refuse_remark"] = refuse_remark;
	
	[self tuiHuoOpeation:[params copy]];
}

- (void)tuiHuoOpeation:(NSDictionary *)param {
	NSString *urlString = [ApiUtilHeader dealRefund];
	/* {"type":"2","order_id":"2176","is_agree":"2","address_id":"883","refuse_remark":"拒绝退货申请的说明"}type为订单类型：1拍品订单，2商品订单。is_agree为是否同意买家的退货申请：2同意，3不同意。如果同意退货，需要传address_id作为买家退货时卖家的收货地址。如果拒绝退货，需要传refuse_remark说明买家退货申请的理由。
	 */
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:param];
	
	params[@"order_id"] = [ToolUtil isEqualToNonNullKong:_model.ID];
	params[@"type"] = @"2";
	
    @weakify(self);
    [ApiUtil postWithParent:self url:urlString params:params.copy success:^(NSInteger code, id  _Nullable response) {
        NSString *alertText = @"已拒绝买家退货申请";
        if ([params[@"is_agree"] integerValue] == 2) {
            alertText = @"已同意买家退货申请";
        }
        [SVProgressHUD showSuccess:alertText completion:^{
            @strongify(self);
            [self loadData:nil];
//            if (_bottomClickBlock) _bottomClickBlock();
//            [self.navigationController popViewControllerAnimated:YES];
        }];
    } fail:nil];
}

/// 填写物流
- (IBAction)clickToLogistics:(id)sender {
    FillLogisticsViewController *fillLogVC = [[FillLogisticsViewController alloc] init];
    fillLogVC.model = _model;
    fillLogVC.logType = 1;
    fillLogVC.bottomClickBlock = ^{
        [self loadData:nil];
    };
    [self.navigationController pushViewController:fillLogVC animated:YES];
}

/// 确认收货
- (IBAction)clickToConfirm:(id)sender {
    AMAlertView *alert = [AMAlertView shareInstanceWithTitle:@"是否确认收货?" buttonArray:@[@"是",@"否"] confirm:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableDictionary *params = [NSMutableDictionary new];
            
            params[@"order_id"] = [ToolUtil isEqualToNonNullKong:_model.ID];
            params[@"type"] = @"2";
            
            [ApiUtil postWithParent:self url:[ApiUtilHeader confirmReceiptForSeller] params:params.copy success:^(NSInteger code, id  _Nullable response) {
                [SVProgressHUD showSuccess:@"确认收货成功" completion:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            } fail:nil];
        });
    } cancel:nil];
    [alert show];
}

#pragma mark -
- (void)loadData:(id)sender {
    NSString *urlStr = _wayType?[ApiUtilHeader getSellOrderDetail]:[ApiUtilHeader getBuyOrderDetail];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    params[@"uid"] = [UserInfoManager shareManager].uid;
    params[@"order_id"] = [ToolUtil isEqualToNonNullKong:_orderID];
    
    [ApiUtil postWithParent:self url:urlStr params:params.copy success:^(NSInteger code, id  _Nullable response) {
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            if (!_model) _model = [MyOrderModel new];
            
            _model = [MyOrderModel yy_modelWithJSON:data];
            _model.state += 1;
            _model.wayType = _wayType;
            
            [self updateContentUI];
        }
        
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [SVProgressHUD showError:errorMsg];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

- (void)updateContentUI {
    _refuneType = _model.oretapply.integerValue;
    _orderType = _model.state;
    
    self.refuseBtn.hidden = YES;
    self.agreeBtn.hidden = YES;
    self.logisticsBtn.hidden = YES;
    _tableViewBottomConstraint.constant = 0.0f;
    
    if (_titleArray.count) [_titleArray removeAllObjects];
    NSMutableDictionary *naviInfo = @{}.mutableCopy;
    if (_wayType == MyOrderWayTypeBuyed) {/// 买家
        if (_orderType == MyOrderTypeQueRenShouHuo ||
            _orderType == MyOrderTypeTuiHuoZhong) {
            if (_refuneType == 1) {/// 申请中
                naviInfo[@"title"] = @"待处理";
                naviInfo[@"color"] = Color_Red;
                [_titleArray addObjectsFromArray:@[@[@"退货信息", @"商品名称", @"退货原因", @"申请时间"]]];
            }else if (_refuneType == 2) {///同意退货
                if (_model.is_deliver_goods.boolValue) {///买家已发货
                    naviInfo[@"title"] = @"待卖家收货";
                    naviInfo[@"color"] = Color_Red;
                    [_titleArray addObjectsFromArray:@[@[@"退货信息" ,@"商品名称", @"退货原因", @"申请时间", @"退货时间"],
                                                       @[@"卖家处理结果",@"退货结果", @"处理时间"],
                                                       @[@"卖家信息", @"收货人", @"联系电话", @"收货地址"],
                                                       @[@"物流信息", @"物流公司", @"物流单号"]]];
                }else {/// 买家未发货
                    self.logisticsBtn.hidden = NO;
                    self.logisticsBtn.enabled = YES;
                    [self.logisticsBtn setTitle:@"填写物流信息" forState:UIControlStateNormal];
                    [self.logisticsBtn addTarget:self action:@selector(clickToLogistics:) forControlEvents:UIControlEventTouchUpInside];
                    _tableViewBottomConstraint.constant = 60.0f + SafeAreaBottomHeight;
                    naviInfo[@"title"] = @"待寄回";
                    naviInfo[@"color"] = Color_Red;
                    [_titleArray addObjectsFromArray:@[@[@"退货信息",@"商品名称", @"退货原因", @"申请时间"],
                                                       @[@"卖家处理结果", @"退货结果", @"处理时间"],
                                                       @[@"卖家信息", @"收货人", @"联系电话", @"收货地址"]]];
                }
            }else if (_refuneType == 3) {
                naviInfo[@"title"] = @"退货失败";
                naviInfo[@"color"] = Color_Red;
                [_titleArray addObjectsFromArray:@[@[@"退货信息", @"商品名称", @"退货原因", @"申请时间"],
                                                   @[@"卖家处理结果", @"退货结果", @"拒绝原因", @"处理时间"]]];
            }
        }else if (_orderType == MyOrderTypeTuiHuoWanCheng) {/// 退货完成-卖家已收货，待退款
            naviInfo[@"title"] = @"退款待到账";
            naviInfo[@"color"] = Color_Red;
            [_titleArray addObjectsFromArray:@[@[@"退款信息",@"退款金额", @"到账状态", @"到账时间"],
                                               @[@"退货信息" ,@"商品名称", @"退货原因", @"申请时间", @"退货时间", @"完成时间"],
                                               @[@"卖家处理结果", @"退货结果", @"处理时间"],
                                               @[@"卖家信息" ,@"收货人", @"联系电话", @"收货地址"],
                                               @[@"物流信息", @"物流公司", @"物流单号"]]];
        }else if (_orderType == MyOrderTypeYiTuiKuan) {/// 退货退款完成
            naviInfo[@"title"] = @"已退货退款";
            naviInfo[@"color"] = Color_Black;
            [_titleArray addObjectsFromArray:@[@[@"退款信息",@"退款金额", @"到账状态", @"到账时间"],
                                               @[@"退货信息" ,@"商品名称", @"退货原因", @"申请时间", @"退货时间", @"完成时间"],
                                               @[@"卖家处理结果", @"退货结果", @"处理时间"],
                                               @[@"卖家信息" ,@"收货人", @"联系电话", @"收货地址"],
                                               @[@"物流信息", @"物流公司", @"物流单号"]]];
        }
    }else {/// 卖家
        if (_orderType == MyOrderTypeQueRenShouHuo ||
            _orderType == MyOrderTypeTuiHuoZhong) {
            [_titleArray addObjectsFromArray:@[@[@"退货信息", @"商品名称", @"申请人", @"退货原因", @"退货金额", @"申请时间"],
                                               @[@"处理结果", @"退货结果", @"处理时间"],
                                               @[@"我的信息", @"收货人", @"联系电话", @"收货地址"]]];
            if (_refuneType == 1) {
                self.refuseBtn.hidden = NO;
                self.agreeBtn.hidden = NO;
                _tableViewBottomConstraint.constant = 60.0f + SafeAreaBottomHeight;
                naviInfo[@"title"] = @"待处理";
                naviInfo[@"color"] = Color_Red;
                [_titleArray addObjectsFromArray:@[@[@"退货信息", @"商品名称", @"申请人", @"退货原因", @"退货金额", @"申请时间"]]];
            }else if (_refuneType == 2) {
                if (_model.is_deliver_goods.boolValue) {
                    if (_titleArray.count) [_titleArray removeAllObjects];
                    [_titleArray addObjectsFromArray:@[@[@"退货信息", @"商品名称", @"申请人", @"退货原因", @"退货金额", @"申请时间"],
                                                       @[@"卖家处理结果", @"退货结果", @"处理时间"],
                                                       @[@"卖家信息", @"收货人", @"联系电话", @"收货地址"],
                                                       @[@"物流信息", @"物流公司", @"物流单号"]]];
                    
                    self.logisticsBtn.hidden = NO;
                    self.logisticsBtn.enabled = YES;
                    [self.logisticsBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                    [self.logisticsBtn addTarget:self action:@selector(clickToConfirm:) forControlEvents:UIControlEventTouchUpInside];
                    _tableViewBottomConstraint.constant = 60.0f + SafeAreaBottomHeight;
                    naviInfo[@"title"] = @"同意退货";
                    naviInfo[@"color"] = Color_Black;
                }else {
                    self.logisticsBtn.hidden = NO;
                    self.logisticsBtn.enabled = NO;
                    [self.logisticsBtn setTitle:@"等待买家退货" forState:UIControlStateDisabled];
                    _tableViewBottomConstraint.constant = 60.0f + SafeAreaBottomHeight;
                    naviInfo[@"title"] = @"已同意";
                    naviInfo[@"color"] = Color_Black;
                }

            }else if (_refuneType == 3) {
                naviInfo[@"title"] = @"已拒绝";
                naviInfo[@"color"] = Color_Black;
                [_titleArray addObjectsFromArray:@[@[@"退货信息", @"商品名称", @"申请人", @"退货原因", @"退货金额", @"申请时间"],
                                                   @[@"处理结果", @"退货结果",@"拒绝原因", @"处理时间"]]];
            }
        } else if (_orderType == MyOrderTypeTuiHuoWanCheng) {
            self.logisticsBtn.hidden = NO;
            self.logisticsBtn.enabled = NO;
            [self.logisticsBtn setTitle:_wayType?@"退款中":@"待退款" forState:UIControlStateDisabled];
            _tableViewBottomConstraint.constant = 60.0f + SafeAreaBottomHeight;
            naviInfo[@"title"] = @"已同意";
            naviInfo[@"color"] = Color_Black;
            [_titleArray addObjectsFromArray:@[@[@"退货信息", @"商品名称", @"申请人", @"退货原因", @"退货金额", @"申请时间"],
                                               @[@"处理结果", @"退货结果", @"处理时间"],
                                               @[@"我的信息", @"收货人", @"联系电话", @"收货地址"]]];//@"退货结果",@"拒绝原因", @"处理时间",   去掉了拒绝原因
        }else if (_orderType == MyOrderTypeYiTuiKuan) {/// 退货退款完成
            self.logisticsBtn.hidden = NO;
            self.logisticsBtn.enabled = NO;
            [self.logisticsBtn setTitle:@"已退货退款" forState:UIControlStateDisabled];
            _tableViewBottomConstraint.constant = 60.0f + SafeAreaBottomHeight;
            naviInfo[@"title"] = @"已退货退款";
            naviInfo[@"color"] = Color_Black;
            [_titleArray addObjectsFromArray:@[@[@"退货信息", @"商品名称", @"申请人", @"退货原因", @"退货金额", @"申请时间"],
                                               @[@"处理结果", @"退货结果",@"拒绝原因", @"处理时间"],
                                               @[@"我的信息", @"收货人", @"联系电话", @"收货地址"]]];
        }
    }

//    [_titleArray addObject:@[@"客服联系方式", @"客服01", @"客服02QQ"]];
    [self updateContentUI:naviInfo.copy];
    
    [self.tableView reloadData];
    
    [self loadCustomData];
}

- (void)loadCustomData {
    if (_customArray && _customArray.count) {
        if (![_titleArray.lastObject.firstObject isEqualToString:@"客服联系方式"]) {
            NSMutableArray *custom = @[@"客服联系方式"].mutableCopy;
            [_customArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dict = (NSDictionary *)obj;
                [custom addObject:[dict objectForKey:@"name"]];
            }];
            [_titleArray addObject:custom.copy];
        }
        [self.tableView reloadData];
    }else {
        [ApiUtil postWithParent:self url:[ApiUtilHeader getCustomerTelephone] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response) {
            if (_customArray.count) [_customArray removeAllObjects];
            _customArray = [(NSArray *)response[@"data"] mutableCopy];
            if (_customArray && _customArray.count) {
                NSMutableArray *custom = @[@"客服联系方式"].mutableCopy;
                [_customArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary *dict = (NSDictionary *)obj;
                    [custom addObject:[dict objectForKey:@"name"]];
                }];
                [_titleArray addObject:custom.copy];
            }
            [self.tableView reloadData];
        } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {}];
    }
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
