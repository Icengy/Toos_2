//
//  VideoReplayModel.h
//  ArtMedia2
//
//  Created by LY on 2020/10/26.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoReplayModel : NSObject
/*
 "chapterId":1,                        //章节主键id
 "courseId":1,                         //课程ID
 "courseType": 1,                      //课程类型 1:直播课;2:点播课,
 "isFree": 1,                          //是否免费 1:免费;2:收费,
 "videoSourceId": "XXXXXXXXX",         //云端视频资源url（视频回放地址）
 "videoStatus": 4,                     //视频状态 1:未上传;2:转码中;3:上传失败;4:视频上传成功
 */
@property (nonatomic , copy) NSString *chapterId;
@property (nonatomic , copy) NSString *courseId;
@property (nonatomic , copy) NSString *courseType;
@property (nonatomic , copy) NSString *isFree;
@property (nonatomic , copy) NSString *videoSourceId;
@property (nonatomic , copy) NSString *videoStatus;
@end

NS_ASSUME_NONNULL_END
