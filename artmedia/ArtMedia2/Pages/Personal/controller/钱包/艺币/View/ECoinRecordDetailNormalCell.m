//
//  ECoinRecordDetailNormalCell.m
//  ArtMedia2
//
//  Created by LY on 2020/10/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "ECoinRecordDetailNormalCell.h"
@interface ECoinRecordDetailNormalCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end
@implementation ECoinRecordDetailNormalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(ECoinRecordDetailModel *)model{
    _model = model;
    if ([model.consumeType isEqualToString:@"1"]) {
        if (self.indexPath.row == 1) {
            self.titleLabel.text = @"实付金额：";
            self.contentLabel.text = [NSString stringWithFormat:@"%@元",model.orderPrice];
        }else if(self.indexPath.row == 2){
            self.titleLabel.text = @"支付方式：";
            if ([model.tradingChannel isEqualToString:@"1"]) {
                self.contentLabel.text = @"支付宝";
            }else if ([model.tradingChannel isEqualToString:@"2"]){
                self.contentLabel.text = @"微信";
            }else{
                self.contentLabel.text = @"Apple 内购";
            }
            
        }else if(self.indexPath.row == 3){
            self.titleLabel.text = @"订单编号：";
            self.contentLabel.text = model.relationNo;
        }else if(self.indexPath.row == 4){
            self.titleLabel.text = @"创建时间：";
            self.contentLabel.text = model.createTime;
        }else if(self.indexPath.row == 5){
            self.titleLabel.text = @"支付时间：";
            self.contentLabel.text = model.createTime;
        }else if(self.indexPath.row == 6){
            self.titleLabel.text = @"订单备注：";
            self.contentLabel.text = @"艺币充值";
        }
    }else{
        if (self.indexPath.row == 1) {
            if ([model.consumeType isEqualToString:@"2"]) {
                self.titleLabel.text = @"消费类型：";
                self.contentLabel.text = @"直播课程消费";
            }else{//3
                self.titleLabel.text = @"消费类型：";
                self.contentLabel.text = @"点播课程消费";
            }
        }else if(self.indexPath.row == 2){
            self.titleLabel.text = @"订单编号：";
            self.contentLabel.text = model.goldNo;
        }else if(self.indexPath.row == 3){
            self.titleLabel.text = @"创建时间：";
            self.contentLabel.text = model.createTime;
        }else if(self.indexPath.row == 4){
            self.titleLabel.text = @"支付时间：";
            self.contentLabel.text = model.createTime;
        }else if(self.indexPath.row == 5){
            self.titleLabel.text = @"订单备注：";
            self.contentLabel.text = model.virtualGoldTitle;
        }
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
