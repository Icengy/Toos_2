//
//  AMCourseEditCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/10/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMCourseModel;
@class AMCourseEditCell;
NS_ASSUME_NONNULL_BEGIN

@protocol AMCourseEditDelegate <NSObject>

@required
- (void)editCell:(AMCourseEditCell *)editCell didSeletedForCourseTitle:(NSString *)title;
- (void)editCell:(AMCourseEditCell *)editCell didSeletedForCourseDesc:(NSString *)desc;
- (void)editCell:(AMCourseEditCell *)editCell didSeletedForCourseFree:(BOOL)isFree;

@optional
- (void)editCell:(AMCourseEditCell *)editCell didSeletedForCoursePrice:(NSString *_Nullable)price;

@end

@interface AMCourseEditCell : UITableViewCell

@property (nonatomic ,weak) id <AMCourseEditDelegate> delegate;
@property (nonatomic ,strong) AMCourseModel *model;

@end

NS_ASSUME_NONNULL_END
