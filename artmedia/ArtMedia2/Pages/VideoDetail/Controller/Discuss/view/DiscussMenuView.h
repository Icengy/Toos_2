//
//  DiscussMenuView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/7/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AMReportView.h"

@class DiscussMenuView;
NS_ASSUME_NONNULL_BEGIN

@protocol DiscussMenuDelegate <NSObject>

@optional
/// way 0:
- (void)menuView:(DiscussMenuView *)menuView didSelectMenuWay:(NSInteger)way ;

@end

@interface DiscussMenuView : UIView

@property (weak, nonatomic) id <DiscussMenuDelegate> delegate;

+ (instancetype _Nullable)shareInstance;

- (void)show;
- (void)hide;

@end

NS_ASSUME_NONNULL_END
