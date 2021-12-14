//
//  ClassDetailTextCell.m
//  ArtMedia2
//
//  Created by LY on 2020/10/20.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "ClassDetailTextCell.h"
@interface ClassDetailTextCell ()

@property (weak, nonatomic) IBOutlet UILabel *classTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@end
@implementation ClassDetailTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)editClick:(UIButton *)sender {
    if (_editClickBlock) {
        _editClickBlock();
    }
}



- (void)setModel:(AMCourseModel *)model{
    _model = model;
    self.classTitleLabel.text = model.courseTitle;
    if ([model.isFree isEqualToString:@"1"]) {
        self.priceLabel.text = @"免费课程";
    }else{
        NSString *price = [NSString stringWithFormat:@"%@",model.coursePrice];
        NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 艺币",price]];
        [attstr addAttributes:@{NSForegroundColorAttributeName:RGB(153, 153, 153),NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(price.length + 1, 2)];
        self.priceLabel.attributedText = attstr;
    }
    self.desLabel.text = model.course_description;
    if ([model.isMySelf isEqual:@"1"]) {
        if ([model.liveCourseStatus isEqualToString:@"1"] || [model.liveCourseStatus isEqualToString:@"3"]) {
            self.editButton.hidden = NO;
        }else{
            self.editButton.hidden = YES;
        }
    }
    
    
}


@end
