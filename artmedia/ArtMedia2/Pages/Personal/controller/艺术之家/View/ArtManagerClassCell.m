//
//  ArtManagerClassCell.m
//  ArtMedia2
//
//  Created by LY on 2020/10/22.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "ArtManagerClassCell.h"
@interface ArtManagerClassCell ()
@property (weak, nonatomic) IBOutlet UILabel *courseNumberLabel;


@end
@implementation ArtManagerClassCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clipsToBounds = YES;
    // Initialization code
}
- (void)setFrame:(CGRect)frame {
    frame.origin.x += 10.0f;
    frame.size.width -= 20.0f;
    [super setFrame:frame];
}

- (void)setCourseNumber:(NSString *)courseNumber{
    _courseNumber = courseNumber;
    self.courseNumberLabel.text = [NSString stringWithFormat:@"%@",courseNumber];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
