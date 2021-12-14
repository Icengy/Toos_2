//
//  AMNewArtistMainSubViewController.h
//  ArtMedia2
//
//  Created by 刘洋 on 2020/9/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BaseItemViewController.h"

@class CustomPersonalModel;
NS_ASSUME_NONNULL_BEGIN

@interface AMNewArtistMainSubViewController : BaseItemViewController

@property (nonatomic , copy) void(^clickForMoreVideosBlock)(void);
@property (nonatomic , strong) CustomPersonalModel *userModel;

NS_ASSUME_NONNULL_END
@end
