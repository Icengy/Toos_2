//
//  ECoinRecordDetailHeadCell.m
//  ArtMedia2
//
//  Created by LY on 2020/10/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "ECoinRecordDetailHeadCell.h"
@interface ECoinRecordDetailHeadCell ()
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;


@end
@implementation ECoinRecordDetailHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(ECoinRecordDetailModel *)model{
    _model = model;
    if ([model.consumeType isEqualToString:@"1"]) {
        self.moneyLabel.text = [NSString stringWithFormat:@"+%@",model.virtualGoldPrice];
        self.typeLabel.text = @"艺币充值";
    }else if([model.consumeType isEqualToString:@"2"]){
        self.moneyLabel.text = [NSString stringWithFormat:@"-%@",model.virtualGoldPrice];
        self.typeLabel.text = @"艺币消费";
    }else{//3
        self.moneyLabel.text = [NSString stringWithFormat:@"-%@",model.virtualGoldPrice];
        self.typeLabel.text = @"点播课程消费";
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
