//
//  IDInfoViewController.h
//  IDCardRecognition
//
//  Created by HanJunqiang on 2017/2/21.
//  Copyright © 2017年 HaRi. All rights reserved.
//

#import "BaseViewController.h"

@class IDInfo;

@interface IDInfoViewController : BaseViewController

// 身份证信息
@property (nonatomic,strong) IDInfo *IDInfo;

// 身份证图像
@property (nonatomic,strong) UIImage *IDImage;

@end
