//
//  VideoListModel.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/30.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VideoGoodsModel.h"
#import "VideoArtModel.h"
#import "VideoItemSizeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoColumnModel : NSObject

@property(nonatomic ,copy) NSString *id;
@property(nonatomic ,copy) NSString *column_name;

@end

@interface VideoListModel : NSObject

//是否需要生成 YES:是 NO:不是
@property (nonatomic ,assign) BOOL needGenerate;
//是否需要发布 YES:是 NO:不是
@property (nonatomic ,assign) BOOL needPublish;

//是否为再次修改状态 YES:编辑修改模式 NO:不是
@property (nonatomic ,assign) BOOL modify_state;
///是否可以存草稿
@property (nonatomic ,assign) BOOL canSaveDraft;

///是否置顶,0不置顶 1置顶
@property(nonatomic ,copy) NSString *sort;
///
@property(nonatomic ,copy) NSString *ID;

@property(nonatomic ,assign) CGFloat image_width;
@property(nonatomic ,assign) CGFloat image_height;

///是否包含拍品：0否，1是，2已售
@property(nonatomic ,copy) NSString *is_include_obj;
///最后修改时间
@property(nonatomic ,copy) NSString *last_modify_time;
///观看次数
@property(nonatomic ,copy) NSString *play_num;
///视频简介
@property(nonatomic ,copy) NSString *video_des;
///视频长度
@property(nonatomic ,copy) NSString *video_length;
///短视频云存储id
@property(nonatomic ,copy) NSString *video_file_id;
///短视频点播地址
@property(nonatomic ,copy) NSString *video_url;
/// 短视频本地路径
@property(nonatomic,copy)  NSString *video_localurl;
///短视频封面地址
@property(nonatomic ) id image_url;

///审核状态：0未申请，1已申请，2已通过，3审核失败
@property(nonatomic ,copy) NSString *check_state;
@property(nonatomic ,copy) NSString *addtime;
///审核失败原因
@property(nonatomic ,copy) NSString *check_explain;
///审核时间
@property(nonatomic ,copy) NSString *check_time;
///收藏次数
@property(nonatomic ,copy) NSString *collect_num;
///ai审核返回建议：pass：嫌疑度不高，建议直接通过；review：嫌疑度较高，建议人工复核；block：嫌疑度很高，建议直接屏蔽
@property(nonatomic ,copy) NSString *confidence;

///是否已回调：0未回调，1已回调
@property(nonatomic ,copy) NSString *has_been_callback;
///是否已删除：0未删除，1已删除
@property(nonatomic ,copy) NSString *is_delete;
///是否违规：0否，1是
@property(nonatomic ,copy) NSString *is_illegal;
///喜欢次数
@property(nonatomic ,copy) NSString *like_num;
///短视频关联的拍品id
@property(nonatomic ,copy) NSString *obj_id;
///1商品 2拍品
@property(nonatomic ,copy) NSString *obj_type;
///短视频关联的库存id
@property(nonatomic ,copy) NSString *stock_id;
///视频状态：0草稿箱，1发布，2关闭
@property(nonatomic ,copy) NSString *video_state;

///发布者头像
@property(nonatomic ,copy) NSString *headimg;
///发布者uid
@property(nonatomic ,copy) NSString *uid;
///发布者昵称
@property(nonatomic ,copy) NSString *uname;
///是否收藏
@property (nonatomic ,assign) BOOL iscollect;
///是否点赞
@property (nonatomic ,assign) BOOL islike;

///是否认证
@property(nonatomic ,assign) BOOL is_auth;
///已认证编号
@property(nonatomic ,copy) NSString *auth_code;

///是否给该视频献过花
@property (nonatomic ,assign) BOOL isreward;
///当前用户给该视频献花的总数量
@property(nonatomic ,copy) NSString *myrewardnum;
///总献花数量
@property(nonatomic ,copy) NSString *reward_num;
/// 评论数量
@property(nonatomic ,copy) NSString *comment_num;
/// 频道ID column_id
@property(nonatomic ,copy) NSString *column_id;

/// 视频播放-艺术家信息
@property (nonatomic ,strong) VideoArtModel *artModel;
/// 商品信息
@property (nonatomic ,strong) VideoGoodsModel *goodsModel;
/// 首页-图片大小
@property (nonatomic ,strong) VideoItemSizeModel *itemSizeModel;
/// 频道数据
@property (nonatomic ,strong) VideoColumnModel *columnModel;

@end

NS_ASSUME_NONNULL_END
