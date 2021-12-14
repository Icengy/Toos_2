//
//  AMMeetingRoomMemberModel.m
//  ArtMedia2
//
//  Created by icnengy on 2020/9/1.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMMeetingRoomMemberModel.h"

#import <YYModel/YYModel.h>

@implementation AMMeetingRoomMemberModel

// 当 JSON 转为 Model 完成后，该方法会被调用。
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    // 可以在这里处理一些数据逻辑，如NSDate格式的转换
    [self userOperationState:[dic objectForKey:@"operation"]];
    return YES;
}

- (void)userOperationState:(NSString *)operation {
    if (![ToolUtil isEqualToNonNull:operation]) return;
    
    NSArray *operations = [operation componentsSeparatedByString:@","];
    BOOL isMuteAudio = NO;
    BOOL isMuteVideo = NO;
    /// 1:禁言|2:不禁言3:禁视频|4:不禁视频
    if (operations && operations.count) {
        if ([StringWithFormat(operations.firstObject) isEqualToString:@"2"]) {
            isMuteAudio = NO;
        }
        if ([StringWithFormat(operations.firstObject) isEqualToString:@"1"]) {
            isMuteAudio = YES;
        }
        if ([StringWithFormat(operations.lastObject) isEqualToString:@"4"]) {
            isMuteVideo = NO;
        }
        if ([StringWithFormat(operations.lastObject) isEqualToString:@"3"]) {
            isMuteVideo = YES;
        }
    }
    self.isForbidAudio_Manager = isMuteAudio;
    self.isForbidVideo_Manager = isMuteVideo;
}

@end
