//
//  IdentityInputViewController.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/28.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface IdentityInputViewController : BaseViewController

@property (nonatomic ,copy) void(^ identifyNextBlock)(NSDictionary *_Nullable resultDict);

@property (nonatomic ,copy) void(^ bizTokenBlock)(NSString *_Nullable bizToken);

@property (assign , nonatomic) BOOL isFromAuth;

@end

NS_ASSUME_NONNULL_END
