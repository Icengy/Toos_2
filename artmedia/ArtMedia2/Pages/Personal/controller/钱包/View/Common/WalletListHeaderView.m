//
//  WalletListHeaderView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/11.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "WalletListHeaderView.h"

#import "AMSegment.h"

@interface WalletListHeaderView () <AMSegmentDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet AMButton *screenBtn;

@property (weak, nonatomic) IBOutlet AMSegment *segment;
@end

@implementation WalletListHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _titleLable.font = [UIFont addHanSanSC:16.0f fontType:0];
    
    _segment.segStyle = AMSegmentStyleProgressView;
    _segment.delegate = self;
    _segment.normalItemTextAttributes = @{NSFontAttributeName:[UIFont addHanSanSC:15.0f fontType:0], NSForegroundColorAttributeName:RGB(179, 179, 179)};
    _segment.selectedItemTextAttributes = @{NSFontAttributeName:[UIFont addHanSanSC:15.0f fontType:0], NSForegroundColorAttributeName:RGB(219, 17, 17)};
    _segment.sliderColor = RGB(219, 17, 17);
}

- (void)setStyle:(AMWalletItemStyle)style {
    _style = style;
    if (_style == AMWalletItemStyleYiB) {
        _titleLable.text = @"艺币明细";
    }
    if (_style == AMWalletItemStyleRevenue) {
        _titleLable.text = @"收入明细";
    }
    if (_style == AMWalletItemStyleBalance) {
        _titleLable.text = @"账单明细";
    }
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
