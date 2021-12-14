//
//  MessageCountModel.m
//  ArtMedia2
//
//  Created by 刘洋 on 2020/9/14.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "MessageCountModel.h"

@implementation MessageCountModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"fans_count" : @"new_fans_count"};
}
@end
