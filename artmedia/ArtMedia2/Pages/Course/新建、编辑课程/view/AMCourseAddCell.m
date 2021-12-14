//
//  AMCourseAddCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/10/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMCourseAddCell.h"

@interface AMCourseAddCell ()

@end

@implementation AMCourseAddCell

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
    frame.origin.x += 15.0f;
    frame.size.width -= 30.0f;
    [super setFrame:frame];
}

@end
