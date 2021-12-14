//
//  GiftViewController.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/26.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "BaseViewController.h"

@class VideoListModel;
NS_ASSUME_NONNULL_BEGIN

@interface GiftViewController : BaseViewController

@property (nonatomic ,strong) VideoListModel *model;

@property(nonatomic,copy) void(^paySuccessForGift)(NSInteger giftNum);
@property(nonatomic,copy) void(^payFailForGift)(void);

- (instancetype)initWithModel:(VideoListModel *)model;
- (void)showEnterance:(UIViewController *_Nullable)viewController;

@end

NS_ASSUME_NONNULL_END
