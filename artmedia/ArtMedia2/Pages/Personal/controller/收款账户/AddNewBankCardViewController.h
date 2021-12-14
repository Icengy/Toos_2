//
//  AddNewBankCardViewController.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/21.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddNewBankCardViewController : BaseViewController

/// account_type 帐户类型：2银行账户 ,3经纪人账户
@property (nonatomic ,assign) NSInteger accountType;

@end

NS_ASSUME_NONNULL_END
