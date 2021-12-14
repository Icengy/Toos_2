//
//  UserInfoModel.h
//  ArtMedia
//
//  Created by 美术传媒 on 2018/10/25.
//  Copyright © 2018 lcy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserAuthInfoModel : NSObject

@property (nonatomic ,copy) NSString *addtime;
@property (nonatomic ,copy) NSString *face_image;
@property (nonatomic ,copy) NSString *id;
@property (nonatomic ,copy) NSString *id_card_number;
@property (nonatomic ,copy) NSString *mobile;
@property (nonatomic ,copy) NSString *real_name;
@property (nonatomic ,copy) NSString *sim;
@property (nonatomic ,copy) NSString *user_id;
@property (nonatomic ,copy) NSString *verify_type;

@end

@interface UserInfoModel : NSObject

@property (nonatomic ,copy) NSString *addtime;
///
@property (nonatomic ,copy) NSString *agent_type;
///
@property (nonatomic ,copy) NSString *artist_title;
///
@property (nonatomic ,copy) NSString *clientid;
///
@property (nonatomic ,copy) NSString *invitation_code;
///
@property (nonatomic ,copy) NSString *device_type;
///
@property (nonatomic ,copy) NSString *direction;
///
@property (nonatomic ,copy) NSString *introduce;
///
@property (nonatomic ,copy) NSString *is_add;
///
@property (nonatomic ,copy) NSString *is_delete;
///
@property (nonatomic ,copy) NSString *is_free_margin;
///
@property (nonatomic ,copy) NSString *is_ident_agent;
///
@property (nonatomic ,copy) NSString *is_lock;
///
@property (nonatomic ,copy) NSString *is_auth;
///
@property (nonatomic ,copy) NSString *last_modify_time;
///
@property (nonatomic ,copy) NSString *last_sync_date;//计算几天前活跃
///手机号
@property (nonatomic ,copy) NSString *mobile;
///
@property (nonatomic ,copy) NSString *msgcount;
///
@property (nonatomic ,copy) NSString *openid;
///
@property (nonatomic ,copy) NSString *password;
///
@property (nonatomic ,copy) NSString *reg_ip;
///
@property (nonatomic ,copy) NSString *sort;
///未读消息数量
@property (nonatomic ,copy) NSString *unreadmsgcount;
///
@property (nonatomic ,copy) NSString *user_type_endtime;
///
@property (nonatomic ,copy) NSString *usercommission;
///用户登录
@property (nonatomic ,copy) NSString *userstatus;
///视频封面
@property (nonatomic ,copy) NSString *video_image;
///视频地址
@property (nonatomic ,copy) NSString *video_url;
///微信openid
@property (nonatomic ,copy) NSString *wechatid;
///微信是否绑定
@property (nonatomic ,assign) BOOL is_bind_wechat;
///是否关注
@property (nonatomic ,assign) BOOL is_collect;
///被关注人ID
@property (nonatomic ,copy) NSString *cuid;
@property (nonatomic ,copy) NSString *id;
///背景图
@property (nonatomic ,copy) NSString *back_img;
///用户头像
@property (nonatomic ,copy) NSString *headimg;
///粉丝数
@property (nonatomic ,copy) NSString *fans_num;
///关注数
@property (nonatomic ,copy) NSString *followcount;
///作品数量
@property (nonatomic ,copy) NSString *goods_num;
///获赞数
@property (nonatomic ,copy) NSString *like_num;
///
@property (nonatomic ,copy) NSString *signature;
///用户昵称
@property (nonatomic ,copy) NSString *username;
///用户类型 1、普通用户 2、经纪人 3、艺术家
@property (nonatomic ,copy) NSString *utype;
///访问数量
@property (nonatomic ,copy) NSString *visit_num;
///是否被拉黑
@property (nonatomic ,assign) BOOL is_blacklist;
/// 新增粉丝数量
@property (nonatomic ,copy) NSString *newfanscount;
/// 认证状态 0未实名 1未提交认证资料（可以点击认证） 2申请中 3申请未通过 4申请通过，未缴费 5认证通过
@property (nonatomic ,copy) NSString *ident_state;
/// 登录token
@property (nonatomic ,copy) NSString *token;

///真实姓名
@property (nonatomic ,strong) UserAuthInfoModel *auth_data;


/// 用户按钮状态 1:约见 2:已预约 3:不显示"
@property (nonatomic, assign) NSInteger orderBtnStatus;
/// 最后活跃时间
@property (nonatomic, copy) NSString *updatetime;
/// 是否显示用户‘更多信息’ 0:不显示1:显示
@property (nonatomic, copy) NSString *if_has_introduce;

@end

NS_ASSUME_NONNULL_END
