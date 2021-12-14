//
//  ApplyRefundViewController.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/12.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "BaseViewController.h"

@class MyOrderModel;
NS_ASSUME_NONNULL_BEGIN

@interface ApplyRefundViewController : BaseViewController

@property (nonatomic ,strong)MyOrderModel *orderModel;
///0:申请退货 1:拒绝原因
@property (nonatomic ,assign) NSInteger type;
///
@property(nonatomic,copy) void(^ bottomClick1Block)(void);

@property (nonatomic ,copy) void(^ bottomClick2Block)(NSString *_Nullable textStr);

@end

NS_ASSUME_NONNULL_END
