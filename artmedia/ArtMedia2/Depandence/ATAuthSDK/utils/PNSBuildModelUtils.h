//
//  PNSBuildModelUtils.h
//  ATAuthSceneDemo
//
//  Created by 刘超的MacBook on 2020/8/6.
//  Copyright © 2020 刘超的MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ATAuthSDK/ATAuthSDK.h>
#import "AMLoginStyleView.h"


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PNSBuildModelStyle) {
    //全屏
    PNSBuildModelStylePortrait,
    PNSBuildModelStyleLandscape,
    PNSBuildModelStyleAutorotate,
    
    //弹窗
    PNSBuildModelStyleAlertPortrait,
    PNSBuildModelStyleAlertLandscape,
    PNSBuildModelStyleAlertAutorotate,
    
    //底部弹窗
    PNSBuildModelStyleSheetPortrait,
};

@interface PNSBuildModelUtils : NSObject

+ (TXCustomModel *)buildModel:(AMLoginStyleBtnBlock)loginStyleBlock;

@end

NS_ASSUME_NONNULL_END
