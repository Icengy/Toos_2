//
//  AMNewArtistMainTimeLineNoDataCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/10/21.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMNewArtistMainTimeLineNoDataCell.h"

@interface AMNewArtistMainTimeLineNoDataCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation AMNewArtistMainTimeLineNoDataCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
