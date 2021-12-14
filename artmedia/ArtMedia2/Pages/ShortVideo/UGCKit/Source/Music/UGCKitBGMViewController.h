//
//  UGCKitBGMViewController.h
//  UGCKit
//
//  Created by icnengy on 2020/8/3.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGCKitTheme.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UGCKitBGMControllerListener <NSObject>
-(void) onBGMControllerPlay:(NSObject *_Nullable) path;
@end

@interface UGCKitBGMViewController : UIViewController

@property (nonatomic ,copy) NSString *selectedBGMPath;

- (instancetype)initWithTheme:(UGCKitTheme*)theme;
- (void)setBGMControllerListener:(id<UGCKitBGMControllerListener>) listener;
//- (void)loadBGMList;
//- (void)clearSelectStatus;

@end

NS_ASSUME_NONNULL_END
