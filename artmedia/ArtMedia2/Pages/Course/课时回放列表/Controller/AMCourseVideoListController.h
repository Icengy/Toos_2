//
//  AMCourseVideoListController.h
//  ArtMedia2
//
//  Created by LY on 2020/12/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BaseViewController.h"
#import "AMCourseModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol AMCourseVideoListDelegate <NSObject>
@optional
- (void)videoListSelect:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath model:(AMCourseChapterModel *)model;

@end

@interface AMCourseVideoListController : BaseViewController
@property (nonatomic , weak) id <AMCourseVideoListDelegate> delegate;
@property (nonatomic , strong) AMCourseModel *courseModel;
@property (nonatomic , strong) AMCourseChapterModel *chapterModel;//当前播放的课时
- (void)showWithController:(UIViewController *)controller;
@end

NS_ASSUME_NONNULL_END
