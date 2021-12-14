//
//  LS_TRTCParams.h
//  LiveStream
//
//  Created by icnengy on 2020/4/20.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <TXLiteAVSDK_Professional/TXLiteAVSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface LS_TRTCParams : TRTCParams


/// 服务器时间
@property (nonatomic, copy) NSString *currentTime;
/// 会客结束时间
@property (nonatomic, copy) NSString *teaEndTime;

///房主ID
@property (nonatomic, copy) NSString *ownerID;
///房主昵称
@property (nonatomic, copy) NSString *ownerName;

@end

NS_ASSUME_NONNULL_END
