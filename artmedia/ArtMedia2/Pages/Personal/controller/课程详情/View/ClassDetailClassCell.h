//
//  ClassDetailClassCell.h
//  ArtMedia2
//
//  Created by LY on 2020/10/20.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMCourseChapterModel.h"
#import "AMCourseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ClassDetailClassCell : UITableViewCell
@property (nonatomic , strong) NSIndexPath *indexPath;
@property (nonatomic , strong) AMCourseChapterModel *model;
@property (nonatomic , strong) AMCourseModel *courseModel;

@end

NS_ASSUME_NONNULL_END
