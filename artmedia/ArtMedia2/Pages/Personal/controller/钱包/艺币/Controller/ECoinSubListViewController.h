//
//  ECoinSubListViewController.h
//  ArtMedia2
//
//  Created by 刘洋 on 2020/10/19.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, ECoinListRecordType) {
    ECoinListRecordTypeAll = 0,//全部
    ECoinListRecordTypeConsumption,//消费
    ECoinListRecordTypeRecharge //充值
};
@interface ECoinSubListViewController : BaseViewController
@property (nonatomic , assign) ECoinListRecordType type;
@end

NS_ASSUME_NONNULL_END
