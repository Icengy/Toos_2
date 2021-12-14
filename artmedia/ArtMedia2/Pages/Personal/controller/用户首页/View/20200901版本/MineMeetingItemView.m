//
//  MineMeetingItemView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/9/2.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "MineMeetingItemView.h"

@implementation MineMeetingItemView

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
    self.backgroundColor = UIColor.clearColor;
    self.view.frame = self.bounds;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.topTitleLabel.font = [UIFont addHanSanSC:15.0 fontType:0];
    self.bottomTitleLabel.font = [UIFont addHanSanSC:13.0 fontType:0];
}


- (IBAction)clickToSelected:(id)sender {
    if (_ItemClickBlock) _ItemClickBlock();
}

@end
