//
//  AMAuctionOrderLogisticsTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/11/13.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMAuctionOrderLogisticsTableCell.h"

#import "MyAddressModel.h"

@interface AMAuctionOrderLogisticsTableCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIStackView *stackView;

@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIView *marginLine;

@end

@implementation AMAuctionOrderLogisticsTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.font = [UIFont addHanSanSC:14.0 fontType:2];
    self.companyLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
    self.tradeLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
    self.addressLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setStyle:(AMAuctionOrderLogisticsStyle)style {
    _style = style;
    
    if (_style == AMAuctionOrderLogisticsStyleDefault) {
        self.iconIV.image = ImageNamed(@"icon-orderDet-tranCord");
        self.titleLabel.text = @"物流信息";
        
        self.marginLine.hidden = NO;
        self.addressLabel.hidden = YES;
        self.companyLabel.hidden = NO;
        self.tradeLabel.hidden = NO;
    }else {
        self.iconIV.image = ImageNamed(@"icon-orderDet-address");
        self.titleLabel.text = nil;
        
        self.marginLine.hidden = YES;
        self.addressLabel.hidden = NO;
        self.companyLabel.hidden = YES;
        self.tradeLabel.hidden = YES;
    }
}

- (void)setAddressModel:(MyAddressModel *)addressModel {
    _addressModel = addressModel;
    if (self.style == AMAuctionOrderLogisticsStyleDefault) {
        self.titleLabel.text = @"物流信息";
        
        self.companyLabel.text = [NSString stringWithFormat:@"物流公司：%@",[ToolUtil isEqualToNonNullKong:_addressModel.devlivery_comp]];
        self.tradeLabel.text = [NSString stringWithFormat:@"物流单号：%@",[ToolUtil isEqualToNonNullKong:_addressModel.devlivery_no]];
        
        self.companyLabel.hidden = ![ToolUtil isEqualToNonNull:self.companyLabel.text];
        self.tradeLabel.hidden = ![ToolUtil isEqualToNonNull:self.tradeLabel.text];
        
    }else {
        self.titleLabel.text = [NSString stringWithFormat:@"%@ %@", [ToolUtil isEqualToNonNullKong:_addressModel.reciver], [ToolUtil isEqualToNonNullKong:_addressModel.phone]];
        
        self.addressLabel.text = [ToolUtil isEqualToNonNullKong:_addressModel.address];
        
        self.addressLabel.hidden = ![ToolUtil isEqualToNonNull:self.addressLabel.text];
    }
    self.stackView.hidden = YES;
    [self.stackView.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.hidden) {
            self.stackView.hidden = NO;
            *stop = YES;
        }
    }];
}

@end
