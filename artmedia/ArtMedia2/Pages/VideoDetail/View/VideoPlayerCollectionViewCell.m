//
//  VideoPlayerCollectionViewCell.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/25.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "VideoPlayerCollectionViewCell.h"

#import "VideoListModel.h"

#import "AMVideoControlIerItemView.h"

@interface VideoPlayerCollectionViewCell () <AMVideoControlIerItemViewDelegate,ZFSliderViewDelegate>
@property (weak, nonatomic) IBOutlet AMVideoControlIerItemView *itemView;

@end

@implementation VideoPlayerCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.itemView.delegate = self;
    self.itemView.sliderDelegate = self;
}

- (AMVideoControlIerItemView *)controlView {
    return self.itemView;
}

- (void)setVideoModel:(VideoListModel *)videoModel {
	_videoModel = videoModel;
	self.itemView.model = _videoModel;
}

#pragma mark - AMVideoControlItemDelegate
- (void)controlViewDidClickSelf:(id)sender {
	if ([self.delegate respondsToSelector:@selector(didClickForPlayControl:)]) {
		[self.delegate didClickForPlayControl:nil];
	}
}

- (void)controlViewDidClickBack:(id)sender {
    if ([self.delegate respondsToSelector:@selector(videoCell:didClickBack:)]) {
        [self.delegate videoCell:self didClickBack:sender];
    }
}

///更多
- (void)controlViewDidClickMore:(id)sender {
    if ([self.delegate respondsToSelector:@selector(videoCell:didClickMore:)]) {
        [self.delegate videoCell:self didClickMore:_videoModel];
    }
}

///喜欢
- (void)controlViewDidClickLike:(id)sender {
    if ([self.delegate respondsToSelector:@selector(videoCell:didClickLike:model:atIndexPath:)]) {
		[self.delegate videoCell:self didClickLike:sender model:_videoModel atIndexPath:self.currentIndexPath];
	}
}
///评论
- (void)controlViewDidClickTalk:(id)sender {
    if ([self.delegate respondsToSelector:@selector(videoCell:didClickDiscuss:atIndexPath:)]) {
        [self.delegate videoCell:self didClickDiscuss:_videoModel atIndexPath:self.currentIndexPath];
    }
}

/// 分享
- (void)controlViewDidClickShare:(id)sender {
    if ([self.delegate respondsToSelector:@selector(videoCell:didClickShare:)]) {
        [self.delegate videoCell:self didClickShare:_videoModel];
    }
}

///购物
- (void)controlViewDidClickGoods:(id)sender {
	if ([self.delegate respondsToSelector:@selector(videoCell:didClickShopping:)]) {
		[self.delegate videoCell:self didClickShopping:_videoModel];
	}
}

///个人中心
- (void)controlViewDidClickPersonal:(id)sender {
	if ([self.delegate respondsToSelector:@selector(videoCell:didClickPersonal:)]) {
		[self.delegate videoCell:self didClickPersonal:_videoModel];
	}
}
///关注
- (void)controlViewDidClickFollow:(id)sender {
	if ([self.delegate respondsToSelector:@selector(videoCell:didClickFollow:atIndexPath:)]) {
		[self.delegate videoCell:self didClickFollow:_videoModel atIndexPath:self.currentIndexPath];
	}
}

- (void)controlViewDidClickCreateTalk:(id)sender {
    if ([self.delegate respondsToSelector:@selector(videoCell:didClickCreateTalk:atIndexPath:)]) {
        [self.delegate videoCell:self didClickCreateTalk:_videoModel atIndexPath:self.currentIndexPath];
    }
}

#pragma mark - ZFSliderViewDelegate
// 滑块滑动结束
- (void)sliderTouchEnded:(float)value
{
    NSLog(@"滑块滑动结束：%.2lf",value);
    if (self.sliderDelegate && [self.sliderDelegate respondsToSelector:@selector(sliderTouchEnded:)]) {
        [self.sliderDelegate sliderTouchEnded:value];
    }
}

@end
