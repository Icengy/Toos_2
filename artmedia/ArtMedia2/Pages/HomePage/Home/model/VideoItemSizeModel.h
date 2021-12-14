//
//  VideoItemSizeModel.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/20.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoItemSizeModel : NSObject

@property (nonatomic ,assign) CGFloat itemWidth;
@property (nonatomic ,assign) CGFloat itemHeight;
@property (nonatomic ,assign) CGFloat imageWidth;
@property (nonatomic ,assign) CGFloat imageHeight;
@property (nonatomic ,assign) CGFloat textWidth;
@property (nonatomic ,assign) CGFloat textHeight;

@end

NS_ASSUME_NONNULL_END
