//
//  ArtManagerHeaderView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/9/3.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArtManagerHeaderView;
NS_ASSUME_NONNULL_BEGIN

@protocol ArtManagerHeaderDelegate <NSObject>

@required
- (void)headerView:(ArtManagerHeaderView *)headerView didSelectedToBack:(id)sender;
- (void)headerView:(ArtManagerHeaderView *)headerView didSelectedToAuthData:(id)sender;

@end

@interface ArtManagerHeaderView : UIView

@property (nonatomic ,assign, readonly) CGFloat contentHeight;
@property (nonatomic ,weak) id <ArtManagerHeaderDelegate>delegate;
//@property (nonatomic , strong) CustomPersonalModel *model;
+ (ArtManagerHeaderView *)shareInstance;
@property (nonatomic ,strong) UserInfoModel *model;

@end

NS_ASSUME_NONNULL_END
