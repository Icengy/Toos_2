//
//  UGCKitSubtitleTextColorsCollectionCell.m
//  UGCKit
//
//  Created by icnengy on 2020/7/29.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "UGCKitSubtitleTextColorsCollectionCell.h"

#import "UGCKit_UIViewAdditions.h"
#import "UGCKitColorMacro.h"

@interface UGCKitSubtitleTextColorsCollectionCell ()

@property (nonatomic ,strong) UIView *colorView;

@end

@implementation UGCKitSubtitleTextColorsCollectionCell

- (UIView *)colorView {
    if (!_colorView) {
        _colorView = [[UIView alloc] init];
        _colorView.backgroundColor = self.color;
        _colorView.clipsToBounds = YES;
    }return _colorView;
}

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = self.ugckit_height/2;
        self.layer.borderWidth = 0.5f;
        self.layer.borderColor = UIColor.clearColor.CGColor;
        
        [self.contentView addSubview:self.colorView];
    }return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.colorView.frame = CGRectMake(0, 0, self.ugckit_width *0.75, self.ugckit_height *0.75);
    self.colorView.center = self.contentView.center;
    
    self.colorView.layer.cornerRadius = self.colorView.ugckit_height/2;
    
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.layer.borderColor = UIColor.whiteColor.CGColor;
    }else {
        self.layer.borderColor = UIColor.clearColor.CGColor;
    }
}

- (void)setColor:(UIColor *)color {
    _color = color;
    _colorView.backgroundColor = _color;
}


@end
