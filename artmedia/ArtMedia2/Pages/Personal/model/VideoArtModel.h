//
//  VideoArtModel.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/5.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

///配合视频播放页面使用
@interface VideoArtModel : NSObject

///艺术家粉丝数
@property(nonatomic ,copy) NSString *fans_num;
///艺术家头像
@property(nonatomic ,copy) NSString *headimg;
///艺术家ID
@property(nonatomic ,copy) NSString *ID;
///艺术家昵称
@property(nonatomic ,copy) NSString *art_name;
///艺术家简介
@property(nonatomic ,copy) NSString *signature;
///艺术家类型 =3已认证
@property (nonatomic ,copy) NSString *utype;
///艺术家是否关注
@property(nonatomic ,assign) BOOL is_collect;

@property (nonatomic ,copy) NSString *artist_title;

@end

NS_ASSUME_NONNULL_END
