//
//  AuctionItemDetailModel.m
//  ArtMedia2
//
//  Created by 刘洋 on 2020/11/23.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AuctionItemDetailModel.h"

@implementation AuctionItemDetailModel
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"opusImagesList" : [OpusImageModel class]
    };
}
@end

@implementation OpusImageModel

@end
