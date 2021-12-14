//
//  AMCourseChapterCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/10/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMCourseModel.h"
@class AMCourseChapterModel;
@class AMCourseChapterCell;
NS_ASSUME_NONNULL_BEGIN

@protocol AMCourseChapterDelegate <NSObject>

@optional

/// 删除课时
- (void)chapterCell:(AMCourseChapterCell *)chapterCell didSelectedDelete:(id)sender;

/// 编辑课时
- (void)chapterCell:(AMCourseChapterCell *)chapterCell didSelectedEdit:(id)sender;

@end

@interface AMCourseChapterCell : UITableViewCell

@property (nonatomic, weak) id <AMCourseChapterDelegate> delegate;
@property (nonatomic ,strong) AMCourseChapterModel *model;
@property (nonatomic , strong) AMCourseModel *courseModel;
@end

NS_ASSUME_NONNULL_END
