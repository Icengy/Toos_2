//
//  VideoListHeadView.m
//  ArtMedia2
//
//  Created by LY on 2020/12/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "VideoListHeadView.h"

@implementation VideoListHeadView

+ (instancetype)share{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}
- (IBAction)hideListClick:(UIButton *)sender {
    if (self.hideListBlock) {
        self.hideListBlock();
    }
}

@end
