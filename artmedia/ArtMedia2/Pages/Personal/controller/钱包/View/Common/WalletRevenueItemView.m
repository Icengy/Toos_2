//
//  WalletRevenueItemView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "WalletRevenueItemView.h"

@implementation WalletRevenueItemView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }return self;
}

- (void)setup {
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [self addSubview:self.view];
    self.view.frame = self.bounds;
    self.view.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.3];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _mainLabel.font = [UIFont addHanSanSC:25.0f fontType:2];
    _cashoutBtn.titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
}

#pragma mark -
- (IBAction)clickToCashout:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickToCashout:)]) {
        [self.delegate didClickToCashout:sender];
    }
}

@end
