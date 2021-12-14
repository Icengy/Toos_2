//
//  VideoListHeadView.h
//  ArtMedia2
//
//  Created by LY on 2020/12/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoListHeadView : UIView
@property (nonatomic , copy) void(^hideListBlock)(void);
+ (instancetype)share;
@end

NS_ASSUME_NONNULL_END
