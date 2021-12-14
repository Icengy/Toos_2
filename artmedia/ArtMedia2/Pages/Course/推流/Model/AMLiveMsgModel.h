//
//  AMLiveMsgModel.h
//  ArtMedia2
//
//  Created by LY on 2020/10/29.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AMLiveMsgData;
@class AMLiveMsgBody;
NS_ASSUME_NONNULL_BEGIN

/*自定义消息体
 {
 “messageType”:0, 0：chatTextMsg聊天文本消息:1：chatImageMsg聊天图片消息，2：onLineNumMsg广播在线人数消息
 “userData”:{
     “userType”:3，发言人类型，0官方发言，1房主发言，2管理员发言，3普通用户发言
     “userId”:1,
     “userName”:”张三”,
     “userHeadImg”:”****.jpg”,
 },
 “messageBody”:{
     “messageText”:”具体的消息文本内容，如果是图片消息，这里为图片地址”,
 }
 “guid”:”xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx”,        //用来作为定位消息的唯一标识，可以以此在界面上对该条消息进行处理，比如撤销或禁言
 “timespan”:1603866801
 }
 */


typedef NS_ENUM(NSInteger , AMLiveMsgType) {
    AMLiveMsgUserTypeChatTextMsg = 0,//聊天文本消息
    AMLiveMsgUserTypeChatImageMsg = 1,//聊天图片消息
    AMLiveMsgUserTypeOnLineNumMsg = 2,//广播在线人数消息
    
    AMLiveMsgUserTypeAuctionBidMsg = 3,//出价消息
    AMLiveMsgUserTypeEndAuctionMsg = 4,//结拍消息
    AMLiveMsgUserTypeChangeAuctonMsg = 5,//切换拍品消息
    AMLiveMsgUserTypeCancelBidMsg = 6,//出价作废消息
    AMLiveMsgUserTypeChangeAuctonShowStartPriceMsg = 7,//切换拍品消息,显示起拍价
    
    AMLiveMsgUserTypeMemberJoin = 10,//用户进入直播间
    AMLiveMsgUserTypeAlet = 11,//警示信息
    AMLiveMsgUserTypeTeacherLeave = 12,//老师暂时离开直播间
    AMLiveMsgUserTypeFinishClass = 13//老师结束课时
};

typedef NS_ENUM(NSInteger , AMLiveMsgUserType) {
    AMLiveMsgUserTypeOfficial = 0,//官方
    AMLiveMsgUserTypeTeacher = 1,//房主
    AMLiveMsgUserTypeManager = 2,//管理员
    AMLiveMsgUserTypeMember = 3//普通用户
};



@interface AMLiveMsgModel : NSObject
@property (nonatomic , assign) AMLiveMsgType messageType;
@property (nonatomic , strong) AMLiveMsgData *userData;
@property (nonatomic , strong) AMLiveMsgBody *messageBody;
@property (nonatomic , copy) NSString *guid;
@property (nonatomic , copy) NSString *timespan;

@property (nonatomic , copy) NSString *appIdentify;
@property (nonatomic , copy) NSString *groupId;

@end




@interface AMLiveMsgData : NSObject
@property (nonatomic , assign) AMLiveMsgUserType userType;
@property (nonatomic , copy) NSString *userId;
@property (nonatomic , copy) NSString *userName;
@property (nonatomic , copy) NSString *userHeadImg;

@end

@interface AMLiveMsgBody : NSObject
@property (nonatomic , copy) NSString *messageText;

//直播pm公用属性
@property (nonatomic , copy) NSString *auctionId;//拍品ID
@property (nonatomic , copy) NSString *auctionLot;//拍品图录号
@property (nonatomic , copy) NSString *bidPrice;
@property (nonatomic , copy) NSString *nextBidPrice;
@property (nonatomic , copy) NSString *time;//出价时间 结拍时间  切换到该拍品的时间  作废时间
@property (nonatomic , copy) NSString *bidType;//1线上出价，2大厅出价
// AMLiveMsgUserTypeAuctionBidMsg = 3, 出价消息

@property (nonatomic , copy) NSString *numberPlate;//参拍用户的拍卖号牌

// AMLiveMsgUserTypeEndAuctionMsg = 4,结拍消息
@property (nonatomic , assign) BOOL ifHasWinner;//是否成交，true表示成交，展示得拍人号牌；false表示流拍，展现流拍样式。
@property (nonatomic , copy) NSString *winnerNumberPlate;//成功得拍人的号牌，流拍情况下为空字符
@property (nonatomic , copy) NSString *endPrice;//最终的成交价格，无人出价为0

// AMLiveMsgUserTypeChangeAuctonMsg = 5,切换拍品消息
@property (nonatomic , copy) NSString *auctionImageUrl;
@property (nonatomic , copy) NSString *auctionTitle;
@property (nonatomic , assign) BOOL ifHasBid;
@property (nonatomic , copy) NSString *nowNumberPlate;

// AMLiveMsgUserTypeCancelBidMsg = 6,//出价作废消息
@property (nonatomic , copy) NSString *needCancelBidLogId;//需要操作作废的那一条出价消息的出价记录ID
@property (nonatomic , copy) NSString *needCancelBidPrice;//需要操作作废的那一条出价消息的出价价格
@end
NS_ASSUME_NONNULL_END
