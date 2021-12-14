//
//  UGCKitSubtitleFontNameCollectionCell.m
//  UGCKit
//
//  Created by icnengy on 2020/7/29.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "UGCKitSubtitleFontNameCollectionCell.h"

#import "UGCKitColorMacro.h"
#import "UGCKitFontUtil.h"

@interface UGCKitSubtitleFontNameCollectionCell ()
@property (nonatomic ,strong) UILabel *titleLabel;
@end

@implementation UGCKitSubtitleFontNameCollectionCell

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.font = [UGCKitFontUtil customFontWithPath:[self.fontDict objectForKey:@"path"] fontSize:13.0f];
        _titleLabel.text = [self.fontDict objectForKey:@"name"];
        
        _titleLabel.layer.cornerRadius = 5.0f;
        _titleLabel.clipsToBounds = YES;
        _titleLabel.backgroundColor = UIColorFromRGB(0x333333);
    }return _titleLabel;
}

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.titleLabel];
    }return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame) * 0.75);
    self.titleLabel.center = self.contentView.center;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.titleLabel.textColor = RGB(254, 79, 67);
    }else {
        self.titleLabel.textColor = UIColor.whiteColor;
    }
}

- (void)setFontDict:(NSDictionary *)fontDict {
    _fontDict = fontDict;
    self.titleLabel.font = [UGCKitFontUtil customFontWithPath:[_fontDict objectForKey:@"path"] fontSize:13.0f];
    self.titleLabel.text = [_fontDict objectForKey:@"name"];
}

@end
