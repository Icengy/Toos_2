//
//  AMMeetingSettingAView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/8/18.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AMMeetingSettingAView;
@protocol AMMeetingSettingAViewDelegate <NSObject>

@required
- (void)settingACell:(AMMeetingSettingAView *)cell didSelectedOpen:(AMButton *)sender;

@end

@interface AMMeetingSettingAView : UIView
@property (nonatomic ,weak) id <AMMeetingSettingAViewDelegate> delegate;
@property (nonatomic ,assign) BOOL isOpen;
@end

NS_ASSUME_NONNULL_END
