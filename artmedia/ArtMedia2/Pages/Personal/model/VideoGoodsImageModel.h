//
//  VideoGoodsImageModel.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/1.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoGoodsImageModel : NSObject

@property(nonatomic ,copy) NSString *addtime;
@property(nonatomic ,copy) NSString *gid;
@property(nonatomic ,copy) NSString *ID;
@property(nonatomic) id imgsrc;
@property(nonatomic ,copy) NSString *mimgsrc;
@property(nonatomic ,copy) NSString *simgsrc;
@property(nonatomic ,copy) NSString *sort;
@property(nonatomic ,copy) NSString *state;
@property(nonatomic ,copy) NSString *type;
@property (nonatomic ,copy) NSString *stock_id;

@end

NS_ASSUME_NONNULL_END
