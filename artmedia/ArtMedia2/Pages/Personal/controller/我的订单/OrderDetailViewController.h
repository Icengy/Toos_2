//
//  OrderDetailViewController.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/8.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderDetailViewController : BaseViewController

/**
 订单类型
 */
@property (nonatomic, assign) MyOrderWayType wayType;

@property (nonatomic ,copy) NSString *orderID;

@end

NS_ASSUME_NONNULL_END
