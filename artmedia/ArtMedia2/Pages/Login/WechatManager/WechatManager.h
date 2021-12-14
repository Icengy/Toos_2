//
//  WechatManager.h
//  HM503
//
//  Created by 程明 on 2018/11/8.
//  Copyright © 2018 余浩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WechatManagerDelagate <NSObject>

@required
-(void)wechatPaySuccessful;
-(void)wechatPayFail;

@end

@interface WechatManager : NSObject

@property(nonatomic,weak)id<WechatManagerDelagate>delegate;
@property(nonatomic,copy)NSString*orderID;

+(instancetype)shareManager;


-(void)payOrderWithType:(NSString*)type withOrderID:(NSString*)order_id;

-(void)payOrderWithType:(NSString*)type roleType:(NSString *)roleType;

//查询订单状态
-(void)getStateOfOrderWithResp:(BaseResp *)resp;

@end

NS_ASSUME_NONNULL_END
