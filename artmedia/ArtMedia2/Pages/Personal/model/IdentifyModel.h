//
//  IdentifyModel.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/14.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ArtsFieldModel;

@interface IdentifyModel : NSObject

/*
 arts = "";
 id = 510;
 "idcard_number" = 413026199410261814;
 "ident_money" = "0.00";
 identexplain = "<null>";
 "identify_type" = 2;
 identstatus = 0;
 imgs =         (
 );
 "invite_uid" = 0;
 mobile = "<null>";
 modifytime = "<null>";
 organization = "<null>";
 "real_name" = "\U674e\U6210\U52c7";
 "self_introduction" = "<null>";
 uid = 746;
 */

@property (nonatomic ,copy) NSString *addtime;
@property (nonatomic ,copy) NSString *modifytime;
@property (nonatomic ,copy) NSString *ID;
///认证类型
@property (nonatomic ,copy) NSString *identify_type;
///
@property (nonatomic ,copy) NSString *uid;
///自我简介
@property (nonatomic ,copy) NSString *self_introduction;
///认证状态
@property (nonatomic ,copy) NSString *identstatus;
///失败信息
@property (nonatomic ,copy) NSString *identexplain;
///真实姓名
@property (nonatomic ,copy) NSString *real_name;
///手机号
@property (nonatomic ,copy) NSString *mobile;
///单位
@property (nonatomic ,copy) NSString *organization;
/// 保证金
@property (nonatomic ,copy) NSString *ident_money;
/// 证书图片数组
@property (nonatomic ,strong) NSArray *imgs;
/// 邀请ID
@property (nonatomic ,copy) NSString *invite_uid;
/// 艺术领域
@property (nonatomic ,strong) ArtsFieldModel *cateinfo;

@end

@interface ArtsFieldModel : NSObject

@property (nonatomic ,copy) NSString *id;

@property (nonatomic ,copy) NSString *scate_banner;
@property (nonatomic ,copy) NSString *scate_name;
@property (nonatomic ,copy) NSString *scate_state;
@property (nonatomic ,copy) NSString *tssort;

@property (nonatomic ,copy) NSString *is_direction;
@property (nonatomic ,strong) NSArray <ArtsFieldModel *>*secondcate;
@property (nonatomic ,copy) NSString *tcate_banner;
@property (nonatomic ,copy) NSString *tcate_name;

@end

NS_ASSUME_NONNULL_END
