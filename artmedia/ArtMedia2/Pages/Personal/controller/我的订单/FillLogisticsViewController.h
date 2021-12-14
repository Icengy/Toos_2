//
//  FillLogisticsViewController.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/12.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "BaseViewController.h"

@class MyOrderModel;
NS_ASSUME_NONNULL_BEGIN

@interface FillLogisticsViewController : BaseViewController

///0:发货物流 1 退货物流
@property (nonatomic ,assign) NSInteger logType;
///
@property (nonatomic ,strong) MyOrderModel *model;
///
@property(nonatomic,copy) void(^bottomClickBlock)(void);

@end

NS_ASSUME_NONNULL_END
