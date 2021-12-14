//
//  TRTCVideoLayoutCell.m
//  LiveStream
//
//  Created by icnengy on 2020/4/9.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "TRTCVideoLayoutCell.h"

#import "AMTRTCVideoView.h"

@implementation TRTCVideoLayoutCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = UIColor.blackColor;
//    self.contentView.backgroundColor = UIColor.clearColor;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSLog(@"");
    }return self;
}

- (void)setMainView:(AMTRTCVideoView *)mainView {
    _mainView = mainView;
    [self addSubview:_mainView];
    _mainView.frame = (CGRect){.origin = CGPointZero, .size = self.frame.size};
}


@end
