//
//  AMMeetingListHeader.m
//  ArtMedia2
//
//  Created by icnengy on 2020/8/18.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMMeetingListHeader.h"

@implementation AMMeetingListHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (AMMeetingListHeader *)shareInstance {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.font = [UIFont addHanSanSC:15.0f fontType:1];
}

- (void)setFrame:(CGRect)frame {
    [self addRoundedCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) withRadii:CGSizeMake(8.0f, 8.0f)];
    
    [super setFrame:frame];
}

@end
