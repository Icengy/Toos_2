//
//  PNSBuildModelUtils.m
//  ATAuthSceneDemo
//
//  Created by 刘超的MacBook on 2020/8/6.
//  Copyright © 2020 刘超的MacBook. All rights reserved.


#import "PNSBuildModelUtils.h"

@implementation PNSBuildModelUtils

+ (TXCustomModel *)buildModel:(AMLoginStyleBtnBlock)loginStyleBlock
{
    TXCustomModel *model =  [self buildFullScreenPortraitModelLoginStyleBlock:loginStyleBlock];
    return model;
}

#pragma mark - 全屏相关
+ (TXCustomModel *)buildFullScreenPortraitModelLoginStyleBlock:(AMLoginStyleBtnBlock)loginStyleBlock
{
    TXCustomModel *model = [[TXCustomModel alloc] init];
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
    model.animationDuration = 0;
    model.navColor = [UIColor clearColor];
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName : [UIColor whiteColor],
        NSFontAttributeName : [UIFont systemFontOfSize:20.0]
    };
    model.navTitle = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
    model.navBackImage = [UIImage imageNamed:@"icon-signUp-close"];
    model.logoImage = [UIImage imageNamed:@"logo-signUp-one"];
    model.changeBtnIsHidden = YES;
    model.numberFont = [UIFont systemFontOfSize:18];
    model.numberColor = RGB(36, 33, 33);
    model.checkBoxIsHidden = YES;
    NSInteger originY = 30;
    
    model.privacyOne = @[@"《用户协议》", [ApiUtil_H5Header h5_userInfoPre]];
    model.privacyColors = @[RGB(157, 155, 152),RGB(36, 33, 33)];
    model.sloganIsHidden = YES;
    model.loginBtnBgImgs = @[[UIImage imageNamed:@"bg-sighUp-btn"],[UIImage imageNamed:@"bg-sighUp-btn"],[UIImage imageNamed:@"bg-sighUp-btn"]];
    model.loginBtnText = [[NSAttributedString alloc] initWithString:@"本机号码一键登录" attributes:@{
        NSForegroundColorAttributeName : UIColor.whiteColor,
        NSFontAttributeName : [UIFont boldSystemFontOfSize:14],
    }];
    model.privacyNavBackImage = [UIImage imageNamed:@"back_black"];
    model.privacyOperatorPreText = @"《";
    model.privacyOperatorSufText = @"》";
    model.privacyAlignment = NSTextAlignmentCenter;

    model.logoFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = originY;
        frame.size = CGSizeMake(99, 65);
        return frame;
    };
    
    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = originY + 65 + 45;
        frame.size.height = 25;
        return frame;
    };
    
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = originY + 65 + 45 + 25 + 23;
        frame.size.height = 41;
        return frame;
    };
    
    
    AMLoginStyleView *loginStyleV = [[AMLoginStyleView alloc] initWithFrame:CGRectZero loginStyleBlock:loginStyleBlock];
    model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
        [superCustomView addSubview:loginStyleV];
    };
    model.customViewLayoutBlock = ^(CGSize screenSize, CGRect contentViewFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
        loginStyleV.frame = CGRectMake(CGRectGetMinX(loginFrame),
                                   CGRectGetMaxY(privacyFrame) - 110,
                                   CGRectGetWidth(loginFrame),
                                   40);
    };
    return model;
}


@end
