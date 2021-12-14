//
//  AMMeetingDetailHeaderView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/8/17.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HK_tea_managerModel;
@class AMMeetingDetailHeaderView;
NS_ASSUME_NONNULL_BEGIN
@protocol AMMeetingDetailHeaderDelegate <NSObject>

@optional
- (void)headerView:(AMMeetingDetailHeaderView *)header didSelectedBack:(id)sender;
- (void)headerView:(AMMeetingDetailHeaderView *)header didSelectedFollow:(AMButton *)sender;
- (void)headerView:(AMMeetingDetailHeaderView *)header didSelectedUserLogo:(id)sender;
- (void)headerView:(AMMeetingDetailHeaderView *)header didSelectedManage:(id)sender;

@end

@interface AMMeetingDetailHeaderView : UIView

@property (nonatomic ,weak) IBOutlet UIView *view;
@property (nonatomic ,weak) id <AMMeetingDetailHeaderDelegate> delegate;
@property (nonatomic, assign) BOOL showDarkStyle;
@property (nonatomic ,strong) HK_tea_managerModel *model;

@end

NS_ASSUME_NONNULL_END
