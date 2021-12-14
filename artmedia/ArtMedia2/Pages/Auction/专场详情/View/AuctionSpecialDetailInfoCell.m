//
//  AuctionSpecialDetailInfoCell.m
//  ArtMedia2
//
//  Created by LY on 2020/11/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AuctionSpecialDetailInfoCell.h"
@interface AuctionSpecialDetailInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentlabel_top_constraint;

@end
@implementation AuctionSpecialDetailInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self changeLineSpaceForLabel:self.contentLabel WithSpace:10];

    // Initialization code
}
-(void)setModel:(AuctionModel *)model{
    _model = model;
    self.titleLabel.text = [ToolUtil isEqualToNonNullKong:_model.auctionFieldTitle];
    self.timeLabel.text = [NSString stringWithFormat:@"直播时间：%@",model.startLiveTime];
    self.contentLabel.text = [ToolUtil isEqualToNonNullKong:_model.auctionFieldDesc];
    
    self.contentlabel_top_constraint.constant = [ToolUtil isEqualToNonNull:_model.auctionFieldDesc]?15.0:0.0;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}
@end
