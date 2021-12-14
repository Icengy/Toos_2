//
//  AMMeetingRoomMemberModel.h
//  ArtMedia2
//
//  Created by icnengy on 2020/9/1.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AMMeetingRoomMemberModel : NSObject

@property (nonatomic ,copy) NSString *isMaster;// 是否是会主 1是，2否
@property (nonatomic ,copy) NSString *operation;// 操作类型。1:禁言，2:不禁言，3:禁视频，4:不禁视频
@property (nonatomic ,copy) NSString *operationId;// 操作ID
@property (nonatomic ,copy) NSString *userId;// 用户id
@property (nonatomic ,copy) NSString *userName;// 用户名称
@property (nonatomic ,copy) NSString *userPhoto;// 用户头像
@property (nonatomic ,copy) NSString *userType;// 用户类型。1普通用户，2经纪人，3艺术家

/// 针对成员列表及View的操作 NO：不静音 YES：静音
@property (nonatomic ,assign) BOOL isForbidAudio_Normal;
/// 针对成员列表及View的操作 NO：不禁视频 YES：禁视频
@property (nonatomic ,assign) BOOL isForbidVideo_Normal;

#pragma mark - 该数据为operation判断而来
/// 针对管理列表的操作 NO：不静音 YES：静音
@property (nonatomic ,assign) BOOL isForbidAudio_Manager;
/// 针对管理列表的操作 NO：不禁视频 YES：禁视频
@property (nonatomic ,assign) BOOL isForbidVideo_Manager;

@end

NS_ASSUME_NONNULL_END
