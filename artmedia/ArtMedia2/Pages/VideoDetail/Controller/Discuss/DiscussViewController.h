//
//  DiscussViewController.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/2.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BaseViewController.h"

@class VideoListModel;
@class DiscussItemInfoModel;
@class DiscussViewController;
NS_ASSUME_NONNULL_BEGIN

@protocol DiscussViewControllerDelegate <NSObject>

@optional
- (void)discuss:(BaseViewController *)discussVC didSelectDetail:(DiscussItemInfoModel *)model;

@end

@interface DiscussViewController : BaseViewController

@property (nonatomic ,weak) id <DiscussViewControllerDelegate> delegate;
@property (nonatomic ,strong) MainNavigationController *navi;
@property (nonatomic, strong) VideoListModel *videoModel;

@end

NS_ASSUME_NONNULL_END
