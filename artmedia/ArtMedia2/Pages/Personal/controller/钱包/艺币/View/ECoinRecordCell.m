//
//  ECoinRecordCell.m
//  ArtMedia2
//
//  Created by LY on 2020/10/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "ECoinRecordCell.h"
@interface ECoinRecordCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;



@end
@implementation ECoinRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)setModel:(ECoinRecordModel *)model{
    _model = model;
    //消费类型 1:充值(+);2消费(-),
    if ([model.consumeType isEqualToString:@"1"]) {
        self.moneyLabel.text = [NSString stringWithFormat:@"+%@",model.virtualGoldPrice];
        self.moneyLabel.textColor = RGB(219, 17, 17);
        self.titleLabel.text = model.virtualGoldTitle;
    }else{
        self.moneyLabel.text = [NSString stringWithFormat:@"-%@",model.virtualGoldPrice];
        self.moneyLabel.textColor = [UIColor blackColor];
        self.titleLabel.text = model.virtualGoldTitle;
    }
    self.timeLabel.text = model.createTime;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
