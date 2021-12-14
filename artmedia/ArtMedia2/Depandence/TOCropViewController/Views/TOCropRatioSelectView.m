//
//  TOCropRatioSelectView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/10/29.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "TOCropRatioSelectView.h"

#define CropRatioButtonTagDefault 2020102917100

@interface TOCropRatioSelectView () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@end

@implementation TOCropRatioSelectView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        self.frame = k_Bounds;
    }return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_stackView.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [(PersonalMenuItemButton *)obj titleLabel].font = [UIFont addHanSanSC:14.0f fontType:0];
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

- (void)setRatioPreset:(TOCropViewControllerAspectRatioPreset)ratioPreset {
    _ratioPreset = ratioPreset;
    NSInteger index = 0;
    switch (_ratioPreset) {
        case TOCropViewControllerAspectRatioPresetSquare: // 1:1
            index = 0;
            break;
        case TOCropViewControllerAspectRatioPreset4x3: // 4:3
            index = 1;
            break;
        case TOCropViewControllerAspectRatioPreset3x4: // 3:4
            index = 2;
            break;
        case TOCropViewControllerAspectRatioPreset16x9: // 16:9
            index = 3;
            break;
            
        default:
            break;
    }
    [_stackView.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [(PersonalMenuItemButton *)obj setSelected:(idx == index)?YES:NO];
    }];
    
}


#pragma mark -
- (IBAction)clickToChoose:(AMButton *)sender {
    if (sender.selected)  return;
    
    [_stackView.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag == sender.tag) {
            [(PersonalMenuItemButton *)obj setSelected:YES];
        }else {
            [(PersonalMenuItemButton *)obj setSelected:NO];
        }
    }];
    NSInteger tag = sender.tag - CropRatioButtonTagDefault;
    TOCropViewControllerAspectRatioPreset preset = TOCropViewControllerAspectRatioPresetSquare;
    switch (tag) {
        case 0: // 1:1
            preset = TOCropViewControllerAspectRatioPresetSquare;
            break;
        case 1: // 4:3
            preset = TOCropViewControllerAspectRatioPreset4x3;
            break;
        case 2: // 3:4
            preset = TOCropViewControllerAspectRatioPreset3x4;
            break;
        case 3: // 16:9
            preset = TOCropViewControllerAspectRatioPreset16x9;
            break;
            
        default:
            break;
    }
    [self hide:^{
        if (self.selectedRatioPresetBlock) self.selectedRatioPresetBlock(preset);
    }];
    
    
}

#pragma mark -
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.contentView]) {
        return NO;
    }
    return YES;
}

@end
