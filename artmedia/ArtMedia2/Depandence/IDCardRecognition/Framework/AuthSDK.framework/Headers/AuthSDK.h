//
//  AuthSDK.h
//  AuthSDK
//
//  Created by jardgechen on 16/8/31.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ValidatorTool.h"
extern NSString *const OcrOnlyNotification;
typedef void(^HttpRequestSuccessBlock)(id responseObject);
typedef void(^HttpRequestFailBlock)(NSError *error);

@protocol AuthSDKDelegate <NSObject>

/**
 回调函数

 @param result 返回的结果
 */
-(void)onResultBack:(NSDictionary *)result;

@end

@interface AuthSDK : NSObject


/**
 初始化服务器URL

 @param serverURL 服务器URL，为nil时 默认为测试服务器地址
 @return 构造函数
 */
- (instancetype)initWithServerURL:(NSString *)serverURL;


-(NSString *)getSDKVersion;


/**
 开始流程

 @param sceneID 业务场景
 @param name 身份证名字, 不需要时可传入nil
 @param idNum 身份号, 不需要时可传入nil
 @param token 需要传入的token, 不需要时可传入nil
 @param vc 父controller
 @param delegate 需要实现回调的Controller
 @param isSecondVerify 是否是二次验证
 */
-(void)startAuthWithToken:(NSString *)token parent:(UIViewController *)vc delegate:(id<AuthSDKDelegate>)delegate;


@end

