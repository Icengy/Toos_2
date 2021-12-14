//
//  DiscussBlackInfoTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/7/6.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "DiscussBlackInfoTableCell.h"

@interface DiscussBlackInfoTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@end

@implementation DiscussBlackInfoTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _tipsLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x += 60.0f;
    frame.size.width -= 60.0f;
    [super setFrame:frame];
}

@end
