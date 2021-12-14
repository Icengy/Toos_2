//
//  IdentityInputView.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/28.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IdentityInputView : UIView

+ (IdentityInputView *)shareIntance;

@property (nonatomic ,copy) void(^ userInputBlock)(NSInteger index, NSString *_Nullable inputStr);

@end

NS_ASSUME_NONNULL_END
