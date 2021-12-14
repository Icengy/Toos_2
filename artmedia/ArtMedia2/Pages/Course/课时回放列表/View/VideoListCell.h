//
//  VideoListCell.h
//  ArtMedia2
//
//  Created by 刘洋 on 2020/10/19.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMCourseModel.h"
#import "AMCourseChapterModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface VideoListCell : UITableViewCell
@property (nonatomic , strong) AMCourseModel *courseModel;
@property (nonatomic , strong) AMCourseChapterModel *model;
@property (nonatomic , copy) NSString *chapterId;//用来判断当前播放是哪个课时
@end

NS_ASSUME_NONNULL_END
