//
//  PublishGenerateLeadingView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/11/2.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PublishGenerateLeadingView : UIView

/// 设置进度 0：生成 1：上传
- (void)setProgress:(CGFloat)progress forType:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
