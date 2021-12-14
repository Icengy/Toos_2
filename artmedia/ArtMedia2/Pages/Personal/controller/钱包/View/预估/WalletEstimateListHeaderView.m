//
//  WalletEstimateListHeaderView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "WalletEstimateListHeaderView.h"

#import "AMSegment.h"

@interface WalletEstimateListHeaderView () <AMSegmentDelegate>
@property (weak, nonatomic) IBOutlet AMSegment *segment;

@end

@implementation WalletEstimateListHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    _segment.segStyle = AMSegmentStyleProgressView;
    _segment.delegate = self;
    _segment.normalItemTextAttributes = @{NSFontAttributeName:[UIFont addHanSanSC:15.0f fontType:0], NSForegroundColorAttributeName:RGB(153, 153, 153)};
    _segment.selectedItemTextAttributes = @{NSFontAttributeName:[UIFont addHanSanSC:15.0f fontType:0], NSForegroundColorAttributeName:RGB(219, 17, 17)};
    _segment.sliderColor = RGB(219, 17, 17);
    
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x += 10.0f;
    frame.size.width -= 10.0f * 2;
    frame.size.height -= 10.0f;
    [super setFrame:frame];
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    _segment.items = _dataArray;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    _segment.selectedSegmentIndex = _currentIndex;
}

#pragma mark -
- (void)segment:(AMSegment *)seg switchSegmentIndex:(NSInteger)index {
    _currentIndex = index;
    if (_clickIndexBlock) _clickIndexBlock(_currentIndex);
}

@end
