//
//  WalletRevenueEstimateTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/11.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "WalletRevenueEstimateTableCell.h"

@interface WalletRevenueEstimateTableCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@end

@implementation WalletRevenueEstimateTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    _valueLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -
- (void)setStyle:(AMWalletItemStyle)style {
    _style = style;
    if (_style == AMWalletItemStyleEstimateProfit) {
        _iconIV.image = ImageNamed(@"Revenue_profit");
        _titleLabel.text = @"预估收益";
    }else if (_style == AMWalletItemStyleEstimateSale) {
        _iconIV.image = ImageNamed(@"Revenue_sale");
        _titleLabel.text = @"预估销售";
    }
}

- (void)setEstimateData:(NSDictionary *)estimateData {
    _estimateData = estimateData;
    NSString *pre_money;
    NSLog(@"setEstimateData = _style%@",@(_style));
    if (_style == AMWalletItemStyleEstimateSale) {
        pre_money = [ToolUtil isEqualToNonNull:[_estimateData objectForKey:@"pre_sale_money"] replace:@"0"];
    }
    if (_style == AMWalletItemStyleEstimateProfit) {
         pre_money = [ToolUtil isEqualToNonNull:[_estimateData objectForKey:@"pre_reward_money"] replace:@"0"];
     }
    _valueLabel.text = [NSString stringWithFormat:@"¥ %.2f",pre_money.doubleValue];
}

@end
