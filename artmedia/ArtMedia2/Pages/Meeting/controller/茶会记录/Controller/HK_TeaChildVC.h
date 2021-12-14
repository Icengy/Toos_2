//
//  HK_TeaChildVC.h
//  ArtMedia2
//
//  Created by guohongkai on 2020/8/13.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HK_RecordStatus) {
    ALL_record =  0,//全部
    Wait_startStatus,//待开始
    Ongoing_Status,//进行中
    Already_End,//已结束
    Already_cancelStatus,//已取消
};
@interface HK_TeaChildVC : BaseViewController
@property (nonatomic,assign)HK_RecordStatus Status_type;
@end

NS_ASSUME_NONNULL_END
