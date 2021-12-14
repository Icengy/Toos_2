//
//  MessageCountModel.h
//  ArtMedia2
//
//  Created by 刘洋 on 2020/9/14.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageCountModel : NSObject
/*
 UntreatedNum = 1;
 "all_system_msg" = 0;
 "all_user_unread_msg" = 6;
 buyerUntreatedNum = 1;
 "new_fans_count" = 5;
 sellerUntreatedNum = 0;
 "unread_comments_num" = 0;
 "unread_fabulous" = 1;
 "unread_msg" = 0;
 */

@property (nonatomic , copy) NSString *UntreatedNum;
@property (nonatomic , copy) NSString *all_system_msg;
@property (nonatomic , copy) NSString *all_user_unread_msg;
//@property (nonatomic , assign) NSInteger all_user_unread_msg;
@property (nonatomic , copy) NSString *buyerUntreatedNum;
@property (nonatomic , copy) NSString *fans_count;
//@property (nonatomic , assign) NSInteger fans_count;

@property (nonatomic , copy) NSString *sellerUntreatedNum;
@property (nonatomic , copy) NSString *unread_comments_num;
@property (nonatomic , copy) NSString *unread_fabulous;
@property (nonatomic , copy) NSString *unread_msg;
@end

NS_ASSUME_NONNULL_END
