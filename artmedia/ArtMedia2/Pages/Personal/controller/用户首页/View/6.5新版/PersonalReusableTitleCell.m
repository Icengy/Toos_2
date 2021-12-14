//
//  PersonalReusableTitleCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/8.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "PersonalReusableTitleCell.h"

@interface PersonalReusableTitleCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation PersonalReusableTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLabel.font = [UIFont addHanSanSC:16.0f fontType:0];
    _titleLabel.textColor = RGB(135, 138, 153);
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    [self updateCellStatusWithSelected:selected];
}

- (void)updateCellStatusWithSelected:(BOOL)selected {
    if (selected) {
        _titleLabel.font = [UIFont addHanSanSC:16.0f fontType:1];
        _titleLabel.textColor = Color_Black;
    }else {
        _titleLabel.font = [UIFont addHanSanSC:16.0f fontType:0];
        _titleLabel.textColor = RGB(135, 138, 153);
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = _title;
}

@end
