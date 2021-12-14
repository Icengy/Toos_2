//
//  AMMobilePwdLoginController.h
//  ArtMedia2
//
//  Created by 美术拍卖 on 2020/12/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AMMobilePwdLoginController : BaseViewController

@property(nonatomic,strong) void(^loginBlock)(id data);

@property (nonatomic ,strong, nullable) Class jumpClass;
@property (nonatomic ,strong) NSArray <__kindof UIViewController *>*viewControllers;

@property(nonatomic,assign)int type;//0:账号密码  1:验证码  3:绑定

@end

NS_ASSUME_NONNULL_END
