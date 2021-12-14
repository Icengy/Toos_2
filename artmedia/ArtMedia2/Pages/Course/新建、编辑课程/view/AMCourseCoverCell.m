//
//  AMCourseCoverCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/10/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMCourseCoverCell.h"

#import "AMCourseModel.h"

@interface AMCourseCoverCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverIV;
@end

@implementation AMCourseCoverCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clipsToBounds = YES;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    CGFloat margin = self.needMargin?15.0f:0.0, cornerRadius = self.needCornerRadius?8.0f:0.0f;
    
    frame.origin.x += margin;
    frame.size.width -= margin *2;
    self.layer.cornerRadius = cornerRadius;
    
    [super setFrame:frame];
}

- (void)setModel:(AMCourseModel *)model {
    _model = model;
    
    [_coverIV am_setImageWithURL:_model.coverImage contentMode:(UIViewContentModeScaleAspectFill)];
}

@end
