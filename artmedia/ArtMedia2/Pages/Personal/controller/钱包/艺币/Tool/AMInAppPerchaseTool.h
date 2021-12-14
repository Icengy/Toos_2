//
//  AMInAppPerchaseTool.h
//  ArtMedia2
//
//  Created by LY on 2020/10/27.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger , IAPPurchType) {
    kIAPPurchSuccess = 0,       // 购买成功
    kIAPPurchFailed = 1,        // 购买失败
    kIAPPurchCancle = 2,        // 取消购买
    KIAPPurchVerFailed = 3,     // 订单校验失败
    KIAPPurchVerSuccess = 4,    // 订单校验成功
    kIAPPurchNotArrow = 5,      // 不允许内购
};
//@protocol AMInAppPerchaseToolDelegate <NSObject>
//@optional
//- (void)payResult:(NSDictionary *)response;
//@end

typedef void (^IAPCompletionHandle)(IAPPurchType type,NSData *data ,NSDictionary *response);
@interface AMInAppPerchaseTool : NSObject
- (void)startPurchWithID:(NSString *)purchID completeHandle:(IAPCompletionHandle)handle;
//@property (nonatomic , weak) id <AMInAppPerchaseToolDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
