//
//  CustomPersonalModel.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/29.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VideoListModel;
@class AMNewArtistTimeLineModel;
NS_ASSUME_NONNULL_BEGIN

@interface CustomPersonalUnreadOrderModel : NSObject

/*wait_pay_num待付款，wait_deliver_num待发货，wait_receive_num待收货，wait_return_num退货*/
/// 待发货
@property (nonatomic ,copy) NSString *wait_deliver_num;
/// 待付款
@property (nonatomic ,copy) NSString *wait_pay_num;
/// 待收货
@property (nonatomic ,copy) NSString *wait_receive_num;
/// 退货
@property (nonatomic ,copy) NSString *wait_return_num;

@end

@interface CustomPersonalModel : NSObject

@property (nonatomic ,strong) NSDictionary *msgData;
@property (nonatomic ,strong) NSDictionary *orderData;
@property (nonatomic ,strong) NSDictionary *wallet;

@property (nonatomic ,copy) NSString *draftsDataCount;
/// 我的喜欢视频数量
@property (nonatomic ,copy) NSString *collectDataCount;
/// 我的视频数量
@property (nonatomic ,copy) NSString *videoDataCount;

/// 我的约见数量
@property (nonatomic ,copy) NSString *my_appointment;
/// 待参加会客数量
@property (nonatomic ,copy) NSString *my_meeting;

///预估收益
@property (nonatomic ,copy) NSString *pre_reward_money;

/// 未读信息model
@property (nonatomic ,strong) CustomPersonalUnreadOrderModel *unreadModel;

@property (nonatomic ,strong) NSArray <VideoListModel *>*videoData;
@property (nonatomic ,strong) NSArray <AMNewArtistTimeLineModel *>*meetingData;
@property (nonatomic ,strong) UserInfoModel *userData;

@end

NS_ASSUME_NONNULL_END
