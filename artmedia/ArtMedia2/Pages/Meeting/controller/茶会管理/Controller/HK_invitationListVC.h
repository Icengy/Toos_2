//
//  HK_invitationListVC.h
//  ArtMedia2
//
//  Created by guohongkai on 2020/8/21.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, HK_invitaNumberList) {
    ALL_List =  0,//全部
    Already_join,//已参加
    Not_join,//不参加
    Wait_sure,//待确认
};
NS_ASSUME_NONNULL_BEGIN

@interface HK_invitationListVC : BaseViewController
@property (nonatomic,assign)HK_invitaNumberList InvitaStatus;
@property (nonatomic , copy) NSString *teaAboutInfoId;
@end

NS_ASSUME_NONNULL_END
