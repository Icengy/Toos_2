//
//  NotificationService.m
//  NotificationService
//
//  Created by icnengy on 2020/5/26.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "NotificationService.h"
#import <GTExtensionSDK/GeTuiExtSdk.h>

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Modify the notification content here...
//    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
    [GeTuiExtSdk handelNotificationServiceRequest:request withAttachmentsComplete:^(NSArray *attachments, NSArray *errors) {
        // [ 测试代码 ] TODO：日志打印，如果APNs处理有错误，可以在这里查看相关错误详情
        //NSLog(@"处理个推APNs展示遇到错误：%@", errors);
        
        // [ 测试代码 ] TODO：用户可以在这里处理通知样式的修改，eg:修改标题，开发阶段可以用于判断是否运行通知扩展
//        self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [test]", self.bestAttemptContent.title];
        
        self.bestAttemptContent.attachments = attachments;      // 设置通知中的多媒体附件
        self.contentHandler(self.bestAttemptContent);           // 展示推送的回调处理需要放到个推回执完成的回调中
    }];
    
//    self.contentHandler(self.bestAttemptContent);
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    // [ GTSDK ] 销毁SDK，释放资源
    [GeTuiExtSdk destory];
    self.contentHandler(self.bestAttemptContent);
}

@end
