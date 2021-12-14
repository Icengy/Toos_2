//
//  SelectTeaStatusModel.h
//  ArtMedia2
//
//  Created by 名课 on 2020/9/5.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectTeaStatusModel : NSObject
/*
 artistId = 830;
 artistName = "<null>";
 createTime = "2020-08-26 14:11:31";
 createUserId = "<null>";
 createUserName = "<null>";
 securityDeposit = "<null>";
 teaSystemId = 11;
 teaSystemStatus = 1;
 updateTime = "2020-09-05 16:01:48";
 updateUserId = "<null>";
 updateUserName = "<null>";
 */
@property (copy , nonatomic) NSString *artistId;
@property (copy , nonatomic) NSString *artistName;
@property (copy , nonatomic) NSString *createTime;
@property (copy , nonatomic) NSString *createUserId;
@property (copy , nonatomic) NSString *createUserName;
@property (copy , nonatomic) NSString *securityDeposit;
@property (copy , nonatomic) NSString *teaSystemId;
@property (copy , nonatomic) NSString *teaSystemStatus;
@property (copy , nonatomic) NSString *updateTime;
@property (copy , nonatomic) NSString *updateUserId;
@property (copy , nonatomic) NSString *updateUserName;
@end

NS_ASSUME_NONNULL_END
