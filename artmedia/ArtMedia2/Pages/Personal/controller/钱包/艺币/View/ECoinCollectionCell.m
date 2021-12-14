//
//  ECoinCollectionCell.m
//  ArtMedia2
//
//  Created by LY on 2020/10/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "ECoinCollectionCell.h"
@interface ECoinCollectionCell ()
@property (weak, nonatomic) IBOutlet UILabel *moneyShowLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyValueLabel;


@end
@implementation ECoinCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (void)setModel:(ECoinRechargeMoneyModel *)model{
    _model = model;
    if (model.isSelect) {
        self.moneyShowLabel.textColor = RGB(209, 74, 68);
        self.moneyValueLabel.textColor = RGB(219, 17, 17);
        self.layer.borderColor = RGB(209, 74, 68).CGColor;
        self.layer.borderWidth = 0.5;
    }else{
        self.moneyShowLabel.textColor = RGB(21, 22, 26);
        self.moneyValueLabel.textColor = RGB(153, 153, 153);
        self.layer.borderColor = RGB(204, 204, 204).CGColor;
        self.layer.borderWidth = 0.5;
    }
    self.moneyShowLabel.text = [NSString stringWithFormat:@"%@艺币",model.moneyShow];
    self.moneyValueLabel.text = [NSString stringWithFormat:@"￥%@",model.moneyValue];
}
@end
