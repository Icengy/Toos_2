//
//  ClassDetailTeacherClassCell.h
//  ArtMedia2
//
//  Created by LY on 2020/10/23.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMCourseChapterModel.h"
#import "AMCourseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class ClassDetailTeacherClassCell;
@protocol ClassDetailTeacherClassCellDelegate <NSObject>
@required
- (void)cellButtonClick:(ClassDetailTeacherClassCell *)cell buttonTitle:(NSString *)title chapterModel:(AMCourseChapterModel *)model indexPath:(NSIndexPath *)indexPath;

@end
@interface ClassDetailTeacherClassCell : UITableViewCell
@property (nonatomic , strong) AMCourseModel *courseModel;
@property (nonatomic , strong) AMCourseChapterModel *chapterModel;
@property (nonatomic , weak) id <ClassDetailTeacherClassCellDelegate> delegate;
@property (nonatomic , strong) NSIndexPath *indexPath;
@end

NS_ASSUME_NONNULL_END
