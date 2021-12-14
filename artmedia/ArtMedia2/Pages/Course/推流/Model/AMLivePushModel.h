//
//  AMLivePushModel.h
//  ArtMedia2
//
//  Created by LY on 2020/10/29.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AMLivePushModel : NSObject
/*
 
 
 chapterId = 92;
 chapterSort = 1;
 chapterTitle = "是啊真的好想好好学学";
 courseId = 45;
 courseTitle = yyhhh;
 courseType = 1;
 isFree = 1;
 liveStatus = 1;
 playUrl = "http://liveplay.debug.ysrmt.cn/live/MSCMLIVE000debug201022000003.flv?txSecret=cfb1e1a47c3eb8f97dee349fc1642053&txTime=5FACDAA8";
 pushUrl = "<null>";
 roomId = 46166155;
 streamName = MSCMLIVE000debug201022000003;
 */
@property (nonatomic , copy) NSString *chapterId;
@property (nonatomic , copy) NSString *chapterSort;
@property (nonatomic , copy) NSString *chapterTitle;
@property (nonatomic , copy) NSString *courseId;
@property (nonatomic , copy) NSString *courseTitle;
@property (nonatomic , copy) NSString *courseType;
@property (nonatomic , copy) NSString *isFree;
@property (nonatomic , copy) NSString *liveStatus;
@property (nonatomic , copy) NSString *playUrl;
@property (nonatomic , copy) NSString *pushUrl;
@property (nonatomic , copy) NSString *roomId;
@property (nonatomic , copy) NSString *streamName;
@end

NS_ASSUME_NONNULL_END
