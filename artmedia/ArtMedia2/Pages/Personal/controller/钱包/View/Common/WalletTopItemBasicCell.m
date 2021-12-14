//
//  WalletTopItemBasicCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "WalletTopItemBasicCell.h"

@implementation GradientView

//- (instancetype) initWithCoder:(NSCoder *)coder {
//    if (self = [super initWithCoder:coder]) {
//        self.layer.cornerRadius = 10.0f;
//    }return self;
//}
//
//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        self.layer.cornerRadius = 10.0f;
//    }return self;
//}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0,1};
    NSMutableArray *colors = @[].mutableCopy;
    if (_colorArray.count) {
        [_colorArray enumerateObjectsUsingBlock:^(UIColor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [colors addObject:(__bridge id)obj.CGColor];
        }];
    }else {
        [colors addObjectsFromArray:@[(__bridge id)RGB(0, 0, 0).CGColor, (__bridge id)RGB(0, 0, 0).CGColor]];
    }
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)colors.copy, locations);
    CGColorSpaceRelease(colorSpace);
    
    CGPoint startPoint = CGPointMake(0.0f, 0.0f);
    CGPoint endPoint = CGPointMake(self.width, self.height);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    CGGradientRelease(gradient);
}

- (void)setColorArray:(NSArray<UIColor *> *)colorArray {
    _colorArray = colorArray;
    [self setNeedsDisplay];
//    CFRunLoopRunInMode (CFRunLoopCopyCurrentMode(CFRunLoopGetCurrent()), 0, FALSE);
}

@end

@implementation WalletTopItemBasicCell

- (instancetype) initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        self.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }return self;
}

@end
