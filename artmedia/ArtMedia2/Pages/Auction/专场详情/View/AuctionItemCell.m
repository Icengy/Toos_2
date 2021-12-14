//
//  AuctionItemCell.m
//  ArtMedia2
//
//  Created by LY on 2020/11/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AuctionItemCell.h"
@interface AuctionItemCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *lotLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *referencePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *startPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dealPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


@end
@implementation AuctionItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 左上角和右下角添加圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.statusLabel.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.statusLabel.bounds;
    maskLayer.path = maskPath.CGPath;
    self.statusLabel.layer.mask = maskLayer;
    
    // Initialization code
}
- (void)setModel:(AuctionItemModel *)model {
    
    _model = model;
    self.lotLabel.text = [NSString stringWithFormat:@"LOT %04ld",model.goodNumber.integerValue];
    [self.headImageView am_setImageWithURL:model.opusCoverImage placeholderImage:[UIImage imageNamed:@"logo"] contentMode:UIViewContentModeScaleAspectFit];
    self.titleLabel.text = [ToolUtil isEqualToNonNullKong:model.composeTitle];
    self.referencePriceLabel.hidden = NO;
    if ([ToolUtil isEqualToNonNull:model.referenceStartPrice] && [ToolUtil isEqualToNonNull:model.referenceEndPrice]) {
        self.referencePriceLabel.text = [NSString stringWithFormat:@"参考价：￥%@-￥%@",[ToolUtil stringToDealMoneyString:model.referenceStartPrice],[ToolUtil stringToDealMoneyString:model.referenceEndPrice]];
    }else if([ToolUtil isEqualToNonNull:model.referenceStartPrice]){
        self.referencePriceLabel.text = [NSString stringWithFormat:@"参考价：￥%@",[ToolUtil stringToDealMoneyString:model.referenceStartPrice]];
    }else if([ToolUtil isEqualToNonNull:model.referenceEndPrice]){
        self.referencePriceLabel.text = [NSString stringWithFormat:@"参考价：￥%@",[ToolUtil stringToDealMoneyString:model.referenceEndPrice]];
    }else{
        self.referencePriceLabel.text = @"";
        self.referencePriceLabel.hidden = YES;
    }
    
    self.currentPriceLabel.text = [NSString stringWithFormat:@"当前价：￥%@",[ToolUtil stringToDealMoneyString:model.currentMaxPrice]];
    self.startPriceLabel.text = [NSString stringWithFormat:@"起拍价：￥%@",[ToolUtil stringToDealMoneyString:model.auctionStartPrice]];
    self.dealPriceLabel.text = [NSString stringWithFormat:@"成交价：￥%@",[ToolUtil stringToDealMoneyString:model.dealPrice]];

    if ([model.auctionGoodStatus isEqualToString:@"1"]) {//未开拍
        self.statusLabel.hidden = YES;
        self.currentPriceLabel.hidden = YES;
        self.currentPriceLabel.text = @"";
        self.startPriceLabel.hidden = NO;
        self.dealPriceLabel.hidden = YES;
        self.dealPriceLabel.text = @"";
    }else if ([model.auctionGoodStatus isEqualToString:@"2"]){//竞价中
        if (model.increasePriceNumber.integerValue == 0) {
            self.statusLabel.hidden = YES;
            self.currentPriceLabel.hidden = YES;
            self.currentPriceLabel.text = @"";
            self.startPriceLabel.hidden = NO;
            self.dealPriceLabel.hidden = YES;
            self.dealPriceLabel.text = @"";;
        }else{
            self.statusLabel.hidden = YES;
            self.currentPriceLabel.hidden = NO;
            self.startPriceLabel.hidden = YES;
            self.startPriceLabel.text = @"";
            self.dealPriceLabel.hidden = YES;
            self.dealPriceLabel.text = @"";;
        }
        
        
    }else if ([model.auctionGoodStatus isEqualToString:@"3"]){//已结拍
        self.statusLabel.text = @"已成交";
        self.statusLabel.backgroundColor = RGB(188, 157, 130);
        self.statusLabel.hidden = NO;
        self.currentPriceLabel.hidden = YES;
        self.currentPriceLabel.text = @"";
        self.startPriceLabel.hidden = YES;
        self.startPriceLabel.text = @"";
        self.dealPriceLabel.hidden = NO;
    }else if ([model.auctionGoodStatus isEqualToString:@"4"]){//流拍
        self.statusLabel.text = @"流拍";
        self.statusLabel.backgroundColor = RGB(154, 133, 126);
        self.statusLabel.hidden = NO;
        self.currentPriceLabel.hidden = NO;
        self.startPriceLabel.hidden = YES;
        self.startPriceLabel.text = @"";
        self.dealPriceLabel.hidden = YES;
        self.dealPriceLabel.text = @"";;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
