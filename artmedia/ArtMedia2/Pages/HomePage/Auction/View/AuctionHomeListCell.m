//
//  AuctionHomeListCell.m
//  ArtMedia2
//
//  Created by LY on 2020/11/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AuctionHomeListCell.h"
@interface AuctionHomeListCell ()
@property (weak, nonatomic) IBOutlet UILabel *auctionNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *auctionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *liveStatusImageView;
@property (weak, nonatomic) IBOutlet UILabel *finishTipsLabel;



@end
@implementation AuctionHomeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.moneyLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
//    [self.moneyLabel adjustsFontSizeToFitWidth];
}
- (void)setModel:(AuctionModel *)model{
    _model = model;
    self.auctionNumLabel.text = model.auctionGoodTotalAmount;
    self.moneyLabel.text = model.depositAmount;
    [self.headImageView am_setImageWithURL:model.headimg placeholderImage:[UIImage imageNamed:@"logo"] contentMode:UIViewContentModeScaleAspectFit];
    [self.coverImageView am_setImageWithURL:model.auctionFieldImage placeholderImage:[UIImage imageNamed:@"logo"] contentMode:UIViewContentModeScaleAspectFill];
    self.auctionNameLabel.text = [NSString stringWithFormat:@"%@·%@",model.createUserName,model.auctionFieldTitle];
    self.timeLabel.text = [NSString stringWithFormat:@"开播时间：%@",model.startLiveTime];
    if ([model.fieldStatus isEqualToString:@"6"]) {
        self.liveStatusImageView.hidden = NO;
    }else{
        self.liveStatusImageView.hidden = YES;
    }
    if ([model.fieldStatus isEqualToString:@"7"]) {
        self.finishTipsLabel.hidden = NO;
    }else{
        self.finishTipsLabel.hidden = YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.headImageView.layer.cornerRadius = self.headImageView.height/2;
}
@end
