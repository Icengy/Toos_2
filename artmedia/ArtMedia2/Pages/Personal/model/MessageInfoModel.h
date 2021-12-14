//
//  MessageInfoModel.h
//  ArtMedia2
//
//  Created by icnengy on 2020/7/8.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageInfoModel : NSObject

@end

@interface SystemMessageModel : MessageInfoModel

@property (copy, nonatomic) NSString *addtime;
@property (copy, nonatomic) NSString *ID;
@property (assign, nonatomic) BOOL isread;
@property (copy, nonatomic) NSString *jump_id;
@property (copy, nonatomic) NSString *jump_type;
@property (copy, nonatomic) NSString *message_detail;
@property (copy, nonatomic) NSString *message_title;
@property (copy, nonatomic) NSString *mtype;
@property (copy, nonatomic) NSString *radio_type;
@property (copy, nonatomic) NSString *uid;

@end

@interface MessageCollectInfoModel : MessageInfoModel

@property (nonatomic ,copy) NSString *addtime;
@property (nonatomic ,copy) NSString *author_id;
/// 评论/点赞人次
@property (nonatomic ,copy) NSString *be_liked_num;
@property (nonatomic ,copy) NSString *collect_banner;
/// 为对应的具体短视频id，或评论id
@property (nonatomic ,copy) NSString *collect_id;
@property (nonatomic ,copy) NSString *collect_title;
/// 5短视频，8评论
@property (nonatomic ,copy) NSString *collect_type;
@property (nonatomic ,copy) NSString *id;
@property (nonatomic ,copy) NSString *type;
@property (nonatomic ,copy) NSString *uid;
@property (nonatomic ,strong) NSArray <UserInfoModel *> *user_info;

@end

@interface MessageDiscussInfoModel : MessageInfoModel

@property (nonatomic ,copy) NSString *action_text;
@property (nonatomic ,copy) NSString *action_type;
/// 评论人次
@property (nonatomic ,copy) NSString *action_user_num;
@property (nonatomic ,copy) NSString *addtime;
@property (nonatomic ,copy) NSString *id;
/// 0未读，1已读
@property (nonatomic ,copy) NSString *is_read;
@property (nonatomic ,copy) NSString *modify_time;
@property (nonatomic ,copy) NSString *obj_author_id;
@property (nonatomic ,copy) NSString *obj_id;
@property (nonatomic ,copy) NSString *obj_image;
@property (nonatomic ,copy) NSString *obj_title;
@property (nonatomic ,copy) NSString *obj_type;
@property (nonatomic ,strong) NSArray *user_head_images;
@property (nonatomic ,strong) NSArray *user_names;

@end

@interface MessageReplyInfoModel : MessageInfoModel

@property (nonatomic ,strong) NSDictionary *comment;
@property (nonatomic ,strong) NSDictionary *notice;
@property (nonatomic ,strong) NSDictionary *reply;
@property (nonatomic ,strong) NSDictionary *video;

@end

@interface MessageSubModel : MessageInfoModel

/*
 addtime = "<null>";
 id = "<null>";
 isRead = "<null>";
 jumpId = "<null>";
 jumpType = "<null>";
 messageDetail = "<null>";
 messageTitle = "<null>";
 mtype = "<null>";
 sum = 0;
 uid = "<null>";
 userType = "<null>";
 */
@property (nonatomic , copy) NSString *addtime;
@property (nonatomic , copy) NSString *ID;
@property (nonatomic , copy) NSString *isRead;
@property (nonatomic , copy) NSString *jumpId;
@property (nonatomic , copy) NSString *jumpType;
@property (nonatomic , copy) NSString *messageDetail;
@property (nonatomic , copy) NSString *messageTitle;
@property (nonatomic , copy) NSString *mtype;
//@property (nonatomic , copy) NSString *sum;
@property (nonatomic , assign) NSInteger sum;
@property (nonatomic , copy) NSString *uid;
@property (nonatomic , copy) NSString *userType;
@end

NS_ASSUME_NONNULL_END
