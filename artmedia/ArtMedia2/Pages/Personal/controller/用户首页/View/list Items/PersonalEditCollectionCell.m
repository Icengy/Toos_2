//
//  PersonalEditCollectionCell.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/17.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "PersonalEditCollectionCell.h"

#import "VideoListModel.h"
#import "HomeToppedCollectionViewCell.h"

@implementation PersonalEditCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	
	_checkStatusLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
	_videoTimeLabel.titleLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
	_playCountLabel.titleLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
	_videoTitleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
	_editBtn.titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
	_deleteBtn.titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
	_statusBtn.titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
}

- (void)setModel:(VideoListModel *)model {
	_model = model;
	[_videoCoverIV am_setImageWithURL:_model.image_url placeholderImage:ImageNamed(@"videoCoverHold") contentMode:UIViewContentModeScaleAspectFill];
	_shoppenBtn.hidden = ![_model.is_include_obj boolValue];
	
	if ([ToolUtil isEqualToNonNull:_model.video_length ]) {
		_videoTimeLabel.hidden = NO;
		[_videoTimeLabel setTitle:[TimeTool timeFormatted:[[ToolUtil isEqualToNonNull:_model.video_length replace:@"0"] doubleValue]] forState:UIControlStateNormal];
	}else {
		_videoTimeLabel.hidden = YES;
	}
	if ([ToolUtil isEqualToNonNull:_model.play_num ]) {
		_playCountLabel.hidden = NO;
		[_playCountLabel setTitle:[ToolUtil isEqualToNonNullKong:_model.play_num] forState:UIControlStateNormal];
	}else {
		_playCountLabel.hidden = YES;
	}
	
	_videoTitleLabel.text = [ToolUtil isEqualToNonNullKong:_model.video_des];
	
	//0未申请，1已申请，2已通过，3审核失败
	switch ([_model.check_state integerValue]) {
		case 0:
		case 2:
			[self setCheckStatusHidden:YES];
			break;
		case 1: {
			_checkStatusLabel.text = @"待审核";
			_checkStatusLabel.backgroundColor = [RGB(17,103,219) colorWithAlphaComponent:0.8];
			[self setCheckStatusHidden:NO];
			break;
		}
		case 3: {
			_checkStatusLabel.text = @"审核未通过";
			_checkStatusLabel.backgroundColor = [Color_GreyLight colorWithAlphaComponent:0.8];
			[self setCheckStatusHidden:NO];
			break;
		}
			
		default:
			break;
	}
	
	//是否包含拍品：0否，1是，2已售
    _shoppenBtn.hidden = !_model.is_include_obj.integerValue;
    if ([ToolUtil isEqualToNonNull:_model.is_include_obj replace:@"0"].integerValue == 2) {
        _statusBtn.hidden = NO;
        _editBtn.hidden = YES;
        _deleteBtn.hidden = YES;
        _shoppenBtn.backgroundColor = Color_GreyLightA(0.8);
	}else {
		_shoppenBtn.backgroundColor = ([_model.is_include_obj integerValue] == 1)?Color_RedA(0.8):Color_GreyLightA(0.8);
        _statusBtn.hidden = YES;
        _editBtn.hidden = NO;
        _deleteBtn.hidden = NO;
	}
}

- (void)setCheckStatusHidden:(BOOL)hidden {
	_checkStatusLabel.hidden = hidden;
	_videoTimeLabel.hidden = !hidden;
	_playCountLabel.hidden = !hidden;
	_shoppenBtn.hidden = !hidden;
}

- (IBAction)clickToEditVideo:(AMButton *)sender {
	if (_editVideoBlock) _editVideoBlock(_model);
}

- (IBAction)clickToDeleteVideo:(AMButton *)sender {
	if (_deleteVideoBlock) _deleteVideoBlock(_model);
}


@end
