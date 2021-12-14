//
//  UGCKitFontUtil.m
//  UGCKit
//
//  Created by icnengy on 2020/7/29.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "UGCKitFontUtil.h"

#import <CoreText/CoreText.h>

@implementation UGCKitFontUtil

+ (UIFont *)customFontWithPath:(NSString*)path fontSize:(CGFloat)size {
    if (!path || path.length == 0) {
        return [UIFont systemFontOfSize:size];
    }
    NSURL *fontUrl = [NSURL fileURLWithPath:path];
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontUrl);
    CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CTFontManagerRegisterGraphicsFont(fontRef, NULL);
    NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
    UIFont *font = [UIFont fontWithName:fontName size:size];
    CGFontRelease(fontRef);
    
    return font;
}

@end
