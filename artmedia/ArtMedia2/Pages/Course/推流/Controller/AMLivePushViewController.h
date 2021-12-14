//
//  AMLivePushViewController.h
//  ArtMedia2
//
//  Created by LY on 2020/10/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BaseViewController.h"
#import "MLVBLiveRoom.h"
#import "AMCourseChapterModel.h"
#import "AMCourseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AMLivePushViewController : BaseViewController
@property (nonatomic , strong) AMCourseChapterModel *chapterModel;
@property (nonatomic , strong) AMCourseModel *courseModel;
@end

NS_ASSUME_NONNULL_END
