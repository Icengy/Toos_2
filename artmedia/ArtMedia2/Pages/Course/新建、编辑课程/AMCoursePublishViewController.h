//
//  AMCoursePublishViewController.h
//  ArtMedia2
//
//  Created by icnengy on 2020/10/20.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BaseViewController.h"

@class AMCourseModel;
NS_ASSUME_NONNULL_BEGIN

@interface AMCoursePublishViewController : BaseViewController

@property (nonatomic ,assign) BOOL success;
@property (nonatomic ,strong) AMCourseModel *model;

@end

NS_ASSUME_NONNULL_END
