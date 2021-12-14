//
//  PersonalDraftCollectionCell.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/17.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "PersonalDraftCollectionCell.h"
#import "VideoListModel.h"

@implementation PersonalDraftCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	
    _lastEditTimeLabel.titleLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
}

- (void)setModel:(VideoListModel *)model {
	_model = model;
	
	[_videoCoverIV am_setImageWithURL:_model.image_url placeholderImage:ImageNamed(@"videoCoverHold") contentMode:UIViewContentModeScaleAspectFill];
    NSString *lastTime = [TimeTool getDifferenceToCurrentSinceTimeStamp:_model.last_modify_time.doubleValue];
	_lastEditTimeLabel.hidden = !lastTime.length;
	if (lastTime.length) {
        _lastEditTimeLabel.hidden = NO;
		NSString *labelText = [NSString stringWithFormat:@"最后编辑:%@前",lastTime];
        [_lastEditTimeLabel setTitle:labelText forState:UIControlStateNormal];
	}else
        _lastEditTimeLabel.hidden = YES;
}


@end
