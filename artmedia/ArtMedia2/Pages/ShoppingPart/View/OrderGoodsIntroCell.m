//
//  OrderGoodsIntroCell.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/7.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "OrderGoodsIntroCell.h"

#import "VideoGoodsModel.h"
#import "MyOrderModel.h"

@interface OrderGoodsIntroCell ()

@property (weak, nonatomic) IBOutlet UIImageView *goodsIV;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *refundWidthContstraint;

@end

@implementation OrderGoodsIntroCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	
	_goodsNameLabel.font = [UIFont addHanSanSC:16.0f fontType:0];
	_authorLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
	
	_refundBtn.titleLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
    _refundBtn.layer.cornerRadius = _refundBtn.height/2;
    _refundBtn.clipsToBounds = YES;
    _refundBtn.layer.borderColor = Color_Grey.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGoodsModel:(VideoGoodsModel *)goodsModel {
	_goodsModel = goodsModel;
	[_goodsIV am_setImageWithURL:_goodsModel.banner contentMode:UIViewContentModeScaleAspectFit];
	_goodsNameLabel.text = [ToolUtil isEqualToNonNullKong:_goodsModel.name];
	_authorLabel.text = [NSString stringWithFormat:@"作者:%@", [ToolUtil isEqualToNonNullKong:_goodsModel.uname]];
}

- (void)setOrderModel:(MyOrderModel *)orderModel {
	_orderModel = orderModel;
	[_goodsIV am_setImageWithURL:_orderModel.obj_image placeholderImage:[UIImage imageWithColor:RGB(229, 229, 229)] contentMode:UIViewContentModeScaleAspectFit];
	_goodsNameLabel.text = [ToolUtil isEqualToNonNullKong:_orderModel.obj_name];
	_authorLabel.text = [NSString stringWithFormat:@"作者:%@", [ToolUtil isEqualToNonNullKong:_orderModel.seller_name]];
	
	
	if (_orderModel.wayType) {
		[self updateSallerBlock];
	}else {
		[self updateBuyerBlock];
	}
}

- (void)updateBuyerBlock {
	BOOL hidden = YES;
	NSString *title = @"";
	switch (_orderModel.state) {
        case MyOrderTypeTuiHuoZhong:
		case MyOrderTypeQueRenShouHuo: {
			hidden = NO;
			self.refundBtn.userInteractionEnabled = YES;
			///退货状态 0 未申请 1 申请中 2同意退货 3拒绝退货
			if (_orderModel.oretapply.integerValue == 1) {
				title = @"申请退货中";
			}else if (_orderModel.oretapply.integerValue == 2) {
                title = _orderModel.is_deliver_goods.boolValue?@"退货信息":@"处理退货";
			}else if (_orderModel.oretapply.integerValue == 3) {
				title = @"退货失败";
			}else {
				title = @"申请退货";
			}
			break;
		}
        case MyOrderTypeTuiHuoWanCheng:
        case MyOrderTypeYiTuiKuan:{
			hidden = NO;
			self.refundBtn.userInteractionEnabled = YES;
			title = @"退货信息";
			break;
		}
			
		default:
			break;
	}
	self.refundBtn.hidden = hidden;
	if (!hidden) {
		CGFloat width = [title sizeWithFont:_refundBtn.titleLabel.font andMaxSize:CGSizeMake(CGFLOAT_MAX, _refundBtn.height)].width + 10.0f;
		if (width < 75.0f) width = 75.0f;
		_refundWidthContstraint.constant = width;
		[self.refundBtn setTitle:title forState:UIControlStateNormal];
        _refundBtn.layer.borderWidth = self.refundBtn.userInteractionEnabled?1.0f:0.0f;
	}
    
}

- (void)updateSallerBlock {
	BOOL hidden = YES;
	NSString *title = @"";
	switch (_orderModel.state) {
        case MyOrderTypeTuiHuoZhong:
		case MyOrderTypeQueRenShouHuo: {
			hidden = NO;
			self.refundBtn.userInteractionEnabled = NO;
			///退货状态 0 未申请 1 申请中 2同意退货 3拒绝退货
			if (_orderModel.oretapply.integerValue == 1) {
				title = @"买家申请退货";
			}else if (_orderModel.oretapply.integerValue == 2) {
                title = (_orderModel.is_deliver_goods.integerValue == 1)?@"买家已退货":@"同意买家退货";
			}else if (_orderModel.oretapply.integerValue == 3) {
				title = @"拒绝买家退货";
			}else {
				hidden = YES;
			}
			break;
		}
		case MyOrderTypeTuiHuoWanCheng:
        case MyOrderTypeYiTuiKuan: {
			hidden = NO;
			self.refundBtn.userInteractionEnabled = YES;
			title = @"退货信息";
			break;
		}
			
		default:
			break;
	}
	self.refundBtn.hidden = hidden;
	if (!hidden) {
		CGFloat width = [title sizeWithFont:_refundBtn.titleLabel.font andMaxSize:CGSizeMake(CGFLOAT_MAX, _refundBtn.height)].width + 10.0f;
		if (width < 75.0f) width = 75.0f;
		_refundWidthContstraint.constant = width;
		[self.refundBtn setTitle:title forState:UIControlStateNormal];
        _refundBtn.layer.borderWidth = self.refundBtn.userInteractionEnabled?1.0f:0.0f;
	}
    
}



- (IBAction)clickToRefund:(AMButton *)sender {
	if (_clickToRefundBlock) _clickToRefundBlock();
}

@end
