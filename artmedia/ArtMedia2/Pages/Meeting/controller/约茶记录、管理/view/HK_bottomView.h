//
//  HK_bottomView.h
//  ArtMedia2
//
//  Created by guohongkai on 2020/8/19.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HK_bottomView : UIView
@property (nonatomic,copy)void(^buttonClickBlock)(NSString *buttonTitle);
- (void)setLeftTitle:(NSString *)title rightTitle:(NSString *)title2;
@end

NS_ASSUME_NONNULL_END
