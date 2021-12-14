//
//  AMCourseChapterHeaderView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/10/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMCourseChapterHeaderView.h"

@interface AMCourseChapterHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation AMCourseChapterHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    _titleLabel.font = [UIFont addHanSanSC:14.0 fontType:2];
    _countLabel.font = [UIFont addHanSanSC:14.0 fontType:2];
}

- (void)setChapters:(NSInteger)chapters {
    _chapters = chapters;
    _countLabel.text = [NSString stringWithFormat:@"共（%@）课时", @(_chapters)];
}

@end
