//
//  AMCourseCoverCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/10/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMCourseModel;
NS_ASSUME_NONNULL_BEGIN

@interface AMCourseCoverCell : UITableViewCell

@property (nonatomic, assign) BOOL needCornerRadius;
@property (nonatomic, assign) BOOL needMargin;

@property (nonatomic ,strong) AMCourseModel *model;

@end

NS_ASSUME_NONNULL_END
