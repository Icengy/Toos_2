//
//  CustomPersonalViewController.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/15.
//  Copyright © 2019年 lcy. All rights reserved.
//
// 个人首页-他人
//

#import "BaseItemParentViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomPersonalViewController : BaseItemParentViewController

+ (CustomPersonalViewController *)shareInstance;
/// 用户ID
@property (nonatomic ,copy) NSString *artuid;

@end

NS_ASSUME_NONNULL_END
