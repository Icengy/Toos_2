//
//  MessageInfoModel.m
//  ArtMedia2
//
//  Created by icnengy on 2020/7/8.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "MessageInfoModel.h"

@implementation MessageInfoModel

@end

@implementation SystemMessageModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}
@end

@implementation MessageCollectInfoModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"user_info" : [UserInfoModel class]
             };
}

@end

@implementation MessageDiscussInfoModel

//+ (NSDictionary *)modelContainerPropertyGenericClass {
//    return @{
//             @"user_head_images" : [NSArray class],
//             @"user_names" : [NSArray class]
//             };
//}

@end

@implementation MessageReplyInfoModel

@end



@implementation MessageSubModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}
@end


