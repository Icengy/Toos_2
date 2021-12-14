//
//  ArtWorkListModel.h
//  ArtMedia2
//
//  Created by LY on 2020/12/17.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArtWorkListModel : NSObject
/*
 des = "看看";
 gbanner = "/Upload/other/20200808/m_5f2e3afd0ecbd.jpg";
 gid = 162;
 gname = "里";
 "good_auth_code" = T86WSUD1;
 "good_is_auth" = 1;
 "good_sell_type" = 0;
 gsellprice = 2000;
 gstatus = 1;
 "pic_height" = 1080;
 "pic_width" = 607;
 */

@property (nonatomic , copy) NSString *des;
@property (nonatomic , copy) NSString *gbanner;
@property (nonatomic , copy) NSString *gid;
@property (nonatomic , copy) NSString *gname;
@property (nonatomic , copy) NSString *good_auth_code;
@property (nonatomic , assign) BOOL good_is_auth;
@property (nonatomic , assign) BOOL good_sell_type;
@property (nonatomic , copy) NSString *gsellprice;
@property (nonatomic , copy) NSString *gstatus;
@property (nonatomic , assign) CGFloat pic_height;
@property (nonatomic , assign) CGFloat pic_width;
@end

NS_ASSUME_NONNULL_END
