//
//  AMCourseNewViewController.h
//  ArtMedia2
//
//  Created by icnengy on 2020/10/10.
//  Copyright © 2020 翁磊. All rights reserved.
//
// 新建、编辑课程
//

#import "BaseViewController.h"

@class AMCourseModel;
NS_ASSUME_NONNULL_BEGIN

@interface AMCourseNewViewController : BaseViewController

/// isCourseEdit :NO新建、YES编辑
@property (nonatomic, assign) BOOL isCourseEdit;
@property (strong, nonatomic) AMCourseModel *model;

@end

NS_ASSUME_NONNULL_END
