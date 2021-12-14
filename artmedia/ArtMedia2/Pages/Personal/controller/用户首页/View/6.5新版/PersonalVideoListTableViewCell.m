//
//  PersonalVideoListTableViewCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/9.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "PersonalVideoListTableViewCell.h"

@implementation PersonalVideoListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
    self.cornersRadii = CGSizeMake(8.0f, 8.0f);
    self.insets = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentCarrier mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
}

- (void)setContentCarrier:(UIView *)contentCarrier {
    _contentCarrier = contentCarrier;
    [self addSubview:_contentCarrier];
}

@end
