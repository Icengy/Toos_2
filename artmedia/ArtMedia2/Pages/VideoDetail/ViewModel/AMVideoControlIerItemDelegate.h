//
//  AMVideoControlIerItemDelegate.h
//  ArtMedia2
//
//  Created by icnengy on 2020/10/28.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VideoListModel;
@class VideoPlayerCollectionViewCell;
@class AMVideoControlIerItemView;

NS_ASSUME_NONNULL_BEGIN

@protocol AMVideoControlIerItemViewDelegate <NSObject>

@required
- (void)controlViewDidClickSelf:(id)sender;

- (void)controlViewDidClickBack:(id)sender;//返回
- (void)controlViewDidClickMore:(id)sender;//更多

- (void)controlViewDidClickGoods:(id)sender;//购买

- (void)controlViewDidClickPersonal:(id)sender;//个人中心
- (void)controlViewDidClickFollow:(id)sender;//关注

- (void)controlViewDidClickLike:(id)sender;//喜欢
- (void)controlViewDidClickTalk:(id)sender;//评论
- (void)controlViewDidClickShare:(id)sender;//分享

- (void)controlViewDidClickCreateTalk:(id)sender;//发起评论

@optional
- (void)controlViewDidClickGift:(id)sender;//礼物

@end

@protocol VideoPlayerCellDelegate <NSObject>

- (void)resetVideoModel:(VideoListModel *)newVideoModel atIndexPath:(NSIndexPath *)indexPath;
- (void)didClickForPlayControl:(id _Nullable)sender;

@optional

//- (void)videoCell:(VideoPlayerCollectionViewCell *)cell didClickCollect:(VideoListModel *)videoModel atIndexPath:(NSIndexPath *)indexPath;//收藏
- (void)videoCell:(VideoPlayerCollectionViewCell *)cell didClickLike:(AMButton *)sender model:(VideoListModel *)videoModel atIndexPath:(NSIndexPath *)indexPath;//喜欢
- (void)videoCell:(VideoPlayerCollectionViewCell *)cell didClickDiscuss:(VideoListModel *)videoModel atIndexPath:(NSIndexPath *)indexPath;//评论
//- (void)videoCell:(VideoPlayerCollectionViewCell *)cell didClickGift:(VideoListModel *)videoModel atIndexPath:(NSIndexPath *)indexPath;//送花
- (void)videoCell:(VideoPlayerCollectionViewCell *)cell didClickShopping:(VideoListModel *)videoModel;//商品详情
- (void)videoCell:(VideoPlayerCollectionViewCell *)cell didClickShare:(VideoListModel *)videoModel;//分享


- (void)videoCell:(VideoPlayerCollectionViewCell *)cell didClickPersonal:(VideoListModel *)videoModel;//个人中心
- (void)videoCell:(VideoPlayerCollectionViewCell *)cell didClickFollow:(VideoListModel *)videoModel atIndexPath:(NSIndexPath *)indexPath;//关注

- (void)videoCell:(VideoPlayerCollectionViewCell *)cell didClickBack:(id _Nullable)sender;//返回
- (void)videoCell:(VideoPlayerCollectionViewCell *)cell didClickMore:(VideoListModel *)videoModel;//更多

- (void)videoCell:(VideoPlayerCollectionViewCell *)cell didClickCreateTalk:(VideoListModel *)videoModel atIndexPath:(NSIndexPath *)indexPath;//更多


@end


@protocol ZFSliderViewDelegate <NSObject>

@optional
// 滑块滑动开始
- (void)sliderTouchBegan:(float)value;
// 滑块滑动中
- (void)sliderValueChanged:(float)value;
// 滑块滑动结束
- (void)sliderTouchEnded:(float)value;
// 滑杆点击
- (void)sliderTapped:(float)value;

@end

NS_ASSUME_NONNULL_END
