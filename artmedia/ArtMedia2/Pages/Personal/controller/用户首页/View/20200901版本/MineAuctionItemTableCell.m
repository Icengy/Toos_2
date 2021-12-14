//
//  MineAuctionItemTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/11/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "MineAuctionItemTableCell.h"

#define MineAuctionItemTagDetault 2020111210500

@interface MineAuctionItemTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;

@end

@implementation MineAuctionItemTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
    
    [_stackView.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PersonalMenuItemButton *btn = (PersonalMenuItemButton *)obj;
        [btn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
        btn.isAddRight = YES;
        btn.badgeNum = 0;
    }];
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

#pragma mark -
- (IBAction)clickToAuctionItem:(AMButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(auctionCell:didSelectedAuctionCellWithIndex:)]) {
        NSInteger tag = sender.tag - MineAuctionItemTagDetault;
        [self.delegate auctionCell:self didSelectedAuctionCellWithIndex:tag];
    }
}

@end
