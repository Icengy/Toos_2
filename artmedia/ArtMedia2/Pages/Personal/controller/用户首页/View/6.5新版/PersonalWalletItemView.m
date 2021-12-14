//
//  PersonalWalletItemView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/5.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "PersonalWalletItemView.h"

@implementation PersonalWalletItemView

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

- (IBAction)clickToTouch:(id)sender {
    if (_personalWalletItemBlock) _personalWalletItemBlock();
}

@end
