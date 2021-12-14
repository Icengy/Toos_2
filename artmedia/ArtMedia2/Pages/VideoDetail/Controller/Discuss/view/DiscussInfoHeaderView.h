//
//  DiscussInfoHeaderView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/7/6.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DiscussItemInfoModel;
@class DiscussInfoHeaderView;
NS_ASSUME_NONNULL_BEGIN

@protocol DiscussInfoHeaderDelegate <NSObject>

@optional
/// 点赞
- (void)infoHeader:(DiscussInfoHeaderView *)header didClickToLike:(AMButton *)sender withModel:(DiscussItemInfoModel *)model;
/// 点击头像
- (void)infoHeader:(DiscussInfoHeaderView *)header didClickToLogo:(id)sender withModel:(DiscussItemInfoModel *)model;

@end

@interface DiscussInfoHeaderView : UIView

@property (weak, nonatomic) id <DiscussInfoHeaderDelegate> delegate;
@property (strong, nonatomic) DiscussItemInfoModel *model;

@end

NS_ASSUME_NONNULL_END
