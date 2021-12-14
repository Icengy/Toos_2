//
//  GiftListTableViewCell.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/26.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "GiftListTableViewCell.h"

@interface GiftRankListModel ()

@end

@implementation GiftRankListModel

@end

@interface GiftListTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *sortView;
@property (weak, nonatomic) IBOutlet UIImageView *usericonIV;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *giftCountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giftCountWidthConstraint;

@end

@implementation GiftListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	self.backgroundColor = [UIColor clearColor];
	
	_usericonIV.layer.borderColor = Color_Whiter.CGColor;
	_usericonIV.layer.borderWidth = 1.0f;
	_usericonIV.clipsToBounds = YES;
	_usericonIV.layer.cornerRadius = _usericonIV.height/2;
	NSLog(@"_usericonIV.height = %.2f",_usericonIV.height);
	
	_userNameLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
	_giftCountLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(GiftRankListModel *)model {
	_model = model;
	
	if (_model && [ToolUtil isEqualToNonNull:_model.sort ]) {
		if ( _model.sort.integerValue < 4) {
			[_sortView setTitle:nil forState:UIControlStateNormal];
			[_sortView setImage:ImageNamed(([NSString stringWithFormat:@"rank_top0%@",@(_model.sort.integerValue)])) forState:UIControlStateNormal];
		}else {
			[_sortView setTitle:_model.sort forState:UIControlStateNormal];
			[_sortView setImage:nil forState:UIControlStateNormal];
		}
	}
	
	[_usericonIV am_setImageWithURL:_model.headimg placeholderImage:ImageNamed(@"logo") contentMode:UIViewContentModeScaleAspectFill];
	
	_userNameLabel.text = [ToolUtil isEqualToNonNullKong:_model.giver_uname];
	
	_giftCountLabel.text = [NSString stringWithFormat:@"赠送%@朵", [ToolUtil isEqualToNonNull:_model.num replace:@"0"]];
	CGFloat width = [_giftCountLabel.text sizeWithFont:_giftCountLabel.font andMaxSize:CGSizeMake(CGFLOAT_MAX, _giftCountLabel.height)].width + 5.0f;
	_giftCountWidthConstraint.constant = width;
}

@end
