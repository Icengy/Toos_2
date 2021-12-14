//
//  AMCourseChapterCreateViewController.h
//  ArtMedia2
//
//  Created by icnengy on 2020/10/15.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BaseViewController.h"
#import "AMCourseModel.h"
@class AMCourseChapterModel;
NS_ASSUME_NONNULL_BEGIN

@interface AMCourseChapterCreateViewController : BaseViewController

/// 是否是编辑
@property (nonatomic ,assign) BOOL isEditChapter;

/// 新增事件底部回调
@property(nonatomic,strong)void(^clickToAddBlock)(AMCourseChapterModel *model);
/// 编辑事件底部回调
@property(nonatomic,strong)void(^clickToEditBlock)(AMCourseChapterModel *model);

/// 课时model
@property (nonatomic ,strong) AMCourseChapterModel *model;
@property (nonatomic , strong) AMCourseModel *courseModel;//课程Model

@property (nonatomic , copy) NSString *courseIsFree;

@end

NS_ASSUME_NONNULL_END
