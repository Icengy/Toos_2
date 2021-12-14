//
//  GoodsDetailModel.m
//  ArtMedia2
//
//  Created by LY on 2020/12/17.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "GoodsDetailModel.h"

@implementation GoodsDetailModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"exemptionContent" : @"exemption.content",
        @"goodAtlas":@"good_atlas",
        @"goodInfo":@"good_info",
        @"userInfo":@"user_info",
        @"videoList":@"video_list",
        
        
    };
}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"goodAtlas" : @"GoodsAtlas",
        @"videoList" : @"GoodsVideoList"
        
    };
}

@end



@implementation GoodsCategory

@end


@implementation GoodsAtlas

@end


@implementation GoodsInfo

@end


@implementation GoodsShare

@end


@implementation GoodsUserInfo
//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"userId" : @"id"
    };
}
@end


@implementation GoodsVideoList
//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"videoId" : @"id"
    };
}
@end


