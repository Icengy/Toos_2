//
//  AMCourseChaptersViewController.h
//  ArtMedia2
//
//  Created by icnengy on 2020/10/19.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BaseItemViewController.h"
#import "AMCourseModel.h"
@class AMCourseChapterModel;
NS_ASSUME_NONNULL_BEGIN

@interface AMCourseChaptersViewController : BaseItemViewController

/// 删除事件回调
@property(nonatomic,strong)void(^clickToReloadBlock)(void);

@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (nonatomic ,strong) NSMutableArray <AMCourseChapterModel *>*dataArray;
@property (nonatomic , strong) AMCourseModel *courseModel;
@end

NS_ASSUME_NONNULL_END
