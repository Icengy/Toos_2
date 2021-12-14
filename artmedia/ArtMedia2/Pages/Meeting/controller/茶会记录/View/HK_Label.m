//
//  HK_Label.m
//  ArtMedia2
//
//  Created by guohongkai on 2020/8/14.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "HK_Label.h"

@implementation HK_Label
- (instancetype)init{
    if (self = [super init]) {
        [self addtargetAction];
    }
    return self;
}
- (void)addtargetAction{
    self.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hk_labelAction:)];
    [self addGestureRecognizer:tap];
}
- (void)hk_labelAction:(UITapGestureRecognizer *)ges{
    if (self.block) {
        self.block(self.text, self.tag);
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
