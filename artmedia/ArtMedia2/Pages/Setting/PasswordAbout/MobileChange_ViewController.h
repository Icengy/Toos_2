//
//  MobileChange_ViewController.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/22.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MobileChange_ViewController : BaseViewController

@property (nonatomic ,assign) NSInteger type;//0：新绑手机号 1、更换绑定手机号

@property (nonatomic ,copy) void (^afterBindPhoneBlock) (NSInteger wayType, NSString *phone);

@end

NS_ASSUME_NONNULL_END
