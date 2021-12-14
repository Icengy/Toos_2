//
//  ArtistSubTableViewCell.m
//  ArtMedia2
//
//  Created by 刘洋 on 2020/9/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "ArtistSubTableViewCell.h"



@interface ArtistSubTableViewCell ()

@end
@implementation ArtistSubTableViewCell




- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
 
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentCarrier mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0.0f);
    }];
}



- (void)setContentCarrier:(UIView *)contentCarrier {
    _contentCarrier = contentCarrier;
    [self addSubview:_contentCarrier];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
