//
//  AMCoursePublishResultTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/10/20.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMCourseModel.h"
@class AMCoursePublishResultTableCell;
NS_ASSUME_NONNULL_BEGIN

@protocol AMCoursePublishResultDelegate <NSObject>

@optional
- (void)resultCell:(AMCoursePublishResultTableCell *)resultCell didSelectedWithSuccess:(id)sender;
- (void)resultCell:(AMCoursePublishResultTableCell *)resultCell didSelectedWithFail:(id)sender;

@end

@interface AMCoursePublishResultTableCell : UITableViewCell

@property (nonatomic ,weak) id <AMCoursePublishResultDelegate>delegate;
@property (nonatomic ,assign) BOOL success;
@property (nonatomic , strong) AMCourseModel *model;

@end

NS_ASSUME_NONNULL_END
