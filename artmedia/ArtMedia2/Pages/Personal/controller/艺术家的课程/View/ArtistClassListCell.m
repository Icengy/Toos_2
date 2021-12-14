//
//  ArtistClassListCell.m
//  ArtMedia2
//
//  Created by LY on 2020/10/22.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "ArtistClassListCell.h"
#import "AMCourseMarkView.h"

@interface ArtistClassListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyCountLabel;
//@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet AMCourseMarkView *statusView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;


@end
@implementation ArtistClassListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clipsToBounds = YES;
    // Initialization code
}
- (void)setModel:(AMCourseModel *)model{
    _model = model;
    [self.mainImageView am_setImageWithURL:model.coverImage placeholderImage:[UIImage imageNamed:@"logo"] contentMode:UIViewContentModeScaleAspectFill];
    self.classNameLabel.text = model.courseTitle;
    self.desLabel.text = model.course_description;
    if ([model.buyCount integerValue] > 0) {
        self.buyCountLabel.text = [NSString stringWithFormat:@"购课人数：%@人",model.buyCount];
    }else{
        self.buyCountLabel.text = @"";
    }
    
    self.statusView.style = [model.liveCourseStatus integerValue];
    
//    if ([model.liveCourseStatus isEqualToString:@"7"]) {
//        self.editButton.hidden = YES;
//    }else{
//        self.editButton.hidden = NO;
//    }
    if ([model.liveCourseStatus isEqualToString:@"1"] || [model.liveCourseStatus isEqualToString:@"3"]) {
        self.deleteButton.hidden = NO;

    }else{
        self.deleteButton.hidden = YES;
    }
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)editClick:(UIButton *)sender {
    if (self.editClassBlock) {
        self.editClassBlock(self.model , sender.titleLabel.text);
    }
}

@end
