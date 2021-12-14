//
//  AMAuctionOrderFooterTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/11/18.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMAuctionOrderFooterTableCell.h"

#import "AMAuctionOrderBaseModel.h"

@interface AMAuctionOrderFooterTableCell ()

@property (weak, nonatomic) IBOutlet UIStackView *stackView;

@property (weak, nonatomic) IBOutlet AMButton *payBtn;
@property (weak, nonatomic) IBOutlet AMButton *cancelBtn;
@property (weak, nonatomic) IBOutlet AMButton *confirmBtn;

@end

@implementation AMAuctionOrderFooterTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.needCorner = YES;
    self.insets = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0);
    self.rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
    self.cornerRudis = 8.0f;
    
    [self.stackView.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [(AMButton *)obj titleLabel].font = [UIFont addHanSanSC:12.0 fontType:0];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(AMAuctionOrderBusinessModel *)model {
    _model = model;
    self.payBtn.hidden = YES;
    self.cancelBtn.hidden = YES;
    self.confirmBtn.hidden = YES;
    
    if (_model.orderStatus == AMAuctionOrderStyleToBePaid) {
        self.payBtn.hidden = NO;
    }
    if (_model.orderStatus == AMAuctionOrderStyleDelivered) {
        self.confirmBtn.hidden = NO;
    }
}

- (IBAction)clickToPay:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(footerCell:clickToPayOrder:)]) {
        [self.delegate footerCell:self clickToPayOrder:sender];
    }
}

- (IBAction)clickToCancel:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(footerCell:clickToCancelOrder:)]) {
        [self.delegate footerCell:self clickToCancelOrder:sender];
    }
}
- (IBAction)clickToConfirm:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(footerCell:clickToConfirmOrder:)]) {
        [self.delegate footerCell:self clickToConfirmOrder:sender];
    }
}

@end
