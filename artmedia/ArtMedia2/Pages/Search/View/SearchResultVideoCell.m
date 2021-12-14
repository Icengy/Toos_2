//
//  SearchResultVideoCell.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/15.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "SearchResultVideoCell.h"

#import "VideoListModel.h"

@interface SearchResultVideoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageIV;

@property (weak, nonatomic) IBOutlet UILabel *videoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *playCountBtn;
@property (weak, nonatomic) IBOutlet UIButton *canBuyBtn;

@end

@implementation SearchResultVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	_videoTitleLabel.font = [UIFont addHanSanSC:16.0f fontType:0];
	_nameLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
	_playCountBtn.titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
	
	_imageIV.backgroundColor = [UIColor blackColor];
	_imageIV.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(VideoListModel *)model {
	_model = model;
	
	[_imageIV am_setImageWithURL:_model.image_url placeholderImage:ImageNamed(@"videoCoverHold") contentMode:UIViewContentModeScaleAspectFit];
	
	_videoTitleLabel.text = [ToolUtil isEqualToNonNullKong:_model.video_des];
    _nameLabel.text = [ToolUtil isEqualToNonNullKong:_model.uname];
	
	[_playCountBtn setTitle:[ToolUtil isEqualToNonNullKong:_model.play_num] forState:UIControlStateNormal];
	switch ([_model.is_include_obj integerValue]) {
		case 0:
			_canBuyBtn.hidden = YES;
			break;
		case 1: {
			_canBuyBtn.hidden = NO;
			_canBuyBtn.selected = YES;
			break;
		}
		case 2: {
			_canBuyBtn.hidden = NO;
			_canBuyBtn.selected = NO;
			break;
		}
			
		default:
			break;
	}
	
}

@end
