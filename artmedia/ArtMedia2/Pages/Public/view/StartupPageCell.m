//
//  StartupPageCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/2/26.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "StartupPageCell.h"

@implementation StartupPageCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
//    self.showBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
//    [self.showBtn addTarget:self action:@selector(clickToTouch:event:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [[event allTouches] anyObject];
//    CGPoint point = [touch locationInView:touch.view];
//    if (_clickToTouchBlock) {
//        if (point.x < K_Width/2) {//点击左边
//            NSLog(@"点击左边");
//            _clickToTouchBlock(YES);
//        }else {//点击右边
//            NSLog(@"点击右边");
//            _clickToTouchBlock(NO);
//        }
//    }
}

//- (void)clickToTouch:(AMButton *)sender event:(UIEvent *)event {
//    UITouch *touch = [[event allTouches] anyObject];
//    CGPoint point = [touch locationInView:sender];
//    if (_clickToTouchBlock) {
//        if (point.x < K_Width/2) {//点击左边
//            NSLog(@"点击左边");
//            _clickToTouchBlock(YES);
//        }else {//点击右边
//            NSLog(@"点击右边");
//            _clickToTouchBlock(NO);
//        }
//    }
//}

@end
