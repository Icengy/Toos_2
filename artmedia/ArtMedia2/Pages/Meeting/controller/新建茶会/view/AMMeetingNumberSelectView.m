//
//  AMMeetingNumberSelectView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/8/14.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMMeetingNumberSelectView.h"

#import <SDRangeSlider.h>

@interface AMMeetingNumberSelectView () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet SDRangeSlider *rangeSlider;
@property (weak, nonatomic) IBOutlet AMButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end

@implementation AMMeetingNumberSelectView {
    NSArray *_selectedValue;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
static BOOL _hadInstance = NO;
+ (instancetype)shareInstance {
    if (!_hadInstance) {
        _hadInstance = YES;
        return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
    }
    return nil;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        self.frame = k_Bounds;
        _selectedValue = @[];
    }return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.rangeSlider.usingLineHeight(4.0f).usingHighlightLineColor(Color_Black);
    [self.rangeSlider eventValueDidChanged:^(SDRangeSliderValues * _Nonnull values) {
        _valueLabel.text = [NSString stringWithFormat:@"%@~%@",values.left, values.right];
        _selectedValue = @[values.left, values.right];
        if (_numberChangedBlock) _numberChangedBlock(_selectedValue);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToHide:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

- (void)setSelectedArray:(NSArray *)selectedArray {
    _selectedArray = selectedArray;
    if (_selectedArray && _selectedArray.count == 2) {
        self.rangeSlider.leftValue = [selectedArray.firstObject doubleValue];
        self.rangeSlider.rightValue = [selectedArray.lastObject doubleValue];
        
        _valueLabel.text = [NSString stringWithFormat:@"%@~%@",selectedArray.firstObject ,selectedArray.lastObject];
    }else {
        self.rangeSlider.leftValue = 2;
        self.rangeSlider.rightValue = 20;
        
        _valueLabel.text = @"2~20";
    }
}

#pragma mark -
- (void)show {
    if (!self) return;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^ {
    } completion:nil];
}

- (void)hide {
    [UIView animateWithDuration:0.4f delay:0.0 options:UIViewAnimationOptionTransitionFlipFromTop animations:^ {
    }completion:^(BOOL finished) {
        _hadInstance = NO;
        [self removeFromSuperview];
    }];
}

#pragma mark -
- (IBAction)clickToHide:(id)sender {
    [self hide];
}

- (IBAction)clickToConfirm:(id)sender {
    [self hide];
    if (_numberChangedBlock) {
        if (_selectedValue && _selectedValue.count == 2) {
            _numberChangedBlock(_selectedValue);
        }else {
            _numberChangedBlock(@[@2, @20]);
        }
    }
}

#pragma mark -
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.contentView]) {
        return NO;
    }
    return YES;
}


@end
