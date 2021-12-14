//
//  AMAuctionOrderFillInfoTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/11/13.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMAuctionOrderFillInfoTableCell.h"

@interface AMAuctionOrderFillInfoTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *priceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *freightTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *freightLabel;

@end

@implementation AMAuctionOrderFillInfoTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.priceTitleLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
    self.priceLabel.font = [UIFont addHanSanSC:14.0 fontType:2];
    self.freightTitleLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
    self.freightLabel.font = [UIFont addHanSanSC:14.0 fontType:2];
    
    self.needCorner = YES;
    self.rectCorner = UIRectCornerAllCorners;
    self.cornerRudis = 8.0f;
    self.insets = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPriceStr:(NSString *)priceStr {
    _priceStr = priceStr;
    self.priceLabel.text = _priceStr;
}

@end
