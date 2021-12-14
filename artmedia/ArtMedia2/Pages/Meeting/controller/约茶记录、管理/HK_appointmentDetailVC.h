//
//  HK_appointmentDetailVC.h
//  ArtMedia2
//
//  Created by guohongkai on 2020/8/18.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BaseViewController.h"
//#import "HK_appointment_model.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, Reservation_status) {
    Wait_invited_status =  1,//待邀请
    Wait_join_status,//待参加
    Already_join_status,//已参加
    Cancel_status,//已取消
};
@interface HK_appointmentDetailVC : BaseViewController
//@property (nonatomic,assign)Reservation_status appointment_Status;
@property (copy , nonatomic) NSString *teaAboutOrderId;
//@property (strong , nonatomic) HK_appointment_model *appointmentModel;
@end

NS_ASSUME_NONNULL_END
