//
//  AMNewArtistMainHeadView.m
//  ArtMedia2
//
//  Created by 刘洋 on 2020/9/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMNewArtistMainHeadView.h"

@implementation AMNewArtistMainHeadView

+ (instancetype)share {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _meetNumberLabel.font = [UIFont addHanSanSC:12.0 fontType:0];
    _moreVideoButton.titleLabel.font = [UIFont addHanSanSC:12.0 fontType:0];
    _timeLabel.font = [UIFont addHanSanSC:12.0 fontType:0];
}

- (IBAction)moreVideoClick:(AMButton *)sender {
    if (self.moreVideoClickBlock) self.moreVideoClickBlock();
}

- (IBAction)moreInfoClick:(id)sender {
    if (self.moreInfoClickBlock) self.moreInfoClickBlock();
}


@end
