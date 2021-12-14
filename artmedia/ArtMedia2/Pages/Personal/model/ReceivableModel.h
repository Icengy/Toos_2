//
//  ReceivableModel.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/13.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReceivableModel : NSObject

///是否选中
@property(nonatomic ,assign) BOOL isSelected;

///account_type 帐户类型：1微信帐户，2银行账户 ,3经纪人账户
@property(nonatomic ,copy) NSString *account_type;
///添加时间
@property(nonatomic ,copy) NSString *addtime;
///银行名
@property(nonatomic ,copy) NSString *bank_name;
/// 银行ID
@property(nonatomic ,copy) NSString *bank_id;
/// 银行logo
@property(nonatomic ,copy) NSString *bank_img;
///银行账号
@property(nonatomic ,copy) NSString *account_number;
///持卡人
@property(nonatomic ,copy) NSString *account_user_name;

@property(nonatomic ,copy) NSString *id;

@property(nonatomic ,assign) BOOL is_default;

@property(nonatomic ,copy) NSString *uid;

@end

NS_ASSUME_NONNULL_END
