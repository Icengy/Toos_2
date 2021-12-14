//
//  UGCKitSubtitleEditView.h
//  UGCKit
//
//  Created by icnengy on 2020/7/28.
//  Copyright © 2020 Tencent. All rights reserved.
//
// 添加字幕
//

#import <UIKit/UIKit.h>
#import "UGCKitTheme.h"

@class UGCKitSubtitleEditView;
@class UGCKitVideoTextThemeInfo;

@interface UGCKitSubtitleInfo : NSObject
@property(nonatomic,strong) UIImage *image;
@property(nonatomic,strong) UIImage *iconImage;
@property(nonatomic,assign) CGSize size;
@property(nonatomic,assign) UIEdgeInsets textEdgeInsets;
@end


@protocol UGCKitSubtitleEditDelegate <NSObject>
@optional

/// 内容改变
/// @param editView editView
/// @param type type 0:字体类型、1:字体大小、2:文本颜色
/// @param changedValue changedValue
- (void)editView:(UGCKitSubtitleEditView *)editView textThemeInfoChangedWithType:(NSInteger)type withValue:(id)changedValue;

@end

@interface UGCKitSubtitleEditView : UIView

@property (nonatomic ,weak) id <UGCKitSubtitleEditDelegate> delegate;
@property (nonatomic ,strong) UGCKitVideoTextThemeInfo *textThemeInfo;
@property (nonatomic ,assign) CGFloat maxFontSize;
@property (nonatomic ,assign) CGFloat currentFontSize;

+ (UGCKitSubtitleEditView *)shareInstanceWithTheme:(UGCKitTheme *)theme;

- (void)onShow;
- (void)onClose;
@end
