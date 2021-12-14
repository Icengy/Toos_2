//
//  DiscussHeaderView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/7/6.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DiscussHeaderView;
NS_ASSUME_NONNULL_BEGIN

@protocol DiscussHeaderDelegate <NSObject>

@optional
- (void)headerView:(DiscussHeaderView *)headerView didSelectedSort:(id)sender;
- (void)headerView:(DiscussHeaderView *)headerView didSelectedAdd:(id)sender;

@end

@interface DiscussHeaderView : UIView

@property (weak, nonatomic) id <DiscussHeaderDelegate> delegate;
@property (nonatomic ,assign) NSInteger discussCount;

@end

NS_ASSUME_NONNULL_END
