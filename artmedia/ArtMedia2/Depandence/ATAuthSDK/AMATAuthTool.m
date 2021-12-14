//
//  AMATAuthTool.m
//  ArtMedia2
//
//  Created by 美术拍卖 on 2020/12/15.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMATAuthTool.h"
#import "MD5Tool.h"

@interface AMATAuthTool ()

@property (nonatomic, assign) BOOL isCanUseOneKeyLogin;
@property (nonatomic, strong) UIViewController *vc;
@property (nonatomic, strong) AMATAuthLoginResultBlock resultBlock;
@property (nonatomic, strong) AMLoginStyleBtnBlock loginStyleBlock;

@end
@implementation AMATAuthTool

+ (instancetype)sharedATAuthTool
{
    static AMATAuthTool *theme = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        theme = [[AMATAuthTool alloc] init];
    });
    return theme;
}
#pragma mark - Setup
- (void)setATAuthToolConfig
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"IOS" forKey:@"systemName"];
    [ApiUtil postWithParent:nil url:[ApiUtilHeader mobileGetCaseSecret] params:params success:^(NSInteger code, id  _Nullable response) {
        NSString *d = (NSString *)[response objectForKey:@"data"];
        [[TXCommonHandler sharedInstance] setAuthSDKInfo:d
                                                complete:^(NSDictionary * _Nonnull resultDic) {
            [self checkAndPrepareEnv];

        }];

    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {


    }];

}

#pragma mark - Logic
- (void)checkAndPrepareEnv
{
    //开始状态置为YES，默认当前环境可以使用一键登录
    self.isCanUseOneKeyLogin = YES;
    
    __weak typeof(self) weakSelf = self;
    //环境检查，异步返回
    [[TXCommonHandler sharedInstance] checkEnvAvailableWithAuthType:PNSAuthTypeLoginToken
                                                           complete:^(NSDictionary * _Nullable resultDic) {
        NSLog(@"环境检查返回：%@", resultDic);
        weakSelf.isCanUseOneKeyLogin = [PNSCodeSuccess isEqualToString:[resultDic objectForKey:@"resultCode"]];
        
        if (weakSelf.isCanUseOneKeyLogin == YES) {
            [[TXCommonHandler sharedInstance] accelerateLoginPageWithTimeout:3.0 complete:^(NSDictionary * _Nonnull resultDic) {
                NSLog(@"为后面授权页拉起加个速，加速结果：%@", resultDic);
            }];
        } else {
            if (self.resultBlock) {
                self.resultBlock(AMATAuthToolTypeAuthFail,nil);
            }
        }
    }];

}

#pragma mark - Action
- (void)authLoginBtn:(UIViewController *)vc style:(PNSBuildModelStyle)style resultBlock:(AMATAuthLoginResultBlock)resultBlock loginStyleBlock:(AMLoginStyleBtnBlock)loginStyleBlock
{
    self.resultBlock = resultBlock;
    self.vc = vc;
    if (self.isCanUseOneKeyLogin == NO) {
        [self checkAndPrepareEnv];
    }
    TXCustomModel *model = [PNSBuildModelUtils buildModel:loginStyleBlock];
    __weak typeof(self) weakSelf = self;
    [[TXCommonHandler sharedInstance] getLoginTokenWithTimeout:3.0
                                                    controller:vc
                                                         model:model
                                                      complete:^(NSDictionary * _Nonnull resultDic) {
        NSString *resultCode = [resultDic objectForKey:@"resultCode"];
        if ([PNSCodeLoginControllerPresentSuccess isEqualToString:resultCode]) {
            NSLog(@"授权页拉起成功回调：%@", resultDic);
        } else if ([PNSCodeLoginControllerClickChangeBtn isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickLoginBtn isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickCheckBoxBtn isEqualToString:resultCode]) {
            NSLog(@"页面点击事件回调：%@", resultDic);
        } else if ([PNSCodeLoginControllerClickProtocol isEqualToString:resultCode]) {
            NSLog(@"协议回调：%@", resultDic);
            
        } else if ([PNSCodeLoginControllerClickCancel isEqualToString:resultCode]) {
            //关闭授权页
            if (weakSelf.resultBlock) {
                weakSelf.resultBlock(AMATAuthToolTypeClose,nil);
            }
            [weakSelf close];
            
        } else if ([PNSCodeSuccess isEqualToString:resultCode]) {
            NSLog(@"获取LoginToken成功回调：%@", resultDic);
            NSString *token = [resultDic objectForKey:@"token"];
//                NSLog(@"接下来可以拿着Token去服务端换取手机号，有了手机号就可以登录，SDK提供服务到此结束，%@",token);
            [weakSelf mobilePhoneNumber:token];

        } else {
            NSLog(@"获取LoginToken或拉起授权页失败回调：%@", resultDic);
            if (weakSelf.resultBlock) {
                weakSelf.resultBlock(AMATAuthToolTypeAuthFail,nil);
            }
        }
    }];

}

#pragma mark - Setup
- (void)mobilePhoneNumber:(NSString *)token
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"accessToken"];
    [ApiUtil postWithParent:self.vc url:[ApiUtilHeader mobilePhoneNumber] params:params success:^(NSInteger code, id  _Nullable response) {
        NSString *mobile = (NSString *)[response objectForKey:@"data"];
        [self userMobileLoginOrRegister:mobile];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        
    }];

}

- (void)userMobileLoginOrRegister:(NSString *)mobile
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:mobile forKey:@"mobile"];
    [params setObject:[TimeTool getCurrentTimestamp] forKey:@"timespan"];
    [params setObject:[MD5Tool signMd5:[TimeTool getCurrentTimestamp]] forKey:@"sign"];
    
    @weakify(self);
    [ApiUtil postWithParent:self.vc url:[ApiUtilHeader userMobileLoginOrRegister] params:params success:^(NSInteger code, id  _Nullable response) {

        @strongify(self);
        if (self.resultBlock) {
            self.resultBlock(AMATAuthToolTypeLoginSuc,response);
        }
        [self close];

    } fail:nil];
}

- (void)close
{
    [self.vc dismissViewControllerAnimated:YES completion:nil];
    [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];

}
@end
