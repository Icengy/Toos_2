//
//  PersonalEditListHeaderView.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/30.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "PersonalEditListHeaderView.h"

#import "AMSegment.h"

#pragma mark -
@interface PersonalEditListHeaderView () <AMSegmentDelegate>
@property (weak, nonatomic) IBOutlet AMSegment *segmentControl;
@property (weak, nonatomic) IBOutlet AMReverseButton *showGoodsBtn;

@end

@implementation PersonalEditListHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
	[super awakeFromNib];
	self.backgroundColor = Color_Whiter;
    
    _segmentControl.items = @[@"全部", @"待审", @"已审"];
    _segmentControl.segStyle = AMSegmentStyleCoverView;
    _segmentControl.normalItemTextAttributes = @{NSFontAttributeName:[UIFont addHanSanSC:13.0f fontType:0], NSForegroundColorAttributeName:RGB(153, 153, 153)};
    _segmentControl.selectedItemTextAttributes = @{NSFontAttributeName:[UIFont addHanSanSC:13.0f fontType:0], NSForegroundColorAttributeName:RGB(219, 17, 17)};
    _segmentControl.delegate = self;
	
    self.showGoodsBtn.titleLabel.font = [UIFont addHanSanSC:11.0f fontType:0];
	[self.showGoodsBtn.titleLabel adjustsFontSizeToFitWidth];
}

- (void)updateToolBar {
    self.showGoodsBtn.hidden = ![UserInfoManager shareManager].isArtist;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    [_segmentControl mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.offset(self.width *0.6);
//        make.left.top.bottom.equalTo(self);
//    }];
//    [_showGoodsBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.right.equalTo(self);
//        make.left.equalTo(_segmentControl.mas_right);
//    }];
}

#pragma mark -
- (void)segment:(AMSegment *)seg switchSegmentIndex:(NSInteger)index {
     if (_selectedVideoStatusBlock) _selectedVideoStatusBlock(index);
}

- (IBAction)clickToShowGoods:(AMButton *)sender {
    sender.selected = !sender.selected;
    if (_showGoodsSwitchBlock) _showGoodsSwitchBlock(sender.selected);
}

@end
