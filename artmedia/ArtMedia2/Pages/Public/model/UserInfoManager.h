//
//  UserInfoManager.h
//  ArtMedia
//
//  Created by 美术传媒 on 2018/10/25.
//  Copyright © 2018 lcy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoManager : NSObject

@property (nonatomic ,strong) UserInfoModel *_Nullable model;

/// 是否登陆
@property (nonatomic ,assign, readonly) BOOL isLogin;
/// 是否为艺术家
@property (nonatomic ,assign, readonly) BOOL isArtist;
/// 是否实名
@property (nonatomic ,assign, readonly) BOOL isAuthed;
/// 用户uid
@property (nonatomic ,copy, readonly) NSString *uid;
/// 用户邀请码
@property (nonatomic ,copy, readonly) NSString *invitation_code;
/// token
@property (nonatomic ,copy, readonly) NSString *token;

/// 单例
+(instancetype)shareManager;

/// 保存本地的UserData
-(void)saveUserData:(NSDictionary *)userData;

/// 删除本地的UserData
-(void)deleteUserData;

/// 更新本地的UserData
- (void)updateUserDataWithInfo:(NSDictionary *)userInfo complete:(void(^ _Nullable)( UserInfoModel * _Nullable model))complete;
-(void)updateUserDataWithModel:(UserInfoModel *)model complete:(void(^ _Nullable)( UserInfoModel * _Nullable model))complete;
- (void)updateUserDataWithKey:(NSString *)key value:(id)value complete:( void(^ _Nullable)( UserInfoModel * _Nullable model))complete;

/// 读取本地的UserData
- (NSDictionary *)readUserData;
- (UserInfoModel*)readUserDataToModel;

@end

NS_ASSUME_NONNULL_END
