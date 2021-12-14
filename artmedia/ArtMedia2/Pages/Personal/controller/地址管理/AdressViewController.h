//
//  AdressViewController.h
//  ArtMedia
//
//  Created by 美术传媒 on 2018/10/27.
//  Copyright © 2018 lcy. All rights reserved.
//

#import "BaseViewController.h"
#import "MyAddressModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AdressViewController : BaseViewController

/// 0、普通地址 1、发货地址 2、退货地址
@property (nonatomic ,assign) NSInteger style;

@property (nonatomic, strong) void(^chooseAdress)(MyAddressModel *adressModel);
@property (nonatomic, strong) void(^backBlock)(void);

@end

NS_ASSUME_NONNULL_END
