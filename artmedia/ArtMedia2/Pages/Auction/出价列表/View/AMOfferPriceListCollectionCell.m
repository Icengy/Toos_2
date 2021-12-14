//
//  AMOfferPriceListCollectionCell.m
//  ArtMedia2
//
//  Created by LY on 2020/12/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMOfferPriceListCollectionCell.h"
@interface AMOfferPriceListCollectionCell ()

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
@implementation AMOfferPriceListCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setPrice:(NSString *)price{
    _price = price;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[ToolUtil stringToDealMoneyString:price]];
}

- (void)setSelectPrice:(NSString *)selectPrice{
    _selectPrice = selectPrice;
    if ([self.price isEqualToString:selectPrice]) {
        self.priceLabel.textColor = RGB(224, 82, 39);
        self.priceLabel.layer.borderColor = RGB(224, 82, 39).CGColor;
    }else{
        self.priceLabel.textColor = RGB(36, 33, 33);
        self.priceLabel.layer.borderColor = RGB(228, 228, 228).CGColor;
    }
}

@end
