//
//  AMCoursePublishInfoTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/10/20.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMCoursePublishInfoTableCell.h"

#import "AMCourseModel.h"

#import "AMCourseMarkView.h"

@interface AMCoursePublishInfoTableCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverIV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet AMCourseMarkView *markView;
@end

@implementation AMCoursePublishInfoTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    _priceLabel.font = [UIFont addHanSanSC:18.0f fontType:0];
    _introLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x += 15.0f;
    frame.size.width -= 30.0f;
    [super setFrame:frame];
}

- (void)setModel:(AMCourseModel *)model {
    _model = model;
    
    _titleLabel.text = [ToolUtil isEqualToNonNullKong:_model.courseTitle];
    if ([model.isFree isEqualToString:@"1"]) {
        _priceLabel.text = @"免费课程";
    }else{
        NSString *price = [ToolUtil isEqualToNonNull:_model.coursePrice replace:@"0"];
        NSString *priceStr = [NSString stringWithFormat:@"%@ 艺币",price];
        NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
        [attriStr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x9A9A9A), NSFontAttributeName:[UIFont addHanSanSC:13.0f fontType:0]} range:[priceStr rangeOfString:@"艺币"]];
        _priceLabel.attributedText = attriStr;
    }
    
    _markView.style = _model.liveCourseStatus.integerValue;
    
    _introLabel.text = [ToolUtil isEqualToNonNullKong:_model.course_description];
    [_introLabel sizeToFit];
    [_coverIV am_setImageWithURL:model.coverImage placeholderImage:[UIImage imageNamed:@"logo"]];
}


@end
