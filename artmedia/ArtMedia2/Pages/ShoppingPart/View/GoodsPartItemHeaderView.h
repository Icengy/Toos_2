//
//  GoodsPartItemHeaderView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/7/22.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoListModel;
NS_ASSUME_NONNULL_BEGIN

@interface GoodsPartItemHeaderView : UIView

+ (GoodsPartItemHeaderView *)shareInstance;

@property (nonatomic ,assign) BOOL isHiddenDetail;
@property (nonatomic ,copy) NSString *video_count;
@property (nonatomic ,copy) NSString *video_authCode;

@end

NS_ASSUME_NONNULL_END
