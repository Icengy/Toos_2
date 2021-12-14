//
//  AMMeetingSettingCView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/8/18.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMMeetingSettingCView;
NS_ASSUME_NONNULL_BEGIN
@protocol AMMeetingSettingCViewDelegate <NSObject>

@required
- (void)settingCCell:(AMMeetingSettingCView *)cell didLoadItemsToHeight:(CGFloat)height;

@end

@interface AMMeetingSettingCView : UIView

@property (nonatomic ,weak) id <AMMeetingSettingCViewDelegate> delegate;
@property (nonatomic ,copy) NSString *tipsStr;

@end

NS_ASSUME_NONNULL_END
