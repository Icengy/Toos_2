//
//  WalletEstimateListTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "WalletEstimateListTableCell.h"

@interface WalletEstimateListTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation WalletEstimateListTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLabel.font = [UIFont addHanSanSC:28 fontType:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setEstimateMoney:(NSString *)estimateMoney {
    _estimateMoney = estimateMoney;
    _titleLabel.text = [NSString stringWithFormat:@"¥ %.2f",[ToolUtil isEqualToNonNull:_estimateMoney replace:@"0"].doubleValue];
}

@end
