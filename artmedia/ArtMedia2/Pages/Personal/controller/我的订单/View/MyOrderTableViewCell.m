//
//  MyOrderTableViewCell.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/23.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "MyOrderTableViewCell.h"
#import "MyOrderModel.h"

@interface MyOrderTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsIV;//商品图片
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;//商品名称
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;//商品价格
@property (weak, nonatomic) IBOutlet UILabel *orderDescLabel;//状态说明

@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;//订单状态
@property (weak, nonatomic) IBOutlet AMButton *operationBtn;//操作按钮
@property (weak, nonatomic) IBOutlet AMButton *operation_B_Btn;//操作按钮B

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *operationWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *operationLeadingConstraint;
@end

@implementation MyOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	
	_goodsNameLabel.font = [UIFont addHanSanSC:16.0f fontType:0];
	_goodsPriceLabel.font = [UIFont addHanSanSC:18.0f fontType:1];
	_orderDescLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
    
	_orderStatusLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
	_operationBtn.titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
    _operation_B_Btn.titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOrderModel:(MyOrderModel *)orderModel {
	_orderModel = orderModel;
	
	[_goodsIV am_setImageWithURL:_orderModel.obj_image placeholderImage:[UIImage imageWithColor:RGB(229, 229, 229)] contentMode:UIViewContentModeScaleAspectFit];
	
	_goodsNameLabel.text = [ToolUtil isEqualToNonNull:_orderModel.obj_name replace:@"测试商品名称"];
	_goodsPriceLabel.text = [ToolUtil isEqualToNonNull:_orderModel.buyer_amount ] ? [NSString stringWithFormat:@"¥ %.2f", _orderModel.buyer_amount.doubleValue]:@"¥ 0.00";
	
    if (_orderModel.wayType) {
        [self updateSelledOrderState];
	}else {
		[self updateBuyedOrderState];
	}
}

/// 买家状态
- (void)updateBuyedOrderState {
	switch (_orderModel.state ) {
		case MyOrderTypeDaiFuKuan: {///待支付
			[self updateOrderState:nil stateColor:nil orderOperation:@"去支付" operationColor:Color_Red descText:nil];
			break;
		}
		case MyOrderTypeYiFuKuan: {///待发货
			[self updateOrderState:@"待发货" stateColor:Color_Red orderOperation:nil operationColor:nil descText:nil];
			break;
		}
		case MyOrderTypeQueRenShouHuo:
        case MyOrderTypeTuiHuoZhong: {///待收货
			if (_orderModel.oretapply.integerValue == 1) {
				[self updateOrderState:nil stateColor:nil orderOperation:@"确认收货" operationColor:Color_Red descText:@"申请退货中"];
			}else if (_orderModel.oretapply.integerValue == 2) {
                if (_orderModel.is_deliver_goods.boolValue) {
                    [self updateOrderState:nil stateColor:nil orderOperation:@"退货信息" operationColor:Color_Black descText:@"已退货，等待卖家收货"];
                }else {
                    [self updateOrderState:nil stateColor:Color_Black orderOperation:@"处理退货" operationColor:Color_Black descText:@"卖家同意退货"];
                    self.operation_B_Btn.hidden = NO;
                }
			}else if (_orderModel.oretapply.integerValue == 3) {
				[self updateOrderState:@"等待客服处理" stateColor:Color_Red orderOperation:nil operationColor:nil descText:@"卖家拒绝退货"];
			}else {
				[self updateOrderState:nil stateColor:nil orderOperation:@"确认收货" operationColor:Color_Red descText:nil];
			}
			break;
		}
		case MyOrderTypeSuccess: {///已完成
			[self updateOrderState:@"交易完成" stateColor:Color_Black orderOperation:nil operationColor:nil descText:nil];
			break;
		}
		case MyOrderTypeTuiHuoWanCheng: {///退货完成
			[self updateOrderState:@"退款待到账" stateColor:Color_Red orderOperation:nil operationColor:nil descText:@"退货成功"];
			break;
		}
		case MyOrderTypeYiTuiKuan: {
			[self updateOrderState:@"订单已关闭" stateColor:Color_Black orderOperation:nil operationColor:nil descText:@"已退货退款"];
			break;
		}
        case MyOrderTypeCancel: {
            [self updateOrderState:@"订单已取消" stateColor:Color_Black orderOperation:nil operationColor:nil descText:nil];
            break;
        }
		default:
			break;
	}
}

- (void)updateSelledOrderState {
	switch (_orderModel.state) {
		case MyOrderTypeDaiFuKuan: { /// 等待买家付款
			[self updateOrderState:@"订单已取消" stateColor:Color_Black orderOperation:nil operationColor:nil descText:@"买家付款超时"];
			break;
		}
		case MyOrderTypeYiFuKuan: { /// 未发货
			[self updateOrderState:nil stateColor:nil orderOperation:@"填写物流" operationColor:Color_Red descText:@"买家已付款"];
			break;
		}
        case MyOrderTypeQueRenShouHuo:
        case MyOrderTypeTuiHuoZhong: {/// 等待买家收货
			if (_orderModel.oretapply.integerValue == 1) {
				[self updateOrderState:nil stateColor:nil orderOperation:@"退货处理" operationColor:Color_Black descText:@"买家申请退货"];
			}else if (_orderModel.oretapply.integerValue == 2) {
                if (_orderModel.is_deliver_goods.boolValue) {
                    [self updateOrderState:nil stateColor:nil orderOperation:@"确认收货" operationColor:Color_Red descText:@"买家已退货"];
                }else
                    [self updateOrderState:nil stateColor:nil orderOperation:@"退货信息" operationColor:Color_Black descText:@"等待买家退货"];
			}else if (_orderModel.oretapply.integerValue == 3) {
				[self updateOrderState:@"等待客服处理" stateColor:Color_Red orderOperation:nil operationColor:nil descText:@"拒绝退货"];
			}else {
				[self updateOrderState:@"待收货" stateColor:Color_Red orderOperation:nil operationColor:Color_Black descText:@"等待买家收货"];
			}
			break;
		}
		case MyOrderTypeSuccess: { ///交易成功
            [self updateOrderState:@"交易完成" stateColor:Color_Black orderOperation:nil operationColor:nil descText:nil];
			break;
        }
		case MyOrderTypeTuiHuoWanCheng: { /// 退货完成-待退款
			[self updateOrderState:@"待退款" stateColor:Color_Red orderOperation:nil operationColor:nil descText:@"买家已退货"];
			break;
		}
		case MyOrderTypeYiTuiKuan: {
            [self updateOrderState:@"订单已关闭" stateColor:Color_Black orderOperation:nil operationColor:nil descText:@"已退货退款"];
			break;
		}
		case MyOrderTypeCancel: {
            [self updateOrderState:@"订单已取消" stateColor:Color_Black orderOperation:nil operationColor:nil descText:nil];
			break;
		}
		default:
			break;
	}
}

- (void)updateOrderState:(NSString *_Nullable)orderState
              stateColor:(UIColor *_Nullable)stateColor
          orderOperation:(NSString *_Nullable)orderOperation
          operationColor:(UIColor *_Nullable)operationColor
                descText:(NSString *_Nullable)descText {
    _orderDescLabel.hidden = ![ToolUtil isEqualToNonNull:descText];
    _orderDescLabel.text = descText;

    _orderStatusLabel.hidden = ![ToolUtil isEqualToNonNull:orderState];
    _orderStatusLabel.text = orderState;
    _orderStatusLabel.textColor = stateColor;
	
	if ([ToolUtil isEqualToNonNull:orderOperation]) {
		_operationBtn.hidden = NO;
        _operationWidthConstraint.constant = 90.0f;
        _operationLeadingConstraint.constant = 10.0f;
		
		[_operationBtn setTitle:orderOperation forState:UIControlStateNormal];
		[_operationBtn setTitleColor:operationColor forState:UIControlStateNormal];
		_operationBtn.layer.borderColor = operationColor.CGColor;
	}else {
		_operationBtn.hidden = YES;
        _operationWidthConstraint.constant = 0.0f;
        _operationLeadingConstraint.constant = 0.0f;
	}
    
    _operation_B_Btn.hidden = YES;
}

- (IBAction)clickToOpeation:(AMButton *)sender {
//	MyOrderType type = _orderModel.state;
//	MyOrderWayType waType = _orderModel.wayType;
//	if ((!waType && (type == MyOrderTypeDaiFuKuan || type == MyOrderTypeQueRenShouHuo)) ||
//		(waType && (type == MyOrderTypeYiFuKuan || type == MyOrderTypeSuccess || _orderModel.oretapply.integerValue))) {
//		if (_clickToOpeationBlock) _clickToOpeationBlock(_orderModel);
//	}else
//		return;
//    if (_clickToOpeationBlock) _clickToOpeationBlock(_orderModel);
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderCell:didClickToOpeation:)]) {
        [self.delegate orderCell:self didClickToOpeation:_orderModel];
    }
}

- (IBAction)clickToOpeationB:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderCell:didClickToQueRenShouHuo:)]) {
        [self.delegate orderCell:self didClickToQueRenShouHuo:_orderModel];
    }
}


/*
     switch (_orderModel.state) {
         case MyOrderTypeDaiFuKuan:/// 待付款商品
         {
             /// 订单描述
             _orderDescLabel.text = nil;
             /// 左边按钮
             _operation_B_Btn.hidden = YES;
             /// 右边按钮
             _operationBtn.hidden = NO;
             _operationWidthConstraint.constant = 90.0f;
             _operationLeadingConstraint.constant = 10.0f;
             _operationBtn.layer.borderColor = Color_Red.CGColor;
             [_operationBtn setTitleColor:Color_Red forState:UIControlStateNormal];
             [_operationBtn setTitle:@"去支付" forState:UIControlStateNormal];
             /// 订单状态
             _orderStatusLabel.textColor = Color_Red;
             _orderStatusLabel.text = @"00:15:00后自动取消订单";
             
             break;
         }
         case MyOrderTypeYiFuKuan:/// 已付款,待发货-等待卖家发货商品
         {
             /// 订单描述
             _orderDescLabel.text = nil;
             /// 左边按钮
             _operation_B_Btn.hidden = YES;
             /// 右边按钮
             _operationBtn.hidden = YES;
             _operationWidthConstraint.constant = 0.0f;
             _operationLeadingConstraint.constant = 0.0f;
             /// 订单状态
             _orderStatusLabel.textColor = Color_Red;
             _orderStatusLabel.text = @"待发货";
 //            if (_) {
 //                <#statements#>
 //            }
             break;
         }
         case MyOrderTypeQueRenShouHuo:/// 已发货-等待收货
         {
             /// 订单描述
             _orderDescLabel.text = nil;
             /// 左边按钮
             _operation_B_Btn.hidden = YES;
             /// 右边按钮
             _operationBtn.hidden = NO;
             _operationWidthConstraint.constant = 90.0f;
             _operationLeadingConstraint.constant = 10.0f;
             _operationBtn.layer.borderColor = Color_Red.CGColor;
             [_operationBtn setTitleColor:Color_Red forState:UIControlStateNormal];
             [_operationBtn setTitle:@"确认收货" forState:UIControlStateNormal];
             /// 订单状态
             _orderStatusLabel.text = nil;
             break;
         }
         case MyOrderTypeSuccess:/// 交易成功-确认收货后商品
         {
             /// 订单描述
             _orderDescLabel.text = nil;
             /// 左边按钮
             _operation_B_Btn.hidden = YES;
             /// 右边按钮
             _operationBtn.hidden = YES;
             _operationWidthConstraint.constant = 0.0f;
             _operationLeadingConstraint.constant = 0.0f;
             /// 订单状态
             _orderStatusLabel.textColor = Color_Black;
             _orderStatusLabel.text = @"已完成";
             break;
         }
         case MyOrderTypeTuiHuoZhong:/// 退货中/退款中-申请退货后/未发货申请退款。
         {
             /// 订单描述
             _orderDescLabel.text = _orderModel.is_deliver_goods?@"申请退货中":@"申请退款中";
             /// 左边按钮
             _operation_B_Btn.hidden = YES;
             /// 右边按钮
             _operationBtn.hidden = NO;
             _operationWidthConstraint.constant = 90.0f;
             _operationLeadingConstraint.constant = 0.0f;
             _operationBtn.layer.borderColor = Color_Red.CGColor;
             [_operationBtn setTitleColor:Color_Red forState:UIControlStateNormal];
             [_operationBtn setTitle:@"确认收货" forState:UIControlStateNormal];
             /// 订单状态
             _orderStatusLabel.text = nil;
             break;
         }
         case MyOrderTypeTuiHuoWanCheng:/// 退货-退款完成-卖家已收货，待退款/退款-卖家同意退款
         {
                 /// 订单描述
             _orderDescLabel.text = _orderModel.is_deliver_goods?@"退货成功":@"卖家同意退款";
             /// 左边按钮
             _operation_B_Btn.hidden = YES;
             /// 右边按钮
             _operationBtn.hidden = YES;
             _operationWidthConstraint.constant = 0.0f;
             _operationLeadingConstraint.constant = 0.0f;
             /// 订单状态
             _orderStatusLabel.textColor = Color_Red;
             _orderStatusLabel.text = @"退款待到账";
             
             break;
         }
         case MyOrderTypeYiTuiKuan:/// 退货-卖家已收货且退款成功/退款成功-退款到账
         {
             if (_orderModel.is_deliver_goods.boolValue) {
                 /// 订单描述
                 _orderDescLabel.text = @"退货成功";
                 /// 左边按钮
                 _operation_B_Btn.hidden = YES;
                 /// 右边按钮
                 _operationBtn.hidden = YES;
                 _operationWidthConstraint.constant = 0.0f;
                 _operationLeadingConstraint.constant = 0.0f;
                 /// 订单状态
                 _orderStatusLabel.textColor = Color_Black;
                 _orderStatusLabel.text = @"订单已关闭";
             }else {
                 /// 订单描述
                 _orderDescLabel.text = @"已退款";
                 /// 左边按钮
                 _operation_B_Btn.hidden = YES;
                 /// 右边按钮
                 _operationBtn.hidden = YES;
                 _operationWidthConstraint.constant = 0.0f;
                 _operationLeadingConstraint.constant = 0.0f;
                 /// 订单状态
                 _orderStatusLabel.textColor = Color_Black;
                 _orderStatusLabel.text = @"订单已关闭";
             }
             
             break;
         }
         case MyOrderTypeCancel:/// 超时订单/已取消
         {
             /// 订单描述
             _orderDescLabel.text = nil;
             /// 左边按钮
             _operation_B_Btn.hidden = YES;
             /// 右边按钮
             _operationBtn.hidden = YES;
             _operationWidthConstraint.constant = 0.0f;
             _operationLeadingConstraint.constant = 10.0f;
             /// 订单状态
             _orderStatusLabel.textColor = Color_Black;
             _orderStatusLabel.text = @"订单已关闭";
             
             break;
         }
             
         default:
             break;
     }
 */

@end
