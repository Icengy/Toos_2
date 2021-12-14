//
//  PublishGenerateLeadingView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/11/2.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "PublishGenerateLeadingView.h"
#import "GKSliderView.h"

@interface PublishGenerateLeadingView ()
@property (nonatomic ,weak) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet GKSliderView *slider;

@end

@implementation PublishGenerateLeadingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark -
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
    self.view.backgroundColor = Color_Whiter;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.slider.allowTapped = NO;
    self.slider.isHideSliderBlock = YES;
    self.slider.sliderHeight = 2.0f;
    self.slider.maximumTrackTintColor = Color_Black;
    self.slider.minimumTrackTintColor = kDefaultTinkColor;
    self.slider.value = 0;
}

- (void)setProgress:(CGFloat)progress forType:(NSInteger)type {
    
    if (progress < 0.0) progress = 0.0;
    if (progress > 1.0) progress = 1.0;
    self.slider.value = progress;
    if (type) {
        self.titleLabel.text = [NSString stringWithFormat:@"视频发布中...%@%@",@((NSInteger)(progress*100)), @"%"];
    }else {
        self.titleLabel.text = [NSString stringWithFormat:@"视频生成中...%@%@",@((NSInteger)(progress*100)), @"%"];
    }
    
}

@end
