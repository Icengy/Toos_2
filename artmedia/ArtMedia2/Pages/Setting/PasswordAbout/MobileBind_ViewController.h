//
//  MobileBind_ViewController.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/22.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MobileBind_ViewController : BaseViewController

///0：首次绑定 1：更换绑定手机号
@property(nonatomic ,assign) NSInteger bindType;

@end

NS_ASSUME_NONNULL_END
