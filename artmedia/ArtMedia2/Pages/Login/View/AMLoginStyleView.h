//
//  AMLoginStyleView.h
//  ArtMedia2
//
//  Created by 美术拍卖 on 2020/12/15.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WXApi.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, AMLoginStyleType) {
    AMLoginStyleTypeWechat = 77, //微信
    AMLoginStyleTypeMobile, //手机密码
    AMLoginStyleTypeCode, //验证码
};

typedef void(^AMLoginStyleBtnBlock)(AMLoginStyleType loginStyleType);

@interface AMLoginStyleView : UIView

@property (nonatomic, strong) AMLoginStyleBtnBlock loginStyleBlock;

- (instancetype)initWithFrame:(CGRect)frame loginStyleBlock:(AMLoginStyleBtnBlock)loginStyleBlock;

@end

NS_ASSUME_NONNULL_END
