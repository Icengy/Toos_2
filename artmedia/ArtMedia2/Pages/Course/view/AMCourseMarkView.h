//
//  AMCourseMarkView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/10/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 弹出框
typedef NS_ENUM(NSUInteger, AMCourseMarkStyle) {
    ///默认不显示
    AMCourseMarkStyleDefault = 1,
    ///审核中
    AMCourseMarkStyleExamining,
    ///审核失败
    AMCourseMarkStyleExamineFail,
    ///待授课
    AMCourseMarkStyleWaitingForClass,
    ///授课中
    AMCourseMarkStyleInClass,
    ///直播中
    AMCourseMarkStyleInLive,
    ///已完结
    AMCourseMarkStyleFinished
};

NS_ASSUME_NONNULL_BEGIN

@interface AMCourseMarkView : UIView

@property (nonatomic, weak) IBOutlet UIView *view;
@property (nonatomic, assign) AMCourseMarkStyle style;

@end

NS_ASSUME_NONNULL_END
