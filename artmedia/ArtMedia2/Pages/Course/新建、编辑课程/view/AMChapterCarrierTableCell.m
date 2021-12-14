//
//  AMChapterCarrierTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/10/19.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMChapterCarrierTableCell.h"

@implementation AMChapterCarrierTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_chapterCarrier mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setChapterCarrier:(UIView *)chapterCarrier {
    _chapterCarrier = chapterCarrier;
    if (![self.contentView.subviews containsObject:_chapterCarrier]) {
        [self.contentView addSubview:_chapterCarrier];
    }

}

@end
