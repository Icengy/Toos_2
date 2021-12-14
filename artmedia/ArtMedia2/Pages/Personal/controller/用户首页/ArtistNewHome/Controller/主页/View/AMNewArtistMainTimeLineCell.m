//
//  AMNewArtistMainTimeLineCell.m
//  ArtMedia2
//
//  Created by 刘洋 on 2020/9/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMNewArtistMainTimeLineCell.h"
@interface AMNewArtistMainTimeLineCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLineLabel;
@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@end
@implementation AMNewArtistMainTimeLineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _timeLineLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(AMNewArtistTimeLineModel *)model{
    _model = model;
    self.timeLineLabel.text = [NSString stringWithFormat:@"%@ %@",model.optTime ,model.optContent];
}

/// -1:第一个cell，隐藏topLine 1:最后一个cell，隐藏bottomLine， 0:不隐藏 -2:全隐藏
- (void)setLinePosition:(NSInteger)linePosition {
    _linePosition = linePosition;
    if (_linePosition == -1) {
        _topLine.hidden = YES;
        _bottomLine.hidden = NO;
    }else if (_linePosition == 1) {
        _topLine.hidden = NO;
        _bottomLine.hidden = YES;
    }else if (_linePosition == -2) {
        _topLine.hidden = YES;
        _bottomLine.hidden = YES;
    } else {
        _topLine.hidden = NO;
        _bottomLine.hidden = NO;
    }
}

@end
