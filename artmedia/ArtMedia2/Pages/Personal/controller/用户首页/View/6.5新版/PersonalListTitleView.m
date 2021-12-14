//
//  PersonalListTitleView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/9.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "PersonalListTitleView.h"

#import "AMSegment.h"

@interface PersonalListTitleView () <AMSegmentDelegate>
@property (weak, nonatomic) IBOutlet AMSegment *segment;
@end

@implementation PersonalListTitleView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _segment.delegate = self;
    _segment.segStyle = AMSegmentStyleProgressView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_segment mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    _segment.items = _dataArray;
}

- (void)setBadges:(NSArray *)badges {
    _badges = badges;
    _segment.badges = _badges;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    _segment.selectedSegmentIndex = _currentIndex;
}

- (void)setFrame:(CGRect)frame {
    if (!UIEdgeInsetsEqualToEdgeInsets(_insets, UIEdgeInsetsZero)) {
        [self addRoundedCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) withRadii:CGSizeMake(8.0f, 8.0f)];
    }else {
        [self addRoundedCorners:UIRectCornerAllCorners withRadii:CGSizeZero];
    }
    frame.origin.x += _insets.left;
    frame.size.width -= (_insets.left+_insets.right);
    [super setFrame:frame];
}

- (void)setInsets:(UIEdgeInsets)insets {
    _insets = insets;
}

#pragma mark -
- (void)segment:(AMSegment *)seg switchSegmentIndex:(NSInteger)index {
    _currentIndex = index;
    if (_clickIndexBlock) _clickIndexBlock(_currentIndex);
}

@end
