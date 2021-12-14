//
//  GoodsDetailModel.h
//  ArtMedia2
//
//  Created by LY on 2020/12/17.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class GoodsCategory;
@class GoodsAtlas;
@class GoodsInfo;
@class GoodsShare;
@class GoodsUserInfo;
@class GoodsVideoList;

@interface GoodsDetailModel : NSObject
/*
 {
     category =         {
         "scate_name" = "花鸟";
         sid = 58;
         "tcate_name" = "国画";
         tid = 13;
     };
     exemption =         {
         content = "<p style=\"margin-top:5px;margin-bottom:5px\"><span style=\";font-family:宋体;font-size:16px\"><span style=\"font-family:宋体\">免责声明</span></span></p><p style=\"margin-top:5px;margin-bottom:5px\"><span style=\";font-family:宋体;font-size:16px\">1. “</span><span style=\";font-family:宋体;font-size:16px\"><span style=\"font-family:宋体\">艺术</span></span><span style=\";font-family:宋体;font-size:16px\"><span style=\"font-family:宋体\">融媒体</span>”仅作为交易活动的支持平台。</span></p><p style=\"margin-top:5px;margin-bottom:5px\"><span style=\";font-family:宋体;font-size:16px\">2. 真伪：认证艺术家的资质已经过平台审核，但艺术品详情介绍为艺术家自行提供，艺术家就艺术品的真伪、品质及相关信息承担全部保证责任。</span></p><p style=\"margin-top:5px;margin-bottom:5px\"><span style=\";font-family:宋体;font-size:16px\">3. 售后：鉴于艺术品的特殊性，买家在购买前应当考虑充分；收货时，请务必当面确认艺术品有无损坏。如因运输过程中造成艺术品损坏，买家提供相关照片后，由卖家负责相关赔付。</span></p><p><br/></p>";
     };
     "good_atlas" =         (
                     {
             aaddtime = 1608171595;
             agid = 409;
             aid = 606;
             aimgsrc = "/Upload/other/20201217/5fdac04b5a1b6.jpeg";
             amimgsrc = "/Upload/other/20201217/m_5fdac04b5a1b6.jpeg";
             asimgsrc = "/Upload/other/20201217/s_5fdac04b5a1b6.jpeg";
             asort = 0;
             astate = 0;
             atype = 1;
         }
     );
     "good_info" =         {
         gbanner = "/Upload/other/20201217/s_5fdac04b5a1b6.jpeg";
         "gcate_id" = 58;
         "gcate_name" = "花鸟";
         gdescribe = on;
         gfreeshipping = 1;
         gid = 409;
         gname = "弄";
         "good_auth_code" = 64G1KS09;
         "good_auth_image_path" = "/Upload/production/good_auth_image/5fdac04bc055f.png";
         "good_created_time" = "暂无";
         "good_is_auth" = 1;
         "good_sell_type" = 1;
         gsellprice = 1;
         gstatus = 0;
         guid = 768;
     };
     share =         {
         des = on;
         img = "/Upload/other/20201217/s_5fdac04b5a1b6.jpeg";
         title = "弄";
         url = "https://test.ysrmt.cn/wechat/#/appShare/goodDetail?uid=0&good_id=409";
     };
     "user_info" =         {
         "fans_num" = 4;
         "goods_num" = 8;
         headimg = "/Upload/other/20201208/5fcf23e5f3db3.jpeg";
         id = 768;
         "is_collected" = 0;
         uname = "游客098596";
         utype = 3;
     };
     "video_list" =         (
                     {
             id = 721;
             "image_url" = "http://1259188522.vod2.myqcloud.com/6421ce2dvodcq1259188522/b2dd0cee5285890811424487517/5285890811424487518.jpg";
             "video_file_id" = 5285890811424487517;
             "video_url" = "http://1259188522.vod2.myqcloud.com/3b0bbbd5vodtranscq1259188522/b2dd0cee5285890811424487517/v.f30.mp4";
         }
     );
 }
 */

@property (nonatomic , copy) NSString *exemptionContent;
@property (nonatomic , strong) GoodsCategory *category;
@property (nonatomic , strong) NSArray <GoodsAtlas *> *goodAtlas;
@property (nonatomic , strong) GoodsInfo *goodInfo;
@property (nonatomic , strong) GoodsShare *share;
@property (nonatomic , strong) GoodsUserInfo *userInfo;
@property (nonatomic , strong) NSArray <GoodsVideoList *> *videoList;
@end



@interface GoodsCategory : NSObject

@property (nonatomic , copy) NSString *scate_name;
@property (nonatomic , copy) NSString *sid;
@property (nonatomic , copy) NSString *tcate_name;
@property (nonatomic , copy) NSString *tid;
@end

@interface GoodsAtlas : NSObject

@property (nonatomic , copy) NSString *aaddtime;
@property (nonatomic , copy) NSString *agid;
@property (nonatomic , copy) NSString *aid;
@property (nonatomic , copy) NSString *aimgsrc;
@property (nonatomic , copy) NSString *amimgsrc;
@property (nonatomic , copy) NSString *asimgsrc;
@property (nonatomic , copy) NSString *asort;
@property (nonatomic , copy) NSString *astate;
@property (nonatomic , copy) NSString *atype;
@property (nonatomic , assign) CGFloat pic_height;
@property (nonatomic , assign) CGFloat pic_width;
@end

@interface GoodsInfo : NSObject

@property (nonatomic , copy) NSString *gbanner;
@property (nonatomic , copy) NSString *gcate_id;
@property (nonatomic , copy) NSString *gcate_name;
@property (nonatomic , copy) NSString *gdescribe;
@property (nonatomic , copy) NSString *gfreeshipping;
@property (nonatomic , copy) NSString *gid;
@property (nonatomic , copy) NSString *gname;
@property (nonatomic , copy) NSString *good_auth_code;
@property (nonatomic , copy) NSString *good_auth_image_path;
@property (nonatomic , copy) NSString *good_created_time;
@property (nonatomic , copy) NSString *good_is_auth;
@property (nonatomic , assign) BOOL good_sell_type;
@property (nonatomic , copy) NSString *gsellprice;
@property (nonatomic , copy) NSString *gstatus;
@property (nonatomic , copy) NSString *guid;
@end

@interface GoodsShare : NSObject
@property (nonatomic , copy) NSString *des;
@property (nonatomic , copy) NSString *img;
@property (nonatomic , copy) NSString *title;
@property (nonatomic , copy) NSString *url;
@end

@interface GoodsUserInfo : NSObject
@property (nonatomic , copy) NSString *fans_num;
@property (nonatomic , copy) NSString *goods_num;
@property (nonatomic , copy) NSString *headimg;
@property (nonatomic , copy) NSString *userId;
@property (nonatomic , copy) NSString *is_collected;
@property (nonatomic , copy) NSString *uname;
@property (nonatomic , copy) NSString *utype;
@end

@interface GoodsVideoList : NSObject
@property (nonatomic , copy) NSString *videoId;
@property (nonatomic , copy) NSString *image_url;
@property (nonatomic , copy) NSString *video_file_id;
@property (nonatomic , copy) NSString *video_url;

@end



NS_ASSUME_NONNULL_END
