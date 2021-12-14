//
//  ClassDetailHeadImageCell.m
//  ArtMedia2
//
//  Created by LY on 2020/10/20.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "ClassDetailHeadImageCell.h"
#import "AMCourseMarkView.h"

@interface ClassDetailHeadImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *classImageView;

@property (weak, nonatomic) IBOutlet AMCourseMarkView *statusView;

@end
@implementation ClassDetailHeadImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setCourseModel:(AMCourseModel *)courseModel{
    _courseModel = courseModel;
    [self.classImageView am_setImageWithURL:courseModel.coverImage placeholderImage:ImageNamed(@"logo") contentMode:UIViewContentModeScaleAspectFill];
    if ([courseModel.isMySelf isEqual:@"1"]) {
        self.statusView.hidden = NO;
        self.statusView.style = [courseModel.liveCourseStatus integerValue];
    }else{
        self.statusView.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
