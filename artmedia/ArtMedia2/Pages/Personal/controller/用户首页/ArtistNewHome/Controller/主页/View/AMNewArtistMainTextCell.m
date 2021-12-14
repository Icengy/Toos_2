//
//  AMNewArtistMainTextCell.m
//  ArtMedia2
//
//  Created by 刘洋 on 2020/9/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMNewArtistMainTextCell.h"

@implementation AMNewArtistMainTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
