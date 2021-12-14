//
//  ClassDetailClassHeadView.h
//  ArtMedia2
//
//  Created by LY on 2020/10/20.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMCourseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ClassDetailClassHeadView : UIView
+ (instancetype)share;
@property (nonatomic , strong) AMCourseModel *model;
@end

NS_ASSUME_NONNULL_END
