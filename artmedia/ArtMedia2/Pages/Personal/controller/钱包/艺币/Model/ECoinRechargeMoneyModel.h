//
//  ECoinRechargeMoneyModel.h
//  ArtMedia2
//
//  Created by 刘洋 on 2020/10/19.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ECoinRechargeMoneyModel : NSObject
@property (nonatomic , assign ,getter = isSelect) BOOL select;
@property (nonatomic , copy) NSString *moneyShow;
@property (nonatomic , copy) NSString *moneyValue;
@property (nonatomic , copy) NSString *inAppPerchaseID;
@end

NS_ASSUME_NONNULL_END
