//
//  MyOrderListViewController.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/23.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyOrderListViewController : BaseViewController

/// 订单类型
@property (nonatomic ,assign) MyOrderWayType wayType;

/// 子页面类型 1全部，2待付款，3待发货，4待收货，5已完成，6退货退款
@property(nonatomic,assign) NSInteger itemType;

//-(void)loadData:(id __nullable)sender;

@end

NS_ASSUME_NONNULL_END
