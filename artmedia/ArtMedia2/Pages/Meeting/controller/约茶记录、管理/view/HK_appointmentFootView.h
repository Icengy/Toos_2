//
//  HK_appointmentFootView.h
//  ArtMedia2
//
//  Created by guohongkai on 2020/8/19.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HK_appointmentFootView;
NS_ASSUME_NONNULL_BEGIN

@protocol HK_appointmentFootViewDelegate <NSObject>

@required
- (void)footerCell:(HK_appointmentFootView *)footer didLoadItemsWithHeight:(CGFloat)height;

@end

@interface HK_appointmentFootView : UIView

@property (nonatomic ,weak) id <HK_appointmentFootViewDelegate> delegate;
+ (HK_appointmentFootView *)shareInstance;
@property (nonatomic ,copy) NSString *tipsStr;
@property (nonatomic ,assign) CGFloat footerHeight;
@end

NS_ASSUME_NONNULL_END
