//
//  SearchResultCustomCell.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/15.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "SearchResultCustomCell.h"

@interface SearchResultCustomCell ()
@property (weak, nonatomic) IBOutlet AMIconView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *customNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *identificatingIV;

@end

@implementation SearchResultCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	_customNameLabel.font = [UIFont addHanSanSC:18.0f fontType:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(UserInfoModel *)model {
	_model = model;
    
	[_iconIV.imageView am_setImageWithURL:_model.headimg placeholderImage:ImageNamed(@"logo") contentMode:UIViewContentModeScaleAspectFill];
    _iconIV.artMark.hidden = model.utype.integerValue < 3;
	
	_customNameLabel.text = [ToolUtil isEqualToNonNullKong:_model.username];
	
	_identificatingIV.hidden = YES;
}


@end
