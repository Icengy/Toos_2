//
//  AuctionSpecialDetailHeadImageCell.m
//  ArtMedia2
//
//  Created by LY on 2020/11/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AuctionSpecialDetailHeadImageCell.h"
@interface AuctionSpecialDetailHeadImageCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;


@end
@implementation AuctionSpecialDetailHeadImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(AuctionModel *)model{
    _model = model;
    [self.headImageView am_setImageWithURL:model.auctionFieldImage placeholderImage:[UIImage imageNamed:@"logo"] contentMode:UIViewContentModeScaleAspectFill];
    if ([model.fieldStatus isEqualToString:@"6"]) {
        self.statusImageView.hidden = NO;
    }else{
        self.statusImageView.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
