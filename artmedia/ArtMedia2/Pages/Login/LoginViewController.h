//
//  LoginViewController.h
//  ArtMedia
//
//  Created by 美术传媒 on 2018/10/23.
//  Copyright © 2018 lcy. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : BaseViewController

@property(nonatomic,strong) void(^loginBlock)(id data);

@property (nonatomic ,strong, nullable) Class jumpClass;
@property (nonatomic ,strong) NSArray <__kindof UIViewController *>*viewControllers;

@property(nonatomic,assign)int type;//0:账号密码  1:验证码  3:绑定

@end

NS_ASSUME_NONNULL_END
