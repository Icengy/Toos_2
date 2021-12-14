//
//  PersonalCommonCollectionCell.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/17.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "PersonalCommonCollectionCell.h"

#import "VideoListModel.h"
#import "HomeToppedCollectionViewCell.h"


@interface PersonalCommonCollectionCell ()

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIImageView *videoCoverIV;
@property (weak, nonatomic) IBOutlet AMButton *shoppenBtn;
@property (weak, nonatomic) IBOutlet GradientButton *videoTimeLabel;
@property (weak, nonatomic) IBOutlet GradientButton *playCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *videoTitleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;

@end


@implementation PersonalCommonCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	_playCountLabel.titleLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
	_videoTimeLabel.titleLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
	_videoTitleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
}

- (void)setModel:(VideoListModel *)model {
	_model = model;
	
    [_videoCoverIV am_setImageWithURL:_model.image_url placeholderImage:ImageNamed(@"videoCoverHold") contentMode:UIViewContentModeScaleAspectFill];
    if (_model.itemSizeModel) {
        _imageHeightConstraint.constant = _model.itemSizeModel.itemHeight;
    }
    
	_videoTitleLabel.text = [ToolUtil isEqualToNonNullKong:_model.video_des];
	if ([ToolUtil isEqualToNonNull:_model.video_length]) {
		_videoTitleLabel.hidden = NO;
		[_videoTimeLabel setTitle:[TimeTool timeFormatted:[[ToolUtil isEqualToNonNull:_model.video_length replace:@"0"] doubleValue]] forState:UIControlStateNormal];
	}else {
		_videoTitleLabel.hidden = YES;
	}
	if ([ToolUtil isEqualToNonNull:_model.play_num ]) {
		_playCountLabel.hidden = NO;
		[_playCountLabel setTitle:[ToolUtil isEqualToNonNullKong:_model.play_num] forState:UIControlStateNormal];
	}else {
		_playCountLabel.hidden = YES;
	}
	
	//是否包含拍品：0否，1是，2已售
	if ([ToolUtil isEqualToNonNull:_model.is_include_obj] && ![_model.is_include_obj integerValue]) {
		_shoppenBtn.hidden = YES;
	}else {
		_shoppenBtn.hidden = NO;
		_shoppenBtn.backgroundColor = ([_model.is_include_obj integerValue] == 1)?Color_RedA(0.8):Color_GreyLightA(0.8);
	}
}


@end
