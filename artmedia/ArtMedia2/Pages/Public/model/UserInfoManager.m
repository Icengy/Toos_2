//
//  UserInfoManager.m
//  ArtMedia
//
//  Created by 美术传媒 on 2018/10/25.
//  Copyright © 2018 lcy. All rights reserved.
//

#import "UserInfoManager.h"

@implementation UserInfoManager

static UserInfoManager*manager=nil;

static NSString * const USER_INFO = @"UserInfo";
static NSString * const PHONE_NUM = @"PhoneNum";

+(instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

- (UserInfoModel *)model {
	if (!_model) {
		_model = [self readUserDataToModel];
	}
	return _model;
}

#pragma mark - 增
-(void)saveUserData:(NSDictionary *)userData {
	/*
	 clientid = "<null>";用户设备号，用来作为推送标识
	 "device_type" = 0;用户设备类型：0其它设备，1安卓设备，2苹果设备。
	 headimg = "/Upload/indentifyImg/20190929/5d90008b57b3b.jpg";
	 id = 237;
	 "is_lock" = 0;是否禁止：0未禁止，1禁止上拍，2禁止参拍，3禁止提现，4同时禁止以上所有。
	 mobile = 13018936326;
	 password = 28704e534d93e2002ce2e6d536681254;用户密码md5加密后的字符串，没设置过密码则为null。
	 signature = "\U4ed6\U5f88\U61d2\Uff0c\U4ec0\U4e48\U90fd\U6ca1\U6709\U8bf4\U54e6...";
	 uname = "\U6e38\U5ba2018685";
	 userstatus = 0;用户状态：0正常，1禁止发私信，2禁止登陆。
	 utype = 1;用户类型：1普通用户，2商家（暂不用），3艺术家。
     mscmToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJhZG1pbiIsImlhdCI6MTYwMDQ4NDY4MiwiZXhwIjoxNjAzMDc2NjgyLCJuYmYiOjE2MDA0ODQ2ODIsInN1YiI6Ijc0NiIsImp0aSI6IjYwNTNhNzQ4ZGRlNzU2YTIxMmY4NmQyMGIyODkzZThlIn0.eC5UQIjh9IcS1Z__71hryULToFVg_dXuNcfNkpWGh40";
	 */
    NSMutableDictionary *userDatas = userData.mutableCopy;
    for(NSString*str in userDatas.allKeys) {
        id value = [userDatas objectForKey:str];
        if(![ToolUtil isEqualToNonNull:value]) {
            [userDatas removeObjectForKey:str];
            [userDatas setObject:@"" forKey:str];
        }
        if ([str isEqualToString:@"mobile"]) {
            AMUserDefaultsSetObject([ToolUtil isEqualToNonNullKong:value], AMPhoneDefaults);
        }
    }
	AMUserDefaultsSetObject(userDatas.copy, USER_INFO);
	AMUserDefaultsSynchronize;
}

#pragma mark - 删
- (void)deleteUserData {
    [AMUserDefaults removeObjectForKey:USER_INFO];
    _model = nil;
}

#pragma mark - 改
- (void)updateUserDataWithInfo:(NSDictionary *)userInfo complete:(void (^ _Nullable)(UserInfoModel * _Nullable))complete {
    [self saveUserData:userInfo];
    
    self.model = nil;
    self.model = [self readUserDataToModel];
    if (complete) complete(_model);
}

- (void)updateUserDataWithKey:(NSString *)key value:(id)value complete:(void (^ _Nullable)(UserInfoModel * _Nullable))complete {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:AMUserDefaultsObjectForKey(USER_INFO)];
    if (userInfo && userInfo.count) {
        [userInfo.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([key isEqualToString:obj]) {
                [userInfo setObject:value forKey:obj];
                *stop = YES;
            }
        }];
        AMUserDefaultsSetObject(userInfo.copy, USER_INFO);
        AMUserDefaultsSynchronize;
    }
    self.model = nil;
    self.model = [self readUserDataToModel];
    if (complete) complete(_model);
}

- (void)updateUserDataWithModel:(UserInfoModel *)model complete:(void (^ _Nullable)(UserInfoModel * _Nullable))complete {
	NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:AMUserDefaultsObjectForKey(USER_INFO)];
	NSDictionary *dict = [model yy_modelToJSONObject];
	if (dict && dict.allKeys) {
		[dict.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			[userInfo setObject:[dict objectForKey:obj] forKey:obj];
		}];
		AMUserDefaultsSetObject(userInfo.copy, USER_INFO);
		AMUserDefaultsSynchronize;
	}
    self.model = nil;
    self.model = [self readUserDataToModel];
    if (complete) complete(_model);
}

#pragma mark - 查
- (NSDictionary *)readUserData {
    NSDictionary *userInfo = AMUserDefaultsObjectForKey(USER_INFO);
    return (userInfo && userInfo.count)? userInfo:@{};
}

- (UserInfoModel*)readUserDataToModel {
    NSDictionary *dic = [AMUserDefaultsObjectForKey(USER_INFO) yy_modelToJSONObject];
    UserInfoModel *model = [UserInfoModel yy_modelWithJSON:dic];
	return model;
}

#pragma mark -
- (BOOL)isLogin {
    return (self.model && [ToolUtil isEqualToNonNull:self.model.id])?YES:NO;
}

- (BOOL)isArtist {
    return (self.model && [ToolUtil isEqualToNonNull:self.model.utype] && self.model.utype.integerValue > 2)?YES:NO;
}

- (BOOL)isAuthed {
    return (self.model && self.model.is_auth.boolValue)?YES:NO;
}

- (NSString *)uid {
    if (self.model) return [ToolUtil isEqualToNonNullKong:self.model.id];
    return @"";
}

- (NSString *)invitation_code {
    if (self.model) return [ToolUtil isEqualToNonNullKong:self.model.invitation_code];
    return @"";
}

- (NSString *)token {
    if (self.model) return [ToolUtil isEqualToNonNullKong:self.model.token];
    return @"";
}


@end
