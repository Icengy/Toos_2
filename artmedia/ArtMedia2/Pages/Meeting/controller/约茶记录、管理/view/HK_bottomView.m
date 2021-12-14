//
//  HK_bottomView.m
//  ArtMedia2
//
//  Created by guohongkai on 2020/8/19.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "HK_bottomView.h"
@interface HK_bottomView()
@property (nonatomic, weak) IBOutlet UIView *view;
@property (nonatomic,weak) IBOutlet AMButton *leftBtn;
@property (nonatomic,weak) IBOutlet AMButton *rightBtn;
@end
@implementation HK_bottomView

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
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.leftBtn.titleLabel.font = [UIFont addHanSanSC:18.0f fontType:0];
    self.rightBtn.titleLabel.font = [UIFont addHanSanSC:18.0f fontType:0];
}

-(void)setLeftTitle:(NSString *)title rightTitle:(NSString *)title2 {
    
    [_leftBtn setTitle:title forState:UIControlStateNormal];
    _leftBtn.enabled = YES;
    [_rightBtn setTitle:title2 forState:UIControlStateNormal];
    _rightBtn.enabled = YES;
}

- (IBAction)NoattendAction:(AMButton *)sender{
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender.titleLabel.text);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
