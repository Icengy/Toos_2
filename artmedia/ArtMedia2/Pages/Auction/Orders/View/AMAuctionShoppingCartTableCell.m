//
//  AMAuctionShoppingCartTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/11/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMAuctionShoppingCartTableCell.h"

#import "AMAuctionOrderBaseModel.h"

@interface AMAuctionShoppingCartTableCell ()

@property (weak, nonatomic) IBOutlet AMButton *selectedBtn;

@property (weak, nonatomic) IBOutlet UIView *marginLine;
@property (weak, nonatomic) IBOutlet UIImageView *lotIV;

/// 拍品名称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/// 成交价
@property (weak, nonatomic) IBOutlet UILabel *dealPriceLabel;
/// 服务费
@property (weak, nonatomic) IBOutlet UILabel *servicePriceLabel;
/// 实付价
@property (weak, nonatomic) IBOutlet UILabel *actualPriceLabel;

@property (strong, nonatomic) AMAuctionOrderBusinessModel *orderModel;

@end

@implementation AMAuctionShoppingCartTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
    self.dealPriceLabel.font = [UIFont addHanSanSC:12.0 fontType:0];
    self.servicePriceLabel.font = [UIFont addHanSanSC:12.0 fontType:0];
    self.actualPriceLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
    
    self.isShoppingCart = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -
- (void)fillData:(AMAuctionOrderBusinessModel *)model atIndexPath:(NSIndexPath *)indexPath {
    self.orderModel = model;
    self.model = [self.orderModel.lots objectAtIndex:(indexPath.row - 1)];
}

- (void)setHiddenBottomMargin:(BOOL)hiddenBottomMargin {
    _hiddenBottomMargin = hiddenBottomMargin;
    
    _marginLine.hidden = _hiddenBottomMargin;
}

- (void)setIsShoppingCart:(BOOL)isShoppingCart {
    self.selectedBtn.hidden = !isShoppingCart;
}

- (void)setModel:(AMAuctionLotModel *)model {
    _model = model;
    self.selectedBtn.selected = _model.isSelect;
    
    [self.lotIV am_setImageWithURL:_model.opusCoverImage placeholderImage:ImageNamed(@"logo") contentMode:(UIViewContentModeScaleAspectFit)];

    self.nameLabel.text = [ToolUtil isEqualToNonNullKong:_model.composeTitle];
    
    self.dealPriceLabel.text = [NSString stringWithFormat:@"成交价：¥%@", [ToolUtil isEqualToNonNull:_model.dealPrice replace:@"0"]];
    self.servicePriceLabel.text = [NSString stringWithFormat:@"服务费：¥%@", [ToolUtil isEqualToNonNull:_model.serviceFeePrice replace:@"0"]];
    
    NSString *titleStr = @"实付价";
    if (_orderModel.orderStatus == AMAuctionOrderStyleToBePaid)
        titleStr = @"需付款";
    self.actualPriceLabel.text = [NSString stringWithFormat:@"%@：¥%@", titleStr, [ToolUtil isEqualToNonNull:_model.actualPrice replace:@"0"]];
}

- (IBAction)clickToSelected:(AMButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shoppingCartCell:didClickToSelected:)]) {
        [self.delegate shoppingCartCell:self didClickToSelected:sender];
    }
}

@end
