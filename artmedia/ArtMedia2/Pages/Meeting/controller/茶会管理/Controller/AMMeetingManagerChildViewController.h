//
//  AMMeetingManagerChildViewController.h
//  ArtMedia2
//
//  Created by icnengy on 2020/9/8.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, HK_tea_managerStatus) {
    ALL_List =  0,//全部
    Wait_startStatus,//待开始
    Ongoing_Status,//进行中
    Already_End,//已结束
    Already_cancelStatus,//已取消
};

NS_ASSUME_NONNULL_BEGIN

@interface AMMeetingManagerChildViewController : BaseViewController

@property (nonatomic,assign)HK_tea_managerStatus managerStatus;

@end

NS_ASSUME_NONNULL_END
