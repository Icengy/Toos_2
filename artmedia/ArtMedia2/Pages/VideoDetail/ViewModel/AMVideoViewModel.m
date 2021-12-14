//
//  AMVideoViewModel.m
//  AMVideo
//
//  Created by QuintGao on 2018/9/23.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import "AMVideoViewModel.h"
#import "VideoListModel.h"

@interface AMVideoViewModel ()

@end

@implementation AMVideoViewModel {
    NSInteger _pages;
}

- (void)refreshAnyVideoDetailWithVideoID:(NSString *)video_id
                                 success:(void(^)(VideoListModel * _Nullable model))success
                                 failure:(void(^)(NSString * _Nullable errorStr))failure {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"uid"] = [UserInfoManager shareManager].uid;
    params[@"videoid"] = [ToolUtil isEqualToNonNullKong:video_id];
    
    [ApiUtil postWithParent:self.superViewController url:[ApiUtilHeader getVideoDetials] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            VideoListModel *model = [VideoListModel new];
            NSDictionary *videodata = (NSDictionary *)[data objectForKey:@"videodata"];
            if (![videodata isKindOfClass:[NSNull class]] && videodata && videodata.count) {
                model = [VideoListModel yy_modelWithJSON:videodata];
            }
            NSDictionary *artdata = (NSDictionary *)[data objectForKey:@"artdata"];
            if (![artdata isKindOfClass:[NSNull class]] && artdata && artdata.count) {
                model.artModel = [VideoArtModel yy_modelWithJSON:artdata];
            }
            NSDictionary *good_data = (NSDictionary *)[data objectForKey:@"good_data"];
            if (![good_data isKindOfClass:[NSNull class]] && good_data && good_data.count) {
                model.goodsModel = [VideoGoodsModel yy_modelWithJSON:good_data];
            }
            if (success) success(model);
        }else
            if (failure) failure(@"获取视频数据失败，请重试或联系客服");
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        if (failure) failure([ToolUtil isEqualToNonNull:errorMsg]?errorMsg:@"获取视频数据失败");
    }];
}

- (void)refreshMoreListWithSuccess:(void(^)(NSArray <VideoListModel *> * _Nullable list))success
						   failure:(void(^)(NSError *_Nullable error))failure {
    
    if (![ToolUtil isEqualToNonNull:_urlString]) {
        [SVProgressHUD dismiss];
        return;
    }
    if ([_params objectForKey:@"page"]) {
        _pages = [[ToolUtil isEqualToNonNull:_params[@"page"] replace:@"0"] integerValue];
        _pages ++;
        NSMutableDictionary *params = self.params.mutableCopy;
        params[@"page"] = StringWithFormat(@(_pages));
        _params = params.copy;
    }
	
    [ApiUtil postWithParent:self.superViewController url:_urlString params:_params.copy success:^(NSInteger code, id  _Nullable response) {
        NSArray *videos = @[];
        if ([[response objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
            videos = (NSArray *)[response objectForKey:@"data"];
        }else if ([[response objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
            if (data && data.count) {
                videos = (NSArray *)[data objectForKey:@"video"];
            }
        }
        if (videos && videos.count) {
            videos = [NSArray yy_modelArrayWithClass:[VideoListModel class] json:videos];
        }
        if (success) success(videos);
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        if (success) success(nil);
    }];
}

@end
