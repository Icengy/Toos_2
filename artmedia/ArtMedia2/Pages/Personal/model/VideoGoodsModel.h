//
//  VideoGoodsModel.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/1.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VideoGoodsImageModel.h"

@class GoodsClassModel;
NS_ASSUME_NONNULL_BEGIN

@interface VideoGoodsModel : NSObject

///商品名称
@property(nonatomic ,copy) NSString *name;
///商品描述
@property(nonatomic ,copy) NSString *describe;
///商品价格
@property(nonatomic ,copy) NSString *price;
///是否包邮
@property(nonatomic ,assign) BOOL freeshipping;
///商品图片（多张）
@property(nonatomic ,strong) NSArray <VideoGoodsImageModel *> *auctionpic;
/// 分级model
@property (nonatomic ,strong) GoodsClassModel *classModel;

///文本协议
@property(nonatomic ,copy) NSString *exemption;

@property (nonatomic ,copy) NSString *remark;
@property (nonatomic ,copy) NSString *check_explain;

///收藏数量
@property(nonatomic ,copy) NSString *collect_count;
///
@property(nonatomic ,copy) NSString *addtime;
///商品banner
@property(nonatomic ,copy) NSString *banner;
///
@property(nonatomic ,copy) NSString *cate_id;
///
@property(nonatomic ,copy) NSString *cate_name;
///
@property(nonatomic ,copy) NSString *delete;
///
@property(nonatomic ,copy) NSString *ID;
///
@property(nonatomic ,copy) NSString *recsort;
///销售数量
@property(nonatomic ,copy) NSString *sellnum;
///销售价格
@property(nonatomic ,copy) NSString *sellprice;
///0未上架 1上架
@property(nonatomic ,assign) BOOL state;
///
@property(nonatomic ,copy) NSString *state_reason;
///
@property(nonatomic ,copy) NSString *state_time;
///0在卖  1已售
@property(nonatomic ,assign) BOOL status;
///库存数量
@property(nonatomic ,copy) NSString *stocknum;
///
@property(nonatomic ,copy) NSString *tid;
///
@property(nonatomic ,copy) NSString *type;
///发布人ID
@property(nonatomic ,copy) NSString *uid;
///发布人姓名
@property(nonatomic ,copy) NSString *uname;
///vip价格
@property(nonatomic ,copy) NSString *vipprice;
///
@property(nonatomic ,copy) NSString *last_modify_time;
///
@property(nonatomic ,copy) NSString *stock_id;
///
@property(nonatomic ,copy) NSString *headimg;
///
@property(nonatomic ,copy) NSString *is_collect;
///
@property(nonatomic ,copy) NSString *signature;
///
@property(nonatomic ,copy) NSString *utype;
///创作日期
@property (nonatomic ,copy) NSString *good_created_time;
/// 0非卖品，1可售卖。
@property (nonatomic ,assign) NSInteger good_sell_type;
/// 艺术品身份证号码
@property (nonatomic ,copy) NSString *good_auth_code;
/// 艺术品身份证路径
@property (nonatomic ,copy) NSString *good_auth_image_path;
/// 作品是否认证
@property (nonatomic ,copy) NSString *good_is_auth;

@end


@interface GoodsClassModel : NSObject

@property (nonatomic ,copy) NSString *id;

@property (nonatomic ,copy) NSString *scate_banner;
@property (nonatomic ,copy) NSString *scate_name;
@property (nonatomic ,copy) NSString *scate_state;
@property (nonatomic ,copy) NSString *tssort;

@property (nonatomic ,copy) NSString *is_direction;
@property (nonatomic ,strong) NSArray <GoodsClassModel *>*secondcate;
@property (nonatomic ,copy) NSString *tcate_banner;
@property (nonatomic ,copy) NSString *tcate_name;

@end

NS_ASSUME_NONNULL_END
