//
//  AppDelegate.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/8/14.
//  Copyright © 2019 lcy. All rights reserved.
//

#import "AppDelegate.h"

#import "StartupPageViewController.h"
//#import "MainTabBarController.h"

#import <WXApi.h>
//#import "IQKeyboardManager.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <AlipaySDK/AlipaySDK.h>
#import <GTSDK/GeTuiSdk.h>
#import <UserNotifications/UserNotifications.h>
#import "XHLaunchAd.h"
#import "ApiUtil.h"

#import <UMCommon/UMCommon.h>

#import <ImSDK/ImSDK.h>

#import "GenerateTestUserSig.h"

@import TXLiteAVSDK_Professional;

@interface AppDelegate ()<UIApplicationDelegate, WXApiDelegate, GeTuiSdkDelegate, UNUserNotificationCenterDelegate, V2TIMSDKListener>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"%f %f",K_Width , K_Height);
    //友盟统计
    [UMConfigure initWithAppkey:UMengAppKey channel:@"App Store"];
    
    // Override point for customization after application launch.
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    ///取消约束警告
    [AMUserDefaults setValue:@(false) forKey:@"_UIConstraintBasedLayoutLogUnsatisfiable"];
    if (!AMUserDefaultsObjectForKey(AMUserMsg)) {
        AMUserDefaultsSetObject(@{}, AMUserMsg);
    }
    
    [AMUserDefaults setBool:NO forKey:AMPhoneUpdatesDefaults];
//    [AMUserDefaults setBool:YES forKey:isFirstLaunchDefaults];
	AMUserDefaultsSynchronize;
    
    
    ///微信相关
    [WXApi registerApp:AMWeChatAppID universalLink:@"https://api.mscmchina.com"];
    
    ///短视频相关
    [TXUGCBase setLicenceURL:AMLicenceURL key:AMLicenceKey];
    [TXLiveBase setLicenceURL:AMTXLiveLicenceURL key:AMLicenceKey];
    
    
    [ApiUtil getWithParent:self url:[ApiUtilHeader selectImConf] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response) {
        if (response) {
            AMUserDefaultsSetObject(response[@"data"][@"sdkAppId"], @"sdkAppId");
            AMUserDefaultsSetObject(response[@"data"][@"sdkAppKey"], @"sdkAppKey");
            AMUserDefaultsSynchronize;
            NSLog(@"%@    %@",AMUserDefaultsObjectForKey(@"sdkAppId"),AMUserDefaultsObjectForKey(@"sdkAppKey"));
        }
        V2TIMSDKConfig *config = [[V2TIMSDKConfig alloc] init];
        if ([[V2TIMManager sharedInstance] initSDK:AM_SDKAppID config:config listener:self]) {
            NSLog(@"-----------------消息初始化成功");
        }else{
            NSLog(@"-----------------消息初始化失败");
        }
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        
    }];
    [ApiUtil postWithParent:self url:[ApiUtilHeader get_app_application] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response) {
        if (response) {
            NSLog(@"%@",response);
            NSString *string = [NSString stringWithFormat:@"%@",response[@"data"][@"is_include_auction"]];
            AMUserDefaultsSetObject(string, @"is_include_auc");
            AMUserDefaultsSynchronize;
            NSLog(@"%@",AMUserDefaultsObjectForKey(@"is_include_auc"));
        }
    } fail:nil];
    
    
    [TXLiveBase setLogLevel:LOGLEVEL_NULL];

    NSLog(@"SDK Version = %@", [TXLiveBase getSDKVersionStr]);
    
    ///推送相关
    [self registerRemoteNotification];
    [GeTuiSdk startSdkWithAppId:GTAppId appKey:GTAppKey appSecret:GTAppSecret delegate:self];
    [GeTuiSdk runBackgroundEnable:YES];


    //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
    [XHLaunchAd setLaunchSourceType:SourceTypeLaunchScreen];
    
    //配置广告数据
    XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration new];
    //广告停留时间
    imageAdconfiguration.duration = 1;
    //广告frame
    imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
    //注意本地广告图片,直接放在工程目录,不要放在Assets里面,否则不识别,此处涉及到内存优化
    imageAdconfiguration.imageNameOrURLString = @"open_image2.png";
    //图片填充模式
    imageAdconfiguration.contentMode = UIViewContentModeScaleAspectFill;
    //广告显示完成动画
    imageAdconfiguration.showFinishAnimate = ShowFinishAnimateFadein;
    //广告显示完成动画时间
    imageAdconfiguration.showFinishAnimateTime = 0.8;
    //跳过按钮类型
    imageAdconfiguration.skipButtonType = SkipTypeNone;
    //后台返回时,是否显示广告
    imageAdconfiguration.showEnterForeground = NO;
    //显示开屏广告
    [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
    
    
    [self ddddd];
    ///
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = Color_Whiter;
    self.window.rootViewController = [[StartupPageViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    [[AMATAuthTool sharedATAuthTool]setATAuthToolConfig];
    
    return YES;
}

- (void)onKickedOffline{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IMOffline" object:nil];
}


/// 在线时票据过期：此时您需要生成新的 userSig 并再次调用 V2TIMManager 的 login() 函数重新登录。
- (void)onUserSigExpired{
    if ([UserInfoManager shareManager].isLogin) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"timeout"] = @"1000";
        dic[@"userId"] = [UserInfoManager shareManager].uid;
        [ApiUtil postWithParent:self url:[ApiUtilHeader sigApi] needHUD:NO params:dic success:^(NSInteger code, id  _Nullable response) {
            if (response) {
                [[V2TIMManager sharedInstance] login:[UserInfoManager shareManager].uid userSig:response[@"data"][@"sig"] succ:^{
                    
                } fail:^(int code, NSString *msg) {
                   
                }];
            }
        } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
            
        }];
    }
 
}


- (void)ddddd{
    NSString * deviceID =[UMConfigure deviceIDForIntegration];
    NSLog(@"集成测试的deviceID:%@", deviceID);


}

#pragma mark - 用户通知(推送) _ 自定义方法

/**
 * [ 参考代码，开发者注意根据实际需求自行修改 ] 注册远程通知
 *
 * 警告：Xcode8及以上版本需要手动开启“TARGETS -> Capabilities -> Push Notifications”
 * 警告：该方法需要开发者自定义，以下代码根据APP支持的iOS系统不同，代码可以对应修改。以下为参考代码
 * 注意根据实际需要修改，注意测试支持的iOS系统都能获取到DeviceToken
 *
 */
- (void)registerRemoteNotification {
    float iOSVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (iOSVersion >= 10.0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error && granted) {
                NSLog(@"[ TestDemo ] iOS request authorization succeeded!");
            }
        }];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskAll;
}
#pragma mark -
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [ApiUtil postWithParent:application.keyWindow url:[ApiUtilHeader getVersion] needHUD:NO params:@{@"type" : @"2"} success:^(NSInteger code, id  _Nullable response) {
        NSDictionary *versionDic = (NSDictionary *)response[@"data"];
        /// app实际版本
        NSString *app_build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        /// 服务器最小兼容版本
        NSString *server_compatible_build = [ToolUtil isEqualToNonNull:[versionDic objectForKey:@"compatible_version_code"] replace:@"0"];
        /// 服务器中app当前版本
        NSString *server_now_build = [ToolUtil isEqualToNonNull:[versionDic objectForKey:@"now_version_code"] replace:@"0"];
        if (app_build.integerValue < server_compatible_build.integerValue) {
            AMAlertView *alert = [AMAlertView shareInstanceWithTitle:@"版本更新提示!" message:[ToolUtil isEqualToNonNullKong:versionDic[@"value2"]] buttonArray:@[@"前往更新"] alertType:AMAlertTypeNonDissmiss confirm:^{
                NSString *urlStr = @"itms-apps://itunes.apple.com/cn/app/id1488278437?mt=8";
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
            } cancel:nil];
            [alert show];
        }else if (app_build.integerValue < server_now_build.integerValue) {
            if (![[AMUserDefaults objectForKey:AMPhoneUpdatesDefaults] boolValue]) {
                AMAlertView *alert = [AMAlertView shareInstanceWithTitle:@"版本更新提示!" message:[ToolUtil isEqualToNonNullKong:[versionDic objectForKey:@"value2"]] buttonArray:@[@"前往更新"] alertType:AMAlertTypeNormal confirm:^{
                    [AMUserDefaults setBool:YES forKey:AMPhoneUpdatesDefaults];
                    [AMUserDefaults synchronize];
                    NSString *urlStr = @"itms-apps://itunes.apple.com/cn/app/id1488278437?mt=8";
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
                } cancel:nil];
                [alert show];
            }

        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"IAPShowHUD" object:nil];
        
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
    }];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -
/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // 向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceTokenData:deviceToken];
}

/// [ 系统回调 ] iOS 10及以上  APNs通知将要显示时触发
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    //completionHandler(UNNotificationPresentationOptionNone); 若不显示通知，则无法点击通知
    NSLog(@"willPresentNotification = %@",notification.request.content);
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

/// [ 系统回调 ] iOS 10及以上 收到APNs推送并点击时触发
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSLog(@"didReceiveNotificationResponse = %@",response.notification.request.content.userInfo);
    [self handleRemoteNotificationUserInfo:response.notification.request.content.userInfo];
    
    // [ GTSDK ]：将收到的APNs信息同步给个推统计
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    completionHandler();
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    NSLog(@"didReceiveRemoteNotification = %@",userInfo);
    
    [self handleRemoteNotificationUserInfo:userInfo];
    // [ GTSDK ]：将收到的APNs信息同步给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)handleRemoteNotificationUserInfo:(NSDictionary *)userInfo {
    if (userInfo) {
        NSLog(@"handleRemoteNotificationUserInfo = %@",userInfo);
    }
}

#pragma mark - GeTuiSdkDelegate
/// [ GTSDK回调 ] SDK启动成功返回cid
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    NSLog(@"[ TestDemo ] [GTSdk RegisterClient]:%@", clientId);
    AMUserDefaultsSetObject(clientId, @"AMDeviceToken");
    AMUserDefaultsSynchronize;
    
    if ([UserInfoManager shareManager].isLogin) {
        NSMutableDictionary *params = [NSMutableDictionary new];
        params[@"uid"] = [UserInfoManager shareManager].uid;
        params[@"clientid"] = clientId;
        params[@"device_type"] = @"2";
        
        [ApiUtil postWithParent:nil url:[ApiUtilHeader editUserInfo] needHUD:NO params:params.copy success:^(NSInteger code, id  _Nullable response) {} fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {}];
    }
}

/// [ GTSDK回调 ] SDK收到透传消息回调
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    // [ GTSDK ]：汇报个推自定义事件(反馈透传消息)
    [GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];

    NSString *payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    NSString *msg = [NSString stringWithFormat:@"Receive Payload: %@, taskId: %@, messageId: %@ %@", payloadMsg, taskId, msgId, offLine ? @"<离线消息>" : @""];
    NSLog(@"[ TestDemo ] [GTSdk ReceivePayload]:%@", msg);
    
    NSDictionary *message = [NSJSONSerialization JSONObjectWithData:payloadData options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"GeTuiSdkDidReceivePayloadData = %@ -- %@", payloadData,message);
    if (!message.allKeys.count) return;
    // 创建推送弹框
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title =  [ToolUtil isEqualToNonNullKong:message[@"title"]];
    content.body = [ToolUtil isEqualToNonNullKong:message[@"body"]];
    content.sound = [UNNotificationSound defaultSound];
    content.badge = [NSNumber numberWithInteger:[[ToolUtil isEqualToNonNull:message[@"badge"] replace:@"0"] integerValue]];
    content.userInfo = message;
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1.0f repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:taskId content:content trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];
}

/// [ GTSDK回调 ] SDK运行状态通知
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    NSLog(@"GeTuiSDkDidNotifySdkState = %@",@(aStatus));
}

- (void)GeTuiSdkDidOccurError:(NSError *)error {
    NSLog(@" [GeTuiSdk GeTuiSdkDidOccurError]:%@\n\n",error.localizedDescription);
}

- (void)GeTuiSdkDidSetTagsAction:(NSString *)sequenceNum result:(BOOL)isSuccess error:(NSError *)aError {
    /*
     参数说明
     sequenceNum: 请求的序列码
     isSuccess: 操作成功 YES, 操作失败 NO
     aError.code:
     20001：tag 数量过大（单次设置的 tag 数量不超过 100)
     20002：调用次数超限（默认一天只能成功设置一次）
     20003：标签重复
     20004：服务初始化失败
     20005：setTag 异常
     20006：tag 为空
     20007：sn 为空
     20008：离线，还未登陆成功
     20009：该 appid 已经在黑名单列表（请联系技术支持处理）
     20010：已存 tag 数目超限
     20011：tag 内容格式不正确
     */
    NSLog(@"GeTuiSdkDidSetTagAction sequenceNum:%@ isSuccess:%@ error: %@", sequenceNum, @(isSuccess), aError);
}

#pragma mark -
- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([url.host isEqualToString:@"safepay"]) {//NOTE: 9.0以后使用新API接口
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            if ([resultDic[@"resultStatus"] integerValue] == 9000) {
                [[NSNotificationCenter defaultCenter] postNotificationName:AliPaymentResultForNormal object:@(0)];
//                [SVProgressHUD showSuccess:@"支付成功！"];
            } else if([resultDic[@"resultStatus"] integerValue] == 6001) {
                [[NSNotificationCenter defaultCenter] postNotificationName:AliPaymentResultForNormal object:@(1)];
//                [SVProgressHUD showMsg:@"已取消支付"];
            } else{
                [[NSNotificationCenter defaultCenter] postNotificationName:AliPaymentResultForNormal object:@(-1)];
//                [SVProgressHUD showError:@"支付失败,请重试"];
            }
        }];
    }else {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler  {
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        NSURL *webpageURL = userActivity.webpageURL;
        NSLog(@"continueUserActivity restorationHandler = %@",webpageURL.absoluteString);
        if ([webpageURL.absoluteString containsString:AMWeChatAppID]) {///微信跳转
            return [WXApi handleOpenUniversalLink:userActivity delegate:self];;
        }else if ([webpageURL.absoluteString containsString:@"getui"]) {
            // [ GTSDK ]：处理个推APPLink回执统计
            // APPLink url 示例：https://link.gl.ink/getui?n=payload&p=mid， 其中 n=payload 字段存储用户透传信息，可以根据透传内容进行业务操作。
            NSString *payload = [GeTuiSdk handleApplinkFeedback:webpageURL];
            if (payload) {
                NSLog(@"[ TestDemo ] 个推APPLink中携带的用户payload信息: %@,URL : %@", payload, webpageURL);
                // TODO: 用户可根据具体 payload 进行业务处理
            }
        }
    }
    return YES;
}

- (void)scene:(UIScene *)scene continueUserActivity:(NSUserActivity *)userActivity  API_AVAILABLE(ios(13.0)) {
    NSURL *webpageURL = userActivity.webpageURL;
    NSLog(@"continueUserActivity = %@",webpageURL.absoluteString);
    if ([webpageURL.absoluteString containsString:AMWeChatAppID]) {///微信跳转
        [WXApi handleOpenUniversalLink:userActivity delegate:self];
    }else if ([webpageURL.absoluteString containsString:@"getui"]) {
        // [ GTSDK ]：处理个推APPLink回执统计
        // APPLink url 示例：https://link.gl.ink/getui?n=payload&p=mid， 其中 n=payload 字段存储用户透传信息，可以根据透传内容进行业务操作。
        NSString *payload = [GeTuiSdk handleApplinkFeedback:webpageURL];
        if (payload) {
            NSLog(@"[ TestDemo ] 个推APPLink中携带的用户payload信息: %@,URL : %@", payload, webpageURL);
            // TODO: 用户可根据具体 payload 进行业务处理
        }
    }
}

-(void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass: [PayResp class]]){
        PayResp *response=(PayResp*)resp;
        switch(response.errCode) {
            case WXSuccess: {
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                [[NSNotificationCenter defaultCenter] postNotificationName:WXPaymentResultForNormal object:@(YES)];
                [[NSNotificationCenter defaultCenter] postNotificationName:WXPaymentResultForOrderList object:@(YES)];
                [[NSNotificationCenter defaultCenter] postNotificationName:WXPaymentResultForOrderDetail object:@(YES)];
                break;
            }
            default: {
                [[NSNotificationCenter defaultCenter] postNotificationName:WXPaymentResultForNormal object:@(NO)];
                [[NSNotificationCenter defaultCenter] postNotificationName:WXPaymentResultForOrderList object:@(NO)];
                [[NSNotificationCenter defaultCenter] postNotificationName:WXPaymentResultForOrderDetail object:@(NO)];
                break;
            }
        }
    }else if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *temp = (SendAuthResp *)resp;
        switch (temp.errCode) {
            case 0: {
                [SVProgressHUD showSuccess:@"授权成功" completion:^{
                    [self getWXInfoWith:temp];
                }];
                break;
            }
            default: {
                [SVProgressHUD showError:@"授权失败"];
                break;
            }
        }
    }else if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        SendMessageToWXResp *req = (SendMessageToWXResp *)resp;
        if (req.errCode == 0) {
            NSLog(@"分享成功/分享取消");
            [[NSNotificationCenter defaultCenter] postNotificationName:WXShareResult object:@{@"isFinish":@(YES), @"errorStr":@""}];
        }else {
            NSLog(@"分享失败");
            [[NSNotificationCenter defaultCenter] postNotificationName:WXShareResult object:@{@"isFinish":@(NO), @"errorStr":req.errStr}];
        }
    }
}

- (void)getWXInfoWith:(SendAuthResp *)resp {
    NSString *accessUrlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",AMWeChatAppID, AMWeChatAppSecret, resp.code];
    [ApiUtil get:accessUrlStr params:nil success:^(id  _Nullable response) {
        if (response) {
            NSDictionary *accessDict = [NSDictionary dictionaryWithDictionary:response];
            [self getWechatUserInfoWithDic:accessDict];
        }else {
            [SVProgressHUD showError:@"拉取微信授权信息失败，请重试"];
        }
    } fail:nil];
}

//获取用户微信信息
- (void)getWechatUserInfoWithDic:(NSDictionary*)dic {
    NSString*urlStr=[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",dic[@"access_token"],dic[@"openid"]];
    [ApiUtil get:urlStr params:nil success:^(id  _Nullable response) {
        if (response) {
            NSDictionary *userinfo = (NSDictionary *)response;
            [[NSNotificationCenter defaultCenter] postNotificationName:WXAuthResult object:nil userInfo:userinfo];
        }else {
            [SVProgressHUD showError:@"获取用户微信信息失败，请重试"];
        }
    } fail:nil];
}

@end


#pragma mark -


//#warning Configuring rotation control. 请配置旋转控制!


@implementation UIViewController (RotationControl)
///
/// 控制器是否可以旋转
///
- (BOOL)shouldAutorotate {
    // iPhone的demo用到了播放器的旋转, 这里返回NO, 除播放器外, 项目中的其他视图控制器都禁止旋转
    if ( UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM() ) {
        return NO;
    }
    
    // iPad的demo未用到播放器的旋转, 这里返回YES, 允许所有控制器旋转
    else if ( UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM() ) {
        return YES;
    }
    
    // 如果你的项目仅支持竖屏, 可以直接返回NO, 无需进行上述的判断区分.
    return NO;
}

///
/// 控制器旋转支持的方向
///
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    // 此处为设置 iPhone demo 仅支持竖屏的方向
    if ( UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM() ) {
        return UIInterfaceOrientationMaskPortrait;
    }
    
    // 此处为设置 iPad demo 仅支持横屏的方向
    else if ( UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM() ) {
        return UIInterfaceOrientationMaskLandscape;
    }
    
    // 如果你的项目仅支持竖屏, 可以直接返回UIInterfaceOrientationMaskPortrait, 无需进行上述的判断区分.
    return UIInterfaceOrientationMaskPortrait;
}

@end


@implementation UITabBarController (RotationControl)
- (UIViewController *)sj_topViewController {
    if ( self.selectedIndex == NSNotFound )
        return self.viewControllers.firstObject;
    return self.selectedViewController;
}

- (BOOL)shouldAutorotate {
    return [[self sj_topViewController] shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [[self sj_topViewController] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self sj_topViewController] preferredInterfaceOrientationForPresentation];
}
@end


@implementation UINavigationController (RotationControl)
- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}

- (nullable UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (nullable UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}
@end

