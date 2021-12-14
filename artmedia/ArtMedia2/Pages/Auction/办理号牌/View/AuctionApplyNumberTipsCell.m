//
//  AuctionApplyNumberTipsCell.m
//  ArtMedia2
//
//  Created by LY on 2020/11/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AuctionApplyNumberTipsCell.h"
@interface AuctionApplyNumberTipsCell ()

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;


@end
@implementation AuctionApplyNumberTipsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tipsLabel.text = @"1. 艺术融媒体提供代拍服务，竞买人需要根据拍卖规则确定是否交保证金；\n2. 若符合艺术融媒体拍卖退回规则，保证金将在拍卖会结束后的14个工作日内把保证金退回给竞买人，竞买人收到保证金的时间以银行实际到账时间为准；\n3. 若对保证金缴纳有任何查询、或支付碰见问题，欢迎咨询本公司客服部：(0571) 8531 1181 。";
    [self changeLineSpaceForLabel:self.tipsLabel WithSpace:10];
    // Initialization code
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
