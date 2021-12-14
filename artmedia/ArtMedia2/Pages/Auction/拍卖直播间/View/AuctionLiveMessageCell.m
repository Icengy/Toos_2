//
//  AuctionLiveMessageCell.m
//  ArtMedia2
//
//  Created by LY on 2020/11/13.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AuctionLiveMessageCell.h"
@interface AuctionLiveMessageCell ()
@property (weak, nonatomic) IBOutlet UILabel *lotNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hammerImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;



@end
@implementation AuctionLiveMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

/*
 AMLiveMsgUserTypeAuctionBidMsg = 3,//出价消息
 AMLiveMsgUserTypeEndAuctionMsg = 4,//结拍消息
 AMLiveMsgUserTypeChangeAuctonMsg = 5,//切换拍品消息
 AMLiveMsgUserTypeCancelBidMsg = 6,//出价作废消息
 */
- (void)setModel:(AMLiveMsgModel *)model{
    _model = model;
    self.contentLabel.layer.cornerRadius = 0;
    self.contentLabel.backgroundColor = [UIColor clearColor];
    
    self.hammerImageView.hidden = YES;
    self.lotNumberLabel.text = [NSString stringWithFormat:@"LOT %04ld",model.messageBody.auctionLot.integerValue];
    
//    if ([model.userData.userId isEqualToString:[UserInfoManager shareManager].uid]) {
//        self.timeLabel.text = [NSString stringWithFormat:@"(我) %@ %@",model.messageBody.numberPlate,model.messageBody.time];
//    }else{
//        if ([model.messageBody.bidType isEqualToString:@"1"]) {//线上
//            self.timeLabel.text = [NSString stringWithFormat:@"%@ %@",model.messageBody.numberPlate,model.messageBody.time];
//        }else{//大厅
//            self.timeLabel.text = [NSString stringWithFormat:@"大厅 %@",model.messageBody.time];
//        }
//    }
    self.contentLabel.attributedText = nil;
    if (model.messageType == AMLiveMsgUserTypeAuctionBidMsg) {//出价消息
        self.contentLabel.text = [NSString stringWithFormat:@"￥%@",[ToolUtil isEqualToNonNull:[ToolUtil stringToDealMoneyString:model.messageBody.bidPrice] replace:@"0"]];

        
    }else if (model.messageType == AMLiveMsgUserTypeEndAuctionMsg){//结拍消息
        if (model.messageBody.ifHasWinner) {
            self.contentLabel.layer.cornerRadius = 12;
            self.contentLabel.layer.masksToBounds = YES;
            self.contentLabel.backgroundColor = RGB(188, 157, 130);
            self.contentLabel.text = [NSString stringWithFormat:@"   落锤价 ￥%@   ",[ToolUtil isEqualToNonNull:[ToolUtil stringToDealMoneyString:model.messageBody.endPrice] replace:@"0"]];
        }else{
            self.contentLabel.text = @"流拍（无人出价）";
        }
        
        
    }else if (model.messageType == AMLiveMsgUserTypeChangeAuctonMsg){//切换拍品消息
        self.contentLabel.text = @"切换到该拍品";
    }else if (model.messageType == AMLiveMsgUserTypeCancelBidMsg){//出价作废消息
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@(作废)",[ToolUtil isEqualToNonNull:[ToolUtil stringToDealMoneyString:model.messageBody.needCancelBidPrice] replace:@"0"]]];
        [attString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, attString.length)];
        self.contentLabel.attributedText = attString;
    }else if (self.model.messageType == AMLiveMsgUserTypeChangeAuctonShowStartPriceMsg){
        self.contentLabel.text = [NSString stringWithFormat:@"起拍价￥%@",[ToolUtil stringToDealMoneyString:model.messageBody.bidPrice]];
    }
}

- (void)setPlateModel:(PlateNumberModel *)plateModel{
    _plateModel = plateModel;
    if (self.model.messageType == AMLiveMsgUserTypeAuctionBidMsg) {//出价消息
        if ([self.model.messageBody.numberPlate isEqualToString:plateModel.auctionFieldPlateNumber]) {
            self.timeLabel.text = [NSString stringWithFormat:@"(我) %@ %@",self.model.messageBody.numberPlate,self.model.messageBody.time];
        }else{
            if ([self.model.messageBody.bidType isEqualToString:@"1"]) {//线上
                self.timeLabel.text = [NSString stringWithFormat:@"%@ %@",self.model.messageBody.numberPlate,self.model.messageBody.time];
            }else{//大厅
                self.timeLabel.text = [NSString stringWithFormat:@"大厅 %@",self.model.messageBody.time];
            }
        }
    }else if (self.model.messageType == AMLiveMsgUserTypeEndAuctionMsg){//结拍消息
        if ([self.model.messageBody.winnerNumberPlate isEqualToString:plateModel.auctionFieldPlateNumber]) {
            self.timeLabel.text = [NSString stringWithFormat:@"(我) %@ %@",self.model.messageBody.winnerNumberPlate,self.model.messageBody.time];
        }else{
            if ([self.model.messageBody.bidType isEqualToString:@"1"]) {//线上
                self.timeLabel.text = [NSString stringWithFormat:@"%@ %@",self.model.messageBody.winnerNumberPlate,self.model.messageBody.time];
            }else{//大厅
                self.timeLabel.text = [NSString stringWithFormat:@"大厅 %@",self.model.messageBody.time];
            }
        }
    }else if (self.model.messageType == AMLiveMsgUserTypeChangeAuctonMsg){//切换拍品消息
        self.timeLabel.text = [NSString stringWithFormat:@"大厅 %@",self.model.messageBody.time];
    }else if (self.model.messageType == AMLiveMsgUserTypeCancelBidMsg){//出价作废消息
        if ([self.model.messageBody.numberPlate isEqualToString:plateModel.auctionFieldPlateNumber]) {
            self.timeLabel.text = [NSString stringWithFormat:@"(我) %@ %@",self.model.messageBody.numberPlate,self.model.messageBody.time];
        }else{
            if ([self.model.messageBody.bidType isEqualToString:@"1"]) {//线上
                self.timeLabel.text = [NSString stringWithFormat:@"%@ %@",self.model.messageBody.numberPlate,self.model.messageBody.time];
            }else{//大厅
                self.timeLabel.text = [NSString stringWithFormat:@"大厅 %@",self.model.messageBody.time];
            }
        }
    }else if (self.model.messageType == AMLiveMsgUserTypeChangeAuctonShowStartPriceMsg){
        self.timeLabel.text = [NSString stringWithFormat:@"大厅 %@",self.model.messageBody.time];
    }
    
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
