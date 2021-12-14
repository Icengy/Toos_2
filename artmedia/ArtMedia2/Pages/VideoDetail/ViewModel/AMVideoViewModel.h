//
//  AMVideoViewModel.h
//  AMVideo
//
//  Created by QuintGao on 2018/9/23.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VideoListModel;
NS_ASSUME_NONNULL_BEGIN

@interface AMVideoViewModel : NSObject

@property (nonatomic, assign) BOOL  has_more;

@property (nonatomic ,strong) id superViewController;
@property (nonatomic ,assign) MyVideoShowStyle style;
@property (nonatomic ,copy, nullable)   NSString *urlString;
@property (nonatomic ,strong, nullable) NSDictionary *params;

- (void)refreshAnyVideoDetailWithVideoID:(NSString *)video_id
								 success:(void(^)(VideoListModel * _Nullable model))success
								 failure:(void(^)(NSString * _Nullable errorStr))failure;

- (void)refreshMoreListWithSuccess:(void(^)(NSArray <VideoListModel *> * _Nullable list))success
						   failure:(void(^)(NSError *_Nullable error))failure;

@end

NS_ASSUME_NONNULL_END
