//
//  GiftHeaderView.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2020/1/9.
//  Copyright © 2020 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoListModel;
NS_ASSUME_NONNULL_BEGIN

@interface GiftHeaderView : UIView

@property (nonatomic ,strong) VideoListModel *model;

+ (GiftHeaderView *)shareInstance;

@end

NS_ASSUME_NONNULL_END
