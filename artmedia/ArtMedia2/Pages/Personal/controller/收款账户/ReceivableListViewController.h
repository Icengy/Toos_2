//
//  ReceivableListViewController.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/21.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReceivableListViewController : BaseViewController

///0：收款账户  1：申请提现（销售提现）2：申请提现（收益提现)
@property (nonatomic ,assign) NSInteger receiveType;
///仅当receiveType>时有值 可提现的最大值
@property(nonatomic ,copy) NSString *cashoutCount;

@property(nonatomic,copy) void(^bottomClickBlock)(void);

@end

NS_ASSUME_NONNULL_END
