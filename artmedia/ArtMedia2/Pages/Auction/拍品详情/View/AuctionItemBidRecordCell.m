//
//  AuctionItemBidRecordCell.m
//  ArtMedia2
//
//  Created by 刘洋 on 2020/11/23.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AuctionItemBidRecordCell.h"
@interface AuctionItemBidRecordCell ()

@property (weak, nonatomic) IBOutlet UILabel *headLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
@implementation AuctionItemBidRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(AuctionOfferPriceRecordModel *)model{
    _model = model;
    if ([model.createUserId isEqualToString:[UserInfoManager shareManager].uid]) {
        self.timeLabel.text = [NSString stringWithFormat:@"（我）%@  %@",model.auctionFieldPlateNumber,[model.createTime substringFromIndex:11]];
    }else{
        if ([model.plateNumberOnlineFlag isEqualToString:@"1"]) {//线上
            self.timeLabel.text = [NSString stringWithFormat:@"%@  %@",model.auctionFieldPlateNumber,[model.createTime substringFromIndex:11]];
        }else{//线下
            self.timeLabel.text = [NSString stringWithFormat:@"（大厅）%@  %@",model.auctionFieldPlateNumber,[model.createTime substringFromIndex:11]];
        }
    }
    if ([model.cancelFlag isEqualToString:@"1"]) {//作废
        self.headLabel.text = [NSString stringWithFormat:@"￥%@ （作废）",[ToolUtil stringToDealMoneyString:model.auctionUserOfferPrice]];
    }else{
        self.headLabel.text = [NSString stringWithFormat:@"￥%@",[ToolUtil stringToDealMoneyString:model.auctionUserOfferPrice]];
    }
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
