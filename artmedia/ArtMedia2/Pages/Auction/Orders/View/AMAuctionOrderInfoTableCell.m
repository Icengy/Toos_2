//
//  AMAuctionOrderInfoTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/11/13.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMAuctionOrderInfoTableCell.h"

#import "AMAuctionOrderModel.h"

@interface AMAuctionOrderInfoTableCell ()
@property (weak, nonatomic) IBOutlet UIStackView *titleStackView;


@property (weak, nonatomic) IBOutlet UIStackView *valueStackView;
@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *createOrderTimeLabel;
/// 商品总额
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceTitleLabel;
/// 实付金额
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation AMAuctionOrderInfoTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.insets = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0);
    self.needCorner = YES;
    self.rectCorner = UIRectCornerAllCorners;
    self.cornerRudis = 8.0f;
    
    [self.titleStackView.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = (UILabel *)obj;
        label.font = [UIFont addHanSanSC:14.0 fontType:0];
    }];
    [self.valueStackView.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = (UILabel *)obj;
        label.font = [UIFont addHanSanSC:14.0 fontType:0];
    }];
    self.priceTitleLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
    self.priceLabel.font = [UIFont addHanSanSC:14.0 fontType:2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(AMAuctionOrderModel *)model {
    _model = model;
    
    self.orderNoLabel.text = [ToolUtil isEqualToNonNullKong:_model.auctionGoodOrderNo];
    self.createOrderTimeLabel.text = [ToolUtil isEqualToNonNullKong:_model.createOrderTime];
    self.orderPriceLabel.text = [NSString stringWithFormat:@"¥%.2f", [ToolUtil isEqualToNonNull:_model.allAuctionGoodPrice replace:@"0"].doubleValue];;
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", [ToolUtil isEqualToNonNull:_model.orderPrice replace:@"0"].doubleValue];
}

@end
