//
//  ECoinModel.h
//  ArtMedia2
//
//  Created by LY on 2020/10/26.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ECoinModel : NSObject
@property (nonatomic , copy) NSString *ecoinID;// 用户钱包主键id
@property (nonatomic , copy) NSString *ID;// 用户id
@property (nonatomic , copy) NSString *nowAccountmoney;// 当前账户余额
@property (nonatomic , copy) NSString *nowVirtualMoney;// 当期虚拟币账户余额
@property (nonatomic , copy) NSString *historyAllVirtualMoney;// 历史总虚拟货币
@end

NS_ASSUME_NONNULL_END
