//
//  PublishResultViewController.h
//  ArtMedia2
//
//  Created by icnengy on 2020/9/9.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PublishResultViewController : BaseViewController

/// 是否包含商品
@property (nonatomic ,assign) BOOL hadGoods;
/// 视频名称
@property (nonatomic ,copy) NSString *videoName;
///艺术品身份证 地址
@property (nonatomic ,copy) NSString *artworkIDCard;

@end

NS_ASSUME_NONNULL_END
