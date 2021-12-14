//
//  PasswordChange_ViewController.h
//  ArtMedia
//
//  Created by 美术传媒 on 2018/11/16.
//  Copyright © 2018 lcy. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PasswordChange_ViewController : BaseViewController

///0、修改密码/首次设置密码 ,1、重置密码
@property (nonatomic ,assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
