//
//  AMSegmentedControl.m
//  ArtMedia2
//
//  Created by LY on 2020/11/28.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMSegmentedControl.h"

@implementation AMSegmentedControl

- (instancetype)initWithItems:(NSArray *)items {
    return [super initWithItems:items];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *subView in self.subviews) {
        for (UIView *subSubview in subView.subviews) {
            if ([subSubview isKindOfClass:[UILabel class]]) {
                UILabel *label = (UILabel *)subSubview;
                [label setTranslatesAutoresizingMaskIntoConstraints:NO];
                NSLayoutConstraint *constraintCenterX = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:subView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
                [subView addConstraint:constraintCenterX];
                NSLayoutConstraint *constraintCenterY = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:subView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
                [subView addConstraint:constraintCenterY];
                NSLayoutConstraint *constraintWidth = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:subView attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0];
                [subView addConstraint:constraintWidth];
            }
        }
    }
}

@end
