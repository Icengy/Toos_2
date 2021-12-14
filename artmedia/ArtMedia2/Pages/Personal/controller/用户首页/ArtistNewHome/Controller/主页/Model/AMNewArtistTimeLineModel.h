//
//  AMNewArtistTimeLineModel.h
//  ArtMedia2
//
//  Created by 刘洋 on 2020/9/14.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AMNewArtistTimeLineModel : NSObject
/*
 id = "<null>";
 optContent = "将开启新一期的会客";
 optTime = "2020-09-14 13:35:00";
 optUserId = "<null>";
 optUserName = "<null>";
 teaAboutInfoId = "<null>";
 */
@property (nonatomic , copy) NSString *ID;
@property (nonatomic , copy) NSString *optContent;
@property (nonatomic , copy) NSString *optTime;
@property (nonatomic , copy) NSString *optUserId;
@property (nonatomic , copy) NSString *optUserName;
@property (nonatomic , copy) NSString *teaAboutInfoId;
@end

NS_ASSUME_NONNULL_END
