//
//  UGCKitFontUtil.h
//  UGCKit
//
//  Created by icnengy on 2020/7/29.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define UGCKitMaxChangedFontSize 56.0f

@interface UGCKitFontUtil : NSObject

+ (UIFont *)customFontWithPath:(NSString*)path fontSize:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
