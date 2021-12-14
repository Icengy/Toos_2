//
//  AMCourseVideoReplayController.h
//  ArtMedia2
//
//  Created by LY on 2020/12/15.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BaseViewController.h"
#import "AMCourseChapterModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AMCourseVideoReplayController : BaseViewController
@property (nonatomic , strong) AMCourseChapterModel *chapterModel;//当前播放的课时
@end

NS_ASSUME_NONNULL_END
