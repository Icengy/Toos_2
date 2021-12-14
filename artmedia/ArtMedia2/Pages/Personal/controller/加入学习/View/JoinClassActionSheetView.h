//
//  JoinClassActionSheetView.h
//  ArtMedia2
//
//  Created by LY on 2020/10/22.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMCourseModel.h"
#import "ECoinModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JoinClassActionSheetView : UIView
@property (nonatomic , strong) AMCourseModel *model;
@property (nonatomic , strong) ECoinModel *ecoinModel;
+ (instancetype)shareInstance;
- (void)show;
- (void)hide;
@property (nonatomic , copy) void(^joinClassBlock)(void);
@end

NS_ASSUME_NONNULL_END
