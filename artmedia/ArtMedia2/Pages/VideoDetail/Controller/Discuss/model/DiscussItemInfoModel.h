//
//  DiscussItemInfoModel.h
//  ArtMedia2
//
//  Created by icnengy on 2020/7/9.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DiscussItemInfoModel : NSObject

@property (copy, nonatomic)  NSString *addtime;
@property (copy, nonatomic)  NSString *id;
/// 是否作者，0否，1是
@property (copy, nonatomic)  NSString *is_author;
@property (copy, nonatomic)  NSString *is_delete;
@property (copy, nonatomic)  NSString *user_id;
@property (strong, nonatomic)  UserInfoModel *user_info;

#pragma mark - 评论
/// 被举报次数
@property (copy, nonatomic)  NSString *be_reported_num;
@property (copy, nonatomic)  NSString *comm_state;
/// 评论
@property (copy, nonatomic)  NSString *comment;
/// 点赞次数
@property (copy, nonatomic)  NSString *like_num;
@property (copy, nonatomic)  NSString *obj_id;
@property (copy, nonatomic)  NSString *obj_type;
@property (strong, nonatomic)  NSArray<DiscussItemInfoModel *> *reply_data;
/// 回复数量
@property (copy, nonatomic)  NSString *reply_num;
/// 折叠隐藏的回复条数
@property (copy, nonatomic)  NSString *un_see_num;
/// 0未赞，1已赞
@property (copy, nonatomic)  NSString *is_liked;

#pragma mark - 回复
/// 评论ID
@property (copy, nonatomic)  NSString *comment_id;
/// 回复
@property (copy, nonatomic)  NSString *reply_comment;
@property (copy, nonatomic)  NSString *reply_stat;
@property (copy, nonatomic)  NSString *reply_type;
@property (copy, nonatomic)  NSString *to_reply_id;
@property (copy, nonatomic)  NSString *to_user_id;
@property (strong, nonatomic)  UserInfoModel *to_user_info;
@end

NS_ASSUME_NONNULL_END
