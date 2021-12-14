//
//  AuctionItemDetailInfoCell.m
//  ArtMedia2
//
//  Created by 刘洋 on 2020/11/23.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AuctionItemDetailInfoCell.h"
@interface AuctionItemDetailInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceTipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *refreshPriceButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *startPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *referencePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *opusSpecsLabel;

@property (weak, nonatomic) IBOutlet UIView *marginView;
@property (weak, nonatomic) IBOutlet AMButton *goLiveRoomButton;

@end
@implementation AuctionItemDetailInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(AuctionItemDetailModel *)model{
    _model = model;
    //拍品状态，1：未开拍，2：竞价中，3：已结拍，4：流拍
    if ([model.auctionGoodStatus isEqualToString:@"1"]) {
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[ToolUtil stringToDealMoneyString:model.auctionStartPrice]];
        self.currentPriceTipsLabel.text = @"起拍价";
    }else if ([model.auctionGoodStatus isEqualToString:@"2"]){
        if (model.increasePriceNumber.integerValue == 0) {
            self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[ToolUtil stringToDealMoneyString:model.auctionStartPrice]];
            self.currentPriceTipsLabel.text = @"起拍价";
        }else{
            self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[ToolUtil stringToDealMoneyString:model.currentMaxPrice]];
            self.currentPriceTipsLabel.text = @"当前出价";
        }
        
    }else if ([model.auctionGoodStatus isEqualToString:@"3"]){
        self.currentPriceTipsLabel.text = @"成交价";
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[ToolUtil stringToDealMoneyString:model.dealPrice]];
    }else if ([model.auctionGoodStatus isEqualToString:@"4"]){
        self.currentPriceTipsLabel.text = @"起拍价";
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[ToolUtil stringToDealMoneyString:model.auctionStartPrice]];
    }
    
    
    
//    if ([ToolUtil isEqualToNonNull:model.currentMaxPrice]) {
//        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.currentMaxPrice.doubleValue];
//
//    }else{
//        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.auctionStartPrice.doubleValue];
//    }
    
    self.titleLabel.text = [ToolUtil isEqualToNonNullKong:model.composeTitle];
    self.startPriceLabel.text = [NSString stringWithFormat:@"起拍价：￥%@",[ToolUtil stringToDealMoneyString:model.auctionStartPrice]];
    self.marginView.hidden = NO;
    self.referencePriceLabel.hidden = NO;
    if ([ToolUtil isEqualToNonNull:model.referenceStartPrice] && [ToolUtil isEqualToNonNull:model.referenceEndPrice]) {
        self.referencePriceLabel.text = [NSString stringWithFormat:@"参考价：￥%@-￥%@",[ToolUtil isEqualToNonNull:[ToolUtil stringToDealMoneyString:model.referenceStartPrice] replace:@"0"],[ToolUtil isEqualToNonNull:model.referenceEndPrice replace:@"0"]];
    }else if([ToolUtil isEqualToNonNull:model.referenceStartPrice]){
        self.referencePriceLabel.text = [NSString stringWithFormat:@"参考价：￥%@",[ToolUtil isEqualToNonNull:[ToolUtil stringToDealMoneyString:model.referenceStartPrice] replace:@"0"]];
    }else if([ToolUtil isEqualToNonNull:model.referenceEndPrice]){
        self.referencePriceLabel.text = [NSString stringWithFormat:@"参考价：￥%@",[ToolUtil isEqualToNonNull:[ToolUtil stringToDealMoneyString:model.referenceEndPrice] replace:@"0"]];
    }else{
        self.referencePriceLabel.hidden = YES;
        self.marginView.hidden = YES;
    }
    
    if ([ToolUtil isEqualToNonNull:model.opusSpecs]) {
        self.opusSpecsLabel.hidden = NO;
        self.opusSpecsLabel.text = model.opusSpecs;
    }else{
        self.opusSpecsLabel.hidden = YES;
    }
    
    
}

- (void)setAuctionModel:(AuctionModel *)auctionModel{
    _auctionModel = auctionModel;
    if ([auctionModel.fieldStatus isEqualToString:@"6"]) {
        self.goLiveRoomButton.hidden = NO;
    }else{
        self.goLiveRoomButton.hidden = YES;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)gotoLiveRoomClick:(UIButton *)sender {
    if (self.gotoLiveRoomBlock) {
        self.gotoLiveRoomBlock();
    }
    
}
- (IBAction)refreshPriceClick:(UIButton *)sender {
    if (self.refreshPriceBlock) {
        self.refreshPriceBlock();
    }
}

@end
