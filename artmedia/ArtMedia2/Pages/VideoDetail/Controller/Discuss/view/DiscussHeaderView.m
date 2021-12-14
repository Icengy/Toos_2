//
//  DiscussHeaderView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/7/6.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "DiscussHeaderView.h"

@interface DiscussHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet AMButton *sortBtn;
@property (weak, nonatomic) IBOutlet AMButton *addBtn;
@end

@implementation DiscussHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    _titleLabel.font = [UIFont addHanSanSC:16.0f fontType:0];
    _countLabel.font = [UIFont addHanSanSC:16.0f fontType:0];
    
    _sortBtn.titleLabel.font = [UIFont addHanSanSC:11.0f fontType:0];
    _addBtn.titleLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
}

- (void)setDiscussCount:(NSInteger)discussCount {
    _discussCount = discussCount;
    _countLabel.text = StringWithFormat(@(_discussCount));
}

- (void)setFrame:(CGRect)frame {
    [self borderForColor:RGB(230, 230, 230) borderWidth:1.0f borderType:(UIBorderSideTypeTop | UIBorderSideTypeBottom)];
    [super setFrame:frame];
}

- (IBAction)clickToSort:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerView:didSelectedSort:)]) {
        [self.delegate headerView:self didSelectedSort:sender];
    }
}

- (IBAction)clickToAdd:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerView:didSelectedAdd:)]) {
        [self.delegate headerView:self didSelectedAdd:sender];
    }
}

@end
