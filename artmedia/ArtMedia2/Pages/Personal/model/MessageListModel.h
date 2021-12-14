//
//  MessageListModel.h
//  ArtMedia2
//
//  Created by 名课 on 2020/9/3.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageListModel : NSObject
@property (copy , nonatomic) NSString *messageTitle;
@property (copy , nonatomic) NSString *messageDetail;
@property (copy , nonatomic) NSString *ID;
@property (nonatomic , copy) NSString *userType;
@property (nonatomic , copy) NSString *uid;
@property (nonatomic , copy) NSString *mtype;
@property (nonatomic , copy) NSString *addtime;
@property (nonatomic , copy) NSString *jumpId;
@property (nonatomic , copy) NSString *jumpType;
@property (nonatomic , copy) NSString *isRead;


/*
 
 addtime = 1600054163;
 id = 356180;
 isRead = 0;
 jumpId = 0;
 jumpType = 5;
 messageDetail = "<null>";
 messageTitle = "<null>";
 mtype = 3;
 sum = "<null>";
 uid = 840;
 userType = 1;
 
 */
@end

NS_ASSUME_NONNULL_END
