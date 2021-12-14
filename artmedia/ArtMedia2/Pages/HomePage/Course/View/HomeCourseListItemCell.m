//
//  HomeCourseListItemCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/10/9.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "HomeCourseListItemCell.h"

#import "AMCourseMarkView.h"

#import "AMCourseModel.h"

@interface HomeCourseListItemCell ()

@property (weak, nonatomic) IBOutlet AMCourseMarkView *stateMark;

@property (weak, nonatomic) IBOutlet UIImageView *coverIV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet AMIconView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation HomeCourseListItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
    _nameLabel.font = [UIFont addHanSanSC:14.0 fontType:1];
    _priceLabel.font = [UIFont addHanSanSC:14.0 fontType:2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(AMCourseModel *)model {
    _model = model;
    _stateMark.style = [model.liveCourseStatus integerValue];
//    [_coverIV am_setImageWithURL:_model.coverImage placeholderImage:[UIImage imageNamed:@"logo"] contentMode:UIViewContentModeScaleAspectFill];
    [_coverIV am_setImageWithURL:_model.coverImage
                placeholderImage:ImageNamed(@"logo")
                   thumbnailSize:CGSizeMake(K_Width, K_Width)
                     contentMode:UIViewContentModeScaleAspectFill
                       completed:nil];
    
    _titleLabel.text = [ToolUtil isEqualToNonNullKong:_model.courseTitle];
    
    [_iconIV.imageView am_setImageWithURL:_model.headimg placeholderImage:ImageNamed(@"logo") contentMode:(UIViewContentModeScaleAspectFit)];
    _iconIV.artMark.hidden = (_model.utype.integerValue < 3);
    _nameLabel.text = [ToolUtil isEqualToNonNullKong:_model.teacherName];
    
    if (_model.isFree.intValue == 1) {/// 免费
        _priceLabel.text= @"免费";
    }else
        _priceLabel.text = [NSString stringWithFormat:@"%@艺币",[ToolUtil isEqualToNonNull:_model.coursePrice replace:@"0"]];
    
    _stateMark.hidden = YES;
    if (_model.liveCourseStatus.integerValue == 6) {
        _stateMark.hidden = NO;
    }
}

@end
