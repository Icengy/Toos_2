//
//  AMATAuthTool.h
//  ArtMedia2
//
//  Created by 美术拍卖 on 2020/12/15.
//  Copyright © 2020 翁磊. All rights reserved.
//  3.1新增一键登录

#import <Foundation/Foundation.h>
#import "PNSBuildModelUtils.h"

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, AMATAuthToolType) {
    AMATAuthToolTypePro = 88, //协议
    AMATAuthToolTypeClose,  //关闭按钮
    AMATAuthToolTypeLoginSuc, //一键登录成功
    AMATAuthToolTypeAuthFail //吊起失败
};

typedef void(^AMATAuthLoginResultBlock)(AMATAuthToolType authToolType, id  _Nullable response);

@interface AMATAuthTool : NSObject

+ (instancetype)sharedATAuthTool;
- (void)setATAuthToolConfig;
- (void)authLoginBtn:(UIViewController *)vc style:(PNSBuildModelStyle)style resultBlock:(AMATAuthLoginResultBlock)resultBlock loginStyleBlock:(AMLoginStyleBtnBlock)loginStyleBlock;
@end

NS_ASSUME_NONNULL_END
