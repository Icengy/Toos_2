//
//  UGCKitWrapper.h
//  XiaoShiPin
//
//  Created by cui on 2019/11/27.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UGCKit/UGCKit.h>
#import "TXUGCPublish.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TCBackMode) {
    TCBackModePop,
    TCBackModeDismiss
};

@class UGCKitWrapper;
@protocol UGCKitWrapperDelegate <NSObject>

/// 前往视频发布编辑页面(自定义)
- (void)wrapper:(UGCKitWrapper *)wrapper onPublishWith:(AMVideoEditer *)videoEdit;
@optional
/// 视频上传成功
- (void)wrapper:(UGCKitWrapper *)wrapper onPublishComplete:(TXPublishResult*)result;
@end

@interface UGCKitWrapper : NSObject

@property (nonatomic ,weak) id <UGCKitWrapperDelegate> delegate;

- (instancetype)initWithViewController:(UIViewController *)viewController theme:(nullable UGCKitTheme *)theme;
- (void)showRecordViewControllerWithConfig:(UGCKitRecordConfig *)config;
- (void)showEditViewController:(UGCKitResult *)result
                      rotation:(TCEditRotation)rotation
        inNavigationController:(UINavigationController *)nav
                      backMode:(TCBackMode)backMode;

@end

NS_ASSUME_NONNULL_END
