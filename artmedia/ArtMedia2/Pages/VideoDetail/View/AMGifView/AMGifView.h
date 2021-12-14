//
//  AMGifView.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/27.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AMGifView : UIView

+ (AMGifView *)shareInstance;

- (void)showGifView:(NSString *_Nullable)gifUrlStr count:(NSInteger)count;

@end

NS_ASSUME_NONNULL_END
