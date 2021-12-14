//
//  AMNewArtistCourseVCell.m
//  ArtMedia2
//
//  Created by LY on 2020/11/26.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMNewArtistCourseVCell.h"
@interface AMNewArtistCourseVCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end

@implementation AMNewArtistCourseVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(AMCourseModel *)model{
    _model = model;
    [_headImageView am_setImageWithURL:model.coverImage placeholderImage:[UIImage imageNamed:@"logo"] contentMode:UIViewContentModeScaleAspectFill];
    _titleLabel.text = [ToolUtil isEqualToNonNullKong:model.courseTitle];
    _contentLabel.text = [ToolUtil isEqualToNonNullKong:model.course_description];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)setFrame:(CGRect)frame {
//    frame.origin.x += 25.0f;
//    frame.size.width -= 50.0f;
//    [super setFrame:frame];
//}
@end
