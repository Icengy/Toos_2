//
//  AMMeetingSettingAView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/8/18.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMMeetingSettingAView.h"

@interface AMMeetingSettingAView ()

@property (weak, nonatomic) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet AMReverseButton *openBtn;

@end

@implementation AMMeetingSettingAView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    _openBtn.titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
}

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
}

- (void)setIsOpen:(BOOL)isOpen {
    _isOpen = isOpen;
    _openBtn.selected = _isOpen;
}

- (IBAction)clickToOpen:(AMButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(settingACell:didSelectedOpen:)]) {
        [self.delegate settingACell:self didSelectedOpen:sender];
    }
}

@end
