//
//  ArtManagerPendingItemView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/9/4.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "ArtManagerPendingItemView.h"

@implementation ArtManagerPendingItemView

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
    self.backgroundColor = UIColor.whiteColor;
    self.view.frame = self.bounds;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.subTitleLabel.font = [UIFont addHanSanSC:13.0 fontType:0];
    self.counttitleLabel.font = [UIFont addHanSanSC:15.0 fontType:0];
}

- (IBAction)clickToItem:(id)sender {
    if (_selectedItemBlock) _selectedItemBlock(self);
}



@end
